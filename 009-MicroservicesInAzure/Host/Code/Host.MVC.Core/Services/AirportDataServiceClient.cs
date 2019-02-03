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
    public class AirportDataServiceClient : IAirportDataProvider
    {
        private readonly HttpClient _httpClient;

        private readonly ILogger<AirportDataServiceClient> _logger;

        public AirportDataServiceClient(IHttpClientFactory httpClientFactory, ILogger<AirportDataServiceClient> logger)
        {
            _logger = logger;
            _httpClient = httpClientFactory.CreateClient("DataService");
        }

        public async Task<AirportModel> FindByCode(string airportCode, CancellationToken cancellationToken)
        {
            return await _httpClient.GetAsyncAs<AirportModel>($"api/airport/{airportCode}", cancellationToken, _logger);
        }

        public async Task<IEnumerable<AirportModel>> GetAll(CancellationToken cancellationToken)
        {
            return await _httpClient.GetAsyncAs<IEnumerable<AirportModel>>("api/airport", cancellationToken, _logger);
        }
    }
}
