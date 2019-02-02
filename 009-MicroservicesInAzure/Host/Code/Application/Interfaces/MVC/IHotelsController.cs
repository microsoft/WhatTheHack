using ContosoTravel.Web.Application.Models;
using System.Threading;
using System.Threading.Tasks;

namespace ContosoTravel.Web.Application.Interfaces.MVC
{
    public interface IHotelsController
    {
        Task<SearchModel> Index(CancellationToken cancellationToken);
        Task<HotelReservationModel> Search(SearchModel searchRequest, CancellationToken cancellationToken);
        Task Purchase(HotelReservationModel hotel, CancellationToken cancellationToken);
    }
}
