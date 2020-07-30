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
    public class AirportDataCosmosSQLProvider : IWritableDataProvider<AirportModel>, IAirportDataProvider
    {
        private readonly CosmosDBProvider _cosmosDBProvider;
        const string COLLECTIONNAME = "Airports";
        private AsyncLazy<DocumentClient> _getClientAndVerifyCollection;

        public AirportDataCosmosSQLProvider(CosmosDBProvider cosmosDBProvider)
        {
            _cosmosDBProvider = cosmosDBProvider;
            _getClientAndVerifyCollection = new AsyncLazy<DocumentClient>(async () =>
            {
                return await _cosmosDBProvider.GetDocumentClientAndVerifyCollection(COLLECTIONNAME);
            });
        }

        public async Task<AirportModel> FindByCode(string airportCode, CancellationToken cancellationToken)
        {
            var docClient = await _getClientAndVerifyCollection;
            return await _cosmosDBProvider.FindById<AirportModel>(docClient, COLLECTIONNAME, airportCode, cancellationToken);
        }

        public async Task<IEnumerable<AirportModel>> GetAll(CancellationToken cancellationToken)
        {
            var docClient = await _getClientAndVerifyCollection;
            return await _cosmosDBProvider.GetAll<AirportModel>(docClient, COLLECTIONNAME, (q) => q.Select(air => air), cancellationToken);
        }

        public async Task<bool> Persist(AirportModel instance, CancellationToken cancellationToken)
        {
            var docClient = await _getClientAndVerifyCollection;
            return await _cosmosDBProvider.Persist<AirportModel>(docClient, COLLECTIONNAME, instance, cancellationToken);
        }
    }
}
