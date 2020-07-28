using ContosoTravel.Web.Application.Interfaces;
using ContosoTravel.Web.Application.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;


namespace ContosoTravel.Web.Application.Data.SQLServer
{
    public class CartDataSQLServerProvider : ICartDataProvider
    {
        private readonly SQLServerProvider _sqlServerProvider;

        public CartDataSQLServerProvider(SQLServerProvider sqlServerProvider)
        {
            _sqlServerProvider = sqlServerProvider;
        }

        private class CartIdParams
        {
            public Guid Id { get; set; }
        }

        public async Task DeleteCart(string cartId, CancellationToken cancellationToken)
        {
            await _sqlServerProvider.Execute<CartIdParams>("DeleteCart", new CartIdParams()
                                                                         {
                                                                             Id = Guid.Parse(cartId)
                                                                         }, cancellationToken);
        }

        public async Task<CartPersistenceModel> GetCart(string cartId, CancellationToken cancellationToken)
        {
            return (await _sqlServerProvider.Query<CartIdParams, CartPersistenceModel>("GetCartById", new CartIdParams()
                                                                                                    {
                                                                                                        Id = Guid.Parse(cartId)
                                                                                                    }, cancellationToken)).FirstOrDefault();
        }

        private class UpdateCartCarParms : CartIdParams
        {
            public int? CarReservation { get; set; }
            public double? CarReservationDuration { get; set; }
        }

        public async Task<CartPersistenceModel> UpsertCartCar(string cartId, int carId, double numberOfDays, CancellationToken cancellationToken)
        {
            await _sqlServerProvider.Execute<UpdateCartCarParms>("UpsertCartCar", new UpdateCartCarParms()
            {
                Id = Guid.Parse(cartId),
                CarReservation = _sqlServerProvider.NullIfZero(carId),
                CarReservationDuration = _sqlServerProvider.NullIfZero(numberOfDays)
            }, cancellationToken);

            return await GetCart(cartId, cancellationToken);
        }

        private class UpsertCartFlightsParms : CartIdParams
        {
            public int? DepartingFlight { get; set; }
            public int? ReturningFlight { get; set; }
        }

        public async Task<CartPersistenceModel> UpsertCartFlights(string cartId, int departingFlightId, int returningFlightId, CancellationToken cancellationToken)
        {
            await _sqlServerProvider.Execute<UpsertCartFlightsParms>("UpsertCartFlights", new UpsertCartFlightsParms()
            {
                Id = Guid.Parse(cartId),
                DepartingFlight = _sqlServerProvider.NullIfZero(departingFlightId),
                ReturningFlight = _sqlServerProvider.NullIfZero(returningFlightId),
            }, cancellationToken);

            return await GetCart(cartId, cancellationToken);
        }

        private class UpdateCartHotelParms : CartIdParams
        {
            public int? HotelReservation { get; set; }
            public int? HotelReservationDuration { get; set; }
        }

        public async Task<CartPersistenceModel> UpsertCartHotel(string cartId, int hotelId, int numberOfDays, CancellationToken cancellationToken)
        {
            await _sqlServerProvider.Execute<UpdateCartHotelParms>("UpsertCartHotel", new UpdateCartHotelParms()
            {
                Id = Guid.Parse(cartId),
                HotelReservation = _sqlServerProvider.NullIfZero(hotelId),
                HotelReservationDuration = _sqlServerProvider.NullIfZero(numberOfDays)
            }, cancellationToken);

            return await GetCart(cartId, cancellationToken);
        }
    }
}
