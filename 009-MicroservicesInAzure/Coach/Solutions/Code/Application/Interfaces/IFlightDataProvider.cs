using ContosoTravel.Web.Application.Models;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace ContosoTravel.Web.Application.Interfaces
{
    public interface IFlightDataProvider
    {
        Task<IEnumerable<FlightModel>> FindFlights(string departingFrom, string arrivingAt, DateTimeOffset desiredTime, TimeSpan offset, CancellationToken cancellationToken);
        Task<FlightModel> FindFlight(int flightId, CancellationToken cancellationToken);
    }
}
