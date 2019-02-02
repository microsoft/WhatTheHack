using ContosoTravel.Web.Application.Interfaces;
using ContosoTravel.Web.Application.Models;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace ContosoTravel.Web.Application.Data
{
    public class CartDisplayProvider
    {
        private readonly IFlightDataProvider _flightDataProvider;
        private readonly ICarDataProvider _carDataProvider;
        private readonly IHotelDataProvider _hotelDataProvider;

        public CartDisplayProvider(IFlightDataProvider flightDataProvider, ICarDataProvider carDataProvider, IHotelDataProvider hotelDataProvider)
        {
            _flightDataProvider = flightDataProvider;
            _carDataProvider = carDataProvider;
            _hotelDataProvider = hotelDataProvider;
        }

        public async Task<T> LoadFullCart<T>(CartPersistenceModel cart, CancellationToken cancellationToken) where T : CartModel, new()
        {
            T cartModel = new T()
            {
                CarReservationDuration = cart.CarReservationDuration,
                HotelReservationDuration = cart.HotelReservationDuration
            };

            if (cart.DepartingFlight != 0)
            {
                cartModel.DepartingFlight = await _flightDataProvider.FindFlight(cart.DepartingFlight, cancellationToken);
            }

            if (cart.ReturningFlight != 0)
            {
                cartModel.ReturningFlight = await _flightDataProvider.FindFlight(cart.ReturningFlight, cancellationToken);
            }

            if (cart.HotelReservation != 0)
            {
                cartModel.HotelReservation = await _hotelDataProvider.FindHotel(cart.HotelReservation, cancellationToken);
            }

            if (cart.CarReservation != 0)
            {
                cartModel.CarReservation = await _carDataProvider.FindCar(cart.CarReservation, cancellationToken);
            }

            return cartModel;
        }

        public async Task<ItineraryModel> LoadFullItinerary(ItineraryPersistenceModel itinerary, CancellationToken cancellationToken)
        {
            ItineraryModel itineraryModel = await LoadFullCart<ItineraryModel>(itinerary, cancellationToken);
            itineraryModel.RecordLocator = itinerary.RecordLocator;
            return itineraryModel;
        }
    }
}
