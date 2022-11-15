using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Azure.Cosmos;
using Microsoft.Azure.Cosmos.Fluent;
using Microsoft.Extensions.Configuration;
using WTHAzureCosmosDB.Models;

namespace WTHAzureCosmosDB.Repositories;

public class CustomerOrderService : ICosmosDbService<CustomerOrder>
{
    private Container _container;

    public CustomerOrderService(
        CosmosClient dbClient,
        string databaseName,
        string containerName)
    {
        this._container = dbClient.GetContainer(databaseName, containerName);

    }

    public async Task AddItemAsync(CustomerOrder item)
    {
        var response = await this._container.CreateItemAsync<CustomerOrder>(item, new PartitionKey(item.Type));
        Console.WriteLine($"CustomerOrder.AddItemAsync(item) Request Charge: {response.RequestCharge} RU/s");
    }

    public async Task DeleteItemAsync(string id, string partitionKey)
    {
        var response = await this._container.DeleteItemAsync<CustomerOrder>(id, new PartitionKey(partitionKey));
        Console.WriteLine($"CustomerOrder.DeleteItemAsync(id, partKey) Request Charge: {response.RequestCharge} RU/s");
    }

    public async Task<CustomerOrder> GetItemAsync(string id, string partitionKey)
    {
        try
        {
            ItemResponse<CustomerOrder> response = await this._container.ReadItemAsync<CustomerOrder>(id, new PartitionKey(partitionKey));
            Console.WriteLine($"CustomerOrder.GetItemAsync(id, partKey) Request Charge: {response.RequestCharge} RU/s");
            return response.Resource;
        }
        catch (CosmosException ex) when (ex.StatusCode == System.Net.HttpStatusCode.NotFound)
        {
            return default(CustomerOrder);
        }

    }

    public async Task<IEnumerable<CustomerOrder>> GetItemsAsync(string queryString)
    {
        var query = this._container.GetItemQueryIterator<CustomerOrder>(new QueryDefinition(queryString));
        var cost = 0.0;
        List<CustomerOrder> results = new List<CustomerOrder>();
        while (query.HasMoreResults)
        {
            var response = await query.ReadNextAsync();
            cost += response.RequestCharge;
            results.AddRange(response.ToList());
        }
        Console.WriteLine($"CustomerOrder.GetItemsAsync(queryStr) Request Charge: {cost} RU/s");

        return results;
    }

    public async Task<IEnumerable<CustomerOrder>> GetItemsAsync(QueryDefinition queryDefinition)
    {
        var query = this._container.GetItemQueryIterator<CustomerOrder>(queryDefinition);
        var cost = 0.0;
        List<CustomerOrder> results = new List<CustomerOrder>();
        while (query.HasMoreResults)
        {
            var response = await query.ReadNextAsync();
            cost += response.RequestCharge;
            results.AddRange(response.ToList());
        }

        Console.WriteLine($"CustomerCart.GetItemsAsync(querydef) Request Charge: {cost} RU/s");

        return results;
    }

    public async Task UpdateItemAsync(string id, CustomerOrder item)
    {
        var response = await this._container.UpsertItemAsync<CustomerOrder>(item, new PartitionKey(item.Type));
        Console.WriteLine($"CustomerOrder.UpdateItemAsync(id, item) Request Charge: {response.RequestCharge} RU/s");
    }
}