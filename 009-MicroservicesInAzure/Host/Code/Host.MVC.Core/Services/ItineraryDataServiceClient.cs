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
    public class ItineraryDataServiceClient : IItineraryDataProvider
    {
        private readonly HttpClient _httpClient;

        private readonly ILogger<ItineraryDataServiceClient> _logger;

        public ItineraryDataServiceClient(IHttpClientFactory httpClientFactory, ILogger<ItineraryDataServiceClient> logger)
        {
            _logger = logger;
            _httpClient = httpClientFactory.CreateClient("ItineraryService");
        }

        public async Task<ItineraryPersistenceModel> FindItinerary(string cartId, CancellationToken cancellationToken)
        {
            return await _httpClient.GetAsyncAs<ItineraryPersistenceModel>($"api/Itinerary/search/{cartId}", cancellationToken, _logger);
        }

        public async Task<ItineraryPersistenceModel> GetItinerary(string recordLocator, CancellationToken cancellationToken)
        {
            return await _httpClient.GetAsyncAs<ItineraryPersistenceModel>($"api/Itinerary/{recordLocator}", cancellationToken, _logger);
        }

        public async Task UpsertItinerary(ItineraryPersistenceModel itinerary, CancellationToken cancellationToken)
        {
            await _httpClient.PostAsync<ItineraryPersistenceModel>("api/Itinerary", itinerary, new System.Net.Http.Formatting.JsonMediaTypeFormatter());
        }
    }
}
