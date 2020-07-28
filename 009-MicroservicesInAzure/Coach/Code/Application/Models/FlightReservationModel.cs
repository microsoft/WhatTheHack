using System;
using System.Collections.Generic;
using System.Text;

namespace ContosoTravel.Web.Application.Models
{
    public class FlightReservationModel
    {
        public IEnumerable<FlightModel> DepartingFlights { get; set; }
        public IEnumerable<FlightModel> ReturningFlights { get; set; }
        public int SelectedDepartingFlight { get; set; }
        public int SelectedReturningFlight { get; set; }
    }
}
