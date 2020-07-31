using ContosoTravel.Web.Application.Interfaces;
using ContosoTravel.Web.Application.Models;
using ContosoTravel.Web.Application.Services;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace ContosoTravel.Web.Host.ItineraryService.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ItineraryController : ControllerBase
    {
        private readonly IItineraryDataProvider _itineraryDataProvider;
        private readonly FulfillmentService _fulfillmentService;

        public ItineraryController(IItineraryDataProvider itineraryDataProvider, FulfillmentService fulfillmentService)
        {
            _itineraryDataProvider = itineraryDataProvider;
            _fulfillmentService = fulfillmentService;
        }

        [HttpPost]
        public async Task UpsertItinerary([FromBody]ItineraryPersistenceModel itinerary, CancellationToken cancellationToken)
        {
             await _itineraryDataProvider.UpsertItinerary(itinerary, cancellationToken);
        }

        [HttpPost("purchase")]
        public async Task PurchaseItinerary([FromBody]CartPersistenceModel cart, DateTimeOffset purchasedOn, CancellationToken cancellationToken)
        {
            await _fulfillmentService.Purchase(cart, purchasedOn, cancellationToken);
        }

        [HttpGet("search/{cartId}")]
        public async Task<ItineraryPersistenceModel> FindItineraryByCart(string cartId, CancellationToken cancellationToken)
        {
            return await _itineraryDataProvider.FindItinerary(cartId, cancellationToken);
        }

        [HttpGet("{recordLocator}")]
        public async Task<ItineraryPersistenceModel> GetItinerary(string recordLocator, CancellationToken cancellationToken)
        {
            return await _itineraryDataProvider.GetItinerary(recordLocator, cancellationToken);
        }
    }
}