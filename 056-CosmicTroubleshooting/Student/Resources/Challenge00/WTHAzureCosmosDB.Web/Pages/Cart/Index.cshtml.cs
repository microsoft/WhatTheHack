using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.ComponentModel.DataAnnotations;
using WTHAzureCosmosDB.Models;
using WTHAzureCosmosDB.Repositories;
using Microsoft.Azure.Cosmos;

namespace WTHAzureCosmosDB.Web.Pages;

public class CartIndexModel : PageModel
{
    private readonly ILogger<IndexModel> _logger;
    private readonly ICosmosDbService<CustomerCart> _customerCartService;
    private readonly ICosmosDbService<CustomerOrder> _customerOrderService;

    public IEnumerable<CustomerCart> CustomerCartItems { get; private set; }

    [BindProperty(SupportsGet = true)]
    public string CustomerId { get; set; }

    [BindProperty(SupportsGet = true)]
    public int StoreId { get; set; }

    public CartIndexModel(ILogger<IndexModel> logger,
                          ICosmosDbService<CustomerCart> customerCartService,
                          ICosmosDbService<CustomerOrder> customerOrderService)
    {
        _logger = logger;
        _customerCartService = customerCartService;
        _customerOrderService = customerOrderService;
    }


    public async Task<IActionResult> OnGetAsync(string customerId, int storeId)
    {
        if (storeId <= 0 || storeId > 9)
        {
            return RedirectToPage("/Cart/Index", new { customerId = customerId, storeId = 1 });
        }

        CustomerId = customerId;
        StoreId = storeId;

        var queryDef = new QueryDefinition("SELECT * FROM c WHERE c.type = 'CustomerCart' and c.customerId = @customerId and c.storeId = @storeId")
            .WithParameter("@customerId", customerId)
            .WithParameter("@storeId", storeId);

        CustomerCartItems = await _customerCartService.GetItemsAsync(queryDef);

        return Page();
    }

    public async Task<IActionResult> OnPostAsync(string customerId, int StoreId)
    {
        if (StoreId > 0)
        {
            var queryDef = new QueryDefinition("SELECT * FROM c WHERE c.type = 'CustomerCart' and c.customerId = @customerId")
                .WithParameter("@customerId", customerId);
            CustomerCartItems = await _customerCartService.GetItemsAsync(queryDef);
        }
        else
        {
            throw new ArgumentException("Unknown Store Id");
        }

        if(CustomerCartItems == null || CustomerCartItems.Count() == 0)
        {
            throw new ArgumentException($"The specified cart ({customerId}) for store {StoreId} has no items to order.");
        }

        var order = new CustomerOrder
        {
            Id = Guid.NewGuid().ToString(),
            CustomerId = CustomerId,
            OrderedItems = CustomerCartItems,
            StoreId = StoreId,
            Status = "Pending Shipment"
        };

        await _customerOrderService.AddItemAsync(order);

        foreach (var cci in CustomerCartItems)
        {
            await _customerCartService.DeleteItemAsync(cci.Id);
        }

        return RedirectToPage("/Order/Index", new { customerId = CustomerId, storeId = StoreId });
    }
}
