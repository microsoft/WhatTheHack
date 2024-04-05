using Azure;
using Azure.Core.Serialization;
using Azure.Search.Documents;
using Azure.Search.Documents.Indexes;
using Azure.Search.Documents.Indexes.Models;
using Azure.Search.Documents.Models;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using System.Text.Json;
using VectorSearchAiAssistant.SemanticKernel.Models;
using VectorSearchAiAssistant.Service.Interfaces;
using VectorSearchAiAssistant.Service.Models.ConfigurationOptions;

namespace VectorSearchAiAssistant.Service.Services
{
    public class CognitiveSearchService : ICognitiveSearchService
    {
        readonly CognitiveSearchSettings _settings;
        readonly ILogger _logger;

        readonly SearchIndexClient _adminClient;
        readonly string _searchIndexName;
        readonly SearchClientOptions _searchClientOptions;

        SearchClient _searchClient;

        public CognitiveSearchService(
            IOptions<CognitiveSearchSettings> options,
            ILogger<CognitiveSearchSettings> logger)
        {
            _settings = options.Value;
            _logger = logger;

            _searchIndexName = $"{_settings.IndexName}-content";

            _searchClientOptions = new SearchClientOptions
            {
                Serializer = new JsonObjectSerializer(new JsonSerializerOptions
                {
                    PropertyNamingPolicy = JsonNamingPolicy.CamelCase
                })
            };

            AzureKeyCredential credential = new(_settings.Key);
            _adminClient = new SearchIndexClient(new Uri(_settings.Endpoint), credential, _searchClientOptions);
        }

        /// <summary>
        /// Initialize the underlying Azure Cognitive Search index.
        /// </summary>
        /// <param name="typesToIndex">The object types supported by the index.</param>
        /// <returns></returns>
        public async Task Initialize(List<Type> typesToIndex)
        {
            try
            {
                var indexNames = await _adminClient.GetIndexNamesAsync().ToListAsync().ConfigureAwait(false);
                if (indexNames.Contains(_searchIndexName))
                {
                    _logger.LogInformation($"The {_searchIndexName} index already exists; index will be updated.");
                }

                var fieldBuilder = new FieldBuilder();

                var fieldsToIndex = typesToIndex
                    .Select(tti => fieldBuilder.Build(tti))
                    .SelectMany(x => x);

                // Combine the search fields, eliminating duplicate names:
                var allFields = fieldsToIndex
                    .GroupBy(field => field.Name)
                    .Select(group => group.First())
                    .ToList();

                SearchIndex searchIndex = new(_searchIndexName)
                {
                    Fields = allFields
                };

                await _adminClient.CreateOrUpdateIndexAsync(searchIndex);
                _searchClient = _adminClient.GetSearchClient(_searchIndexName);

                _logger.LogInformation($"Created the {_searchIndexName} index.");
            }
            catch (Exception e)
            {
                _logger.LogError($"An error occurred while trying to build the {_searchIndexName} index: {e}");
            }
        }

        public async Task IndexItem(object item)
        {
            try
            {
                if (item is EmbeddedEntity entity)
                    entity.entityType__ = item.GetType().Name;
                else
                    throw new ArgumentException("Only objects derived from EmbeddedEntity can be added to the index.");

                await _searchClient.IndexDocumentsAsync(IndexDocumentsBatch.Upload(new object[] { item }));
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error indexing item {item}. The error is {ex.Message}.");
            }
        }

        public async Task<Response<SearchResults<SearchDocument>>> SearchAsync(SearchOptions searchOptions)
        {
            var result = await _searchClient
                .SearchAsync<SearchDocument>("*", searchOptions);
            return result;
        }
    }
}
