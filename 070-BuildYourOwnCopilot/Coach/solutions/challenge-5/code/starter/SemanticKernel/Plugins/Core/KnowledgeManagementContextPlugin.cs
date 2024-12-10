using BuildYourOwnCopilot.Common.Models;
using BuildYourOwnCopilot.Common.Models.Chat;
using BuildYourOwnCopilot.Common.Text;
using BuildYourOwnCopilot.SemanticKernel.Chat;
using BuildYourOwnCopilot.SemanticKernel.Models;
using Microsoft.Extensions.Logging;
using Microsoft.SemanticKernel;
using Microsoft.SemanticKernel.ChatCompletion;
using Microsoft.SemanticKernel.Memory;
using System.ComponentModel;

#pragma warning disable SKEXP0001

namespace BuildYourOwnCopilot.SemanticKernel.Plugins.Core
{
    /// <summary>
    /// Provides the capability to build the context for chat completions by recalling object information from the long term memory using vector-based similarity.
    /// Optionally, a short-term, volatile memory can be also used to enhance the result set.
    /// </summary>
    public sealed class KnowledgeManagementContextPlugin
    {
        private readonly List<MemoryStoreContextPlugin> _contextPlugins = [];
        private readonly string _systemPrompt;
        private readonly OpenAISettings _openAISettings;
        private readonly ILogger<KnowledgeManagementContextPlugin> _logger;

        /// <summary>
        /// Creates a new instance of the KnowledgeManagementContextPlugin.
        /// </summary>
        public KnowledgeManagementContextPlugin(
            string systemPrompt,
            OpenAISettings openAISettings,
            ILogger<KnowledgeManagementContextPlugin> logger)
        {
            _systemPrompt = systemPrompt;
            _openAISettings = openAISettings;
            _logger = logger;
        }

        public void SetContextPlugins(
            List<MemoryStoreContextPlugin> contextPlugins)
        {
            _contextPlugins.Clear();
            _contextPlugins.AddRange(contextPlugins);
        }

        /// <summary>
        /// Builds the context used for chat completions.
        /// </summary>
        /// <example>
        /// <param name="userPrompt">The input text to find related memories for.</param>
        [KernelFunction(name: "BuildContext")]
        public async Task<string> BuildContextAsync(
            [Description("The user prompt for which the context is being built.")] string userPrompt,
            [Description("The history of messages in the current conversation.")] List<Message> messageHistory)
        {
            var combinedMemories = await _contextPlugins
                .ToAsyncEnumerable()
                .SelectAwait(async cp => await cp.GetMemories(userPrompt))
                .ToListAsync();

            var memoryTypes = ModelRegistry.Models.ToDictionary(m => m.Key, m => m.Value.Type);
            var context = new ContextBuilder(
                    _openAISettings.CompletionsDeploymentMaxTokens,
                    memoryTypes!,
                    promptOptimizationSettings: _openAISettings.PromptOptimization)
                        .WithSystemPrompt(
                            _systemPrompt)
                        .WithMemories(
                            combinedMemories.SelectMany(x => x).ToList())
                        .WithMessageHistory(
                            messageHistory.Select(m => (new AuthorRole(m.Sender.ToLower()), m.Text.NormalizeLineEndings())).ToList())
                        .Build();

            return context;
        }
    }
}
