using ContosoTravel.Web.Application.Models;
using System.Threading;
using System.Threading.Tasks;

namespace ContosoTravel.Web.Application.Interfaces.MVC
{
    public interface ICarsController
    {
        Task<SearchModel> Index(CancellationToken cancellationToken);
        Task<CarReservationModel> Search(SearchModel searchRequest, CancellationToken cancellationToken);
        Task Purchase(CarReservationModel car, CancellationToken cancellationToken);
    }
}
