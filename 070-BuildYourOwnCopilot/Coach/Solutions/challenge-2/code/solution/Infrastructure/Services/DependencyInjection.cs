using BuildYourOwnCopilot.Common.Interfaces;
using BuildYourOwnCopilot.Common.Models.Configuration;
using BuildYourOwnCopilot.Common.Services;
using BuildYourOwnCopilot.Infrastructure.Interfaces;
using BuildYourOwnCopilot.Infrastructure.MemorySource;
using BuildYourOwnCopilot.Infrastructure.Models.ConfigurationOptions;
using BuildYourOwnCopilot.Infrastructure.Services;
using BuildYourOwnCopilot.Infrastructure.Services.Text;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

namespace BuildYourOwnCopilot
{
    /// <summary>
    /// General purpose dependency injection extensions.
    /// </summary>
    public static partial class DependencyInjection
    {
        /// <summary>
        /// Registers the <see cref="ICosmosDBService"/> implementation with the dependency injection container."/>
        /// </summary>
        /// <param name="builder">The hosted applications and services builder.</param>
        public static void AddCosmosDBService(this IHostApplicationBuilder builder)
        {
            builder.Services.AddOptions<CosmosDBSettings>()
                .Bind(builder.Configuration.GetSection("MSCosmosDBOpenAI:CosmosDB"));
            builder.Services.AddSingleton<ICosmosDBService, CosmosDBService>();
            builder.Services.AddSingleton<ICosmosDBClientFactory, CosmosDBClientFactory>();
        }

        /// <summary>
        /// Registers the <see cref="IRAGService"/> implementation with the dependency injection container.
        /// </summary>
        /// <param name="builder">The hosted applications and services builder.</param>
        public static void AddSemanticKernelRAGService(this IHostApplicationBuilder builder)
        {
            builder.Services.AddOptions<SemanticKernelRAGServiceSettings>()
                .Bind(builder.Configuration.GetSection("MSCosmosDBOpenAI"));
            builder.Services.AddSingleton<IRAGService, SemanticKernelRAGService>();
        }

        /// <summary>
        /// Registers the <see cref="IChatService"/> implementation with the dependency injection container.
        /// </summary>
        /// <param name="builder">The hosted applications and services builder.</param>
        public static void AddChatService(this IHostApplicationBuilder builder)
        {
            builder.Services.AddSingleton<IChatService, ChatService>();
        }

        /// <summary>
        /// Registers the <see cref="ISystemPromptService"/> implementation with the dependency injection container.
        /// </summary>
        /// <param name="builder">The hosted applications and services builder.</param>
        public static void AddPromptService(this IHostApplicationBuilder builder)
        {
            // System prompt service backed by an Azure blob storage account
            builder.Services.AddOptions<DurableSystemPromptServiceSettings>()
                .Bind(builder.Configuration.GetSection("MSCosmosDBOpenAI:DurableSystemPrompt"));
            builder.Services.AddSingleton<ISystemPromptService, DurableSystemPromptService>();
        }

        /// <summary>
        /// Registers the <see cref="IMemorySource"/> implementations with the dependency injection container.
        /// </summary>
        /// <param name="builder">The hosted applications and services builder.</param>
        public static void AddMemorySourceServices(this IHostApplicationBuilder builder)
        {
            builder.Services.AddOptions<BlobStorageMemorySourceSettings>()
                .Bind(builder.Configuration.GetSection("MSCosmosDBOpenAI:BlobStorageMemorySource"));
            builder.Services.AddTransient<IMemorySource, BlobStorageMemorySource>();
        }

        /// <summary>
        /// Registers the <see cref="ITextSplittingService"/> implementations with the dependency injection container.
        /// </summary>
        /// <param name="builder">The hosted applications and services builder.</param>
        public static void AddTextSplittingServices(this IHostApplicationBuilder builder)
        {
            builder.Services.AddSingleton<ITokenizerService, MicrosoftBPETokenizerService>();
            builder.Services.ActivateSingleton<ITokenizerService>();

            builder.Services.AddOptions<TokenTextSplitterServiceSettings>()
                .Bind(builder.Configuration.GetSection("MSCosmosDBOpenAI:TextSplitter"));
            builder.Services.AddSingleton<ITextSplitterService, TokenTextSplitterService>();
        }

        /// <summary>
        /// Registers the <see cref="IItemTransformerFactory"/> implementation with the dependency injection container."/>
        /// </summary>
        /// <param name="builder">The hosted applications and services builder.</param>
        public static void AddItemTransformerFactory(this IHostApplicationBuilder builder) =>
            builder.Services.AddSingleton<IItemTransformerFactory, ItemTransformerFactory>();
    }
}
