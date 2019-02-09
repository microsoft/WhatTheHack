using ContosoTravel.Web.Application.Interfaces;
using ContosoTravel.Web.Application.Models;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace ContosoTravel.Web.Application.Data.SQLServer
{
    public class AirportDataSQLServerProvider : IAirportDataProvider, IWritableDataProvider<AirportModel>
    {
        private readonly SQLServerProvider _sqlServerProvider;

        public AirportDataSQLServerProvider(SQLServerProvider sqlServerProvider)
        {
            _sqlServerProvider = sqlServerProvider;
        }

        private class FindAiportByCodeParams
        {
            public string AirportCode { get; set; }
        }

        public async Task<AirportModel> FindByCode(string airportCode, CancellationToken cancellationToken)
        {
            return (await _sqlServerProvider.Query<FindAiportByCodeParams, AirportModel>("FindAirportByCode", 
                                                                                    new FindAiportByCodeParams () { AirportCode = airportCode }, 
                                                                                    cancellationToken)).FirstOrDefault();
        }

        public async Task<IEnumerable<AirportModel>> GetAll(CancellationToken cancellationToken)
        {
            return (await _sqlServerProvider.Query<SQLServerEmptyParams, AirportModel>("GetAllAirports",
                                                                                        new SQLServerEmptyParams(),
                                                                                        cancellationToken));
        }

        public async Task<bool> Persist(AirportModel instance, CancellationToken cancellationToken)
        {
            await _sqlServerProvider.Execute<AirportModel>("CreateAirport", instance, cancellationToken);
            return true;
        }
    }
}
