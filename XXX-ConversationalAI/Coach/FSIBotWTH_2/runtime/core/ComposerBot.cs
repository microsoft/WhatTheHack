// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

using System.Security.Claims;
using System.Security.Principal;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Bot.Builder;
using Microsoft.Bot.Builder.Dialogs;
using Microsoft.Bot.Builder.Dialogs.Adaptive;
using Microsoft.Bot.Builder.Dialogs.Debugging;
using Microsoft.Bot.Builder.Dialogs.Declarative;
using Microsoft.Bot.Builder.Dialogs.Declarative.Resources;
using Microsoft.Bot.Builder.Skills;
using Microsoft.Bot.Connector.Authentication;
using Microsoft.Bot.Schema;

namespace Microsoft.BotFramework.Composer.Core
{
    public class ComposerBot : ActivityHandler
    {
        private readonly ResourceExplorer resourceExplorer;
        private readonly UserState userState;
        private DialogManager dialogManager;
        private readonly ConversationState conversationState;
        private readonly IStatePropertyAccessor<DialogState> dialogState;
        private readonly string rootDialogFile;
        private readonly IBotTelemetryClient telemetryClient;
        private readonly string defaultLocale;
        private readonly bool removeRecipientMention;

        public ComposerBot(ConversationState conversationState, UserState userState, ResourceExplorer resourceExplorer, BotFrameworkClient skillClient, SkillConversationIdFactoryBase conversationIdFactory, IBotTelemetryClient telemetryClient, string rootDialog, string defaultLocale, bool removeRecipientMention = false)
        {
            this.conversationState = conversationState;
            this.userState = userState;
            this.dialogState = conversationState.CreateProperty<DialogState>("DialogState");
            this.resourceExplorer = resourceExplorer;
            this.rootDialogFile = rootDialog;
            this.defaultLocale = defaultLocale;
            this.telemetryClient = telemetryClient;
            this.removeRecipientMention = removeRecipientMention;

            LoadRootDialogAsync();
            this.dialogManager.InitialTurnState.Set(skillClient);
            this.dialogManager.InitialTurnState.Set(conversationIdFactory);
        }

        public override async Task OnTurnAsync(ITurnContext turnContext, CancellationToken cancellationToken = default(CancellationToken))
        {
            if (this.removeRecipientMention && turnContext?.Activity?.Type == "message")
            {
                turnContext.Activity.RemoveRecipientMention();
            }

            await this.dialogManager.OnTurnAsync(turnContext, cancellationToken: cancellationToken);
            await this.conversationState.SaveChangesAsync(turnContext, false, cancellationToken);
            await this.userState.SaveChangesAsync(turnContext, false, cancellationToken);
        }

        private void LoadRootDialogAsync()
        {
            var rootFile = resourceExplorer.GetResource(rootDialogFile);
            var rootDialog = resourceExplorer.LoadType<Dialog>(rootFile);
            this.dialogManager = new DialogManager(rootDialog)
                                .UseResourceExplorer(resourceExplorer)
                                .UseLanguageGeneration()
                                .UseLanguagePolicy(new LanguagePolicy(defaultLocale));

            if (telemetryClient != null)
            {
                dialogManager.UseTelemetry(this.telemetryClient);
            }
        }
    }
}
