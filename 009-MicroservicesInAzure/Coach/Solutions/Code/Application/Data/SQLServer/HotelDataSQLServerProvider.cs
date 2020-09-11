using ContosoTravel.Web.Application.Interfaces;
using ContosoTravel.Web.Application.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;


namespace ContosoTravel.Web.Application.Data.SQLServer
{
    public class HotelDataSQLServerProvider : IHotelDataProvider, IWritableDataProvider<HotelModel>
    {
        private readonly SQLServerProvider _sqlServerProvider;
        private readonly IAirportDataProvider _airportDataProvider;

        public HotelDataSQLServerProvider(SQLServerProvider sqlServerProvider, IAirportDataProvider airportDataProvider)
        {
            _sqlServerProvider = sqlServerProvider;
            _airportDataProvider = airportDataProvider;
        }

        public async Task<HotelModel> FindHotel(int carId, CancellationToken cancellationToken)
        {
            return await ResolveAirport((await _sqlServerProvider.Query<SQLServerFindByIdParam, HotelModel>("FindHotelById",
                                                                                    new SQLServerFindByIdParam() { Id = carId },
                                                                                    cancellationToken)).FirstOrDefault(), cancellationToken);
        }

        private class FindHotelsParms
        {
            public string Location { get; set; }
            public DateTimeOffset DesiredTime { get; set; }
        }

        public async Task<IEnumerable<HotelModel>> FindHotels(string location, DateTimeOffset desiredTime, CancellationToken cancellationToken)
        {
            return await ResolveAirport(await _sqlServerProvider.Query<FindHotelsParms, HotelModel>("FindHotels",
                                                                            new FindHotelsParms() { Location = location, DesiredTime = desiredTime },
                                                                            cancellationToken), cancellationToken);
        }

        private class CreateHotelParams
        {
            public int Id { get; set; }
            public string Location { get; set; }
            public DateTimeOffset StartingTime { get; set; }
            public DateTimeOffset EndingTime { get; set; }
            public double Cost { get; set; }
            public int RoomType { get; set; }
        }

        public async Task<bool> Persist(HotelModel instance, CancellationToken cancellationToken)
        {
            await _sqlServerProvider.Execute<CreateHotelParams>("CreateHotel", new CreateHotelParams()
            {
                Id = instance.Id,
                Location = instance.LocationAirport.AirportCode,
                StartingTime = instance.StartingTime,
                EndingTime = instance.EndingTime,
                Cost = instance.Cost,
                RoomType = (int)instance.RoomType
            }, cancellationToken);
            return true;
        }

        private async Task<HotelModel> ResolveAirport(HotelModel hotelModel, CancellationToken cancellationToken)
        {
            if (!string.IsNullOrEmpty(hotelModel?.Location))
            {
                hotelModel.LocationAirport = await _airportDataProvider.FindByCode(hotelModel.Location, cancellationToken);
            }

            return hotelModel;
        }

        private async Task<IEnumerable<HotelModel>> ResolveAirport(IEnumerable<HotelModel> hotelModels, CancellationToken cancellationToken)
        {
            if (hotelModels != null && hotelModels.Any())
            {
                foreach (var hotel in hotelModels)
                {
                    await ResolveAirport(hotel, cancellationToken);
                }
            }

            return hotelModels;
        }
    }
}
