using ContosoTravel.Web.Application.Interfaces;
using ContosoTravel.Web.Application.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;


namespace ContosoTravel.Web.Application.Data.SQLServer
{
    public class ItineraryDataSQLServerProvider : IItineraryDataProvider
    {
        private readonly SQLServerProvider _sqlServerProvider;

        public ItineraryDataSQLServerProvider(SQLServerProvider sqlServerProvider)
        {
            _sqlServerProvider = sqlServerProvider;
        }

        private class ItineraryIdParams
        {
            public Guid Id { get; set; }
        }

        public async Task<ItineraryPersistenceModel> FindItinerary(string cartId, CancellationToken cancellationToken)
        {
            return (await _sqlServerProvider.Query<ItineraryIdParams, ItineraryPersistenceModel>("GetItineraryById", new ItineraryIdParams()
            {
                Id = Guid.Parse(cartId)
            }, cancellationToken)).FirstOrDefault();
        }

        private class ItineraryByRecordLocatorParams
        {
            public string RecordLocator { get; set; }
        }

        public async Task<ItineraryPersistenceModel> GetItinerary(string recordLocator, CancellationToken cancellationToken)
        {
            return (await _sqlServerProvider.Query<ItineraryByRecordLocatorParams, ItineraryPersistenceModel>("GetItineraryByRecordLocatorId", new ItineraryByRecordLocatorParams()
            {
                RecordLocator = recordLocator
            }, cancellationToken)).FirstOrDefault();
        }

        private class ItineraryUpsertParams
        {
            public Guid Id { get; set; }
            public int? DepartingFlight { get; set; }
            public int? ReturningFlight { get; set; }
            public int? CarReservation { get; set; }
            public double? CarReservationDuration { get; set; }
            public int? HotelReservation { get; set; }
            public int? HotelReservationDuration { get; set; }
            public string RecordLocator { get; set; }
            public DateTimeOffset PurchasedOn { get; set; }
        }

        public async Task UpsertItinerary(ItineraryPersistenceModel itinerary, CancellationToken cancellationToken)
        {
            await _sqlServerProvider.Execute<ItineraryUpsertParams>("UpsertItinerary", new ItineraryUpsertParams()
            {
                Id = Guid.Parse(itinerary.Id),
                DepartingFlight = _sqlServerProvider.NullIfZero(itinerary.DepartingFlight),
                ReturningFlight = _sqlServerProvider.NullIfZero(itinerary.ReturningFlight),
                CarReservation = _sqlServerProvider.NullIfZero(itinerary.CarReservation),
                CarReservationDuration = _sqlServerProvider.NullIfZero(itinerary.CarReservationDuration),
                HotelReservation = _sqlServerProvider.NullIfZero(itinerary.HotelReservation),
                HotelReservationDuration = _sqlServerProvider.NullIfZero(itinerary.HotelReservationDuration),
                RecordLocator = itinerary.RecordLocator,
                PurchasedOn = itinerary.PurchasedOn
            }, cancellationToken);
        }
    }
}
