using ContosoTravel.Web.Application.Models;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace ContosoTravel.Web.Application.Interfaces
{
    public interface IHotelDataProvider
    {
        Task<IEnumerable<HotelModel>> FindHotels(string location, DateTimeOffset desiredTime, CancellationToken cancellationToken);
        Task<HotelModel> FindHotel(int hotelId, CancellationToken cancellationToken);
    }
}
