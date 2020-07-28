using ContosoTravel.Web.Application.Interfaces;
using ContosoTravel.Web.Application.Models;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;

namespace ContosoTravel.Web.Host.MVC.Core.Services
{
    public class ItineraryPurchaseServiceClient : IPurchaseService
    {
        private readonly HttpClient _httpClient;
        private readonly ICartDataProvider _cartDataProvider;

        private readonly ILogger<ItineraryDataServiceClient> _logger;

        public ItineraryPurchaseServiceClient(IHttpClientFactory httpClientFactory, ILogger<ItineraryDataServiceClient> logger, ICartDataProvider cartDataProvider)
        {
            _logger = logger;
            _httpClient = httpClientFactory.CreateClient("ItineraryService");
            _cartDataProvider = cartDataProvider;
        }

        public async Task<bool> SendForProcessing(string cartId, DateTimeOffset PurchasedOn, CancellationToken cancellationToken)
        {
            var cart = await _cartDataProvider.GetCart(cartId, cancellationToken);

            if ( cart != null )
            {
                await _httpClient.PostAsync<CartPersistenceModel>($"api/Itinerary/purchase?purchasedOn={System.Web.HttpUtility.UrlEncode(PurchasedOn.ToString())}", cart, new System.Net.Http.Formatting.JsonMediaTypeFormatter());
                return true;
            }

            return false;

        }
    }
}
