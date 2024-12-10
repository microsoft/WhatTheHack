using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BuildYourOwnCopilot.SemanticKernel.Chat
{
    public record PromptOptimizationSettings
    {
        public required int CompletionsMinTokens { get; init; }
        public required int CompletionsMaxTokens { get; init; }
        public required int SystemMaxTokens { get; init; }
        public required int MemoryMinTokens { get; init; }
        public required int MemoryMaxTokens { get; init; }
        public required int MessagesMinTokens { get; init; }
        public required int MessagesMaxTokens { get; init; }
    }
}
