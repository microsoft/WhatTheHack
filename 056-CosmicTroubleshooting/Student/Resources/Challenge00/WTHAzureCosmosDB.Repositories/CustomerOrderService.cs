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
        await this._container.CreateItemAsync<CustomerOrder>(item, new PartitionKey(item.Id));
    }

    public async Task DeleteItemAsync(string id)
    {
        await this._container.DeleteItemAsync<CustomerOrder>(id, new PartitionKey(id));
    }

    public async Task<CustomerOrder> GetItemAsync(string id)
    {
        try
        {
            ItemResponse<CustomerOrder> response = await this._container.ReadItemAsync<CustomerOrder>(id, new PartitionKey(id));
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
        List<CustomerOrder> results = new List<CustomerOrder>();
        while (query.HasMoreResults)
        {
            var response = await query.ReadNextAsync();

            results.AddRange(response.ToList());
        }

        return results;
    }

    public async Task<IEnumerable<CustomerOrder>> GetItemsAsync(QueryDefinition queryDefinition)
    {
        var query = this._container.GetItemQueryIterator<CustomerOrder>(queryDefinition);
        List<CustomerOrder> results = new List<CustomerOrder>();
        while (query.HasMoreResults)
        {
            var response = await query.ReadNextAsync();

            results.AddRange(response.ToList());
        }

        return results;
    }

    public async Task UpdateItemAsync(string id, CustomerOrder item)
    {
        await this._container.UpsertItemAsync<CustomerOrder>(item, new PartitionKey(id));
    }
}