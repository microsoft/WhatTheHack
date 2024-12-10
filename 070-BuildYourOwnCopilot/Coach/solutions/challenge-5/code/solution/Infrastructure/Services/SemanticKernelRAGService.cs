using Azure.AI.OpenAI;
using BuildYourOwnCopilot.Common.Interfaces;
using BuildYourOwnCopilot.Common.Models.BusinessDomain;
using BuildYourOwnCopilot.Common.Models.Chat;
using BuildYourOwnCopilot.Infrastructure.Constants;
using BuildYourOwnCopilot.Infrastructure.Interfaces;
using BuildYourOwnCopilot.Infrastructure.Models;
using BuildYourOwnCopilot.Infrastructure.Models.ConfigurationOptions;
using BuildYourOwnCopilot.SemanticKernel.Memory;
using BuildYourOwnCopilot.SemanticKernel.Plugins.Core;
using BuildYourOwnCopilot.SemanticKernel.Plugins.Memory;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Microsoft.SemanticKernel;
using Microsoft.SemanticKernel.Connectors.OpenAI;
using Microsoft.SemanticKernel.Memory;
using System.Text.Json;
using System.Text.RegularExpressions;

#pragma warning disable SKEXP0001, SKEXP0010, SKEXP0020, SKEXP0050, SKEXP0060

namespace BuildYourOwnCopilot.Infrastructure.Services;

public class SemanticKernelRAGService : IRAGService
{
    readonly IItemTransformerFactory _itemTransformerFactory;
    readonly ISystemPromptService _systemPromptService;
    readonly IEnumerable<IMemorySource> _memorySources;
    readonly ICosmosDBClientFactory _cosmosDBClientFactory;
    readonly ITokenizerService _tokenizerService;
    readonly SemanticKernelRAGServiceSettings _settings;
    readonly ILoggerFactory _loggerFactory;

    readonly ILogger<SemanticKernelRAGService> _logger;
    readonly Kernel _semanticKernel;
    
    readonly Dictionary<string, VectorMemoryStore> _longTermMemoryStores = [];
    VectorMemoryStore _shortTermMemoryStore;

    readonly List<PluginBase> _contextPlugins = [];
    KnowledgeManagementContextPlugin _kmContextPlugin;
    ContextPluginsListPlugin _listPlugin;

    readonly ISemanticCacheService _semanticCache;

    bool _serviceInitialized = false;

    string _prompt = string.Empty;
    string _contextSelectorPrompt = string.Empty;

    public bool IsInitialized => _serviceInitialized;

    public SemanticKernelRAGService(
        IItemTransformerFactory itemTransformerFactory,
        ISystemPromptService systemPromptService,
        IEnumerable<IMemorySource> memorySources,
        ICosmosDBClientFactory cosmosDBClientFactory,
        ITokenizerService tokenizerService,
        IOptions<SemanticKernelRAGServiceSettings> options,
        ILoggerFactory loggerFactory)
    {
        _itemTransformerFactory = itemTransformerFactory;
        _systemPromptService = systemPromptService;
        _memorySources = memorySources;
        _cosmosDBClientFactory = cosmosDBClientFactory;
        _tokenizerService = tokenizerService;
        _settings = options.Value;
        _loggerFactory = loggerFactory;

        _logger = _loggerFactory.CreateLogger<SemanticKernelRAGService>();

        _logger.LogInformation("Initializing the Semantic Kernel RAG service...");

        var builder = Kernel.CreateBuilder();

        builder.Services.AddSingleton<ILoggerFactory>(loggerFactory);

        builder.AddAzureOpenAIChatCompletion(
            _settings.OpenAI.CompletionsDeployment,
            _settings.OpenAI.Endpoint,
            _settings.OpenAI.Key);

        _semanticKernel = builder.Build();

        CreateMemoryStoresAndPlugins();

        // Semantic cache uses a dedicated text embedding generation service.
        // This allows us to experiment with different embedding sizes.
        _semanticCache = new SemanticCacheService(
            _settings.SemanticCache,
            _settings.OpenAI,
            _settings.SemanticCacheIndexing,
            cosmosDBClientFactory,
            _tokenizerService,
            _settings.TextSplitter.TokenizerEncoder!,
            loggerFactory);

        Task.Run(Initialize);
    }

