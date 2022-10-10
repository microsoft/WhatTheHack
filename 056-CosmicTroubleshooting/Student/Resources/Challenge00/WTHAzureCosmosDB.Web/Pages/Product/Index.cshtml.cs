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
        var queryDef = new QueryDefinition("SELECT * FROM c WHERE c.type = 'Product' and c.itemId = @itemId")
                .WithParameter("@itemId", itemId);

        ProductInstance = (await _productService.GetItemsAsync(queryDef)).FirstOrDefault();

        return Page();
    }

    public async Task<IActionResult> OnPostAsync(string ItemId, int Quantity, string CustomerId)
    {
        var queryDef = new QueryDefinition("SELECT * FROM c WHERE c.type = 'Product' and c.itemId = @itemId")
                .WithParameter("@itemId", ItemId);
        var productInstance = (await _productService.GetItemsAsync(queryDef)).FirstOrDefault();

        var customerCartItem = new models.CustomerCart
        {
            Id = Guid.NewGuid().ToString(),
            ProductId = ItemId,
            ProductName = productInstance.Name,
            ProductPrice = productInstance.Price,
            CustomerId = CustomerId,
            StoreId = productInstance.StoreId,
            Quantity = Quantity,
            Type = "CustomerCart"
        };

        await _customerCartService.AddItemAsync(customerCartItem);

        return RedirectToPage("/Cart/Index", new { customerId = CustomerId, storeId = productInstance.StoreId });
    }
}
