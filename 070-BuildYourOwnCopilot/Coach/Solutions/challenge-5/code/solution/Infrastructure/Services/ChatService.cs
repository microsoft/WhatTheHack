using BuildYourOwnCopilot.Common.Interfaces;
using BuildYourOwnCopilot.Common.Models.BusinessDomain;
using BuildYourOwnCopilot.Common.Models.Chat;
using BuildYourOwnCopilot.Infrastructure.Constants;
using BuildYourOwnCopilot.Infrastructure.Interfaces;
using Microsoft.Extensions.Logging;

namespace BuildYourOwnCopilot.Infrastructure.Services;

public class ChatService : IChatService
{
    private readonly ICosmosDBService _cosmosDBService;
    private readonly IRAGService _ragService;
    private readonly IItemTransformerFactory _itemTransformerFactory;
    private readonly ILogger _logger;

    public string Status
    {
        get
        {
            if (_cosmosDBService.IsInitialized && _ragService.IsInitialized)
                return "ready";

            var status = new List<string>();

            if (!_cosmosDBService.IsInitialized)
                status.Add("CosmosDBService: initializing");
            if (!_ragService.IsInitialized)
                status.Add("SemanticKernelRAGService: initializing");

            return string.Join(",", status);
        }
    }

    public ChatService(
        ICosmosDBService cosmosDBService,
        IRAGService ragService,
        IItemTransformerFactory itemTransformerFactory,
        ILogger<ChatService> logger)
    {
        _cosmosDBService = cosmosDBService;
        _ragService = ragService;
        _itemTransformerFactory = itemTransformerFactory;
        _logger = logger;
    }

    /// <summary>
    /// Returns list of chat session ids and names.
    /// </summary>
    public async Task<List<Session>> GetAllChatSessionsAsync()
    {
        return await _cosmosDBService.GetSessionsAsync();
    }

    /// <summary>
    /// Returns the chat messages related to an existing session.
    /// </summary>
    public async Task<List<Message>> GetChatSessionMessagesAsync(string sessionId)
    {
        ArgumentNullException.ThrowIfNull(sessionId);
        return await _cosmosDBService.GetSessionMessagesAsync(sessionId);
    }

    /// <summary>
    /// Creates a new chat session.
    /// </summary>
    public async Task<Session> CreateNewChatSessionAsync()
    {
        Session session = new();
        return await _cosmosDBService.InsertSessionAsync(session);
    }

    /// <summary>
    /// Rename the chat session from its default (eg., "New Chat") to the summary provided by OpenAI.
    /// </summary>
    public async Task<Session> RenameChatSessionAsync(string sessionId, string newChatSessionName)
    {
        ArgumentNullException.ThrowIfNull(sessionId);
        ArgumentException.ThrowIfNullOrEmpty(newChatSessionName);

        return await _cosmosDBService.UpdateSessionNameAsync(sessionId, newChatSessionName);
    }

    /// <summary>
    /// Delete a chat session and related messages.
    /// </summary>
    public async Task DeleteChatSessionAsync(string sessionId)
    {
        ArgumentNullException.ThrowIfNull(sessionId);
        await _cosmosDBService.DeleteSessionAndMessagesAsync(sessionId);
    }

    /// <summary>
    /// Receive a prompt from a user, vectorize it from the OpenAI service, and get a completion from the OpenAI service.
    /// </summary>
    public async Task<Completion> GetChatCompletionAsync(string? sessionId, string userPrompt)
    {
        try
        {
            ArgumentNullException.ThrowIfNull(sessionId);

            // Retrieve conversation, including latest prompt.
            // If you put this after the vector search it doesn't take advantage of previous information given so harder to chain prompts together.
            // However if you put this before the vector search it can get stuck on previous answers and not pull additional information. Worth experimenting

            // Retrieve conversation, including latest prompt.
            var messages = await _cosmosDBService.GetSessionMessagesAsync(sessionId);

            // Generate the completion to return to the user
            //(string completion, int promptTokens, int responseTokens) = await_openAiService.GetChatCompletionAsync(sessionId, conversation, retrievedDocuments);
            var result = await _ragService.GetResponse(userPrompt, messages);

            // Add both prompt and completion to cache, then persist in Cosmos DB
            var promptMessage = new Message(
                sessionId, 
                nameof(Participants.User), 
                result.UserPromptTokens, 
                result.RenderedPromptTokens, 
                result.FromCache ? 0 : result.RenderedPromptTokens, // if we hit the cache, the actual token consumption is zero.
                result.UserPrompt, 
                result.UserPromptEmbedding,
                null);
            var completionMessage = new Message(
                sessionId,
                nameof(Participants.Assistant),
                result.CompletionTokens,
                result.CompletionTokens, // in the case of a completion the text and the rendered text are identical.
                result.FromCache ? 0: result.CompletionTokens, // if we hit the cache, the actual token consumption is zero.
                result.Completion,
                null,
                null);
            var completionPrompt = new CompletionPrompt(sessionId, completionMessage.Id, result.RenderedPrompt);
            completionMessage.CompletionPromptId = completionPrompt.Id;

            await AddPromptCompletionMessagesAsync(sessionId, promptMessage, completionMessage, completionPrompt);

            return new Completion { Text = result.Completion };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error getting completion in session {sessionId} for user prompt [{userPrompt}].");
            return new Completion { Text = "Could not generate a completion due to an internal error." };
        }
    }

