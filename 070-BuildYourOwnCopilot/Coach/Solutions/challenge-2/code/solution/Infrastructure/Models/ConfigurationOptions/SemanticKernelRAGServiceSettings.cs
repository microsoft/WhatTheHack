using BuildYourOwnCopilot.Common.Models.Configuration;
using BuildYourOwnCopilot.Common.Models.ConfigurationOptions;
using BuildYourOwnCopilot.Infrastructure.Models.ConfigurationOptions;
using BuildYourOwnCopilot.SemanticKernel.Models;

namespace BuildYourOwnCopilot.Infrastructure.Models.ConfigurationOptions
{
    public record SemanticKernelRAGServiceSettings
    {
        public required OpenAISettings OpenAI { get; init; }
        public required CosmosDBSettings CosmosDBVectorStore { get; init; }
        public required Dictionary<string, CosmosDBVectorStoreSettings> ModelRegistryKnowledgeIndexing {  get; init; }
        public required VectorStoreSettings StaticKnowledgeIndexing { get; init; }
        public required CosmosDBVectorStoreSettings SemanticCacheIndexing { get; init; }
        public required TokenTextSplitterServiceSettings TextSplitter {  get; init; }
        public required SemanticCacheServiceSettings SemanticCache { get; init; }
        public required List<SystemCommandPluginSettings> SystemCommandPlugins { get; init; }
    }
}