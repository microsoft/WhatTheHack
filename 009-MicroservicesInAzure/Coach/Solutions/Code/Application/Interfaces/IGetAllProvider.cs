using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace ContosoTravel.Web.Application.Interfaces
{
    public interface IGetAllProvider<T>
    {
        Task<IEnumerable<T>> GetAll(CancellationToken cancellationToken);
    }
}
