using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Microsoft.SemanticKernel;
using Microsoft.SemanticKernel.AI.ChatCompletion;
using Microsoft.SemanticKernel.AI.Embeddings;
using Microsoft.SemanticKernel.AI.TextCompletion;
using Microsoft.SemanticKernel.Connectors.Memory.AzureCognitiveSearch;
using Microsoft.SemanticKernel.Planners;
using Microsoft.SemanticKernel.Plugins.Memory;
using Newtonsoft.Json;
using System.Text.RegularExpressions;
using VectorSearchAiAssistant.SemanticKernel.Chat;
using VectorSearchAiAssistant.SemanticKernel.Plugins.Core;
using VectorSearchAiAssistant.SemanticKernel.Plugins.Fun;
using VectorSearchAiAssistant.SemanticKernel.Plugins.Memory;
using VectorSearchAiAssistant.SemanticKernel.Text;
using VectorSearchAiAssistant.Service.Interfaces;
using VectorSearchAiAssistant.Service.MemorySource;
using VectorSearchAiAssistant.Service.Models;
using VectorSearchAiAssistant.Service.Models.Chat;
using VectorSearchAiAssistant.Service.Models.ConfigurationOptions;
using VectorSearchAiAssistant.Service.Models.Search;

namespace VectorSearchAiAssistant.Service.Services;

public class SemanticKernelRAGService : IRAGService
{
    readonly SemanticKernelRAGServiceSettings _settings;

    readonly IKernel _semanticKernel;
    readonly IEnumerable<IMemorySource> _memorySources;
    readonly ILogger<SemanticKernelRAGService> _logger;
    readonly ISystemPromptService _systemPromptService;
    readonly IChatCompletion _chat;
    readonly VectorMemoryStore _longTermMemory;
    readonly VectorMemoryStore _shortTermMemory;
    readonly Dictionary<string, Type> _memoryTypes;

    readonly string _shortTermCollectionName = "short-term";

    bool _serviceInitialized = false;
    bool _shortTermMemoryInitialized = false;

    public bool IsInitialized => _serviceInitialized;

    public SemanticKernelRAGService(
        ISystemPromptService systemPromptService,
        IEnumerable<IMemorySource> memorySources,
        IOptions<SemanticKernelRAGServiceSettings> options,
        IOptions<AzureCognitiveSearchMemorySourceSettings> cognitiveSearchMemorySourceSettings,
        ILogger<SemanticKernelRAGService> logger,
        ILoggerFactory loggerFactory)
    {
        _systemPromptService = systemPromptService;
        _memorySources = memorySources;
        _settings = options.Value;
        _logger = logger;

        _logger.LogInformation("Initializing the Semantic Kernel RAG service...");

        _memoryTypes = ModelRegistry.Models.ToDictionary(m => m.Key, m => m.Value.Type);

        var builder = new KernelBuilder();

        builder.WithLoggerFactory(loggerFactory);

        builder.WithAzureTextEmbeddingGenerationService(
            _settings.OpenAI.EmbeddingsDeployment,
            _settings.OpenAI.Endpoint,
            _settings.OpenAI.Key);

        builder.WithAzureChatCompletionService(
            _settings.OpenAI.CompletionsDeployment,
            _settings.OpenAI.Endpoint,
            _settings.OpenAI.Key);

        _semanticKernel = builder.Build();

        // The long-term memory uses an Azure Cognitive Search memory store
        _longTermMemory = new VectorMemoryStore(
            _settings.CognitiveSearch.IndexName,
            new AzureCognitiveSearchMemoryStore(
                _settings.CognitiveSearch.Endpoint,
                _settings.CognitiveSearch.Key),
            _semanticKernel.GetService<ITextEmbeddingGeneration>(),
            loggerFactory.CreateLogger<VectorMemoryStore>());

        _shortTermMemory = new VectorMemoryStore(
            _shortTermCollectionName,
            new VolatileMemoryStore(),
            _semanticKernel.GetService<ITextEmbeddingGeneration>(),
            loggerFactory.CreateLogger<VectorMemoryStore>());

        _chat = _semanticKernel.GetService<IChatCompletion>();

        _serviceInitialized = true;

        _logger.LogInformation("Semantic Kernel RAG service initialized.");
    }

    private async Task EnsureShortTermMemory()
    {
        try
        {
            if (_shortTermMemoryInitialized)
                return;

            // The memories collection in the short term memory store must be created explicitly
            await _shortTermMemory.MemoryStore.CreateCollectionAsync(_shortTermCollectionName);

            // Get current short term memories. Short term memories are generated or loaded at runtime and kept in SK's volatile memory.
            //The memories (data) here were generated from ACSMemorySourceConfig.json in blob storage that was used to execute faceted queries in Cog Search to iterate through
            //each product category stored and count up the number of products in each category. The query also counts all the products for the entire company.
            //The content here has embeddings generated on it so it can be used in a vector query by the user

            // TODO: Explore the option of moving static memories loaded from blob storage into the long-term memory (e.g., the Azure Cognitive Search index).
            // For now, the static memories are re-loaded each time together with the analytical short-term memories originating from Azure Cognitive Search faceted queries.
            var shortTermMemories = new List<string>();
            foreach (var memorySource in _memorySources)
            {
                if (memorySource is BlobStorageMemorySource)
                    shortTermMemories.AddRange(await memorySource.GetMemories());
            }

            foreach (var stm in shortTermMemories
                .Select(m => (object)new ShortTermMemory
                {
                    entityType__ = nameof(ShortTermMemory),
                    memory__ = m
                }))
            {
                await _shortTermMemory.AddMemory(stm, "N/A");
            }

            _shortTermMemoryInitialized = true;
            _logger.LogInformation("Semantic Kernel RAG service short-term memory initialized.");

        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "The Semantic Kernel RAG service short-term memory failed to initialize.");
        }
    }

    public async Task<(string Completion, string UserPrompt, int UserPromptTokens, int ResponseTokens, float[]? UserPromptEmbedding)> GetResponse(string userPrompt, List<Message> messageHistory)
    {
        /* TODO: Challenge 3. 
         * Complete the todo tasks as instructed by the comments
         */

        await EnsureShortTermMemory();

        var policyPlugin = new PolicyPlugin(
            _shortTermMemory,
            _logger);

        _semanticKernel.ImportFunctions(policyPlugin);
        var shakespearePlugin = new ShakespearePlugin(_semanticKernel);

        var planner = new SequentialPlanner(_semanticKernel);
        var plan = await planner.CreatePlanAsync(userPrompt);
        var planResult = await _semanticKernel.RunAsync(plan);

        return new(planResult.GetValue<string>(), userPrompt, 0, 0, null);
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

    public async Task AddMemory(object item, string itemName)
    {
        await _longTermMemory.AddMemory(item, itemName);
    }

    public async Task RemoveMemory(object item)
    {
        await _longTermMemory.RemoveMemory(item);
    }
}
