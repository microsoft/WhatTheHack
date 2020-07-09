using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Transactions;
using InventoryService.Api.Models;

namespace InventoryService.Api.Services
{
    public class InventoryManager
    {
        private readonly IInventoryData data;
        private readonly BadSqlInventoryData badData;
        private readonly IInventoryNotificationService notifications;

        public InventoryManager(IInventoryData data, BadSqlInventoryData badData, IInventoryNotificationService notifications)
        {
            this.data = data;
            this.badData = badData;
            this.notifications = notifications;
        }

        public Task<InventoryItem> GetInventoryBySkuBad(string sku)
        {
            return badData.GetInventoryBySku(sku);
        }

        public async Task<IEnumerable<InventoryItem>> GetInventoryBySkus(IEnumerable<string> skus)
        {
            var sanitizedSkus = SanitizedSkus(skus);
            List<InventoryItem> results;
            using (var scope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                results = (await data.GetInventoryBySkus(sanitizedSkus)).ToList();
                if (results.Count != sanitizedSkus.Count())
                {
                    var missingSkus = sanitizedSkus.Except(results.Select(i => i.Sku));
                    var random = new Random();
                    foreach (var sku in missingSkus)
                    {
                        var newItem = await data.CreateInventory(sku, random.Next(1, 100), DateTime.Now);
                        await notifications.NotifyInventoryChanged(newItem);
                        results.Add(newItem);
                    }
                }
                scope.Complete();
            }
            return results;
        }

        public async Task<InventoryItem> IncrementInventory(string sku)
        {
            var updatedItem = await data.UpdateInventory(sku, quantityChanged: 1);
            await notifications.NotifyInventoryChanged(updatedItem);
            return updatedItem;
        }

        public async Task<InventoryItem> DecrementInventory(string sku)
        {            
            var updatedItem = await data.UpdateInventory(sku, quantityChanged: -1);
            await notifications.NotifyInventoryChanged(updatedItem);
            return updatedItem;
        }

        private List<string> SanitizedSkus(IEnumerable<string> skus)
        {
            return skus.Select(sku => sku.Trim()).ToList();
        }
    }
}