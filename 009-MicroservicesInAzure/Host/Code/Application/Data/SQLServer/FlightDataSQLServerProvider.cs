using ContosoTravel.Web.Application.Interfaces;
using ContosoTravel.Web.Application.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;


namespace ContosoTravel.Web.Application.Data.SQLServer
{
    public class FlightDataSQLServerProvider : IFlightDataProvider, IWritableDataProvider<FlightModel>
    {
        private readonly SQLServerProvider _sqlServerProvider;
        private readonly IAirportDataProvider _airportDataProvider;

        public FlightDataSQLServerProvider(SQLServerProvider sqlServerProvider, IAirportDataProvider airportDataProvider)
        {
            _sqlServerProvider = sqlServerProvider;
            _airportDataProvider = airportDataProvider;
        }

        public async Task<FlightModel> FindFlight(int flightId, CancellationToken cancellationToken)
        {
            return await ResolveAirport((await _sqlServerProvider.Query<SQLServerFindByIdParam, FlightModel>("FindFlightById",
                                                                                        new SQLServerFindByIdParam() { Id = flightId },
                                                                                        cancellationToken)).FirstOrDefault(), cancellationToken);
        }

        private class FindFlightsParams
        {
            public string DepartingFrom { get; set; }
            public string ArrivingAt { get; set; }
            public DateTimeOffset DesiredTime { get; set; }
            public int SecondsOffset { get; set; }
        }

        public async Task<IEnumerable<FlightModel>> FindFlights(string departingFrom, string arrivingAt, DateTimeOffset desiredTime, TimeSpan offset, CancellationToken cancellationToken)
        {
            return await ResolveAirport(await _sqlServerProvider.Query<FindFlightsParams, FlightModel>("FindFlights",
                                                                                   new FindFlightsParams()
                                                                                   {
                                                                                       DepartingFrom = departingFrom,
                                                                                       ArrivingAt = arrivingAt,
                                                                                       DesiredTime = desiredTime,
                                                                                       SecondsOffset = (int)offset.TotalSeconds
                                                                                   },
                                                                                   cancellationToken), cancellationToken);
        }


        private class CreateFlightParams
        {
            public int Id { get; set; }
            public string DepartingFrom { get; set; }
            public string ArrivingAt { get; set; }
            public DateTimeOffset DepartureTime { get; set; }
            public DateTimeOffset ArrivalTime { get; set; }
            public TimeSpan Duration { get; set; }
            public double Cost { get; set; }
        }

        public async Task<bool> Persist(FlightModel instance, CancellationToken cancellationToken)
        {
            await _sqlServerProvider.Execute<CreateFlightParams>("CreateFlight", new CreateFlightParams()
            {
                Id = instance.Id,
                DepartingFrom = instance.DepartingFromAiport.AirportCode,
                ArrivingAt = instance.ArrivingAtAiport.AirportCode,
                DepartureTime = instance.DepartureTime,
                ArrivalTime = instance.ArrivalTime,
                Cost = instance.Cost,
                Duration = instance.Duration
            }, cancellationToken);
            return true;
        }

        private async Task<FlightModel> ResolveAirport(FlightModel flightModel, CancellationToken cancellationToken)
        {
            if (!string.IsNullOrEmpty(flightModel?.DepartingFrom))
            {
                flightModel.DepartingFromAiport = await _airportDataProvider.FindByCode(flightModel.DepartingFrom, cancellationToken);
            }

            if (!string.IsNullOrEmpty(flightModel?.ArrivingAt))
            {
                flightModel.ArrivingAtAiport = await _airportDataProvider.FindByCode(flightModel.ArrivingAt, cancellationToken);
            }
            return flightModel;
        }

        private async Task<IEnumerable<FlightModel>> ResolveAirport(IEnumerable<FlightModel> flightModels, CancellationToken cancellationToken)
        {
            if (flightModels != null && flightModels.Any())
            {
                foreach (var flight in flightModels)
                {
                    await ResolveAirport(flight, cancellationToken);
                }
            }

            return flightModels;
        }
    }
}
