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
    public class HotelDataMockProvider : IHotelDataProvider, IGetAllProvider<HotelModel>
    {
        private readonly IAirportDataProvider _airportDataProvider;
        AsyncLazy<IEnumerable<HotelModel>> _hotelModels;
        AsyncLazy<Dictionary<int, HotelModel>> _hotelModelLookup;

        public HotelDataMockProvider()
        {
            _airportDataProvider = new AirportDataMockProvider();
            _hotelModels = new AsyncLazy<IEnumerable<HotelModel>>(async () =>
            {
                return await GetAll(CancellationToken.None);
            });

            _hotelModelLookup = new AsyncLazy<Dictionary<int, HotelModel>>(async () =>
            {
                return (await _hotelModels).ToDictionary(hotel => hotel.Id, car => car);
            });
        }

        public async Task<IEnumerable<HotelModel>> FindHotels(string location, DateTimeOffset desiredTime, CancellationToken cancellationToken)
        {
            return (await _hotelModels).Where(f => f.Location.Equals(location) &&
                                       f.StartingTime < desiredTime &&
                                       f.EndingTime > desiredTime).OrderBy(c => c.Cost);
        }

        public async Task<HotelModel> FindHotel(int hotelId, CancellationToken cancellationToken)
        {
            return (await _hotelModelLookup)[hotelId];
        }

        public async Task<IEnumerable<HotelModel>> GetAll(CancellationToken cancellationToken)
        {
            Random random = new Random();

            List<HotelModel> allHotels = new List<HotelModel>();
            HotelRoomType[] hotelTypes = new HotelRoomType[] { HotelRoomType.King,
                                                 HotelRoomType.TwoQueens,
                                                 HotelRoomType.Suite,
                                                 HotelRoomType.Penthouse };

            foreach (var airPort in (await _airportDataProvider.GetAll(cancellationToken)))
            {
                for (int dayOffset = -1; dayOffset < 7; dayOffset++)
                {
                    DateTime today = DateTime.Now.Date.AddDays(dayOffset);
                    TimeZoneInfo airPortTimeZone = ContosoTravel.Web.Application.Extensions.TimeZoneHelper.FindSystemTimeZoneById(airPort.TimeZone);
                    DateTimeOffset startDate = DateTimeOffset.Parse($"{today.ToString("MM/dd/yyyy")} 12:00 AM {airPortTimeZone.BaseUtcOffset.Hours.ToString("00")}:{airPortTimeZone.BaseUtcOffset.Minutes.ToString("00")}");
                    if (airPortTimeZone.IsDaylightSavingTime(today))
                    {
                        startDate = startDate.AddHours(1);
                    }

                    double baseCost = 200d;

                    foreach (HotelRoomType hotelType in hotelTypes)
                    {
                        allHotels.Add(new HotelModel()
                        {
                            StartingTime = startDate,
                            EndingTime = startDate.AddDays(1),
                            RoomType = hotelType,
                            Location = airPort.AirportCode,
                            LocationAirport = airPort,
                            Cost = random.NextDouble() * baseCost
                        });

                        baseCost += 50d;
                    }
                }
            }

            return allHotels;
        }

        private DateTimeOffset CalcLocalTime(FlightTime flightTime, AirportModel arrivingAt, DateTimeOffset departDate)
        {
            DateTimeOffset arrivalTime = departDate.Add(flightTime.Duration);
            TimeZoneInfo timeZoneInfo = ContosoTravel.Web.Application.Extensions.TimeZoneHelper.FindSystemTimeZoneById(arrivingAt.TimeZone);

            if (timeZoneInfo.IsDaylightSavingTime(arrivalTime))
            {
                arrivalTime = arrivalTime.AddHours(1);
            }

            return TimeZoneInfo.ConvertTime(arrivalTime.DateTime, timeZoneInfo);
        }
    }
}
