using Azure;
using Azure.Search.Documents;
using Azure.Search.Documents.Models;

namespace VectorSearchAiAssistant.Service.Interfaces
{
    public interface ICognitiveSearchService
    {
        Task Initialize(List<Type> typesToIndex);

        Task IndexItem(object item);

        Task<Response<SearchResults<SearchDocument>>> SearchAsync(SearchOptions searchOptions);
    }
}
