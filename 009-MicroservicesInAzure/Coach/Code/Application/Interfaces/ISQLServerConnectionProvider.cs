using System.Data.SqlClient;
using System.Threading;
using System.Threading.Tasks;

namespace ContosoTravel.Web.Application.Interfaces
{
    public interface ISQLServerConnectionProvider
    {
        Task<SqlConnection> GetOpenConnection(CancellationToken cancellationToken);
    }
}
