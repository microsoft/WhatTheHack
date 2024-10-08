using BuildYourOwnCopilot.Common.Models.BusinessDomain;
using BuildYourOwnCopilot.Infrastructure.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace ChatAPI
{
    public class ChatEndpoints
    {
        private readonly IChatService _chatService;

        public ChatEndpoints(IChatService chatService)
        {
            _chatService = chatService;
        }

        public void Map(WebApplication app)
        {
            app.MapGet("/status", () => _chatService.Status)
                .WithName("GetServiceStatus");

            app.MapGet("/sessions/", async () => await _chatService.GetAllChatSessionsAsync())
                .WithName("GetAllChatSessions");

            app.MapGet("/sessions/{sessionId}/messages",
                    async (string sessionId) => await _chatService.GetChatSessionMessagesAsync(sessionId))
                .WithName("GetChatSessionMessages");

            app.MapPost("/sessions/{sessionId}/message/{messageId}/rate", 
                    async (string messageId, string sessionId, bool? rating) =>
                    await _chatService.RateMessageAsync(messageId, sessionId, rating))
                .WithName("RateMessage");

            app.MapGet("/sessions/{sessionId}/completionprompts/{completionPromptId}",
                    async (string sessionId, string completionPromptId) =>
                    await _chatService.GetCompletionPrompt(sessionId, completionPromptId))
                .WithName("GetCompletionPrompt");

            app.MapPost("/sessions/", async () => await _chatService.CreateNewChatSessionAsync())
                .WithName("CreateNewChatSession");

            app.MapPost("/sessions/{sessionId}/rename", async (string sessionId, string newChatSessionName) =>
                    await _chatService.RenameChatSessionAsync(sessionId, newChatSessionName))
                .WithName("RenameChatSession");

            app.MapDelete("/sessions/{sessionId}", async (string sessionId) =>
                    await _chatService.DeleteChatSessionAsync(sessionId))
                .WithName("DeleteChatSession");

            app.MapPost("/sessions/{sessionId}/completion", async (string sessionId, [FromBody] string userPrompt) =>
                    await _chatService.GetChatCompletionAsync(sessionId, userPrompt))
                .WithName("GetChatCompletion");

            app.MapPost("/sessions/{sessionId}/summarize-name", async (string sessionId, [FromBody] string prompt) =>
                    await _chatService.SummarizeChatSessionNameAsync(sessionId, prompt))
                .WithName("SummarizeChatSessionName");

            app.MapPut("/products", async ([FromBody] Product product) =>
                    await _chatService.AddProduct(product))
                .WithName("AddProduct");

            app.MapPut("/customers", async ([FromBody] Customer customer) =>
                    await _chatService.AddCustomer(customer))
                .WithName("AddCustomer");

            app.MapPut("/salesorders", async ([FromBody] SalesOrder salesOrder) =>
                    await _chatService.AddSalesOrder(salesOrder))
                .WithName("AddSalesOrder");

            app.MapDelete("/products/{productId}", async (string productId, string categoryId) =>
                    await _chatService.DeleteProduct(productId, categoryId))
                .WithName("DeleteProduct");

            app.MapPost("/semanticcache/reset", async () =>
                await _chatService.ResetSemanticCache())
                .WithName("ResetSemanticCache");
        }
    }
}
