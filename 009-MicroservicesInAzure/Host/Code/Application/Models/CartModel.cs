using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Text;

namespace ContosoTravel.Web.Application.Models
{
    public class CartModel
    {
        public CartModel()
        {
            Id = Guid.NewGuid();
        }

        public Guid Id { get; set; }
        public FlightModel DepartingFlight { get; set; }
        public FlightModel ReturningFlight { get; set; }
        public CarModel CarReservation { get; set; }
        public double CarReservationDuration { get; set; }
        public HotelModel HotelReservation { get; set; }
        public int HotelReservationDuration { get; set; }
        public double TotalCost => (DepartingFlight?.Cost ?? 0d) + (ReturningFlight?.Cost ?? 0d) + (CarReservation?.Cost ?? 0d) * CarReservationDuration + (HotelReservation?.Cost ?? 0d) * HotelReservationDuration;
    }

    public class CartPersistenceModel
    {
        [JsonProperty(PropertyName = "id")]
        public string Id { get; set; }
        public int DepartingFlight { get; set; }
        public int ReturningFlight { get; set; }
        public int CarReservation { get; set; }
        public double CarReservationDuration { get; set; }
        public int HotelReservation { get; set; }
        public int HotelReservationDuration { get; set; }
    }
}
