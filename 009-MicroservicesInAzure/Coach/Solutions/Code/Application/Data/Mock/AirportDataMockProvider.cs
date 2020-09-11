using ContosoTravel.Web.Application.Interfaces;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Linq;
using ContosoTravel.Web.Application.Models;

namespace ContosoTravel.Web.Application.Data.Mock
{
    public class AirportDataMockProvider : IAirportDataProvider, IGetAllProvider<AirportModel>
    {
        private List<AirportModel> _airports;
        private Dictionary<string, AirportModel> _airportLookup;

        public AirportDataMockProvider()
        {
            _airports = AirportModel.GetAll();
            _airportLookup = _airports.ToDictionary(air => air.AirportCode, air => air);
        }

        public async Task<AirportModel> FindByCode(string airportCode, CancellationToken cancellationToken)
        {
            return await Task.FromResult(_airportLookup[airportCode]);
        }

        public async Task<IEnumerable<AirportModel>> GetAll(CancellationToken cancellationToken)
        {
            return await Task.FromResult(_airports);
        }
    }
}
