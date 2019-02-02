using ContosoTravel.Web.Application.Interfaces;
using ContosoTravel.Web.Application.Models;
using Nito.AsyncEx;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace ContosoTravel.Web.Application.Data.Mock
{
    public class FlightDataMockProvider : IFlightDataProvider, IGetAllProvider<FlightModel>
    {
        private readonly IAirportDataProvider _airportDataProvider;
        AsyncLazy<IEnumerable<FlightModel>> _flightModels;
        AsyncLazy<Dictionary<int, FlightModel>> _flightModelLookup;
         
        public FlightDataMockProvider()
        {
            _airportDataProvider = new AirportDataMockProvider();
            _flightModels = new AsyncLazy<IEnumerable<FlightModel>>(async () =>
            {
                return await GetAll(CancellationToken.None);
            });

            _flightModelLookup = new AsyncLazy<Dictionary<int, FlightModel>>(async () =>
            {
                return (await _flightModels).ToDictionary(flight => flight.Id, flight => flight);
            });
        }

        public async Task<IEnumerable<FlightModel>> FindFlights(string departingFrom, string arrivingAt, DateTimeOffset desiredTime, TimeSpan offset, CancellationToken cancellationToken)
        {            
            return (await _flightModels).Where(f => f.DepartingFrom.Equals(departingFrom) && f.ArrivingAt.Equals(arrivingAt) &&
                                       f.DepartureTime > desiredTime.Subtract(offset) &&
                                       f.DepartureTime < desiredTime.Add(offset)).OrderBy(f => f.DepartureTime);
        }

        public async Task<FlightModel> FindFlight(int flightId, CancellationToken cancellationToken)
        {
            return (await _flightModelLookup)[flightId];
        }

        public async Task<IEnumerable<FlightModel>> GetAll(CancellationToken cancellationToken)
        {
            Random random = new Random();

            List<FlightModel> allFlights = new List<FlightModel>();

            foreach (var flightTime in FlightTime.GetAll())
            {
                var departingFrom = await _airportDataProvider.FindByCode(flightTime.DepartingFrom, CancellationToken.None);
                var arrivingAt = await _airportDataProvider.FindByCode(flightTime.ArrivingAt, CancellationToken.None);

                for (int dayOffset = -1; dayOffset < 7; dayOffset++)
                {
                    int numberOfFlights = random.Next(3, 5);
                    DateTime today = DateTime.Now.Date.AddDays(dayOffset);
                    TimeZoneInfo departingTimeZone = ContosoTravel.Web.Application.Extensions.TimeZoneHelper.FindSystemTimeZoneById(departingFrom.TimeZone);

                    for (int ii = 0; ii < numberOfFlights; ii++)
                    {
                        int minutesToAddToFiveAm = (int)(random.NextDouble() * 19d * 60d);
                        DateTimeOffset departDate = DateTimeOffset.Parse($"{today.ToString("MM/dd/yyyy")} 5:00 AM {departingTimeZone.BaseUtcOffset.Hours.ToString("00")}:{departingTimeZone.BaseUtcOffset.Minutes.ToString("00")}").AddMinutes(minutesToAddToFiveAm);

                        if (departingTimeZone.IsDaylightSavingTime(today))
                        {
                            departDate = departDate.AddHours(1);
                        }

                        allFlights.Add(new FlightModel()
                        {
                            DepartingFromAiport = departingFrom,
                            DepartingFrom = flightTime.DepartingFrom,
                            ArrivingAtAiport = arrivingAt,
                            ArrivingAt = flightTime.ArrivingAt,
                            Duration = flightTime.Duration,
                            DepartureTime = departDate,
                            Cost = 1500d * random.NextDouble(),
                            ArrivalTime = CalcLocalTime(flightTime, arrivingAt, departDate)

                    });
                    }
                }
            }

            return allFlights;
        }

        private DateTimeOffset CalcLocalTime(FlightTime flightTime, AirportModel arrivingAt, DateTimeOffset departDate)
        {
            DateTimeOffset arrivalTime = departDate.Add(flightTime.Duration);
            TimeZoneInfo timeZoneInfo = ContosoTravel.Web.Application.Extensions.TimeZoneHelper.FindSystemTimeZoneById(arrivingAt.TimeZone);

            if ( timeZoneInfo.IsDaylightSavingTime(arrivalTime))
            {
                arrivalTime = arrivalTime.AddHours(1);
            }

            return TimeZoneInfo.ConvertTime(arrivalTime.DateTime, timeZoneInfo);
        }
    }
}
