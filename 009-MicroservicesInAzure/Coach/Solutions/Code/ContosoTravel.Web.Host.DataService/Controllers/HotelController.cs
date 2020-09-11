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
    public class HotelController : ControllerBase
    {
        private readonly IHotelDataProvider _hotelDataProvider;

        public HotelController(IHotelDataProvider hotelDataProvider)
        {
            _hotelDataProvider = hotelDataProvider;
        }

        [HttpGet("search/{location}")]
        public async Task<IEnumerable<HotelModel>> FindHotels(string location, DateTimeOffset desiredTime, CancellationToken cancellationToken)
        {
            return await _hotelDataProvider.FindHotels(location, desiredTime, cancellationToken);
        }

        [HttpGet("{carId}")]
        public async Task<HotelModel> FindHotel(int carId, CancellationToken cancellationToken)
        {
            return await _hotelDataProvider.FindHotel(carId, cancellationToken);
        }
    }
}