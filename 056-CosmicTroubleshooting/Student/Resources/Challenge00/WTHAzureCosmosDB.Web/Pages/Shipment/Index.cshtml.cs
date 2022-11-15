using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Azure.Cosmos;
using System.ComponentModel.DataAnnotations;
using models = WTHAzureCosmosDB.Models;
using WTHAzureCosmosDB.Repositories;

namespace WTHAzureCosmosDB.Web.Pages;

public class ShipmentIndexModel : PageModel
{
    private readonly ILogger<IndexModel> _logger;
    private readonly ICosmosDbService<models.Shipment> _shipmentService;

    [BindProperty(SupportsGet = true)]
    public IEnumerable<WTHAzureCosmosDB.Models.Shipment> CustomerShipments { get; set; }

    [BindProperty(SupportsGet = true)]
    public string CustomerId { get; set; }

    [BindProperty(SupportsGet = true)]
    public int StoreId { get; set; }

    public ShipmentIndexModel(ILogger<IndexModel> logger, 
                             ICosmosDbService<models.Shipment> shipmentService)
    {
        _logger = logger;
        _shipmentService = shipmentService;
    }


    public async Task<IActionResult> OnGet(string customerId, int storeId)
    {
        if (storeId <= 0 || storeId > 9)
        {
            return RedirectToPage("/Shipment/Index", new { customerId = customerId, storeId = 1 });
        }
        
        var queryDef = new QueryDefinition("SELECT * FROM c WHERE c.type = @type and c.customerId = @customerId and c.storeId = @storeId")
                .WithParameter("@type", $"Shipment-{customerId}")
                .WithParameter("@customerId", customerId)
                .WithParameter("@storeId", storeId);
        CustomerId = customerId;
        StoreId = storeId;
        CustomerShipments = await _shipmentService.GetItemsAsync(queryDef);

        return Page();
    }
}
