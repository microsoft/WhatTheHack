using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Azure.Cosmos;
using Microsoft.Azure.Cosmos.Fluent;
using Microsoft.Extensions.Configuration;
using WTHAzureCosmosDB.Models;

namespace WTHAzureCosmosDB.Repositories;

public class ShipmentService : ICosmosDbService<Shipment>
{
    private Container _container;

    public ShipmentService(
        CosmosClient dbClient,
        string databaseName,
        string containerName)
    {
        this._container = dbClient.GetContainer(databaseName, containerName);

    }

    public async Task AddItemAsync(Shipment item)
    {
        await this._container.CreateItemAsync<Shipment>(item, new PartitionKey(item.Type));
    }

    public async Task DeleteItemAsync(string id)
    {
        throw new NotImplementedException();
    }

    public async Task<Shipment> GetItemAsync(string id)
    {
        throw new NotImplementedException();
    }

    public async Task<Shipment> GetItemAsync(string id, string partitionKey)
    {
        try
        {
            ItemResponse<Shipment> response = await this._container.ReadItemAsync<Shipment>(id, new PartitionKey(partitionKey));
            Console.WriteLine($"Product.GetItemAsync(id, partKey) Request Charge: {response.RequestCharge} RU/s");
            return response.Resource;
        }
        catch (CosmosException ex) when (ex.StatusCode == System.Net.HttpStatusCode.NotFound)
        {
            return default(Shipment);
        }

    }

    public async Task<IEnumerable<Shipment>> GetItemsAsync(string queryString)
    {
        var query = this._container.GetItemQueryIterator<Shipment>(new QueryDefinition(queryString));
        List<Shipment> results = new List<Shipment>();
        while (query.HasMoreResults)
        {
            var response = await query.ReadNextAsync();

            results.AddRange(response.ToList());
        }

        return results;
    }

    public async Task<IEnumerable<Shipment>> GetItemsAsync(QueryDefinition queryDefinition)
    {
        var query = this._container.GetItemQueryIterator<Shipment>(queryDefinition);
        List<Shipment> results = new List<Shipment>();
        while (query.HasMoreResults)
        {
            var response = await query.ReadNextAsync();

            results.AddRange(response.ToList());
        }

        return results;
    }

    public async Task UpdateItemAsync(string id, Shipment item)
    {
        await this._container.UpsertItemAsync<Shipment>(item, new PartitionKey(item.Type));
    }
}