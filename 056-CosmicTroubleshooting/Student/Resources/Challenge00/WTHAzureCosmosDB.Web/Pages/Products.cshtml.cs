using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Text.Json;
using models = WTHAzureCosmosDB.Models;
using WTHAzureCosmosDB.Repositories;

namespace WTHAzureCosmosDB.Web.Pages;

public class ProductsModel : PageModel
{
    private readonly ILogger<IndexModel> _logger;

    private readonly ICosmosDbService<models.Product> _productService;

    public List<WTHAzureCosmosDB.Models.Product> Products { get; private set; }

    public ProductsModel(ILogger<IndexModel> logger, ICosmosDbService<models.Product> service)
    {
        _logger = logger;
        _productService = service;
    }

    public async Task<IActionResult> OnGet(int storeId)
    {
        if (storeId <= 0 || storeId > 9)
        {
            return RedirectToPage("Products", new { storeId = 1 });
        }
        
        try
        {
            // Read our static products
            var directory = Path.Combine(Environment.CurrentDirectory, "wwwroot\\data");
            var productsAsJson = System.IO.File.ReadAllText(Path.Combine(directory, "products.json"));
            Products = JsonSerializer.Deserialize<List<WTHAzureCosmosDB.Models.Product>>(productsAsJson, new JsonSerializerOptions() { PropertyNamingPolicy = JsonNamingPolicy.CamelCase });

            var random = new Random();

            Products = Products.Where(p => p.StoreId == storeId).ToList();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex.ToString());
        }

        return Page();
    }
}
