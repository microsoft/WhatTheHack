using System.Collections.Generic;

namespace ContosoTravel.Web.Application.Models
{
    public class CarReservationModel
    {
        public IEnumerable<CarModel> Cars { get; set; }
        public double NumberOfDays { get; set; }
        public int SelectedCar { get; set; }
    }
}