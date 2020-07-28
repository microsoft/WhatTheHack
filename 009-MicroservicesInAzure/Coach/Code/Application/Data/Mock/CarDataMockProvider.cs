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
    public class CarDataMockProvider : ICarDataProvider, IGetAllProvider<CarModel>
    {
        private readonly IAirportDataProvider _airportDataProvider;
        AsyncLazy<IEnumerable<CarModel>> _carModels;
        AsyncLazy<Dictionary<int, CarModel>> _carModelLookup;

        public CarDataMockProvider()
        {
            _airportDataProvider = new AirportDataMockProvider();
            _carModels = new AsyncLazy<IEnumerable<CarModel>>(async () =>
            {
                return await GetAll(CancellationToken.None);
            });

            _carModelLookup = new AsyncLazy<Dictionary<int, CarModel>>(async () =>
            {
                return (await _carModels).ToDictionary(car => car.Id, car => car);
            });
        }

        public async Task<IEnumerable<CarModel>> FindCars(string location, DateTimeOffset desiredTime, CancellationToken cancellationToken)
        {
            return (await _carModels).Where(f => f.Location.Equals(location) &&
                                       f.StartingTime < desiredTime &&
                                       f.EndingTime > desiredTime).OrderBy(c => c.Cost);
        }

        public async Task<CarModel> FindCar(int carId, CancellationToken cancellationToken)
        {
            return (await _carModelLookup)[carId];
        }

        public async Task<IEnumerable<CarModel>> GetAll(CancellationToken cancellationToken)
        {
            Random random = new Random();

            List<CarModel> allCars = new List<CarModel>();
            CarType[] carTypes = new CarType[] { CarType.Compact,
                                                 CarType.Intermediate,
                                                 CarType.Full,
                                                 CarType.SUV,
                                                 CarType.Minivan,
                                                 CarType.Convertable};

            foreach (var airPort in (await _airportDataProvider.GetAll(CancellationToken.None)))
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
                    foreach (CarType carType in carTypes)
                    {
                        allCars.Add(new CarModel()
                        {
                            StartingTime = startDate,
                            EndingTime = startDate.AddDays(1),
                            CarType = carType,
                            Location = airPort.AirportCode,
                            LocationAirport = airPort,
                            Cost = random.NextDouble() * baseCost
                        });

                        baseCost += 50d;
                    }
                }
            }

            return allCars;
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
