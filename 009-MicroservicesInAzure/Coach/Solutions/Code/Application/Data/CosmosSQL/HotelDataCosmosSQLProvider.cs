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
    public class HotelDataCosmosSQLProvider : IWritableDataProvider<HotelModel>, IHotelDataProvider
    {
        private readonly CosmosDBProvider _cosmosDBProvider;
        const string COLLECTIONNAME = "Hotels";
        private AsyncLazy<DocumentClient> _getClientAndVerifyCollection;

        public HotelDataCosmosSQLProvider(CosmosDBProvider cosmosDBProvider)
        {
            _cosmosDBProvider = cosmosDBProvider;
            _getClientAndVerifyCollection = new AsyncLazy<DocumentClient>(async () =>
            {
                return await _cosmosDBProvider.GetDocumentClientAndVerifyCollection(COLLECTIONNAME, new string[] { "/location", "/startingTimeEpoc", "/endingTimeEpoc" });
            });
        }

        public async Task<HotelModel> FindHotel(int hotelId, CancellationToken cancellationToken)
        {
            var docClient = await _getClientAndVerifyCollection;
            return await _cosmosDBProvider.FindById<HotelModel>(docClient, COLLECTIONNAME, hotelId.ToString(), cancellationToken);
        }

        public async Task<IEnumerable<HotelModel>> FindHotels(string location, DateTimeOffset desiredTime, CancellationToken cancellationToken)
        {
            var docClient = await _getClientAndVerifyCollection;
            return await _cosmosDBProvider.GetAll<HotelModel>(docClient, COLLECTIONNAME, (q) => q.Where(c => c.Location == location &&
                                                                                                             c.StartingTimeEpoc <= desiredTime.ToEpoch() &&
                                                                                                             c.EndingTimeEpoc >= desiredTime.ToEpoch()).OrderBy(c => c.Cost), cancellationToken);
        }

        public async Task<bool> Persist(HotelModel instance, CancellationToken cancellationToken)
        {
            var docClient = await _getClientAndVerifyCollection;
            return await _cosmosDBProvider.Persist<HotelModel>(docClient, COLLECTIONNAME, instance, cancellationToken);
        }
    }
}
