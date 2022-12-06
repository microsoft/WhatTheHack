using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Azure.Cosmos;
using System.ComponentModel.DataAnnotations;
using WTHAzureCosmosDB.Models;
using WTHAzureCosmosDB.Repositories;

namespace WTHAzureCosmosDB.Web.Pages;

public class OrderIndexModel : PageModel
{
    private readonly ILogger<IndexModel> _logger;
    private readonly ICosmosDbService<CustomerOrder> _customerOrderService;

    public IEnumerable<CustomerOrder> CustomerOrderItems { get; private set; }

    [BindProperty(SupportsGet = true)]
    public string CustomerId { get; set; }

    [BindProperty(SupportsGet = true)]
    public int StoreId { get; set; }

    public OrderIndexModel(ILogger<IndexModel> logger,
                           ICosmosDbService<CustomerOrder> customerOrderService)
    {
        _logger = logger;
        _customerOrderService = customerOrderService;
    }


    public async Task<IActionResult> OnGetAsync(string customerId, int storeId)
    {
        CustomerId = customerId;

        if (storeId > 0)
        {
            var queryDef = new QueryDefinition("SELECT * FROM c WHERE c.type = @type and c.customerId = @customerId and c.storeId = @storeId")
                .WithParameter("@type", $"CustomerOrder-{customerId}")
                .WithParameter("@customerId", customerId)
                .WithParameter("@storeId", storeId);
            CustomerOrderItems = await _customerOrderService.GetItemsAsync(queryDef);
        }
        else
        {

            throw new ArgumentException("Unknown Store Id");
        }

        return Page();
    }
}
