namespace BuildYourOwnCopilot.Common.Models.Chat
{
    public class CompletionResult
    {
        
        public string UserPrompt { get; set; }
        public int UserPromptTokens { get; set; }
        public float[]? UserPromptEmbedding { get; set; }
        public string RenderedPrompt { get; set; }
        public int RenderedPromptTokens { get; set; }
        public string Completion { get; set; }
        public int CompletionTokens { get; set; }
        public bool FromCache { get; set; }
    }
}
