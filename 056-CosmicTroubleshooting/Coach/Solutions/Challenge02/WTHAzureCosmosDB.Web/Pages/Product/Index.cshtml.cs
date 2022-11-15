using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Azure.Cosmos;
using System.ComponentModel.DataAnnotations;
using models = WTHAzureCosmosDB.Models;
using WTHAzureCosmosDB.Repositories;

namespace WTHAzureCosmosDB.Web.Pages;

public class ProductIndexModel : PageModel
{
    private readonly ILogger<IndexModel> _logger;
    private readonly ICosmosDbService<models.Product> _productService;
    private readonly ICosmosDbService<models.CustomerCart> _customerCartService;

    [BindProperty(SupportsGet = true)]
    public WTHAzureCosmosDB.Models.Product ProductInstance { get; set; }

    [BindProperty(SupportsGet = true)]
    [Required]
    [Range(0, 100)]
    public int Quantity { get; set; }

    [BindProperty(SupportsGet = true)]
    [Required]
    public string CustomerId { get; set; }

    public ProductIndexModel(ILogger<IndexModel> logger,
                             ICosmosDbService<models.Product> productService,
                             ICosmosDbService<models.CustomerCart> customerCartService)
    {
        _logger = logger;
        _productService = productService;
        _customerCartService = customerCartService;
    }


    public async Task<IActionResult> OnGet(string itemId)
    {
        ProductInstance = await _productService.GetItemAsync(itemId, "Product");

        return Page();
    }

    public async Task<IActionResult> OnPostAsync(string ItemId, int Quantity, string CustomerId)
    {
        var productInstance = await _productService.GetItemAsync(ItemId, "Product");

        // Check if a cart item already exists
        var customerCartInstance = await _customerCartService.GetItemAsync(CustomerId, $"CustomerCart-{productInstance.StoreId}");

        // This is a new customer cart item
        if (customerCartInstance == null)
        {
            customerCartInstance = new models.CustomerCart
            {
                Id = CustomerId,
                StoreId = productInstance.StoreId,
                Items = new List<models.CustomerCartItem>()
            };

            customerCartInstance.Items.Add(new models.CustomerCartItem{
                ProductId = productInstance.Id,
                ProductName = productInstance.Name,
                ProductPrice = productInstance.Price,
                Quantity = Quantity
            });

        await _customerCartService.AddItemAsync(customerCartInstance);
        }
        // Customer cart item already exists, add the product to it
        else{
            customerCartInstance.Items.Add(new models.CustomerCartItem{
                ProductId = productInstance.Id,
                ProductName = productInstance.Name,
                ProductPrice = productInstance.Price,
                Quantity = Quantity
            });

            await _customerCartService.UpdateItemAsync(customerCartInstance.Id, customerCartInstance);
        }

        return RedirectToPage("/Cart/Index", new { customerId = CustomerId, storeId = productInstance.StoreId });
    }
}
