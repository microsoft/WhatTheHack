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
    public class CarController : ControllerBase
    {
        private readonly ICarDataProvider _carDataProvider;

        public CarController(ICarDataProvider carDataProvider)
        {
            _carDataProvider = carDataProvider;
        }

        [HttpGet("search/{location}")]
        public async Task<IEnumerable<CarModel>> FindCars(string location, DateTimeOffset desiredTime, CancellationToken cancellationToken)
        {
            return await _carDataProvider.FindCars(location, desiredTime, cancellationToken);
        }

        [HttpGet("{carId}")]
        public async Task<CarModel> FindCar(int carId, CancellationToken cancellationToken)
        {
            return await _carDataProvider.FindCar(carId, cancellationToken);
        }
    }
}