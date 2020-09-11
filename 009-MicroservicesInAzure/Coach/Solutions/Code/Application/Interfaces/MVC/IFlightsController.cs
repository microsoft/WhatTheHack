using ContosoTravel.Web.Application.Models;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace ContosoTravel.Web.Application.Interfaces.MVC
{
    public interface IFlightsController
    {
        Task<SearchModel> Index(CancellationToken cancellationToken);
        Task<FlightReservationModel> Search(SearchModel searchRequest, CancellationToken cancellationToken);
        Task Purchase(FlightReservationModel flight, CancellationToken cancellationToken);
    }
}
