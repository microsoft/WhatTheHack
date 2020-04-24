using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using InventoryService.Api.Models;

namespace InventoryService.Api.Services
{
    public interface IInventoryData
    {
        Task<IEnumerable<InventoryItem>> GetInventoryBySkus(IEnumerable<string> skus);
        Task<InventoryItem> CreateInventory(string sku, int quantity, DateTime modified);
        Task<InventoryItem> UpdateInventory(string sku, int quantityChanged);
    }
}