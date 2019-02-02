using ContosoTravel.Web.Application;
using ContosoTravel.Web.Application.Interfaces;
using System.Data.SqlClient;
using System.Threading;
using System.Threading.Tasks;

namespace DataLoader.SQLServer
{
    public class SQLServerConnectionProvider : ISQLServerConnectionProvider
    {
        private string _connectionString;

        public SQLServerConnectionProvider(ContosoConfiguration contosoConfiguration)
        {
            SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder();
            builder.UserID = contosoConfiguration.DataAdministratorLogin;
            builder.Password = contosoConfiguration.DataAdministratorLoginPassword;
            builder.IntegratedSecurity = false;
            builder.DataSource = $"{contosoConfiguration.DataAccountName}.database.windows.net";
            builder.InitialCatalog = contosoConfiguration.DatabaseName;
            _connectionString = builder.ConnectionString;
        }

        public async Task<SqlConnection> GetOpenConnection(CancellationToken cancellationToken)
        {
            var newConnection = new SqlConnection(_connectionString);
            await newConnection.OpenAsync(cancellationToken);
            return newConnection;
        }

    }
}
