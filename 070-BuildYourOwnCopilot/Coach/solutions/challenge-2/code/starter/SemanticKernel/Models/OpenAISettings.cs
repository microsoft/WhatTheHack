using BuildYourOwnCopilot.SemanticKernel.Chat;
using System.Diagnostics.CodeAnalysis;

namespace BuildYourOwnCopilot.SemanticKernel.Models
{
    public record OpenAISettings
    {
        public required string CompletionsDeployment { get; set; }
        public required int CompletionsDeploymentMaxTokens { get; init; }
        public required string EmbeddingsDeployment { get; init; }
        public required int EmbeddingsDeploymentMaxTokens { get; init; }
        public required string ChatCompletionPromptName { get; init; }
        public required string ShortSummaryPromptName { get; init; }
        public required string ContextSelectorPromptName { get; init; }
        public required PromptOptimizationSettings PromptOptimization { get; init; }
        public required string Endpoint { get; init; }
        public required string Key { get; init; }
    }
}
