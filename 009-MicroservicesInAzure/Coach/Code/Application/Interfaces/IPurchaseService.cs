using ContosoTravel.Web.Application.Models;
using System.Threading;
using System.Threading.Tasks;

namespace ContosoTravel.Web.Application.Interfaces
{
    public interface IPurchaseService
    {
        Task<bool> SendForProcessing(string cartId, System.DateTimeOffset PurchasedOn, CancellationToken cancellationToken);
    }
}
