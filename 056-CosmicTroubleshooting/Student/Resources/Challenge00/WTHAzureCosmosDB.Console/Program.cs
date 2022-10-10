using System.Text.Json;
using System.Threading.Tasks;
using WTHAzureCosmosDB.Models;
using WTHAzureCosmosDB.Repositories;
using Microsoft.Extensions.Configuration;

internal class Program
{
    private static async Task Main(string[] args)
    {
        List<string> options = Environment.GetCommandLineArgs().ToList();

        if (options.Count() < 4)
        {
            Console.WriteLine("\nThe console app requires parameters that control the mode of operation.");
            Console.WriteLine("Acceptable modes: ");
            Console.WriteLine("- dotnet run /seedProducts /connString <Azure Cosmos DB Connection String>\n");
            return;
        }

        var mode = options[1];
        var authType = options[2];
        var authValue = options[3];

        switch (mode)
        {
            case "/seedProducts":
                await seedProducts(authType, authValue);
                return;
            case "default":
                return;
        }

        async Task seedProducts(string authType, string authValue)
        {
            // Parse the products from products.json
            var productsAsJson = File.ReadAllText("products.json");
            var productsList = JsonSerializer.Deserialize<List<Product>>(productsAsJson, new JsonSerializerOptions() { PropertyNamingPolicy = JsonNamingPolicy.CamelCase });

            IConfiguration Configuration = new ConfigurationBuilder().AddJsonFile("appsettings.json").Build();

            var database = Configuration.GetValue<string>("Cosmos:Database");
            var container = Configuration.GetValue<string>("Cosmos:CollectionName");
            Microsoft.Azure.Cosmos.CosmosClient client = new Microsoft.Azure.Cosmos.CosmosClient(connectionString: authValue);
            ProductService service = new ProductService(client, database, container);

            foreach (var p in productsList)
            {
                p.Id = Guid.NewGuid().ToString();
                await service.AddItemAsync(p);
            }
        }
    }
}