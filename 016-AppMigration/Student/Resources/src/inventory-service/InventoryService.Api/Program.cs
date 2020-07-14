using System.Linq;
using InventoryService.Api.Database;
using InventoryService.Api.Models;
using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Azure.KeyVault;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Configuration.AzureKeyVault;
using Microsoft.Extensions.DependencyInjection;

namespace InventoryService.Api
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var config = new ConfigurationBuilder()
                .AddUserSecrets<Startup>()
                .AddEnvironmentVariables()
                .Build();

            var host = CreateWebHostBuilder(args)
                .ConfigureAppConfiguration((ctx, builder) =>
                {
                    var keyVaultEndpoint = config["KeyVaultEndpoint"];
                    if (!string.IsNullOrEmpty(keyVaultEndpoint))
                    {
                        var azureServiceTokenProvider = new AzureServiceTokenProvider();
                        var keyVaultClient = new KeyVaultClient(
                            new KeyVaultClient.AuthenticationCallback(
                                azureServiceTokenProvider.KeyVaultTokenCallback));
                        builder.AddAzureKeyVault(
                            keyVaultEndpoint, keyVaultClient, new DefaultKeyVaultSecretManager());
                    }
                }).Build();

            using (var scope = host.Services.CreateScope())
            {
                var context = scope.ServiceProvider.GetRequiredService<InventoryContext>();
                context.Database.Migrate();
                // make sure there is a user inserted (for SQL injection demo)
                if (context.SecretUsers.Count() == 0)
                {
                    context.SecretUsers.Add(new SecretUser
                    {
                        Username = "administrator",
                        Password = "MySuperSecr3tPassword!"
                    });
                    context.SaveChanges();
                }
                if (context.Payroll.Count() == 0)
                {
                    context.Payroll.AddRange(
                        new Payroll
                        {
                            EmployeeName = "Nancy Daviolo",
                            Title = "Executive Vice President of Operations",
                            Salary = 150000
                        },
                        new Payroll
                        {
                            EmployeeName = "Margaret Peacock",
                            Title = "President",
                            Salary = 135000
                        });
                    context.SaveChanges();
                }
            }
            host.Run();
        }

        public static IWebHostBuilder CreateWebHostBuilder(string[] args) =>
            WebHost.CreateDefaultBuilder(args)
                .UseStartup<Startup>();
    }
}
