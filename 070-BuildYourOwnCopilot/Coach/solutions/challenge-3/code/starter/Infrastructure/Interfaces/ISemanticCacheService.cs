using BuildYourOwnCopilot.Common.Models.Chat;
using BuildYourOwnCopilot.Infrastructure.Models.Chat;

namespace BuildYourOwnCopilot.Infrastructure.Interfaces
{
    public interface ISemanticCacheService
    {
        Task Initialize();
        Task Reset();
        void SetMinRelevanceOverride(double minRelevance);

        Task<SemanticCacheItem> GetCacheItem(string userPrompt, List<Message> messageHistory);
        Task SetCacheItem(SemanticCacheItem cacheItem);
    }
}
