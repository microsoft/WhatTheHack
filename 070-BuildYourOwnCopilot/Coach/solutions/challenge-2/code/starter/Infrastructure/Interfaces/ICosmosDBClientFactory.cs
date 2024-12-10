using Microsoft.Azure.Cosmos;

namespace BuildYourOwnCopilot.Infrastructure.Interfaces
{
    public interface ICosmosDBClientFactory
    {
        public string DatabaseName { get; }

        public CosmosClient Client { get; }
    }
}
