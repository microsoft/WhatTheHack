using System.Collections.Generic;
using System.Threading.Tasks;
using WTHAzureCosmosDB.Models;
using Microsoft.Azure.Cosmos;

namespace WTHAzureCosmosDB.Repositories;

public interface ICosmosDbService<T>
{
    Task<IEnumerable<T>> GetItemsAsync(string query);
    Task<IEnumerable<T>> GetItemsAsync(QueryDefinition queryDefinition);
    Task<T> GetItemAsync(string id);
    Task AddItemAsync(T item);
    Task UpdateItemAsync(string id, T item);
    Task DeleteItemAsync(string id);
}