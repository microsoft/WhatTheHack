using ContosoTravel.Web.Application.Interfaces;
using ContosoTravel.Web.Application.Interfaces.MVC;
using ContosoTravel.Web.Application.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace ContosoTravel.Web.Application.Controllers.MVC
{
    public class FlightsController : IFlightsController
    {
        private readonly IFlightDataProvider _flightDataProvider;
        private readonly ICartDataProvider _cartDataProvider;
        private readonly IAirportDataProvider _airportDataProvider;
        private readonly ICartCookieProvider _cartCookieProvider;
        private static TimeSpan THREEHOURSBEFOREORAFTER = TimeSpan.FromHours(3);

        public FlightsController(IFlightDataProvider flightDataProvider, ICartDataProvider cartDataProvider, IAirportDataProvider airportDataProvider, ICartCookieProvider cartCookieProvider)
        {
            _flightDataProvider = flightDataProvider;
            _cartDataProvider = cartDataProvider;
            _airportDataProvider = airportDataProvider;
            _cartCookieProvider = cartCookieProvider;
        }

        public async Task<SearchModel> Index(CancellationToken cancellationToken)
        {
            return new SearchModel()
            {
                SearchMode = SearchMode.Flights,
                IncludeEndLocation = true,
                StartLocationLabel = "Depart From",
                EndLocationLabel = "Return From",
                StartDateLabel = "Depart",
                EndDateLabel = "Return",
                AirPorts = (await _airportDataProvider.GetAll(cancellationToken)).OrderBy(air => air.AirportCode)
            };
        }
        public async Task<FlightReservationModel> Search(SearchModel searchRequest, CancellationToken cancellationToken)
        {
            FlightReservationModel roundTrip = new FlightReservationModel();
            roundTrip.DepartingFlights = await _flightDataProvider.FindFlights(searchRequest.StartLocation, searchRequest.EndLocation, searchRequest.StartDate, THREEHOURSBEFOREORAFTER, cancellationToken);
            roundTrip.ReturningFlights = await _flightDataProvider.FindFlights(searchRequest.EndLocation, searchRequest.StartLocation, searchRequest.EndDate, THREEHOURSBEFOREORAFTER, cancellationToken);

            if (searchRequest.IsTest)
            {
                roundTrip.SelectedDepartingFlight = roundTrip.DepartingFlights.Skip(TestSettings.random.Next(roundTrip.DepartingFlights.Count() - 1)).First().Id;
            }

            if (searchRequest.IsTest)
            {
                roundTrip.SelectedReturningFlight = roundTrip.ReturningFlights.Skip(TestSettings.random.Next(roundTrip.ReturningFlights.Count() - 1)).First().Id;
            }

            return roundTrip;
        }

        public async Task Purchase(FlightReservationModel flight, CancellationToken cancellationToken)
        {
            string cartId = _cartCookieProvider.GetCartCookie();
            var updatedCart = await _cartDataProvider.UpsertCartFlights(cartId, flight.SelectedDepartingFlight, flight.SelectedReturningFlight, cancellationToken);

            if ( string.IsNullOrEmpty(cartId))
            {
                _cartCookieProvider.SetCartCookie(updatedCart.Id);
            }
        }

    }
}
