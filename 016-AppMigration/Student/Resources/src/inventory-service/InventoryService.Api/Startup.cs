using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using InventoryService.Api.Database;
using InventoryService.Api.Services;
using NSwag.AspNetCore;
using NJsonSchema;
using InventoryService.Api.Hubs;
using Newtonsoft.Json.Serialization;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Http;

namespace InventoryService.Api
{
    public class Startup
    {
        private readonly string signalRServiceConnectionString;
        private readonly bool useSignalRService;
        private bool isPostgres;
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
            signalRServiceConnectionString = configuration["SignalRServiceConnectionString"];
            useSignalRService = !string.IsNullOrEmpty(signalRServiceConnectionString);
        }

        public IConfiguration Configuration { get; }

        public void ConfigureServices(IServiceCollection services)
        {
            services.AddMvc().SetCompatibilityVersion(CompatibilityVersion.Version_2_1);
            services.AddSwagger();
            services.AddDbContext<InventoryContext>(options =>
            {
                var connectionString = Configuration.GetConnectionString("InventoryContext");
                isPostgres = connectionString.Contains("postgres");
                if (isPostgres)
                {
                    options.UseNpgsql(connectionString);
                }
                else
                {
                    options.UseSqlServer(connectionString);
                }
            });
            services.AddCors();
            var signalR = services.AddSignalR()
                .AddJsonProtocol(builder =>
                    builder.PayloadSerializerSettings.ContractResolver = new CamelCasePropertyNamesContractResolver());
            if (useSignalRService)
            {
                signalR.AddAzureSignalR(signalRServiceConnectionString);
            }
            services.AddScoped<InventoryManager>();
            services.AddScoped<IInventoryData, SqlInventoryData>();
            services.AddScoped<IInventoryNotificationService, SignalRInventoryNotificationService>();
            services.AddScoped<SqlConnection>(_ =>
            {
                if (isPostgres)
                {
                    return null;
                }

                var connectionString = Configuration.GetConnectionString("InventoryContextReadOnly");
                if (string.IsNullOrEmpty(connectionString))
                {
                    connectionString = Configuration.GetConnectionString("InventoryContext");
                }

                return new SqlConnection(connectionString);
            });
            services.AddScoped<BadSqlInventoryData>();
        }

        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            app.UseCors(builder => builder.AllowAnyOrigin());
            app.UseSwaggerUi3WithApiExplorer(settings =>
            {
                settings.GeneratorSettings.DefaultPropertyNameHandling =
                    PropertyNameHandling.CamelCase;
                settings.GeneratorSettings.Title = "Inventory Service";
            });

            if (useSignalRService)
            {
                app.UseAzureSignalR(builder => builder.MapHub<InventoryHub>("/signalr/inventory"));
            }
            else
            {
                app.UseSignalR(builder => builder.MapHub<InventoryHub>("/signalr/inventory"));
            }

            app.UseMvc();
            app.UseFileServer("/www");
            app.Run(async context =>
            {
                // return 200 at the root for healthchecks
                await context.Response.WriteAsync("Inventory Service");
            });
        }
    }
}
