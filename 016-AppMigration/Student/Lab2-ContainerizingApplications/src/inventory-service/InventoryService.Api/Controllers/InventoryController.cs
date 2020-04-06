using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using InventoryService.Api.Models;
using InventoryService.Api.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace InventoryService.Api.Controllers
{
    [Route("api/inventory")]
    [ApiController]
    public class InventoryController : ControllerBase
    {
        private readonly InventoryManager inventoryManager;
        private readonly ILogger<InventoryController> logger;

        public InventoryController(InventoryManager inventoryManager, ILogger<InventoryController> logger)
        {
            this.inventoryManager = inventoryManager ?? throw new ArgumentNullException(nameof(inventoryManager));
            this.logger = logger;
        }

        /// <summary>
        /// Retrieves one or more inventory items.
        /// </summary>
        /// <returns>
        /// Inventory items
        /// </returns>
        /// <param name="skus">The list of comma-separated SKUs.</param>
        [HttpGet]
        public async Task<IEnumerable<InventoryItem>> GetAsync([FromQuery] string skus)
        {
            if (!string.IsNullOrEmpty(skus))
            {
                var splitSkus = skus.Split(',', StringSplitOptions.RemoveEmptyEntries);
                foreach(var sku in splitSkus)
                {
                    logger.LogInformation(new EventId(0, "GetSkuMultiple"), "Getting sku {sku}", sku);
                }
                return await inventoryManager.GetInventoryBySkus(splitSkus);
            }
            else
            {
                return new List<InventoryItem>();
            }
        }

        /// <summary>
        /// Retrieves an inventory item (susceptible to SQL injection).
        /// </summary>
        /// <returns>
        /// Inventory item
        /// </returns>
        /// <param name="sku">The product SKU.</param>
        [HttpGet("bad/{sku}")]
        public async Task<IActionResult> GetSingleBadAsync(string sku)
        {
            logger.LogInformation(new EventId(2, "GetSkuSingleBad"), "Getting sku {sku}", sku);
            var result = await inventoryManager.GetInventoryBySkuBad(sku);
            if (result != null)
            {
                return Ok(result);
            }
            else
            {
                return NotFound();
            }
        }

        /// <summary>
        /// Retrieves an inventory item.
        /// </summary>
        /// <returns>
        /// Inventory item
        /// </returns>
        /// <param name="sku">The product SKU.</param>
        [HttpGet("{sku}")]
        public async Task<InventoryItem> GetSingleAsync(string sku)
        {
            logger.LogInformation(new EventId(1, "GetSkuSingle"), "Getting sku {sku}", sku);
            return (await inventoryManager.GetInventoryBySkus(new string[] { sku })).FirstOrDefault();
        }

        /// <summary>
        /// Increments an inventory item quantity by one.
        /// </summary>
        /// <returns>
        /// The updated inventory item
        /// </returns>
        /// <param name="sku">The product SKU.</param>
        [HttpPost("{sku}/increment")]
        public async Task<InventoryItem> IncrementAsync(string sku)
        {
            var result = await inventoryManager.IncrementInventory(sku);
            logger.LogInformation(new EventId(3, "Increment"), "Incrementing sku {sku}. New value {newValue}", sku, result.Quantity);
            return result;
        }

        /// <summary>
        /// Decrements an inventory item quantity by one.
        /// </summary>
        /// <returns>
        /// The updated inventory item
        /// </returns>
        /// <param name="sku">The product SKU.</param> 
        [HttpPost("{sku}/decrement")]
        public async Task<InventoryItem> DecrementAsync(string sku)
        {
            var result = await inventoryManager.DecrementInventory(sku);
            logger.LogInformation(new EventId(4, "Decrement"), "Decrementing sku {sku}. New value {newValue}", sku, result.Quantity);
            return result;
        }
    }
}