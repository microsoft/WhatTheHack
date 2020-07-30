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
    public class HotelDataServiceClient : IHotelDataProvider
    {
        private readonly HttpClient _httpClient;

        private readonly ILogger<HotelDataServiceClient> _logger;

        public HotelDataServiceClient(IHttpClientFactory httpClientFactory, ILogger<HotelDataServiceClient> logger)
        {
            _logger = logger;
            _httpClient = httpClientFactory.CreateClient("DataService");
        }

        public async Task<HotelModel> FindHotel(int hotelId, CancellationToken cancellationToken)
        {
            return await _httpClient.GetAsyncAs<HotelModel>($"api/Hotel/{hotelId}", cancellationToken, _logger);
        }

        public async Task<IEnumerable<HotelModel>> FindHotels(string location, DateTimeOffset desiredTime, CancellationToken cancellationToken)
        {
            return await _httpClient.GetAsyncAs<IEnumerable<HotelModel>>($"api/Hotel/search/{location}?desiredTime={System.Web.HttpUtility.UrlEncode(desiredTime.ToString())}", cancellationToken, _logger);
        }
    }
}
