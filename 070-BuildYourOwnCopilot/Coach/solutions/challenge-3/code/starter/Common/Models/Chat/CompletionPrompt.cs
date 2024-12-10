namespace BuildYourOwnCopilot.Common.Models.Chat
{
    public class CompletionPrompt
    {
        public string Id { get; set; }
        public string Type { get; set; }
        public string SessionId { get; set; }
        public string MessageId { get; set; }
        public string Prompt { get; set; }

        public CompletionPrompt(string sessionId, string messageId, string prompt)
        {
            Id = Guid.NewGuid().ToString();
            Type = nameof(CompletionPrompt);
            SessionId = sessionId;
            MessageId = messageId;
            Prompt = prompt;
        }
    }
}
