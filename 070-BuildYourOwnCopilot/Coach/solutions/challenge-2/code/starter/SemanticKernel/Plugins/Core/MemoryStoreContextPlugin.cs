using BuildYourOwnCopilot.Common.Models.ConfigurationOptions;
using BuildYourOwnCopilot.SemanticKernel.Plugins.Memory;
using Microsoft.Extensions.Logging;
using Microsoft.SemanticKernel;
using Microsoft.SemanticKernel.Memory;
using System.ComponentModel;
using System.Text;

#pragma warning disable SKEXP0001

namespace BuildYourOwnCopilot.SemanticKernel.Plugins.Core
{
    /// <summary>
    /// Provides the capability to build the context for chat completions by recalling object information from the memory store using vector-based similarity.
    /// </summary>
    public sealed class MemoryStoreContextPlugin : PluginBase
    {
        private readonly VectorMemoryStore _memoryStore;
        private readonly VectorStoreSettings _settings;
        private readonly ILogger<MemoryStoreContextPlugin> _logger;

        /// <summary>
        /// Creates a new instance of the MemoryStoreContextPlugin.
        /// </summary>
        public MemoryStoreContextPlugin(
            VectorMemoryStore memoryStore,
            VectorStoreSettings settings,
            ILogger<MemoryStoreContextPlugin> logger) : base(settings.IndexName, settings.Description)
        {
            _memoryStore = memoryStore;
            _settings = settings;
            _logger = logger;
        }

        public async Task<List<string>> GetMemories(
            string userPrompt)
        {
            _logger.LogTrace("Searching memories in {CollectionName} with minimum relevance {MinRelevance}", _memoryStore.CollectionName, _settings.MinRelevance);

            // Search memory store
            List<MemoryQueryResult> memories = await _memoryStore
                .GetNearestMatches(
                    userPrompt,
                    _settings.MaxVectorSearchResults,
                    _settings.MinRelevance)
                .ToListAsync()
                .ConfigureAwait(false);

            if (memories.Count == 0)
            {
                _logger.LogWarning("No memories retrieved from {CollectionName}.", _memoryStore.CollectionName);
            }

            _logger.LogTrace("Done looking for memories");

            return memories
                .Select(m => m.Metadata.AdditionalMetadata).ToList();
        }

        /// <summary>
        /// Builds the context used for chat completions.
        /// </summary>
        /// <example>
        /// <param name="userPrompt">The input text to find related memories for.</param>
        [KernelFunction]
        public async Task<string> BuildContextAsync(
            [Description("The user prompt for which the context is being built.")] string userPrompt)
        {
            var memories = await GetMemories(userPrompt);

            var sb = new StringBuilder();

            foreach (var memory in memories)
                sb.AppendLine(string.Join(Environment.NewLine, [
                        "BEGIN_ITEM",
                        memory,
                        "END_ITEM"
                    ]));

            return sb.ToString();
        }
    }
}
