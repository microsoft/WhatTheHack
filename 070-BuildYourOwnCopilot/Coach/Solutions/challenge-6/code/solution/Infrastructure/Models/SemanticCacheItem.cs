using BuildYourOwnCopilot.Common.Models.BusinessDomain;

namespace BuildYourOwnCopilot.Infrastructure.Models.Chat
{
    public class SemanticCacheItem
    {
        public string Id { get; set; }
        public string PartitionKey { get; set; }
        public string UserPrompt { get; set; }
        public int UserPromptTokens { get; set; }
        public ReadOnlyMemory<float> UserPromptEmbedding { get; set; }
        public string ConversationContext {  get; set; }
        public int ConversationContextTokens { get; set; }
        public ReadOnlyMemory<float> ConversationContextEmbedding { get; set; }

        public string Completion {  get; set; }
        public int CompletionTokens { get; set; }
    }
}
