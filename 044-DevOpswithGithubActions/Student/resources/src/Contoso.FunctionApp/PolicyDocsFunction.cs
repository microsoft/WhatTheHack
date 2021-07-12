using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Net.Http;
using System.Threading.Tasks;

namespace Contoso.FunctionApp
{
    public static class PolicyDocsFunction
    {
        // ******************************************
        // Retrieve PolicyDocuments
        [FunctionName("PolicyDocs")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = "policies/{policyHolder}/{policyNumber}")] HttpRequest req, string policyHolder, string policyNumber, ILogger log)
        // ******************************************
        {
            log.LogInformation($"PolicyDocs Function recieved a request for document '{policyHolder}-{policyNumber}.pdf'.");

            var fileBytes = await GetDocumentFromStorage(policyHolder, policyNumber);

            return fileBytes.Length > 0
                ? (ActionResult)new FileContentResult(fileBytes, "application/pdf")
                : new NotFoundObjectResult("No policy document was found for the specified policy holder and number");
        }

        private static async Task<byte[]> GetDocumentFromStorage(string policyHolder, string policyNumber)
        {
            // ******************************************
            // Container reference for Policy Documents in Azure Storage.
            var containerUri = Environment.GetEnvironmentVariable("PolicyStorageUrl");
            var sasToken = Environment.GetEnvironmentVariable("PolicyStorageSas");
            // ******************************************

            var uri = $"{containerUri}/{policyHolder}-{policyNumber}.pdf{sasToken}";

            using (var client = new HttpClient())
            {
                using (var request = new HttpRequestMessage())
                {
                    request.Method = HttpMethod.Get;
                    request.RequestUri = new Uri(uri);

                    var response = await client.SendAsync(request).ConfigureAwait(false);

                    if (response.IsSuccessStatusCode)
                    {
                        return await response.Content.ReadAsByteArrayAsync();
                    }
                    else
                    {
                        return new byte[] { };
                    }
                }
            }
        }
    }
}
