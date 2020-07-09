using System.Data.SqlClient;
using System.Threading.Tasks;
using InventoryService.Api.Models;

namespace InventoryService.Api.Services
{
    public class BadSqlInventoryData
    {
        private readonly SqlConnection connection;

        public BadSqlInventoryData(SqlConnection connection)
        {
            this.connection = connection;
        }

        public async Task<InventoryItem> GetInventoryBySku(string sku)
        {
            InventoryItem result = null;
            await connection.OpenAsync();


            var sql = $"SELECT Sku, Quantity FROM Inventory WHERE Sku = @Sku";
            using (var command = new SqlCommand(sql, connection))
            {
                command.Parameters.AddWithValue("@Sku", sku);

                var reader = await command.ExecuteReaderAsync();
                if (await reader.ReadAsync())
                {
                    result = new InventoryItem
                    {
                        Sku = reader.GetString(0),
                        Quantity = reader.GetInt32(1)
                    };
                }
            }
            connection.Close();
            return result;
        }
    }
}