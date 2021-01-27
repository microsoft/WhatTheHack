// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

using Microsoft.ApplicationInsights.Extensibility;
using Microsoft.AspNetCore.Http;
using Microsoft.Azure.Functions.Extensions.DependencyInjection;
using Microsoft.Bot.Builder;
using Microsoft.Bot.Builder.AI.Luis;
using Microsoft.Bot.Builder.AI.QnA;
using Microsoft.Bot.Builder.ApplicationInsights;
using Microsoft.Bot.Builder.Azure;
using Microsoft.Bot.Builder.Azure.Blobs;
using Microsoft.Bot.Builder.BotFramework;
using Microsoft.Bot.Builder.Dialogs;
using Microsoft.Bot.Builder.Dialogs.Adaptive;
using Microsoft.Bot.Builder.Dialogs.Declarative;
using Microsoft.Bot.Builder.Dialogs.Declarative.Resources;
using Microsoft.Bot.Builder.Integration.ApplicationInsights.Core;
using Microsoft.Bot.Builder.Integration.AspNet.Core;
using Microsoft.Bot.Builder.Integration.AspNet.Core.Skills;
using Microsoft.Bot.Builder.Skills;
using Microsoft.Bot.Connector.Authentication;
using Microsoft.BotFramework.Composer.Core;
using Microsoft.BotFramework.Composer.Core.Settings;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;

[assembly: FunctionsStartup(typeof(Microsoft.BotFramework.Composer.Functions.Startup))]

namespace Microsoft.BotFramework.Composer.Functions
{
    public class Startup : FunctionsStartup
    {
        private const string AssetsDirectoryName = "ComposerDialogs";
        private const string SettingsRelativePath = "settings/appsettings.json";
        private const string WwwRoot = "wwwroot";
        private const string DialogFileExtension = ".dialog";
        private const string DefaultLanguageSetting = "DefaultLanguage";
        private const string EnglishLocale = "en-us";

