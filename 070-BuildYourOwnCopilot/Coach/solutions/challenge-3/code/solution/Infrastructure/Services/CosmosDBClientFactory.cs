using BuildYourOwnCopilot.Common.Models.Configuration;
using BuildYourOwnCopilot.Infrastructure.Interfaces;
using BuildYourOwnCopilot.SemanticKernel.Memory;
using Microsoft.Azure.Cosmos;
using Microsoft.Extensions.Options;
using System.Text.Json;

namespace BuildYourOwnCopilot.Infrastructure.Services
{
    public class CosmosDBClientFactory(
        IOptions<CosmosDBSettings> settings) : ICosmosDBClientFactory
    {
        private readonly CosmosDBSettings _settings = settings.Value;

        private readonly CosmosClient _client = new CosmosClient(
            settings.Value.Endpoint,
            settings.Value.Key,
            new CosmosClientOptions
            {
                ConnectionMode = ConnectionMode.Gateway,
                Serializer = new CosmosSystemTextJsonSerializer(JsonSerializerOptions.Default)
            });

        public CosmosClient Client => _client;

        public string DatabaseName => _settings.Database;
    }
}
