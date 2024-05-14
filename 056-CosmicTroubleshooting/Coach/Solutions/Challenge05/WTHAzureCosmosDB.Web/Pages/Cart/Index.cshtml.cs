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

    public CustomerCart CustomerCartInstance { get; private set; }

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

        CustomerCartInstance = await _customerCartService.GetItemAsync(customerId, $"CustomerCart-{storeId}");

        return Page();
    }

    public async Task<IActionResult> OnPostAsync(string customerId, int StoreId)
    {
        var customerCartItems = new List<CustomerCart>();

        if (StoreId > 0)
        {
            CustomerCartInstance = await _customerCartService.GetItemAsync(customerId, $"CustomerCart-{StoreId}");

            if (CustomerCartInstance != null)
            {
                customerCartItems.Add(CustomerCartInstance);
            }
        }
        else
        {
            throw new ArgumentException("Unknown Store Id");
        }

        if (customerCartItems == null || customerCartItems.Count() == 0)
        {
            throw new ArgumentException($"The specified customer ({customerId}) {(StoreId > 0 ? $"for store {StoreId}" : $"for all stores")} has no items to order.");
        }

        foreach (var customerCartItem in customerCartItems)
        {
            var order = new CustomerOrder
            {
                Id = Guid.NewGuid().ToString(),
                CustomerId = CustomerId,
                OrderedItems = new List<CustomerOrderItem>(),
                StoreId = StoreId,
                Status = "Pending Shipment"
            };

            foreach (var cartItem in customerCartItem.Items)
            {
                order.OrderedItems.Add(new CustomerOrderItem
                {
                    CustomerId = CustomerId,
                    ProductId = cartItem.ProductId,
                    StoreId = StoreId,
                    ProductName = cartItem.ProductName,
                    ProductPrice = cartItem.ProductPrice,
                    Quantity = cartItem.Quantity
                });
            }

            await _customerOrderService.AddItemAsync(order);

            foreach (var cci in customerCartItems)
            {
                await _customerCartService.DeleteItemAsync(cci.Id, cci.Type);
            }
        }



        return RedirectToPage("/Order/Index", new { customerId = CustomerId, storeId = StoreId });
    }
}
