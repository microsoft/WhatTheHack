using ContosoTravel.Web.Application.Interfaces;
using ContosoTravel.Web.Application.Interfaces.MVC;
using ContosoTravel.Web.Application.Models;
using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace ContosoTravel.Web.Application.Controllers.MVC
{
    public class HotelsController : IHotelsController
    {
        private readonly IHotelDataProvider _hotelDataProvider;
        private readonly ICartDataProvider _cartDataProvider;
        private readonly IAirportDataProvider _airportDataProvider;
        private readonly ICartCookieProvider _cartCookieProvider;
        private static TimeSpan THREEHOURSBEFOREORAFTER = TimeSpan.FromHours(3);

        public HotelsController(IHotelDataProvider hotelDataProvider, ICartDataProvider cartDataProvider, IAirportDataProvider airportDataProvider, ICartCookieProvider cartCookieProvider)
        {
            _hotelDataProvider = hotelDataProvider;
            _cartDataProvider = cartDataProvider;
            _airportDataProvider = airportDataProvider;
            _cartCookieProvider = cartCookieProvider;
        }

        public async Task<SearchModel> Index(CancellationToken cancellationToken)
        {
            return new SearchModel()
            {
                SearchMode = SearchMode.Hotels,
                IncludeEndLocation = false,
                StartLocationLabel = "Location",
                StartDateLabel = "Check-In",
                EndDateLabel = "Check-Out",
                AirPorts = await _airportDataProvider.GetAll(cancellationToken)
            };
        }

        public async Task<HotelReservationModel> Search(SearchModel searchRequest, CancellationToken cancellationToken)
        {
            HotelReservationModel hotelReservation = new HotelReservationModel() { NumberOfDays = (int)Math.Ceiling(searchRequest.EndDate.Subtract(searchRequest.StartDate).TotalDays) };
            hotelReservation.Hotels = await _hotelDataProvider.FindHotels(searchRequest.StartLocation, searchRequest.StartDate, cancellationToken);

            if ( searchRequest.IsTest )
            {
                hotelReservation.SelectedHotel = hotelReservation.Hotels.Skip(TestSettings.random.Next(hotelReservation.Hotels.Count() - 1)).First().Id;
            }

            return hotelReservation;
        }

        public async Task Purchase(HotelReservationModel hotel, CancellationToken cancellationToken)
        {
            string cartId = _cartCookieProvider.GetCartCookie();
            var updatedCart = await _cartDataProvider.UpsertCartHotel(cartId, hotel.SelectedHotel, hotel.NumberOfDays, cancellationToken);

            if (string.IsNullOrEmpty(cartId))
            {
                _cartCookieProvider.SetCartCookie(updatedCart.Id);
            }
        }
    }
}
