using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Transactions;
using InventoryService.Api.Database;
using InventoryService.Api.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace InventoryService.Api.Services
{
    public class SqlInventoryData : IInventoryData
    {
        private readonly InventoryContext context;
        private readonly ILogger<SqlInventoryData> logger;

        public SqlInventoryData(InventoryContext context, ILogger<SqlInventoryData> logger)
        {
            this.context = context;
            this.logger = logger;
        }

        public async Task<IEnumerable<InventoryItem>> GetInventoryBySkus(IEnumerable<string> skus)
        {
            return await context
                .Inventory
                .Where(i => skus.Contains(i.Sku))
                .ToListAsync()
                .ConfigureAwait(false);
        }

        public async Task<InventoryItem> CreateInventory(string sku, int quantity, DateTime modified)
        {
            var item = new InventoryItem
            {
                Sku = sku,
                Quantity = quantity,
                Modified = modified
            };
            context.Inventory.Add(item);
            await context.SaveChangesAsync();
            return item;
        }

        public async Task<InventoryItem> UpdateInventory(string sku, int quantityChanged)
        {
            using (var scope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                var item = await context.Inventory.FindAsync(sku);
                if (item != null)
                {
                    item.Quantity += quantityChanged;
                    var averageQuantity = quantityChanged / item.Quantity; // should an exception if 0 (for app insights demo)
					item.Modified = DateTime.Now;
                    await context.SaveChangesAsync();
                    scope.Complete();
                    return item;
                }
                else
                {
                    logger.LogError("Error updating sku. Sku '{sku}' not found.", sku);
                    throw new ArgumentException("Sku not found");
                }
            }
        }
    }
}