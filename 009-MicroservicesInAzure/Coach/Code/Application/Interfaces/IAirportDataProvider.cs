using ContosoTravel.Web.Application.Models;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace ContosoTravel.Web.Application.Interfaces
{
    public interface IAirportDataProvider
    {
        Task<IEnumerable<AirportModel>> GetAll(CancellationToken cancellationToken);
        Task<AirportModel> FindByCode(string airportCode, CancellationToken cancellationToken);
    }
}
