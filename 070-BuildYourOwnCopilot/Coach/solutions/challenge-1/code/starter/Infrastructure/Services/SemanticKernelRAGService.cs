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

        //--------------------------------------------------------------------------------------------------------
        // TODO: [Challenge 1][Exercise 1.1.1]
        // Explore setting up a Semantic Kernel kernel.
        // Explore the use of completion services in the kernel (see the lines above).
        // Explore the setup for the Azure OpenAI-based chat completion service.
        //--------------------------------------------------------------------------------------------------------
        _semanticKernel = builder.Build();

        CreateMemoryStoresAndPlugins();

        // Semantic cache uses a dedicated text embedding generation service.
        // This allows us to experiment with different embedding sizes.
        //--------------------------------------------------------------------------------------------------------
        // TODO: [Challenge 4][Exercise 4.1.1]
        // Initialize the semantic cache service here.
        //--------------------------------------------------------------------------------------------------------

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
            
            //--------------------------------------------------------------------------------------------------------
            // TODO: [Challenge 3][Exercise 3.1.1]
            // Analyze the implementation of the ISystemPromptService interface (see the line above).
            // Locate the definition of the system prompt used for chat completion and analyze its structure.
            // Change the system prompt to experiment the implications in the chat completion process.
            //--------------------------------------------------------------------------------------------------------
            
            _kmContextPlugin = new KnowledgeManagementContextPlugin(
                _prompt,
                _settings.OpenAI,
                _loggerFactory.CreateLogger<KnowledgeManagementContextPlugin>());
            //--------------------------------------------------------------------------------------------------------
            // TODO: [Challenge 1][Exercise 1.2.1]
            // Explore importing plugins into a Semantic Kernel kernel.
            // Explore the implementation of the KnowledgeManagementContextPlugin plugin.
            //--------------------------------------------------------------------------------------------------------
            _semanticKernel.ImportPluginFromObject(_kmContextPlugin);

            _contextSelectorPrompt = await _systemPromptService.GetPrompt(_settings.OpenAI.ContextSelectorPromptName);
            
            //--------------------------------------------------------------------------------------------------------
            // TODO: [Challenge 3][Exercise 3.2.1]
            // Locate the definition of the system prompt used to select the plugins
            // that will be used to build the context for the completion request (see the line above).
            // Change the system prompt to experiment the implications in the chat completion process.
            //--------------------------------------------------------------------------------------------------------
            
            _listPlugin = new ContextPluginsListPlugin(
                _contextPlugins);
            //--------------------------------------------------------------------------------------------------------
            // TODO: [Challenge 1][Exercise 1.3.1]
            // Explore importing plugins into a Semantic Kernel kernel.
            // Explore the implementation of the ContextPluginsListPlugin plugin.
            //--------------------------------------------------------------------------------------------------------
            _semanticKernel.ImportPluginFromObject(_listPlugin);

            _serviceInitialized = true;
            _logger.LogInformation("Semantic Kernel RAG service initialized.");
            
            //--------------------------------------------------------------------------------------------------------
            // TODO: [Challenge 3][Exercise 3.3.1]
            // Attempt to ask questions that would reveal the instructions from the
            // system prompt used for chat completion and the context selector prompt.
            // Improve the prompts with additional instructions to avoid revealing the instructions.
            //--------------------------------------------------------------------------------------------------------
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
            //--------------------------------------------------------------------------------------------------------
            // TODO: [Challenge 1][Exercise 1.4.1]
            // Explore using vector stores with a Semantic Kernel kernel.
            // Explore the implementation of the VectorMemoryStore class which enables us to use multiple memory store
            // implementations provided by Semantic Kernel.
            //--------------------------------------------------------------------------------------------------------
            var memoryStore = new VectorMemoryStore(
                item.IndexName,
                //--------------------------------------------------------------------------------------------------------
                // TODO: [Challenge 1][Exercise 1.5.1]
                // Explore the CosmosDB memory store implementation from Semantic Kernel.
                //--------------------------------------------------------------------------------------------------------
                new AzureCosmosDBNoSQLMemoryStore(
                    _cosmosDBClientFactory.Client,
                    _cosmosDBClientFactory.DatabaseName,
                    item.VectorEmbeddingPolicy,
                    item.IndexingPolicy),
                //--------------------------------------------------------------------------------------------------------
                // TODO: [Challenge 1][Exercise 1.6.1]
                // Explore the use of text embedding services in the kernel.
                // Explore the setup for the Azure OpenAI-based text embedding service.
                //--------------------------------------------------------------------------------------------------------
                new AzureOpenAITextEmbeddingGenerationService(
                    _settings.OpenAI.EmbeddingsDeployment,
                    _settings.OpenAI.Endpoint,
                    _settings.OpenAI.Key,
                    dimensions: (int)item.Dimensions),
                _loggerFactory.CreateLogger<VectorMemoryStore>()
            );

            _longTermMemoryStores.Add(memoryStore.CollectionName, memoryStore);
            
            //--------------------------------------------------------------------------------------------------------
            // TODO: [Challenge 1][Exercise 1.7.1]
            // Explore importing plugins into a Semantic Kernel kernel.
            // Explore the implementation of the MemoryStoreContextPlugin plugin.
            //--------------------------------------------------------------------------------------------------------
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

        //--------------------------------------------------------------------------------------------------------
        // TODO: [Challenge 5][Exercise 5.1.1]
        // Add system command plugins to the list of context builder plugins.
        // The list of system command plugins is available in _settings.SystemCommandPlugins.
        //--------------------------------------------------------------------------------------------------------
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
                    
                    //--------------------------------------------------------------------------------------------------------
                    // TODO: [Challenge 5][Exercise 5.2.1]
                    // Invoke the Reset method on the semantic cache service.
                    // Add a relevant message to the results list to inform the user about the reset.
                    //--------------------------------------------------------------------------------------------------------
                    break;
                
                case SystemCommands.SetSemanticCacheSimilarityScore:
                    
                    //--------------------------------------------------------------------------------------------------------
                    // TODO: [Challenge 5][Exercise 5.3.1]
                    // Invoke the SetMinRelevanceOverride method on the semantic cache service.
                    // Add a relevant message to the results list to inform the user about the change.
                    // Compared to handling the cache reset, this exercise is more challenging because you will need to find
                    // a way to extract the numerical value from the user prompt and set it as the new minimum relevance override.
                    // Note the GetSemanticCacheSimilarityScore method that you can use to parse the similarity score from the user prompt.
                    //--------------------------------------------------------------------------------------------------------
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
        
        //--------------------------------------------------------------------------------------------------------
        // TODO: [Challenge 5][Exercise 5.3.2]
        // Check out the prompt that is already configured for the plugin.
        // Invoke the prompt to get a structured response that you can then parse to extract the numerical value.
        // Note the ParsedSimilarityScore model which is already available and aligned with the prompt structure.
        //--------------------------------------------------------------------------------------------------------
        return 0.95;
    }

    public async Task<CompletionResult> GetResponse(string userPrompt, List<Message> messageHistory)
    {
        //--------------------------------------------------------------------------------------------------------
        // TODO: [Challenge 4][Exercise 4.2.1]
        // Attempt to retrieve the completion from the semantic cache and return it.
        // var cacheItem = ...
        // if (!string.IsNullOrEmpty(cacheItem.Completion))
        // {
        //     return new CompletionResult ...
        // }
        //--------------------------------------------------------------------------------------------------------

        // The semantic cache was not able to retrieve a hit from the cache so we are moving on with the normal flow.
        // We still need to keep the cache item around as it contains the properties we need later on to update the cache with the new entry.

        // Use observability features to capture the fully rendered prompts.
        //--------------------------------------------------------------------------------------------------------
        // TODO: [Challenge 2][Exercise 2.1.1]
        // Attach an IPromptRenderFilter to the Semantic Kernel kernel.
        // This will allow you to intercept the rendered prompts in their final form (before submission to the Large Language Model).
        // Note that the DefaultPromptFilter is a good starting point to implement a prompt filter.
        //--------------------------------------------------------------------------------------------------------
        
        //--------------------------------------------------------------------------------------------------------
        // TODO: [Challenge 2][Exercise 2.3.1]
        // Attach an IFunctionInvocationFilter to the Semantic Kernel kernel.
        // This will allow you to intercept the function calling happening behind the scenes.
        // Note that you will need to write your own implementation class.
        //--------------------------------------------------------------------------------------------------------

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
                UserPromptTokens = 0, // TODO: [Challenge 4][Exercise 4.3.1] Set the user prompt tokens from the cache item.
                UserPromptEmbedding = [], // TODO: [Challenge 4][Exercise 4.3.2] Set the user prompt embedding from the cache item.
                RenderedPrompt = string.Empty, // TODO: [Challenge 2][Exercise 2.1.2] Retrieve the rendered prompt via the prompt filter.
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
                UserPromptTokens = 0, // TODO: [Challenge 4][Exercise 4.3.1] Set the user prompt tokens from the cache item.
                UserPromptEmbedding = [], // TODO: [Challenge 4][Exercise 4.3.2] Set the user prompt embedding from the cache item.
                RenderedPrompt = string.Empty, // TODO: [Challenge 2][Exercise 2.1.2] Retrieve the rendered prompt via the prompt filter.
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
        //--------------------------------------------------------------------------------------------------------
        // TODO: [Challenge 4][Exercise 4.4.1]
        // Set the completion and the completion tokens count on the cache item and then add then add it to the semantic memory.
        //--------------------------------------------------------------------------------------------------------

        return new CompletionResult
        {
            UserPrompt = userPrompt,
            UserPromptTokens = 0, // TODO: [Challenge 4][Exercise 4.3.1] Set the user prompt tokens from the cache item.
            UserPromptEmbedding = [], // TODO: [Challenge 4][Exercise 4.3.2] Set the user prompt embedding from the cache item.
            RenderedPrompt = string.Empty, // TODO: [Challenge 2][Exercise 2.1.2] Retrieve the rendered prompt via the prompt filter.
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
