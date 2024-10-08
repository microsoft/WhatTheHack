using BuildYourOwnCopilot.Common.Models.BusinessDomain;
using BuildYourOwnCopilot.Common.Models.Chat;

namespace BuildYourOwnCopilot.Infrastructure.Interfaces;

public interface IChatService
{
    string Status { get; }

    /// <summary>
    /// Returns list of chat session ids and names for left-hand nav to bind to (display Name and ChatSessionId as hidden)
    /// </summary>
    Task<List<Session>> GetAllChatSessionsAsync();

    /// <summary>
    /// Returns the chat messages to display on the main web page when the user selects a chat from the left-hand nav
    /// </summary>
    Task<List<Message>> GetChatSessionMessagesAsync(string sessionId);

    /// <summary>
    /// User creates a new Chat Session.
    /// </summary>
    Task<Session> CreateNewChatSessionAsync();

    /// <summary>
    /// Rename the Chat Session from "New Chat" to the summary provided by OpenAI
    /// </summary>
    Task<Session> RenameChatSessionAsync(string sessionId, string newChatSessionName);

    /// <summary>
    /// User deletes a chat session
    /// </summary>
    Task DeleteChatSessionAsync(string sessionId);

    /// <summary>
    /// Receive a prompt from a user, Vectorize it from _openAIService Get a completion from _openAiService
    /// </summary>
    Task<Completion> GetChatCompletionAsync(string? sessionId, string userPrompt);

    Task<Completion> SummarizeChatSessionNameAsync(string? sessionId, string prompt);

    /// <summary>
    /// Rate an assistant message. This can be used to discover useful AI responses for training, discoverability, and other benefits down the road.
    /// </summary>
    Task<Message> RateMessageAsync(string id, string sessionId, bool? rating);

    Task AddProduct(Product product);

    Task AddCustomer(Customer customer);

    Task AddSalesOrder(SalesOrder salesOrder);

    Task DeleteProduct(string productId, string categoryId);

    Task<CompletionPrompt> GetCompletionPrompt(string sessionId, string completionPromptId);

    Task ResetSemanticCache();
}