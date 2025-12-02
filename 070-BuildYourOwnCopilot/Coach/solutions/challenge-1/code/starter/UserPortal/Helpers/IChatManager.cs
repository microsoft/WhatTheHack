using BuildYourOwnCopilot.Common.Models.Chat;

namespace BuildYourOwnCopilot.Helpers;

public interface IChatManager
{
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
    Task CreateNewChatSessionAsync();

    /// <summary>
    /// Rename the Chat Ssssion from "New Chat" to the summary provided by OpenAI
    /// </summary>
    Task RenameChatSessionAsync(string sessionId, string newChatSessionName, bool onlyUpdateLocalSessionsCollection = false);

    /// <summary>
    /// User deletes a chat session
    /// </summary>
    Task DeleteChatSessionAsync(string sessionId);

    /// <summary>
    /// Receive a prompt from a user, Vectorize it from _openAIService Get a completion from _openAiService
    /// </summary>
    Task<string> GetChatCompletionAsync(string sessionId, string userPrompt);

    Task<string> SummarizeChatSessionNameAsync(string sessionId, string prompt);

    /// <summary>
    /// Rate an assistant message. This can be used to discover useful AI responses for training, discoverability, and other benefits down the road.
    /// </summary>
    Task<Message> RateMessageAsync(string id, string sessionId, bool? rating);

    Task<CompletionPrompt> GetCompletionPrompt(string sessionId, string completionPromptId);
}