using ContosoTravel.Web.Application.Interfaces;
using ContosoTravel.Web.Application.Models;
using Microsoft.Azure.Documents.Client;
using Nito.AsyncEx;
using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;


namespace ContosoTravel.Web.Application.Data.CosmosSQL
{
    public class CartDataCosmosSQLProvider : ICartDataProvider
    {
        private readonly CosmosDBProvider _cosmosDBProvider;
        const string COLLECTIONNAME = "Carts";
        private AsyncLazy<DocumentClient> _getClientAndVerifyCollection;
        private ContosoConfiguration _contosoConfig;

        public CartDataCosmosSQLProvider(CosmosDBProvider cosmosDBProvider, ContosoConfiguration contosoConfig)
        {
            _cosmosDBProvider = cosmosDBProvider;
            _contosoConfig = contosoConfig;
            _getClientAndVerifyCollection = new AsyncLazy<DocumentClient>(async () =>
            {
                return await _cosmosDBProvider.GetDocumentClientAndVerifyCollection(COLLECTIONNAME);
            });
        }

        public async Task<CartPersistenceModel> GetCart(string cartId, CancellationToken cancellationToken)
        {
            var docClient = await _getClientAndVerifyCollection;
            return (await _cosmosDBProvider.GetAll<CartPersistenceModel>(docClient, COLLECTIONNAME, (q) => q.Where(f => f.Id == cartId), cancellationToken)).FirstOrDefault();
        }

        public async Task<CartPersistenceModel> UpsertCartFlights(string cartId, int departingFlightId, int returningFlightId, CancellationToken cancellationToken)
        {
            return await UpdateAndPersist(cartId, (cart) =>
            {
                cart.DepartingFlight = departingFlightId;
                cart.ReturningFlight = returningFlightId;
            }, cancellationToken);
        }

        public async Task<CartPersistenceModel> UpsertCartCar(string cartId, int carId, double numberOfDays, CancellationToken cancellationToken)
        {
            return await UpdateAndPersist(cartId, (cart) =>
            {
                cart.CarReservation = carId;
                cart.CarReservationDuration = numberOfDays;
            }, cancellationToken);
        }

        public async Task<CartPersistenceModel> UpsertCartHotel(string cartId, int hotelId, int numberOfDays, CancellationToken cancellationToken)
        {
            return await UpdateAndPersist(cartId, (cart) =>
            {
                cart.HotelReservation = hotelId;
                cart.HotelReservationDuration = numberOfDays;
            }, cancellationToken);
        }

        public async Task DeleteCart(string cartId, CancellationToken cancellationToken)
        {
            var docClient = await _getClientAndVerifyCollection;
            await docClient.DeleteDocumentAsync(UriFactory.CreateDocumentUri(_contosoConfig.DatabaseName, COLLECTIONNAME, cartId.ToLower()), cancellationToken: cancellationToken);
        }

        private async Task<CartPersistenceModel> UpdateAndPersist(string cartId, Action<CartPersistenceModel> updateMe, CancellationToken cancellationToken)
        {
            var docClient = await _getClientAndVerifyCollection;
            var cart = await GetCart(cartId, cancellationToken);
            if ( cart == null )
            {
                cart = new CartPersistenceModel() { Id = cartId };
            }
            updateMe(cart);
            await _cosmosDBProvider.Persist<CartPersistenceModel>(docClient, COLLECTIONNAME, cart, cancellationToken);
            return cart;
        }
    }
}
