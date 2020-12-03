using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Azure.Management.ResourceManager.Fluent.Authentication;
using Microsoft.Azure.Management.Fluent;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;
using System.Threading;

namespace Functions
{
    public static class RegisterStudent
    {
        const string BLANK_TEMPLATE = @"{
                                          '$schema': 'https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#', 
                                          'contentVersion': '1.0.0.0', 
                                          'parameters': {}, 
                                          'variables': {}, 
                                          'resources': []
                                       }";
        [FunctionName("RegisterStudent")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = "registerStudent/{code}/{ns1}/{ns2}/{ns3}/{ns4}")] HttpRequest req,
            string code, string ns1, string ns2, string ns3, string ns4, ILogger log, CancellationToken cancellationToken)
        {
           var credentials = SdkContext.AzureCredentialsFactory.FromMSI(new MSILoginInformation(MSIResourceType.AppService), AzureEnvironment.AzureGlobalCloud);
           var azure = Azure.Configure()
                             .WithLogLevel(HttpLoggingDelegatingHandler.Level.Basic)
                             .Authenticate(credentials)
                             .WithDefaultSubscription();

            log.LogInformation($"Registering Student {code}");
            var zone = await azure.DnsZones.GetByResourceGroupAsync("rg-contosomasks", "contosomasks.com", cancellationToken);
            bool exists = false;
            try
            {
                var currentNSRecord = await zone.NSRecordSets.GetByNameAsync(code, cancellationToken);

                exists = currentNSRecord != null;
            }
            catch (Exception)
            {

            }

            if ( !exists )
            {
                log.LogInformation($"Delegating Subdomain for Student {code}");
                await zone.Update().DefineNSRecordSet(code)
                                   .WithNameServer(ns1)
                                   .WithNameServer(ns2)
                                   .WithNameServer(ns3)
                                   .WithNameServer(ns4)
                                   .Attach().ApplyAsync(cancellationToken);
            }
            else
            {
                log.LogInformation($"Subdomain already delegated Student {code}");
            }

            return new ContentResult() { Content = BLANK_TEMPLATE, ContentType = "application/json", StatusCode = 200 };
        }
    }
}
