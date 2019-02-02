using ContosoTravel.Web.Application.Services;
using Microsoft.Azure.Documents;
using Microsoft.Azure.Documents.Client;
using Microsoft.Azure.Documents.Linq;
using Nito.AsyncEx;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace ContosoTravel.Web.Application.Data.CosmosSQL
{
    public class CosmosDBProvider
    {
        private DocumentClient _client;
        private ContosoConfiguration _contosoConfig;

        public CosmosDBProvider(ContosoConfiguration contosoConfig, AzureManagement azureManagement)
        {
            _contosoConfig = contosoConfig;

            _client = new DocumentClient(new Uri($"https://{contosoConfig.DataAccountName}.documents.azure.com"), contosoConfig.DataAccountPassword, new ConnectionPolicy() { RetryOptions = new RetryOptions() { MaxRetryAttemptsOnThrottledRequests = 20 } });

        }

        public DocumentClient GetDocumentClient()
        {
            return _client;
        }

        public async Task<DocumentClient> GetDocumentClientAndVerifyCollection(string collection, params string[][] indexes)
        {
            // leave indexes for later

            await _client.CreateDocumentCollectionIfNotExistsAsync(UriFactory.CreateDatabaseUri(_contosoConfig.DatabaseName),
                                                                     new DocumentCollection
                                                                     {
                                                                         Id = collection
                                                                     },
                                                                     new RequestOptions { OfferThroughput = 400 });
            return _client;
        }

        public async Task<T> FindById<T>(DocumentClient client, string collection, string id, CancellationToken cancellationToken)
        {
            return await client.ReadDocumentAsync<T>(UriFactory.CreateDocumentUri(_contosoConfig.DatabaseName, collection, id), cancellationToken: cancellationToken);
        }

        public async Task<FeedResponse<T>> GetAll<T>(DocumentClient client, string collection, Func<IOrderedQueryable<T>, IQueryable<T>> filter, CancellationToken cancellationToken)
        {
            var query = filter(client.CreateDocumentQuery<T>(UriFactory.CreateDocumentCollectionUri(_contosoConfig.DatabaseName, collection),
                                                                                                           new FeedOptions
                                                                                                           {
                                                                                                               EnableCrossPartitionQuery = true
                                                                                                           })).AsDocumentQuery();

            var response = await query.ExecuteNextAsync<T>(cancellationToken);
            return response;
        }

        public async Task<bool> Persist<T>(DocumentClient client, string collection, T instance, CancellationToken cancellationToken)
        {
            await client.UpsertDocumentAsync(UriFactory.CreateDocumentCollectionUri(_contosoConfig.DatabaseName, collection), instance, cancellationToken: cancellationToken, disableAutomaticIdGeneration: true);
            return true;
        }
    }
}
