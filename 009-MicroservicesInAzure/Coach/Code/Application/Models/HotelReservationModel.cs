using System.Collections.Generic;

namespace ContosoTravel.Web.Application.Models
{
    public class HotelReservationModel
    {
        public IEnumerable<HotelModel> Hotels { get; set; }
        public int NumberOfDays { get; set; }
        public int SelectedHotel { get; set; }
    }
}