    private async Task Initialize()
    {
        try
        {
            foreach (var longTermMemoryStore in _longTermMemoryStores.Values)
                await longTermMemoryStore.Initialize();
            await EnsureShortTermMemory();
            await _semanticCache.Initialize();

            _prompt = await _systemPromptService.GetPrompt(_settings.OpenAI.ChatCompletionPromptName);
            _kmContextPlugin = new KnowledgeManagementContextPlugin(
                _prompt,
                _settings.OpenAI,
                _loggerFactory.CreateLogger<KnowledgeManagementContextPlugin>());
            _semanticKernel.ImportPluginFromObject(_kmContextPlugin);

            _contextSelectorPrompt = await _systemPromptService.GetPrompt(_settings.OpenAI.ContextSelectorPromptName);
            _listPlugin = new ContextPluginsListPlugin(
                _contextPlugins);
            _semanticKernel.ImportPluginFromObject(_listPlugin);

            _serviceInitialized = true;
            _logger.LogInformation("Semantic Kernel RAG service initialized.");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Semantic Kernel RAG service was not initialized. The following error occurred: {ErrorMessage}.", ex.Message);
        }
    }

    private void CreateMemoryStoresAndPlugins()
    {
        // The long-term memory stores use an Azure Cosmos DB NoSQL memory store.

        foreach (var item in _settings.ModelRegistryKnowledgeIndexing.Values)
        {
            var memoryStore = new VectorMemoryStore(
                item.IndexName,
                new AzureCosmosDBNoSQLMemoryStore(
                    _cosmosDBClientFactory.Client,
                    _cosmosDBClientFactory.DatabaseName,
                    item.VectorEmbeddingPolicy,
                    item.IndexingPolicy),
                new AzureOpenAITextEmbeddingGenerationService(
                    _settings.OpenAI.EmbeddingsDeployment,
                    _settings.OpenAI.Endpoint,
                    _settings.OpenAI.Key,
                    dimensions: (int)item.Dimensions),
                _loggerFactory.CreateLogger<VectorMemoryStore>()
            );

            _longTermMemoryStores.Add(memoryStore.CollectionName, memoryStore);
            _contextPlugins.Add(new MemoryStoreContextPlugin(
                memoryStore,
                item,
                _loggerFactory.CreateLogger<MemoryStoreContextPlugin>()));
        }

        // The short-term memory store uses a volatile memory store.

        _shortTermMemoryStore = new VectorMemoryStore(
             _settings.StaticKnowledgeIndexing.IndexName,
             new VolatileMemoryStore(),
             new AzureOpenAITextEmbeddingGenerationService(
                 _settings.OpenAI.EmbeddingsDeployment,
                 _settings.OpenAI.Endpoint,
                 _settings.OpenAI.Key,
                 dimensions: (int)_settings.StaticKnowledgeIndexing.Dimensions),
             _loggerFactory.CreateLogger<VectorMemoryStore>()
        );

        _contextPlugins.Add(new MemoryStoreContextPlugin(
            _shortTermMemoryStore,
            _settings.StaticKnowledgeIndexing,
            _loggerFactory.CreateLogger<MemoryStoreContextPlugin>()));

        _contextPlugins.AddRange(
            _settings.SystemCommandPlugins.Select(
                sp => new SystemCommandPlugin(sp.Name, sp.Description, sp.PromptName)));
    }

