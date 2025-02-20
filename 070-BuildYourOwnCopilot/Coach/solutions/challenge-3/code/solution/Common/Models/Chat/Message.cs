namespace BuildYourOwnCopilot.Common.Models.Chat;

public record Message
{
    /// <summary>
    /// Unique identifier
    /// </summary>
    public string Id { get; set; }

    public string Type { get; set; }
    /// <summary>
    /// Partition key
    /// </summary>
    public string SessionId { get; set; }

    public DateTime TimeStamp { get; set; }

    public string Sender { get; set; }

    public int? TokensSize { get; set; }

    public int? RenderedTokensSize { get; set; }

    public int? TokensUsed { get; set; }

    public string Text { get; set; }

    public bool? Rating { get; set; }

    public float[]? Vector { get; set; }

    public string CompletionPromptId { get; set; }

    public Message(string sessionId, string sender, int? tokensSize, int? renderedTokensSize, int? tokensUsed, string text, float[]? vector, bool? rating)
    {
        Id = Guid.NewGuid().ToString();
        Type = nameof(Message);
        SessionId = sessionId;
        Sender = sender;
        TokensSize = tokensSize;
        RenderedTokensSize = renderedTokensSize ?? 0;
        TokensUsed = tokensUsed ?? 0;
        TimeStamp = DateTime.UtcNow;
        Text = text;
        Rating = rating;
        Vector = vector;
    }
}