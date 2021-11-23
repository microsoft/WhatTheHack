using Contoso.Azure.KeyVault;
using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;

namespace Contoso.WebApi
{
    public class Program
    {
        public static void Main(string[] args)
        {
            CreateWebHostBuilder(args).Build().Run();
        }

        public static IWebHostBuilder CreateWebHostBuilder(string[] args) =>
            WebHost.CreateDefaultBuilder(args)
                .ConfigureAppConfiguration((context, config) =>
                {
                    var buildConfig = config.Build();

                    config.AddEnvironmentVariables();

                    // ******************************************
                    // Connecting to Azure Key Vault.
                    config.AddAzureKeyVault(
                    KeyVaultConfig.GetKeyVaultEndpoint(buildConfig["KeyVaultName"]),
                    buildConfig["KeyVaultClientId"],
                    buildConfig["KeyVaultClientSecret"]
);
                    // ******************************************
                })
                .UseStartup<Startup>();
    }
}