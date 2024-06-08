using VectorSearchAiAssistant.Service.Models.Chat;
using VectorSearchAiAssistant.Service.Models.Search;

namespace VectorSearchAiAssistant.Service.Interfaces
{
    public interface IRAGService
    {
        bool IsInitialized { get; }

        Task<(string Completion, string UserPrompt, int UserPromptTokens, int ResponseTokens, float[]? UserPromptEmbedding)> GetResponse(string userPrompt, List<Message> messageHistory);

        Task<string> Summarize(string sessionId, string userPrompt);

        Task AddMemory(object item, string itemName);

        Task RemoveMemory(object item);
    }
}
