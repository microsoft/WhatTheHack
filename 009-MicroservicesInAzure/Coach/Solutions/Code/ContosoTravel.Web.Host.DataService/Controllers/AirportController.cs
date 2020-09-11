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
    public class AirportController : ControllerBase
    {
        private readonly IAirportDataProvider _airportDataProvider;

        public AirportController(IAirportDataProvider airportDataProvider)
        {
            _airportDataProvider = airportDataProvider;
        }

        [HttpGet]
        public async Task<IEnumerable<AirportModel>> GetAll(CancellationToken cancellationToken)
        {
            return await _airportDataProvider.GetAll(cancellationToken);
        }

        [HttpGet("{airportCode}")]
        public async Task<AirportModel> FindByCode(string airportCode, CancellationToken cancellationToken)
        {
            return await _airportDataProvider.FindByCode(airportCode, cancellationToken);
        }
    }
}