using Microsoft.Extensions.Logging;
using Microsoft.SemanticKernel;
using Microsoft.SemanticKernel.Memory;
using System.ComponentModel;
using System.Text.Json;
using VectorSearchAiAssistant.SemanticKernel.Plugins.Memory;

namespace VectorSearchAiAssistant.SemanticKernel.Plugins.Core
{
    /// <summary>
    /// TextEmbeddingObjectMemoryPlugin provides the capability to recall object information from the long term memory using vector-based similarity.
    /// Optionally, a short-term, volatile memory can be also used to enhance the result set.
    /// </summary>
    /// <example>
    /// Usage: kernel.ImportSkill("memory", new TextEmbeddingObjectMemorySkill());
    /// Examples:
    /// SKContext["input"] = "what is the capital of France?"
    /// {{memory.recall $input }} => "Paris"
    /// </example>
    public sealed class TextEmbeddingObjectMemoryPlugin
    {
        /// <summary>
        /// The vector embedding of the last text input submitted to the Recall method.
        /// Can only be read once, to avoid inconsistencies across multiple calls to Recall.
        /// </summary>
        public ReadOnlyMemory<float>? LastInputTextEmbedding
        {
            get
            {
                var result = _lastInputTextEmbedding;
                _lastInputTextEmbedding = null;
                return result;
            }
        }

        private const string DefaultCollection = "generic";
        private const double DefaultRelevance = 0.7;
        private const int DefaultLimit = 1;

        private ReadOnlyMemory<float>? _lastInputTextEmbedding;

        private readonly VectorMemoryStore _longTermMemory;
        private readonly VectorMemoryStore _shortTermMemory;
        private readonly ILogger _logger;

        /// <summary>
        /// Creates a new instance of the TextEmbeddingMemorySkill
        /// </summary>
        public TextEmbeddingObjectMemoryPlugin(
            VectorMemoryStore longTermMemory,
            VectorMemoryStore shortTermMemory,
            ILogger logger)
        {
            _longTermMemory = longTermMemory;
            _shortTermMemory = shortTermMemory;
            _logger = logger;
        }

        /// <summary>
        /// Vector search and return up to N memories related to the input text. The long-term memory and an optional, short-term memory are used.
        ///
        /// In this application, short term memory is made up of the product count for each product category and the total products for the company.
        /// </summary>
        /// <example>
        /// SKContext["input"] = "what is the capital of France?"
        /// {{memory.recall $input }} => "Paris"
        /// </example>
        /// <param name="text">The input text to find related memories for.</param>
        /// <param name="collection">Memories collection to search.</param>
        /// <param name="relevance">The relevance score, from 0.0 to 1.0, where 1.0 means perfect match.</param>
        /// <param name="limit">The maximum number of relevant memories to recall.</param>
        /// <param name="context">Contains the memory to search.</param>
        /// <param name="shortTermMemory">An optional volatile, short-term memory store.</param>
        [SKFunction]
        public async Task<string> RecallAsync(
            [Description("The input text to find related memories for")] string text,
            [Description("Memories collection to search"), DefaultValue(DefaultCollection)] string collection,
            [Description("The relevance score, from 0.0 to 1.0, where 1.0 means perfect match"), DefaultValue(DefaultRelevance)] double? relevance,
            [Description("The maximum number of relevant memories to recall"), DefaultValue(DefaultLimit)] int? limit)
        {
            ArgumentException.ThrowIfNullOrEmpty(collection, nameof(collection));
            relevance ??= DefaultRelevance;
            limit ??= DefaultLimit;

            _logger.LogTrace("Searching memories in collection '{0}', relevance '{1}'", collection, relevance);

            _lastInputTextEmbedding = await _longTermMemory.GetEmbedding(text);

            // Search memory
            List<MemoryQueryResult> memories = await _longTermMemory
                .GetNearestMatches(text, limit.Value, relevance.Value)
                .ToListAsync()
                .ConfigureAwait(false);

            var combinedMemories = memories.ToList();
            if (_shortTermMemory != null)
            {
                var shortTermMemories = await _shortTermMemory
                    .GetNearestMatches(_lastInputTextEmbedding.Value, limit.Value, relevance.Value)
                    .ToListAsync()
                    .ConfigureAwait(false);

                combinedMemories = combinedMemories
                    .Concat(shortTermMemories)
                    .OrderByDescending(r => r.Relevance)
                    .ToList();
            }

            if (combinedMemories.Count == 0)
            {
                _logger.LogWarning("Neither the collection {0} nor the short term store contain any matching memories.", collection);
                return string.Empty;
            }

            _logger.LogTrace("Done looking for memories in collection '{0}')", collection);
            return JsonSerializer.Serialize(combinedMemories.Select(x => x.Metadata.AdditionalMetadata));
        }
    }
}
