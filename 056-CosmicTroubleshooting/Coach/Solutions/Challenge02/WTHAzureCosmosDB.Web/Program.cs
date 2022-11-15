using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Logging;
using WTHAzureCosmosDB.Models;
using WTHAzureCosmosDB.Web.Helpers;
using WTHAzureCosmosDB.Repositories;
using Microsoft.Extensions.Caching.Memory;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddRazorPages().AddRazorPagesOptions(options =>
{
    options.Conventions.ConfigureFilter(new Microsoft.AspNetCore.Mvc.IgnoreAntiforgeryTokenAttribute());
});

builder.Services.AddSingleton<ICosmosDbService<Product>>(
    options =>
    {
        var accountEndpoint = builder.Configuration.GetValue<string>("Cosmos:AccountEndpoint");
        var tokenCredential = new Azure.Identity.DefaultAzureCredential();
        var database = builder.Configuration.GetValue<string>("Cosmos:Database");
        var container = builder.Configuration.GetValue<string>("Cosmos:ProductCollectionName");        
        var connectionString = builder.Configuration.GetValue<string>("Cosmos:ConnectionString");
        Microsoft.Azure.Cosmos.CosmosClient client;

        if (string.IsNullOrEmpty(connectionString))
        {
            client = new Microsoft.Azure.Cosmos.CosmosClient(accountEndpoint, tokenCredential);
        }
        else
        {
            client = new Microsoft.Azure.Cosmos.CosmosClient(connectionString: connectionString);
        }
        ProductService service = new ProductService(client, database, container);

        return service;
    }
);

builder.Services.AddSingleton<ICosmosDbService<CustomerCart>>(
    options =>
    {
        var accountEndpoint = builder.Configuration.GetValue<string>("Cosmos:AccountEndpoint");
        var tokenCredential = new Azure.Identity.DefaultAzureCredential();
        var database = builder.Configuration.GetValue<string>("Cosmos:Database");
        var container = builder.Configuration.GetValue<string>("Cosmos:CustomerCartCollectionName");
        var connectionString = builder.Configuration.GetValue<string>("Cosmos:ConnectionString");
        Microsoft.Azure.Cosmos.CosmosClient client;

        if (string.IsNullOrEmpty(connectionString))
        {
            client = new Microsoft.Azure.Cosmos.CosmosClient(accountEndpoint, tokenCredential);
        }
        else
        {
            client = new Microsoft.Azure.Cosmos.CosmosClient(connectionString: connectionString);
        }
        CustomerCartService service = new CustomerCartService(client, database, container);

        return service;
    }
);

builder.Services.AddSingleton<ICosmosDbService<CustomerOrder>>(
    options =>
    {
        var accountEndpoint = builder.Configuration.GetValue<string>("Cosmos:AccountEndpoint");
        var tokenCredential = new Azure.Identity.DefaultAzureCredential();
        var database = builder.Configuration.GetValue<string>("Cosmos:Database");
        var container = builder.Configuration.GetValue<string>("Cosmos:CustomerOrderCollectionName");        
        var connectionString = builder.Configuration.GetValue<string>("Cosmos:ConnectionString");
        Microsoft.Azure.Cosmos.CosmosClient client;

        if (string.IsNullOrEmpty(connectionString))
        {
            client = new Microsoft.Azure.Cosmos.CosmosClient(accountEndpoint, tokenCredential);
        }
        else
        {
            client = new Microsoft.Azure.Cosmos.CosmosClient(connectionString: connectionString);
        }
        CustomerOrderService service = new CustomerOrderService(client, database, container);

        return service;
    }
);

builder.Services.AddSingleton<ICosmosDbService<Shipment>>(
    options =>
    {
        var accountEndpoint = builder.Configuration.GetValue<string>("Cosmos:AccountEndpoint");
        var tokenCredential = new Azure.Identity.DefaultAzureCredential();
        var database = builder.Configuration.GetValue<string>("Cosmos:Database");
        var container = builder.Configuration.GetValue<string>("Cosmos:ShipmentCollectionName");        
        var connectionString = builder.Configuration.GetValue<string>("Cosmos:ConnectionString");
        Microsoft.Azure.Cosmos.CosmosClient client;

        if (string.IsNullOrEmpty(connectionString))
        {
            client = new Microsoft.Azure.Cosmos.CosmosClient(accountEndpoint, tokenCredential);
        }
        else
        {
            client = new Microsoft.Azure.Cosmos.CosmosClient(connectionString: connectionString);
        }
        ShipmentService service = new ShipmentService(client, database, container);

        return service;
    }
);

builder.Services.AddSingleton(typeof(MemoryCache), new MemoryCache(new MemoryCacheOptions() { }));

// The following line enables Application Insights telemetry collection.
builder.Services.AddApplicationInsightsTelemetry();

builder.Services.AddSingleton(typeof(AzureLoadTestingRunHelper), new AzureLoadTestingRunHelper());

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();

app.MapRazorPages();

app.Run();