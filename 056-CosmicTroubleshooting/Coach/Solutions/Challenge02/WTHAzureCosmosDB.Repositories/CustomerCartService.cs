using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Azure.Cosmos;
using Microsoft.Azure.Cosmos.Fluent;
using Microsoft.Extensions.Configuration;
using WTHAzureCosmosDB.Models;

namespace WTHAzureCosmosDB.Repositories;

public class CustomerCartService : ICosmosDbService<CustomerCart>
{
    private Container _container;

    public CustomerCartService(
        CosmosClient dbClient,
        string databaseName,
        string containerName)
    {
        this._container = dbClient.GetContainer(databaseName, containerName);

    }

    public async Task AddItemAsync(CustomerCart item)
    {
        var response = await this._container.CreateItemAsync<CustomerCart>(item, new PartitionKey(item.Type));
        Console.WriteLine($"CustomerCart.AddItemAsync(item) Request Charge: {response.RequestCharge} RU/s");
    }

    public async Task DeleteItemAsync(string id, string partitionKey)
    {
        var response = await this._container.DeleteItemAsync<CustomerCart>(id, new PartitionKey(partitionKey));
        Console.WriteLine($"CustomerCart.DeleteItemAsync(id, partKey) Request Charge: {response.RequestCharge} RU/s");
    }

    public async Task<CustomerCart> GetItemAsync(string id, string partitionKey)
    {
        try
        {
            ItemResponse<CustomerCart> response = await this._container.ReadItemAsync<CustomerCart>(id, new PartitionKey(partitionKey));
            Console.WriteLine($"CustomerCart.GetItemAsync(id, partKey) Request Charge: {response.RequestCharge} RU/s");
            return response.Resource;
        }
        catch (CosmosException ex) when (ex.StatusCode == System.Net.HttpStatusCode.NotFound)
        {
            return default(CustomerCart);
        }

    }

    public async Task<IEnumerable<CustomerCart>> GetItemsAsync(string queryString)
    {
        var query = this._container.GetItemQueryIterator<CustomerCart>(new QueryDefinition(queryString));
        var cost = 0.0;
        List<CustomerCart> results = new List<CustomerCart>();
        while (query.HasMoreResults)
        {
            var response = await query.ReadNextAsync();
            cost += response.RequestCharge;
            results.AddRange(response.ToList());
        }

        Console.WriteLine($"CustomerCart.GetItemAsync(queryStr) Request Charge: {cost} RU/s");

        return results;
    }

    public async Task<IEnumerable<CustomerCart>> GetItemsAsync(QueryDefinition queryDefinition)
    {
        var query = this._container.GetItemQueryIterator<CustomerCart>(queryDefinition);
        var cost = 0.0;
        List<CustomerCart> results = new List<CustomerCart>();
        while (query.HasMoreResults)
        {
            var response = await query.ReadNextAsync();
            cost += response.RequestCharge;
            results.AddRange(response.ToList());
        }

        Console.WriteLine($"CustomerCart.GetItemsAsync(queryDef) Request Charge: {cost} RU/s");

        return results;
    }

    public async Task UpdateItemAsync(string id, CustomerCart item)
    {
        var response = await this._container.UpsertItemAsync<CustomerCart>(item, new PartitionKey(item.Type));
        Console.WriteLine($"CustomerCart.UpdateItemAsync(id, item) Request Charge: {response.RequestCharge} RU/s");
    }
}