    /// <summary>
    /// Generate a name for a chat message, based on the passed in prompt.
    /// </summary>
    public async Task<Completion> SummarizeChatSessionNameAsync(string? sessionId, string prompt)
    {
        try
        {
            ArgumentNullException.ThrowIfNull(sessionId);

            var summary = await _ragService.Summarize(sessionId, prompt);

            await RenameChatSessionAsync(sessionId, summary);

            return new Completion { Text = summary };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error getting a summary in session {sessionId} for user prompt [{prompt}].");
            return new Completion { Text = "[No Summary]" };
        }
    }

    /// <summary>
    /// Add user prompt and AI assistance response to the chat session message list object and insert into the data service as a transaction.
    /// </summary>
    private async Task AddPromptCompletionMessagesAsync(string sessionId, Message promptMessage, Message completionMessage, CompletionPrompt completionPrompt)
    {
        var session = await _cosmosDBService.GetSessionAsync(sessionId);

        // Update session cache with tokens used
        session.TokensUsed += promptMessage.TokensUsed;
        session.TokensUsed += completionMessage.TokensUsed;

        await _cosmosDBService.UpsertSessionBatchAsync(promptMessage, completionMessage, completionPrompt, session);
    }

    /// <summary>
    /// Rate an assistant message. This can be used to discover useful AI responses for training, discoverability, and other benefits down the road.
    /// </summary>
    public async Task<Message> RateMessageAsync(string id, string sessionId, bool? rating)
    {
        ArgumentNullException.ThrowIfNull(id);
        ArgumentNullException.ThrowIfNull(sessionId);

        return await _cosmosDBService.UpdateMessageRatingAsync(id, sessionId, rating);
    }

    public async Task AddProduct(Product product)
    {
        ArgumentNullException.ThrowIfNull(product);
        ArgumentException.ThrowIfNullOrEmpty(product.id);
        ArgumentException.ThrowIfNullOrEmpty(product.categoryId);

        await _cosmosDBService.InsertProductAsync(product);
    }

    public async Task AddCustomer(Customer customer)
    {
        ArgumentNullException.ThrowIfNull(customer);
        ArgumentException.ThrowIfNullOrEmpty(customer.id);
        ArgumentException.ThrowIfNullOrEmpty(customer.customerId);

        await _cosmosDBService.InsertCustomerAsync(customer);
    }

    public async Task AddSalesOrder(SalesOrder salesOrder)
    {
        ArgumentNullException.ThrowIfNull(salesOrder);
        ArgumentException.ThrowIfNullOrEmpty(salesOrder.id);
        ArgumentException.ThrowIfNullOrEmpty(salesOrder.customerId);

        await _cosmosDBService.InsertSalesOrderAsync(salesOrder);
    }

    public async Task DeleteProduct(string productId, string categoryId)
    {
        ArgumentException.ThrowIfNullOrEmpty(productId);
        ArgumentException.ThrowIfNullOrEmpty(categoryId);

        await _cosmosDBService.DeleteProductAsync(productId, categoryId);

        try
        {
            IItemTransformer itemTransformer = _itemTransformerFactory.CreateItemTransformer(
                new Product { id = productId });

            // Remove the entity from the Semantic Kernel memory used by the RAG service
            await _ragService.RemoveMemory(itemTransformer);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error attempting to remove memory for product id {productId} (category id {categoryId})");
        }
    }

    public async Task<CompletionPrompt> GetCompletionPrompt(string sessionId, string completionPromptId)
    {
        ArgumentException.ThrowIfNullOrEmpty(sessionId);
        ArgumentException.ThrowIfNullOrEmpty(completionPromptId);

        return await _cosmosDBService.GetCompletionPrompt(sessionId, completionPromptId);
    }

    public async Task ResetSemanticCache() =>
        await _ragService.ResetSemanticCache();
}