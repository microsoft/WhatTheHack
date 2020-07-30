using ContosoTravel.Web.Application.Interfaces;
using ContosoTravel.Web.Application.Models;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace ContosoTravel.Web.Application.Services.Monolith
{
    public class PurchaseMonolithService : IPurchaseService
    {
        private readonly FulfillmentService _fulfillmentService;
        private readonly Random _random = new Random();

        public PurchaseMonolithService(FulfillmentService fulfillmentService)
        {
            _fulfillmentService = fulfillmentService;
        }

        public async Task<bool> SendForProcessing(string cartId, System.DateTimeOffset PurchasedOn, CancellationToken cancellationToken)
        {
            await Task.Delay(_random.Next(0, 30) * 1000);   
            string recordId = await _fulfillmentService.Purchase(cartId, PurchasedOn, cancellationToken);
            return !string.IsNullOrEmpty(recordId);
        }
    }
}
