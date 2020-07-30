using ContosoTravel.Web.Application.Models;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace ContosoTravel.Web.Application.Interfaces.MVC
{
    public interface ICartController
    {
        Task<CartModel> Index(CancellationToken cancellationToken);
        Task<bool> Purchase(DateTimeOffset PurchasedOn, CancellationToken cancellationToken);
    }
}
