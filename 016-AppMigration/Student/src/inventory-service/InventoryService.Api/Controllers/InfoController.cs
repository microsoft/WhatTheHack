using System.Data.Common;
using System.Data.SqlClient;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;

namespace InventoryService.Api.Controllers
{
    [Route("api/[controller]")]
    public class InfoController : Controller
    {
        private readonly IConfiguration config;
        private readonly SqlConnection connection;

        public InfoController(IConfiguration config, SqlConnection connection)
        {
            this.config = config;
            this.connection = connection;
        }

        /// <summary>
        /// Get server info.
        /// </summary>
        /// <returns>
        /// Server info
        /// </returns>
        [HttpGet()]
        public async Task<object> GetAsync()
        {
            await connection.OpenAsync();
            using (var command = new SqlCommand("SELECT @@VERSION", connection))
            {
                return new
                {
                    connection.DataSource,
                    DatabaseEdition = await command.ExecuteScalarAsync()
                };
            }
        }
    }
}