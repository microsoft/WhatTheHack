using ContosoTravel.Web.Application.Models;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace ContosoTravel.Web.Application.Interfaces.MVC
{
    public interface IItineraryController
    {
        Task<ItineraryModel> GetByCartId(CancellationToken cancellationToken);
        Task<ItineraryModel> GetByRecordLocator(string recordLocator, CancellationToken cancellationToken);
    }
}
