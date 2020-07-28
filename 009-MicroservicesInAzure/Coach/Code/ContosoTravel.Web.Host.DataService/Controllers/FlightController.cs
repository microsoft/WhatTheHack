using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using ContosoTravel.Web.Application.Interfaces;
using ContosoTravel.Web.Application.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace ContosoTravel.Web.Host.DataService.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FlightController : ControllerBase
    {
        private readonly IFlightDataProvider _flightDataProvider;

        public FlightController(IFlightDataProvider flightDataProvider)
        {
            _flightDataProvider = flightDataProvider;
        }

        [HttpGet("search/{departingFrom}/{arrivingAt}")]
        public async Task<IEnumerable<FlightModel>> FindFlights(string departingFrom, string arrivingAt, DateTimeOffset desiredTime, TimeSpan offset, CancellationToken cancellationToken)
        {
            return await _flightDataProvider.FindFlights(departingFrom, arrivingAt, desiredTime, offset, cancellationToken);
        }

        [HttpGet("{flightId}")]
        public async Task<FlightModel> FindFlight(int flightId, CancellationToken cancellationToken)
        {
            return await _flightDataProvider.FindFlight(flightId, cancellationToken);
        }
    }
}