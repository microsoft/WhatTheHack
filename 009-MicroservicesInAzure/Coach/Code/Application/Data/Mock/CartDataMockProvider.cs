using ContosoTravel.Web.Application.Interfaces;
using ContosoTravel.Web.Application.Models;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace ContosoTravel.Web.Application.Data.Mock
{
    public class CartDataMockProvider : ICartDataProvider
    {
        public Dictionary<string, CartPersistenceModel> _carts = new Dictionary<string, CartPersistenceModel>();


        public async Task<CartPersistenceModel> GetCart(string cartId, CancellationToken cancellationToken)
        {
            CartPersistenceModel cart;
            _carts.TryGetValue(cartId, out cart);
            return await Task.FromResult(cart);
        }

        public async Task<CartPersistenceModel> UpsertCartFlights(string cartId, int departingFlightId, int returningFlightId, CancellationToken cancellationToken)
        {
            CartPersistenceModel cart;

            if ( !_carts.TryGetValue(cartId, out cart))
            {
                cart = new CartPersistenceModel() { Id = cartId };
            }

            cart.DepartingFlight = departingFlightId;
            cart.ReturningFlight = returningFlightId;

            _carts[cartId] = cart;

            return await Task.FromResult(cart);
        }

        public async Task<CartPersistenceModel> UpsertCartCar(string cartId, int carId, double numberOfDays, CancellationToken cancellationToken)
        {
            CartPersistenceModel cart;

            if ( !_carts.TryGetValue(cartId, out cart))
            {
                cart = new CartPersistenceModel() { Id = cartId };
            }

            cart.CarReservation = carId;
            cart.CarReservationDuration = numberOfDays;
            _carts[cartId] = cart;

            return await Task.FromResult(cart);

        }
        public async Task<CartPersistenceModel> UpsertCartHotel(string cartId, int hotelId, int numberOfDays, CancellationToken cancellationToken)
        {
            CartPersistenceModel cart;

            if (!_carts.TryGetValue(cartId, out cart))
            {
                cart = new CartPersistenceModel() { Id = cartId };
            }

            cart.HotelReservation = hotelId;
            cart.HotelReservationDuration = numberOfDays;
            _carts[cartId] = cart;

            return await Task.FromResult(cart);
        }

        public async Task DeleteCart(string cartId, CancellationToken cancellationToken)
        {
            await Task.FromResult(_carts.Remove(cartId));
        }
    }
}
