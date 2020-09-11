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
    public class FlightDataCosmosSQLProvider : IWritableDataProvider<FlightModel>, IFlightDataProvider
    {
        private readonly CosmosDBProvider _cosmosDBProvider;
        const string COLLECTIONNAME = "Flights";
        private AsyncLazy<DocumentClient> _getClientAndVerifyCollection;

        public FlightDataCosmosSQLProvider(CosmosDBProvider cosmosDBProvider)
        {
            _cosmosDBProvider = cosmosDBProvider;
            _getClientAndVerifyCollection = new AsyncLazy<DocumentClient>(async () =>
            {
                return await _cosmosDBProvider.GetDocumentClientAndVerifyCollection(COLLECTIONNAME, new string[] { "/departingFrom", "/arrivingAt", "/departureTimeEpoc" });
            });
        }

        public async Task<FlightModel> FindFlight(int flightId, CancellationToken cancellationToken)
        {
            var docClient = await _getClientAndVerifyCollection;
            return await _cosmosDBProvider.FindById<FlightModel>(docClient, COLLECTIONNAME, flightId.ToString(), cancellationToken);
        }

        public async Task<IEnumerable<FlightModel>> FindFlights(string departingFrom, string arrivingAt, DateTimeOffset desiredTime, TimeSpan offset, CancellationToken cancellationToken)
        {
            var docClient = await _getClientAndVerifyCollection;
            return await _cosmosDBProvider.GetAll<FlightModel>(docClient, COLLECTIONNAME, (q) => q.Where(f => f.DepartingFrom == departingFrom &&
                                                                                                            f.ArrivingAt == arrivingAt &&
                                                                                                            f.DepartureTimeEpoc >= desiredTime.Subtract(offset).ToEpoch() &&
                                                                                                           f.DepartureTimeEpoc <= desiredTime.Add(offset).ToEpoch()).OrderBy(f => f.DepartureTimeEpoc), cancellationToken);
        }

        public async Task<bool> Persist(FlightModel instance, CancellationToken cancellationToken)
        {
            var docClient = await _getClientAndVerifyCollection;
            return await _cosmosDBProvider.Persist<FlightModel>(docClient, COLLECTIONNAME, instance, cancellationToken);
        }
    }
}
