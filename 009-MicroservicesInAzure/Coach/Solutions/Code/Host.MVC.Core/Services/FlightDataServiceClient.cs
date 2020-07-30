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
    public class FlightDataServiceClient : IFlightDataProvider
    {
        private readonly HttpClient _httpClient;

        private readonly ILogger<FlightDataServiceClient> _logger;

        public FlightDataServiceClient(IHttpClientFactory httpClientFactory, ILogger<FlightDataServiceClient> logger)
        {
            _logger = logger;
            _httpClient = httpClientFactory.CreateClient("DataService");
        }

        public async Task<FlightModel> FindFlight(int carId, CancellationToken cancellationToken)
        {
            return await _httpClient.GetAsyncAs<FlightModel>($"api/Flight/{carId}", cancellationToken, _logger);
        }

        public async Task<IEnumerable<FlightModel>> FindFlights(string departingFrom, string arrivingAt, DateTimeOffset desiredTime, TimeSpan offset, CancellationToken cancellationToken)
        {
            return await _httpClient.GetAsyncAs<IEnumerable<FlightModel>>($"api/Flight/search/{departingFrom}/{arrivingAt}?desiredTime={System.Web.HttpUtility.UrlEncode(desiredTime.ToString())}&offset={System.Web.HttpUtility.UrlEncode(offset.ToString())}", cancellationToken, _logger);
        }
    }
}
