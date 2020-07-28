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
    public class CarDataServiceClient : ICarDataProvider
    {
        private readonly HttpClient _httpClient;

        private readonly ILogger<CarDataServiceClient> _logger;

        public CarDataServiceClient(IHttpClientFactory httpClientFactory, ILogger<CarDataServiceClient> logger)
        {
            _logger = logger;
            _httpClient = httpClientFactory.CreateClient("DataService");
        }

        public async Task<CarModel> FindCar(int carId, CancellationToken cancellationToken)
        {
            return await _httpClient.GetAsyncAs<CarModel>($"api/Car/{carId}", cancellationToken, _logger);
        }

        public async Task<IEnumerable<CarModel>> FindCars(string location, DateTimeOffset desiredTime, CancellationToken cancellationToken)
        {
            return await _httpClient.GetAsyncAs<IEnumerable<CarModel>>($"api/Car/search/{location}?desiredTime={System.Web.HttpUtility.UrlEncode(desiredTime.ToString())}", cancellationToken, _logger);
        }
    }
}
