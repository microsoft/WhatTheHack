using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using DNS.Client;
using DNS.Protocol;
using Microsoft.Azure.Management.Fluent;
using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Azure.Management.ResourceManager.Fluent.Authentication;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;

namespace Functions
{
    public static class RemoveOldStudents
    {
        [FunctionName("RemoveOldStudents")]
        public static async Task Run([TimerTrigger("0 0 * * * *")]TimerInfo myTimer, ILogger log, CancellationToken cancellationToken)
        {
            log.LogInformation($"Checking for Old or Deleted Students: {DateTime.Now}");

            var credentials = SdkContext.AzureCredentialsFactory.FromMSI(new MSILoginInformation(MSIResourceType.AppService), AzureEnvironment.AzureGlobalCloud);
            var azure = Azure.Configure()
                            .WithLogLevel(HttpLoggingDelegatingHandler.Level.Basic)
                            .Authenticate(credentials)
                            .WithDefaultSubscription();

            var zone = await azure.DnsZones.GetByResourceGroupAsync("rg-contosomasks", "contosomasks.com");

            var allNSRecords = await zone.NSRecordSets.ListAsync(true, cancellationToken);

            if (allNSRecords != null && allNSRecords.Any(ns => !ns.Name.Equals("@")))
            {
                DnsClient client = new DnsClient("8.8.8.8");

                foreach ( var ns in allNSRecords.Where(ns => !ns.Name.Equals("@")))
                {
                    var request = client.Create();
                    request.Questions.Add(new DNS.Protocol.Question(Domain.FromString($"donotdelete.{ns.Name}.contosomasks.com"), RecordType.TXT));
                    request.RecursionDesired = true;
                    bool found = false;

                    try
                    {
                        var response = await request.Resolve();
                        found = response.AnswerRecords != null && response.AnswerRecords.Any();
                    }
                    catch (Exception)
                    {
                        found = false;
                    }

                    if ( !found  )
                    {
                        log.LogInformation($"Student {ns.Name} is done, removing subdomain");
                        await zone.Update().WithoutNSRecordSet(ns.Name).ApplyAsync();
                    }
                    else
                    {
                        log.LogInformation($"Student {ns.Name} is still active");
                    }
                }
            }
        }
    }
}
