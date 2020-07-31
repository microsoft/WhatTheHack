using ContosoTravel.Web.Application.Models;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace ContosoTravel.Web.Application.Interfaces
{
    public interface IItineraryDataProvider
    {
        Task<ItineraryPersistenceModel> FindItinerary(string cartId, CancellationToken cancellationToken);
        Task<ItineraryPersistenceModel> GetItinerary(string recordLocator, CancellationToken cancellationToken);
        Task UpsertItinerary(ItineraryPersistenceModel itinerary, CancellationToken cancellationToken);
    }
}