        public override void Configure(IFunctionsHostBuilder builder)
        {
            // Get assets directory.
            var assetsDirectory = GetAssetsDirectory();

            // Build configuration with assets.
            var config = BuildConfiguration(assetsDirectory);

            var settings = new BotSettings();
            config.Bind(settings);

            var services = builder.Services;

            services.AddSingleton<IConfiguration>(config);

            services.AddLogging();

            // Create the credential provider to be used with the Bot Framework Adapter.
            services.AddSingleton<ICredentialProvider, ConfigurationCredentialProvider>();
            services.AddSingleton<BotAdapter>(sp => (BotFrameworkHttpAdapter)sp.GetService<IBotFrameworkHttpAdapter>());

            // Register AuthConfiguration to enable custom claim validation.
            services.AddSingleton<AuthenticationConfiguration>();

            // Adaptive component registration
            ComponentRegistration.Add(new DialogsComponentRegistration());
            ComponentRegistration.Add(new DeclarativeComponentRegistration());
            ComponentRegistration.Add(new AdaptiveComponentRegistration());
            ComponentRegistration.Add(new LanguageGenerationComponentRegistration());
            ComponentRegistration.Add(new QnAMakerComponentRegistration());
            ComponentRegistration.Add(new LuisComponentRegistration());

            // This is for custom action component registration.
            //ComponentRegistration.Add(new CustomActionComponentRegistration());

            // Register the skills client and skills request handler.
            services.AddSingleton<SkillConversationIdFactoryBase, SkillConversationIdFactory>();
            services.AddHttpClient<BotFrameworkClient, SkillHttpClient>();
            services.AddSingleton<ChannelServiceHandler, SkillHandler>();

            // Register telemetry client, initializers and middleware
            services.AddApplicationInsightsTelemetry(settings?.ApplicationInsights?.InstrumentationKey ?? string.Empty);

            services.AddSingleton<ITelemetryInitializer, OperationCorrelationTelemetryInitializer>();
            services.AddSingleton<ITelemetryInitializer, TelemetryBotIdInitializer>();
            services.AddSingleton<IBotTelemetryClient, BotTelemetryClient>();
            services.AddSingleton<TelemetryLoggerMiddleware>(sp =>
            {
                var telemetryClient = sp.GetService<IBotTelemetryClient>();
                return new TelemetryLoggerMiddleware(telemetryClient, logPersonalInformation: settings?.Telemetry?.LogPersonalInformation ?? false);
            });
            services.AddSingleton<TelemetryInitializerMiddleware>(sp =>
            {
                var httpContextAccessor = sp.GetService<IHttpContextAccessor>();
                var telemetryLoggerMiddleware = sp.GetService<TelemetryLoggerMiddleware>();
                return new TelemetryInitializerMiddleware(httpContextAccessor, telemetryLoggerMiddleware, settings?.Telemetry?.LogActivities ?? false);
            });

            // Storage
            IStorage storage;
            if (ConfigSectionValid(settings?.CosmosDb?.AuthKey))
            {
                storage = new CosmosDbPartitionedStorage(settings?.CosmosDb);
            }
            else
            {
                storage = new MemoryStorage();
            }

            services.AddSingleton(storage);
            var userState = new UserState(storage);
            var conversationState = new ConversationState(storage);
            services.AddSingleton(userState);
            services.AddSingleton(conversationState);

            // Resource explorer to track declarative assets
            var resourceExplorer = new ResourceExplorer().AddFolder(assetsDirectory.FullName);
            services.AddSingleton(resourceExplorer);

            // Adapter
            services.AddSingleton<IBotFrameworkHttpAdapter, BotFrameworkHttpAdapter>(s =>
            {
                // Retrieve required dependencies
                IStorage storage = s.GetService<IStorage>();
                UserState userState = s.GetService<UserState>();
                ConversationState conversationState = s.GetService<ConversationState>();
                TelemetryInitializerMiddleware telemetryInitializerMiddleware = s.GetService<TelemetryInitializerMiddleware>();

                var adapter = new BotFrameworkHttpAdapter(new ConfigurationCredentialProvider(config));

                adapter
                  .UseStorage(storage)
                  .UseBotState(userState, conversationState)
                  .Use(new RegisterClassMiddleware<IConfiguration>(config))
                  .Use(telemetryInitializerMiddleware);

                // Configure Middlewares
                ConfigureTranscriptLoggerMiddleware(adapter, settings);
                ConfigureInspectionMiddleWare(adapter, settings, s);
                ConfigureShowTypingMiddleWare(adapter, settings);

                adapter.OnTurnError = async (turnContext, exception) =>
                {
                    await turnContext.SendActivityAsync(exception.Message).ConfigureAwait(false);
                    await conversationState.ClearStateAsync(turnContext).ConfigureAwait(false);
                    await conversationState.SaveChangesAsync(turnContext).ConfigureAwait(false);
                };

                return adapter;
            });

            var defaultLocale = config.GetValue<string>(DefaultLanguageSetting) ?? EnglishLocale;

            var removeRecipientMention = settings?.Feature?.RemoveRecipientMention ?? false;

            // Bot
            services.AddSingleton<IBot>(s =>
                new ComposerBot(
                    s.GetService<ConversationState>(),
                    s.GetService<UserState>(),
                    s.GetService<ResourceExplorer>(),
                    s.GetService<BotFrameworkClient>(),
                    s.GetService<SkillConversationIdFactoryBase>(),
                    s.GetService<IBotTelemetryClient>(),
                    GetRootDialog(assetsDirectory.FullName),
                    defaultLocale,
                    removeRecipientMention));
        }

