using Microsoft.Azure.Management.Fluent;
using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Azure.Management.ResourceManager.Fluent.Authentication;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Rest;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace ContosoTravel.Web.Application.Services
{
    public class AzureManagement
    {
        private readonly ContosoConfiguration _contosoConfig;

        public AzureManagement(ContosoConfiguration contosoConfig)
        {
            _contosoConfig = contosoConfig;
        }

        public async Task<IAzure> ConnectToSubscription(string subscriptionId)
        {
            var tokenProvider = new AzureServiceTokenProvider();
            string msiKey = await tokenProvider.GetAccessTokenAsync("https://management.azure.com/");

            var loginInfo = new MSILoginInformation(MSIResourceType.VirtualMachine);
            var cred = new AzureCredentials(new TokenCredentials(msiKey), new TokenCredentials(msiKey), _contosoConfig.TenantId, AzureEnvironment.AzureGlobalCloud);
            return Azure
                .Configure()
                .WithLogLevel(HttpLoggingDelegatingHandler.Level.BodyAndHeaders)
                .Authenticate(cred)
                .WithSubscription(subscriptionId);
        }
    }
}