    private async Task EnsureShortTermMemory()
    {
        try
        {
            // The memories collection in the short term memory store must be created explicitly
            await _shortTermMemoryStore.MemoryStore.CreateCollectionAsync(
                _settings.StaticKnowledgeIndexing.IndexName);

            // Get current short term memories. Short term memories are generated or loaded at runtime and kept in SK's volatile memory.
            //The content here has embeddings generated on it so it can be used in a vector query by the user.

            // TODO: Explore the option of moving static memories loaded from blob storage into the long-term memory (e.g., the Azure Cosmos DB vector store collection).
            // For now, the static memories are re-loaded each time.
            var shortTermMemories = new List<string>();
            foreach (var memorySource in _memorySources)
            {
                shortTermMemories.AddRange(await memorySource.GetMemories());
            }

            foreach (var itemTransformer in shortTermMemories
                .Select(m => _itemTransformerFactory.CreateItemTransformer(new ShortTermMemory
                {
                    entityType__ = nameof(ShortTermMemory),
                    memory__ = m
                })))
            {
                await _shortTermMemoryStore.AddMemory(itemTransformer);
            }

            _logger.LogInformation("Semantic Kernel RAG service short-term memory initialized.");

        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "The Semantic Kernel RAG service short-term memory failed to initialize.");
        }
    }

    private List<MemoryStoreContextPlugin> GetMemoryPluginsToRun(List<string> pluginNames) =>
        _contextPlugins
            .Where(cp => pluginNames.Contains(cp.Name) && (cp is MemoryStoreContextPlugin))
            .Select(cp => (cp as MemoryStoreContextPlugin)!)
            .ToList();

    private async Task<string> ExecuteSystemCommands(List<string> pluginNames, string userPompt)
    {
        var results = new List<string>();

        foreach (var pluginName in pluginNames)
        {
            switch (pluginName)
            {
                case SystemCommands.ResetSemanticCache:
                    
                    await _semanticCache.Reset();
                    results.Add("The content of the semantic cache was reset.");
                    break;
                
                case SystemCommands.SetSemanticCacheSimilarityScore:
                    
                    var similarityScore = await GetSemanticCacheSimilarityScore(userPompt, pluginName);
                    var newSimilarityScore = similarityScore == 1 
                        ? 1
                        : similarityScore;

                    _semanticCache.SetMinRelevanceOverride(newSimilarityScore);

                    results.Add(similarityScore == 1
                        ? "The similarity score parser was not able to parse a value for the similarity score of the semantic cache. The default value of 0.95 will be used."
                        : $"The similarity score {similarityScore} was set for the semantic cache. The new score will be in effect until the backend API is restarted.");
                    break;
                
                default:
                    break;
            }
        }

        results.Add("Because your request contained system commands, all other requests were ignored.");

        return string.Join(Environment.NewLine, results);
    }

    private bool HasSystemCommands(List<string> pluginNames) =>
        pluginNames
            .Intersect([
                SystemCommands.ResetSemanticCache,
                SystemCommands.SetSemanticCacheSimilarityScore
            ])
            .Any();

    private async Task<double> GetSemanticCacheSimilarityScore(string userPrompt, string pluginName)
    {
        var plugin = _contextPlugins.SingleOrDefault(p => p.Name == pluginName);
        if (plugin == null)
            return 1;
        var pluginPrompt = await _systemPromptService.GetPrompt(plugin.PromptName!);

        var result = await _semanticKernel.InvokePromptAsync(
            pluginPrompt,
            new KernelArguments()
            {
                ["userPrompt"] = userPrompt
            });
        var serializedSimilarityScore = result.GetValue<string>();

        try
        {
            var score = JsonSerializer.Deserialize<ParsedSimilarityScore>(serializedSimilarityScore!);
            return score == null
                ? 1
                : score.SimilarityScore;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error when parsing similarity score: {ErrorMessage}", ex.Message);
            return 1;
        }
    }

    public async Task<CompletionResult> GetResponse(string userPrompt, List<Message> messageHistory)
    {
        var cacheItem = await _semanticCache.GetCacheItem(userPrompt, messageHistory);
        if (!string.IsNullOrEmpty(cacheItem.Completion))
            // If the Completion property is set, it means the cache item was populated with a hit from the cache
            return new CompletionResult
            {
                UserPrompt = userPrompt,
                UserPromptTokens = cacheItem.UserPromptTokens,
                UserPromptEmbedding = cacheItem.UserPromptEmbedding.ToArray(),
                RenderedPrompt = cacheItem.ConversationContext,
                RenderedPromptTokens = cacheItem.ConversationContextTokens,
                Completion = cacheItem.Completion,
                CompletionTokens = cacheItem.CompletionTokens,
                FromCache = true
            };

        // The semantic cache was not able to retrieve a hit from the cache so we are moving on with the normal flow.
        // We still need to keep the cache item around as it contains the properties we need later on to update the cache with the new entry.

        // Use observability features to capture the fully rendered prompts.
        var promptFilter = new DefaultPromptFilter();
        _semanticKernel.PromptRenderFilters.Add(promptFilter);

        var result = await _semanticKernel.InvokePromptAsync(
            _contextSelectorPrompt,
            new KernelArguments
            {
                ["userPrompt"] = userPrompt
            });

        var pluginNamesList = result.GetValue<string>();
        if (string.IsNullOrWhiteSpace(pluginNamesList))
        {
            return new CompletionResult
            {
                UserPrompt = userPrompt,
                UserPromptTokens = cacheItem.UserPromptTokens,
                UserPromptEmbedding = cacheItem.UserPromptEmbedding.ToArray(),
                RenderedPrompt = promptFilter.RenderedPrompt,
                RenderedPromptTokens = 0,
                Completion = "I am sorry, I was not able to determine a suitable action based on your request.",
                CompletionTokens = 0,
                FromCache = false
            };
        }

        var pluginNames = pluginNamesList
            .Split(',', StringSplitOptions.TrimEntries | StringSplitOptions.RemoveEmptyEntries)
            .Select(pn => pn.ToLower())
            .ToList();

        if (HasSystemCommands(pluginNames))
        {
            var systemCommandsResult = await ExecuteSystemCommands(pluginNames, userPrompt);
            return new CompletionResult
            {
                UserPrompt = userPrompt,
                UserPromptTokens = cacheItem.UserPromptTokens,
                UserPromptEmbedding = cacheItem.UserPromptEmbedding.ToArray(),
                RenderedPrompt = promptFilter.RenderedPrompt,
                RenderedPromptTokens = 0,
                Completion = systemCommandsResult,
                CompletionTokens = 0,
                FromCache = false
            };
        }

        var pluginsToRun = GetMemoryPluginsToRun(pluginNames);
        _kmContextPlugin.SetContextPlugins(pluginsToRun);

        result = await _semanticKernel.InvokePromptAsync(
            _prompt,
            new KernelArguments()
            {
                ["userPrompt"] = userPrompt,
                ["messageHistory"] = messageHistory
            });

        var completion = result.GetValue<string>()!;
        var completionUsage = (result.Metadata!["Usage"] as CompletionsUsage)!;

        // Add the completion to the semantic memory
        cacheItem.Completion = completion;
        cacheItem.CompletionTokens = completionUsage!.CompletionTokens;
        await _semanticCache.SetCacheItem(cacheItem);

        return new CompletionResult
        {
            UserPrompt = userPrompt,
            UserPromptTokens = cacheItem.UserPromptTokens,
            UserPromptEmbedding = cacheItem.UserPromptEmbedding.ToArray(),
            RenderedPrompt = promptFilter.RenderedPrompt,
            RenderedPromptTokens = completionUsage.PromptTokens,
            Completion = completion,
            CompletionTokens = completionUsage.CompletionTokens,
            FromCache = false
        };
    }

    public async Task<string> Summarize(string sessionId, string userPrompt)
    {
        var summarizerPlugin = new TextSummaryPlugin(
            await _systemPromptService.GetPrompt(_settings.OpenAI.ShortSummaryPromptName),
            500,
            _semanticKernel);

        var updatedContext = await summarizerPlugin.SummarizeTextAsync(
            userPrompt);

        //Remove all non-alpha numeric characters (Turbo has a habit of putting things in quotes even when you tell it not to)
        var summary = Regex.Replace(updatedContext, @"[^a-zA-Z0-9.\s]", "");

        return summary;
    }

    public async Task AddMemory(IItemTransformer itemTransformer)
    {
        if (!string.IsNullOrWhiteSpace(itemTransformer.VectorIndexName))
        {
            await _longTermMemoryStores[itemTransformer.VectorIndexName].AddMemory(itemTransformer);
        }
        else
            _logger.LogWarning("Object with embedding id {EmbeddingId} and name {Name} has an invalid vector index name.", 
                itemTransformer.EmbeddingId,
                itemTransformer.Name);
    }

    public async Task RemoveMemory(IItemTransformer itemTransformer)
    {
        if (!string.IsNullOrWhiteSpace(itemTransformer.VectorIndexName))
        {
            await _longTermMemoryStores[itemTransformer.VectorIndexName].RemoveMemory(itemTransformer);
        }
        else
            _logger.LogWarning("Object with embedding id {EmbeddingId} and name {Name} has an invalid vector index name.",
                itemTransformer.EmbeddingId,
                itemTransformer.Name);
    }

    public async Task ResetSemanticCache() =>
        await _semanticCache.Reset();
}
