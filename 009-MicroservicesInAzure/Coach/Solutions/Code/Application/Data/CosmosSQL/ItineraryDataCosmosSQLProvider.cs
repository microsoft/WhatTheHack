using ContosoTravel.Web.Application.Interfaces;
using Microsoft.Azure.Documents;
using Microsoft.Azure.Documents.Client;
using Nito.AsyncEx;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Linq;
using ContosoTravel.Web.Application.Models;
using Microsoft.Azure.Documents.Linq;


namespace ContosoTravel.Web.Application.Data.CosmosSQL
{
    public class ItineraryDataCosmosSQLProvider : IItineraryDataProvider
    {
        private readonly CosmosDBProvider _cosmosDBProvider;
        const string COLLECTIONNAME = "Itineraries";
        private AsyncLazy<DocumentClient> _getClientAndVerifyCollection;

        public ItineraryDataCosmosSQLProvider(CosmosDBProvider cosmosDBProvider)
        {
            _cosmosDBProvider = cosmosDBProvider;
            _getClientAndVerifyCollection = new AsyncLazy<DocumentClient>(async () =>
            {
                return await _cosmosDBProvider.GetDocumentClientAndVerifyCollection(COLLECTIONNAME, new string[] { "/recordLocator" });
            });
        }

        public async Task<ItineraryPersistenceModel> FindItinerary(string cartId, CancellationToken cancellationToken)
        {
            var docClient = await _getClientAndVerifyCollection;
            return (await _cosmosDBProvider.GetAll<ItineraryPersistenceModel>(docClient, COLLECTIONNAME, (q) => q.Where(f => f.Id == cartId), cancellationToken)).FirstOrDefault();
        }

        public async Task<ItineraryPersistenceModel> GetItinerary(string recordLocator, CancellationToken cancellationToken)
        {
            var docClient = await _getClientAndVerifyCollection;
            return (await _cosmosDBProvider.GetAll<ItineraryPersistenceModel>(docClient, COLLECTIONNAME, (q) => q.Where(f => f.RecordLocator == recordLocator), cancellationToken)).FirstOrDefault();
        }

        public async Task UpsertItinerary(ItineraryPersistenceModel itinerary, CancellationToken cancellationToken)
        {
            var docClient = await _getClientAndVerifyCollection;
            await _cosmosDBProvider.Persist<ItineraryPersistenceModel>(docClient, COLLECTIONNAME, itinerary, cancellationToken);
        }
    }
}
