using Autofac;
using Microsoft.Azure.KeyVault;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Configuration.AzureKeyVault;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Text;

namespace ContosoTravel.Web.Application
{
    public static class Setup
    {
        private static object _lockObject = new object();
        private static IContainer _container = null;

        public static IContainer InitCotosoWithOneTimeLock(string keyVaultUrl, string currentDirectory, Assembly mainAssembly, ContainerBuilder builder = null)
        {
            if (_container == null)
            {
                lock (_lockObject)
                {
                    if (_container == null)
                    {
                        _container = InitCotoso(keyVaultUrl, currentDirectory, mainAssembly, builder);
                    }
                }
            }

            return _container;
        }

        public static IContainer InitCotoso(string keyVaultUrl, string currentDirectory, Assembly mainAssembly, ContainerBuilder builder = null, bool withDBSecrets = false)
        {
            IConfigurationBuilder configBuilder = new ConfigurationBuilder().SetBasePath(currentDirectory).AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);

            if (!string.IsNullOrEmpty(keyVaultUrl))
            {
                var tokenProvider = new AzureServiceTokenProvider();
                var kvClient = new KeyVaultClient((authority, resource, scope) => tokenProvider.KeyVaultTokenCallback(authority, resource, scope));

                configBuilder = configBuilder.AddAzureKeyVault(keyVaultUrl, kvClient, new DefaultKeyVaultSecretManager());
            }

            var config = configBuilder.AddEnvironmentVariables().Build();
            ContosoConfiguration contsoConfig = ContosoConfiguration.PopulateFromConfig(config, withDBSecrets);

            bool buildHere = false;
            IContainer container = null;

            if (builder == null)
            {
                buildHere = true;
                builder = new ContainerBuilder();
            }

            builder.RegisterInstance<ContosoConfiguration>(contsoConfig).AsSelf();
            builder.RegisterAssemblyModules(typeof(Application.ContosoConfiguration).Assembly, mainAssembly);

            if (buildHere)
            {
                container = builder.Build();
            }

            return container;
        }
    }
}
