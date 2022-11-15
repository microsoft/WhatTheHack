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
        await this._container.CreateItemAsync<CustomerCart>(item, new PartitionKey(item.Id));
    }

    public async Task DeleteItemAsync(string id)
    {
        await this._container.DeleteItemAsync<CustomerCart>(id, new PartitionKey(id));
    }

    public async Task<CustomerCart> GetItemAsync(string id)
    {
        try
        {
            ItemResponse<CustomerCart> response = await this._container.ReadItemAsync<CustomerCart>(id, new PartitionKey(id));
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
        List<CustomerCart> results = new List<CustomerCart>();
        while (query.HasMoreResults)
        {
            var response = await query.ReadNextAsync();

            results.AddRange(response.ToList());
        }

        return results;
    }

    public async Task<IEnumerable<CustomerCart>> GetItemsAsync(QueryDefinition queryDefinition)
    {
        var query = this._container.GetItemQueryIterator<CustomerCart>(queryDefinition);
        List<CustomerCart> results = new List<CustomerCart>();
        while (query.HasMoreResults)
        {
            var response = await query.ReadNextAsync();

            results.AddRange(response.ToList());
        }

        return results;
    }

    public async Task UpdateItemAsync(string id, CustomerCart item)
    {
        await this._container.UpsertItemAsync<CustomerCart>(item, new PartitionKey(id));
    }
}