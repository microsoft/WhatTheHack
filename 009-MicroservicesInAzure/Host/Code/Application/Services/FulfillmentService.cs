using ContosoTravel.Web.Application.Interfaces;
using ContosoTravel.Web.Application.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace ContosoTravel.Web.Application.Services
{
    public class FulfillmentService
    {
        // reference https://github.com/18F/record-locator
        private char[] SAFECHARACTERS = "234679CDFGHJKMNPRTWXYZ".ToCharArray();
        private readonly ICartDataProvider _cartDataProvider;
        private readonly IItineraryDataProvider _itineraryDataProvider;
        private Random _random = new Random();

        public FulfillmentService(ICartDataProvider cartDataProvider, IItineraryDataProvider itineraryDataProvider)
        {
            _cartDataProvider = cartDataProvider;
            _itineraryDataProvider = itineraryDataProvider;
        }

        public async Task<string> Purchase(string cartId, System.DateTimeOffset PurchasedOn, CancellationToken cancellationToken)
        {
            CartPersistenceModel cart = await _cartDataProvider.GetCart(cartId, cancellationToken);
            return await Purchase(cart, PurchasedOn, cancellationToken);
        }

        public async Task<string> Purchase(CartPersistenceModel cart, System.DateTimeOffset PurchasedOn, CancellationToken cancellationToken)
        {
            ItineraryPersistenceModel itinerary = JsonConvert.DeserializeObject<ItineraryPersistenceModel>(JsonConvert.SerializeObject(cart));
            itinerary.PurchasedOn = PurchasedOn;

            for (int ii = 0; ii < 6; ii++)
            {
                itinerary.RecordLocator += SAFECHARACTERS[_random.Next(0, 21)];
            }

            await _itineraryDataProvider.UpsertItinerary(itinerary, cancellationToken);
            return itinerary.RecordLocator;
        }
    }
}