        public void ConfigureTranscriptLoggerMiddleware(BotFrameworkHttpAdapter adapter, BotSettings settings)
        {
            if (ConfigSectionValid(settings?.BlobStorage?.ConnectionString) && ConfigSectionValid(settings?.BlobStorage?.Container))
            {
                adapter.Use(new TranscriptLoggerMiddleware(new BlobsTranscriptStore(settings?.BlobStorage?.ConnectionString, settings?.BlobStorage?.Container)));
            }
        }

        public void ConfigureShowTypingMiddleWare(BotFrameworkAdapter adapter, BotSettings settings)
        {
            if (settings?.Feature?.UseShowTypingMiddleware == true)
            {
                adapter.Use(new ShowTypingMiddleware());
            }
        }

        public void ConfigureInspectionMiddleWare(BotFrameworkAdapter adapter, BotSettings settings, IServiceProvider s)
        {
            if (settings?.Feature?.UseInspectionMiddleware == true)
            {
                adapter.Use(s.GetService<TelemetryInitializerMiddleware>());
            }
        }

        private string GetRootDialog(string folderPath)
        {
            var dir = new DirectoryInfo(folderPath);
            foreach (var f in dir.GetFiles())
            {
                if (f.Extension == DialogFileExtension)
                {
                    return f.Name;
                }
            }

            throw new Exception($"Can't locate root dialog in {dir.FullName}");
        }

        private bool ConfigSectionValid(string val)
        {
            return !string.IsNullOrEmpty(val) && !val.StartsWith('<');
        }

        private static DirectoryInfo GetAssetsDirectory()
        {
            // The directory structure in functions is as follows
            // wwwroot
            //   | bin
            //   | ComposerDialogs
            //   | messages
            //   | ...
            //
            // However depending on the exact runtime environment and architecture (i.e. x64)
            // there can be variations in the folder structure, for example having the binaries in
            // an x64 subfolder within bin.
            // To make this more flexible, we obtain the executing assembly location and navigate up
            // the directory tree until wwwroot, and pick up the composer dialogs path from there,
            // making this more robust.

            // Obtain executing binary directory
            var binDirectory = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);

            var parent = Directory.GetParent(binDirectory);

            // Navigate folder structure upwards until we find the folder, reach wwwroot or there are no
            // more parents to navigate
            while (parent != null)
            {
                // For the current directory, check if there is a child directory named
                // 'ComposerDialogs'
                var children = parent.EnumerateDirectories(AssetsDirectoryName);

                if (children.Any())
                {
                    // We found our assets directory!
                    return children.First();
                }
                else
                {
                    // In functions, if we reached wwwroot, we cannot go further up. Fail the operation
                    // so that an error is displayed in the functions telemetry and start page.
                    if (parent.Name.Contains(WwwRoot))
                    {
                        throw new InvalidDataException($"Failed to start functions bot, could not find asset folder {AssetsDirectoryName} in path {parent.FullName}.");
                    }
                    else
                    {
                        // If we didn't reach wwwroot, keep going up.
                        parent = parent.Parent;
                    }
                }
            }

            // We should never be here unless we failed to find the folder. Throw clear exception.
            throw new InvalidDataException($"Failed to start functions bot, could not find asset folder {AssetsDirectoryName}.");
        }


        private static IConfigurationRoot BuildConfiguration(DirectoryInfo assetsDirectory)
        {
            var config = new ConfigurationBuilder();

            // Config precedence 1: root app.settings in case users add it.
            // Note that the function root (wwwroot) is one directory above the assets dir.
            config.SetBasePath(assetsDirectory.Parent.FullName);

            // Config precedence 2: ComposerDialogs/settings settings which are injected by the composer publish.
            var configFile = Path.GetFullPath(Path.Combine(assetsDirectory.FullName, SettingsRelativePath));
            config.AddJsonFile(configFile, optional: true, reloadOnChange: true);

            config.UseComposerSettings();

            if (!Debugger.IsAttached)
            {
                config.AddUserSecrets<Startup>();
            }

            config.AddEnvironmentVariables();

            return config.Build();
        }
    }
}
