using BuildYourOwnCopilot.Common.Models.Chat;
using BuildYourOwnCopilot.Infrastructure.Constants;
using BuildYourOwnCopilot.Infrastructure.Interfaces;
using BuildYourOwnCopilot.Infrastructure.Models.Chat;
using BuildYourOwnCopilot.Infrastructure.Models.ConfigurationOptions;
using BuildYourOwnCopilot.SemanticKernel.Memory;
using BuildYourOwnCopilot.SemanticKernel.Models;
using BuildYourOwnCopilot.SemanticKernel.Plugins.Memory;
using MathNet.Numerics;
using Microsoft.Extensions.Logging;
using Microsoft.SemanticKernel.Connectors.OpenAI;
using System.Text.Json;

#pragma warning disable SKEXP0010, SKEXP0020;

namespace BuildYourOwnCopilot.Infrastructure.Services
{
    public class SemanticCacheService : ISemanticCacheService
    {
        private readonly SemanticCacheServiceSettings _settings;
        private readonly CosmosDBVectorStoreSettings _searchSettings;
        private readonly VectorMemoryStore _memoryStore;
        private readonly ITokenizerService _tokenizer;
        private readonly string _tokenizerEncoder;
        private readonly ILogger<SemanticCacheService> _logger;

        private double? _minRelevanceOverride;

        public SemanticCacheService(
            SemanticCacheServiceSettings settings,
            OpenAISettings openAISettings,
            CosmosDBVectorStoreSettings searchSettings,
            ICosmosDBClientFactory cosmosDBClientFactory,
            ITokenizerService tokenizerService,
            string tokenizerEncoder,
            ILoggerFactory loggerFactory)
        {
            _settings = settings;
            _searchSettings = searchSettings;
            _memoryStore = new VectorMemoryStore(
                _searchSettings.IndexName,
                new AzureCosmosDBNoSQLMemoryStore(
                    cosmosDBClientFactory.Client,
                    cosmosDBClientFactory.DatabaseName,
                    searchSettings.VectorEmbeddingPolicy,
                    searchSettings.IndexingPolicy
                ),
                new AzureOpenAITextEmbeddingGenerationService(
                    openAISettings.EmbeddingsDeployment,
                    openAISettings.Endpoint,
                    openAISettings.Key,
                    dimensions: (int)_searchSettings.Dimensions
                ),
                loggerFactory.CreateLogger<VectorMemoryStore>());
            _tokenizer = tokenizerService;
            _tokenizerEncoder = tokenizerEncoder;

            _logger = loggerFactory.CreateLogger<SemanticCacheService>();
        }

        public async Task Initialize() =>
            await _memoryStore.Initialize();

        public async Task Reset() =>
            await _memoryStore.Reset();

        public void SetMinRelevanceOverride(double minRelevance) =>
            _minRelevanceOverride = minRelevance;

        public double MinRelevance =>
            _minRelevanceOverride ?? _searchSettings.MinRelevance;

        public async Task<SemanticCacheItem> GetCacheItem(string userPrompt, List<Message> messageHistory)
        {
            var uniqueId = Guid.NewGuid().ToString().ToLower();
            var cacheItem = new SemanticCacheItem()
            {
                Id = uniqueId,
                PartitionKey = uniqueId,
                UserPrompt = userPrompt,
                UserPromptEmbedding = await _memoryStore.GetEmbedding(userPrompt),
                UserPromptTokens = _tokenizer.Encode(userPrompt, _tokenizerEncoder).Count
            };
            var userMessageHistory = messageHistory.Where(m => m.Sender == nameof(Participants.User)).ToList();
            var assistantMessageHistory = messageHistory.Where(m => m.Sender == nameof(Participants.Assistant)).ToList();

            if (userMessageHistory.Count > 0)
            {
                //--------------------------------------------------------------------------------------------------------
                // TODO: [Challenge 4][Exercise 4.5.1]
                // Handle the particular case when the user asks the same question (or a very similar one) as the previous one.
                // Calculate the similarity between cacheItem.UserPromptEmbedding and userMessageHistory.Last().Vector.
                // If the similarity is above a certain threshold, return the cache item ensuring you update ConversationContext, ConversationContextTokens, Completion, and CompletionTokens.
                //--------------------------------------------------------------------------------------------------------
            }

            await SetConversationContext(cacheItem, userMessageHistory);

            try
            {

                var cacheMatches = await _memoryStore
                    .GetNearestMatches(
                        cacheItem.ConversationContextEmbedding,
                        1,
                        MinRelevance)
                    .ToListAsync()
                    .ConfigureAwait(false);
                if (cacheMatches.Count == 0)
                    return cacheItem;

                var matchedCacheItem = JsonSerializer.Deserialize<SemanticCacheItem>(
                    cacheMatches.First().Metadata.AdditionalMetadata);

                cacheItem.Completion = matchedCacheItem!.Completion;
                cacheItem.CompletionTokens = matchedCacheItem.CompletionTokens;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in cache search: {ErrorMessage}.", ex.Message);
            }

            return cacheItem;
        }

        public async Task SetCacheItem(SemanticCacheItem cacheItem) =>
            await _memoryStore.AddMemory(
                cacheItem.Id,
                cacheItem.ConversationContext,
                cacheItem.ConversationContextEmbedding,
                JsonSerializer.Serialize(cacheItem),
                cacheItem.PartitionKey);

        private async Task SetConversationContext(SemanticCacheItem cacheItem, List<Message> userMessageHistory)
        {
            var tokensCount = cacheItem.UserPromptTokens;
            var result = new List<string> { cacheItem.UserPrompt };

            for (int i = userMessageHistory.Count - 1; i >= 0; i--)
            {
                tokensCount += userMessageHistory[i].TokensSize!.Value;
                if (tokensCount > _settings.ConversationContextMaxTokens)
                    break;
                result.Insert(0, userMessageHistory[i].Text);
            }

            cacheItem.ConversationContext = string.Join(Environment.NewLine, [.. result]);
            cacheItem.ConversationContextTokens = _tokenizer.Encode(cacheItem.ConversationContext, _tokenizerEncoder).Count;
            cacheItem.ConversationContextEmbedding = await _memoryStore.GetEmbedding(cacheItem.ConversationContext);
        }
    }
}
