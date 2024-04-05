using Azure.Search.Documents;
using Microsoft.Extensions.Logging;
using Azure.Search.Documents.Models;
using Azure.Storage.Blobs;
using Newtonsoft.Json;
using Microsoft.Extensions.Options;
using VectorSearchAiAssistant.Service.Interfaces;

namespace VectorSearchAiAssistant.Service.MemorySource
{
    public class AzureCognitiveSearchMemorySource : IMemorySource
    {
        private readonly ICognitiveSearchService _cognitiveSearchService;
        private readonly AzureCognitiveSearchMemorySourceSettings _settings;
        private readonly ILogger _logger;

        private AzureCognitiveSearchMemorySourceConfig _config;

        public AzureCognitiveSearchMemorySource(
            ICognitiveSearchService cognitiveSearchService,
            IOptions<AzureCognitiveSearchMemorySourceSettings> settings,
            ILogger<AzureCognitiveSearchMemorySource> logger)
        {
            _cognitiveSearchService = cognitiveSearchService;
            _settings = settings.Value;
            _logger = logger;
        }


        /// <summary>
        /// This function runs faceted queries to count all of the products in a product category and all the products for the company.
        /// This data is then vectorized and stored in semantic kernel's short term memory to use as a source of data for any vector queries.
        /// </summary>
        /// <returns></returns>
        public async Task<List<string>> GetMemories()
        {
            await EnsureConfig();

            var memories = new List<string>();

            foreach (var memorySource in _config.FacetedQueryMemorySources)
            {
                var searchOptions = new SearchOptions
                {
                    Filter = memorySource.Filter,
                    Size = 0
                };
                foreach (var facet in memorySource.Facets)
                    searchOptions.Facets.Add(facet.Facet);

                var facetTemplates = memorySource.Facets.ToDictionary(f => f.Facet.Split(',')[0], f => f.CountMemoryTemplate);

                var result = await _cognitiveSearchService.SearchAsync(searchOptions);

                long totalCount = 0;
                foreach (var facet in result.Value.Facets)
                {
                    foreach (var facetResult in facet.Value)
                    {
                        memories.Add(string.Format(
                            facetTemplates[facet.Key],
                            facetResult.Value, facetResult.Count));
                        totalCount += facetResult.Count.Value;
                    }
                }
                //This is the faceted query for counting all the products for Cosmic Works
                memories.Add(string.Format(memorySource.TotalCountMemoryTemplate, totalCount));
            }

            return memories;
        }

        private async Task EnsureConfig()
        {
            if (_config == null)
            {
                var blobServiceClient = new BlobServiceClient(_settings.ConfigBlobStorageConnection);
                var storageClient = blobServiceClient.GetBlobContainerClient(_settings.ConfigBlobStorageContainer);
                var blobClient = storageClient.GetBlobClient(_settings.ConfigFilePath);
                var reader = new StreamReader(await blobClient.OpenReadAsync());
                var configContent = await reader.ReadToEndAsync();

                _config = JsonConvert.DeserializeObject<AzureCognitiveSearchMemorySourceConfig>(configContent);
            }
        }
    }
}
