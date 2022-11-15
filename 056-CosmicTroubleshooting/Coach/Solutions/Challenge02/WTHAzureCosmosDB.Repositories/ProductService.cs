using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Azure.Cosmos;
using Microsoft.Azure.Cosmos.Fluent;
using Microsoft.Extensions.Configuration;
using WTHAzureCosmosDB.Models;

namespace WTHAzureCosmosDB.Repositories;

public class ProductService : ICosmosDbService<Product>
{
    private Container _container;

    public ProductService(
        CosmosClient dbClient,
        string databaseName,
        string containerName)
    {
        this._container = dbClient.GetContainer(databaseName, containerName);

    }

    public async Task AddItemAsync(Product item)
    {
        var response = await this._container.CreateItemAsync<Product>(item, new PartitionKey(item.Type));
        Console.WriteLine($"Product.AddItemAsync(item) Request Charge: {response.RequestCharge} RU/s");
    }

    public async Task DeleteItemAsync(string id, string partitionKey)
    {
        var response = await this._container.DeleteItemAsync<Product>(id, new PartitionKey(partitionKey));
        Console.WriteLine($"Product.DeleteItemAsync(id, partKey) Request Charge: {response.RequestCharge} RU/s");
    }

    public async Task<Product> GetItemAsync(string id, string partitionKey)
    {
        try
        {
            ItemResponse<Product> response = await this._container.ReadItemAsync<Product>(id, new PartitionKey(partitionKey));
            Console.WriteLine($"Product.GetItemAsync(id, partKey) Request Charge: {response.RequestCharge} RU/s");
            return response.Resource;
        }
        catch (CosmosException ex) when (ex.StatusCode == System.Net.HttpStatusCode.NotFound)
        {
            return default(Product);
        }

    }

    public async Task<IEnumerable<Product>> GetItemsAsync(string queryString)
    {
        var query = this._container.GetItemQueryIterator<Product>(new QueryDefinition(queryString));
        var cost = 0.0;
        List<Product> results = new List<Product>();
        while (query.HasMoreResults)
        {
            var response = await query.ReadNextAsync();
            cost+= response.RequestCharge;
            results.AddRange(response.ToList());
        }
        Console.WriteLine($"Product.GetItemsAsync(queryStr) Request Charge: {cost} RU/s");

        return results;
    }

    public async Task<IEnumerable<Product>> GetItemsAsync(QueryDefinition queryDefinition)
    {
        var query = this._container.GetItemQueryIterator<Product>(queryDefinition);
        var cost = 0.0;
        List<Product> results = new List<Product>();
        while (query.HasMoreResults)
        {
            var response = await query.ReadNextAsync();
            cost += response.RequestCharge;
            results.AddRange(response.ToList());
        }
        Console.WriteLine($"Product.GetItemsAsync(queryDef) Request Charge: {cost} RU/s");

        return results;
    }

    public async Task UpdateItemAsync(string id, Product item)
    {
        var response = await this._container.UpsertItemAsync<Product>(item, new PartitionKey(item.Type));
        Console.WriteLine($"Product.UpdateItemAsync(id, item) Request Charge: {response.RequestCharge} RU/s");
    }
}