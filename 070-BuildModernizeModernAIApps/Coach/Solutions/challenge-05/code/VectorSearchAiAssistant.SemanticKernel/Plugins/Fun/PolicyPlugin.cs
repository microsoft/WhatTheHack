using Microsoft.Extensions.Logging;
using Microsoft.SemanticKernel.Memory;
using Microsoft.SemanticKernel;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VectorSearchAiAssistant.SemanticKernel.Plugins.Memory;
using System.Text.Json;

namespace VectorSearchAiAssistant.SemanticKernel.Plugins.Fun
{
    public class PolicyPlugin
    {
        private const double DefaultRelevance = 0.7;
        private const int DefaultLimit = 1;

        private readonly VectorMemoryStore _policyMemory;
        private readonly ILogger _logger;

        /// <summary>
        /// Creates a new instance of the TextEmbeddingMemorySkill
        /// </summary>
        public PolicyPlugin(
            VectorMemoryStore policyMemory,
            ILogger logger)
        {
            _policyMemory = policyMemory;
            _logger = logger;
        }

        [SKFunction, Description("Get information product policies.")]
        public async Task<string> RecallAsync(
            [Description("The input text to find related memories for")] string text,
            [Description("The relevance score, from 0.0 to 1.0, where 1.0 means perfect match"), DefaultValue(DefaultRelevance)] double? relevance,
            [Description("The maximum number of relevant memories to recall"), DefaultValue(DefaultLimit)] int? limit)
        {
            relevance ??= DefaultRelevance;
            limit ??= DefaultLimit;

            var policyMemories = await _policyMemory
                .GetNearestMatches(text, limit.Value, relevance.Value)
                .ToListAsync()
                .ConfigureAwait(false);

            if (policyMemories.Count == 0)
            {
                _logger.LogWarning("The policies memory store does not contain any matching memories.");
                return string.Empty;
            }

            _logger.LogTrace("Done looking for policy memories");
            var result = string.Join("\n", policyMemories.Select(m => m.Metadata.Text));
            return result;
        }
    }
}
