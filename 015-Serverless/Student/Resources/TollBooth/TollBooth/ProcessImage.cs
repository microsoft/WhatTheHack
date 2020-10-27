// Default URL for triggering event grid function in the local environment.
// http://localhost:7071/runtime/webhooks/EventGrid?functionName={functionname}

// Learn how to locally debug an Event Grid-triggered function:
//    https://aka.ms/AA30pjh

// Use for local testing:
//   https://{ID}.ngrok.io/runtime/webhooks/EventGrid?functionName=ProcessImage

using System;
using System.IO;
using System.Net.Http;
using System.Net.Mime;
using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Azure.EventGrid.Models;
using Microsoft.Azure.WebJobs.Extensions.EventGrid;
using Microsoft.Extensions.Logging;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using Newtonsoft.Json.Linq;
using TollBooth.Models;

namespace TollBooth
{
    public static class ProcessImage
    {
        private static HttpClient _client;
        private static string GetBlobNameFromUrl(string bloblUrl)
        {
            var uri = new Uri(bloblUrl);
            var cloudBlob = new CloudBlob(uri);
            return cloudBlob.Name;
        }

        [FunctionName("ProcessImage")]
        public static async Task Run([EventGridTrigger]EventGridEvent eventGridEvent,
            [Blob(blobPath: "{data.url}", access: FileAccess.Read,
                Connection = "blobStorageConnection")] Stream incomingPlate,
            ILogger log)
        {
            var licensePlateText = string.Empty;
            // Reuse the HttpClient across calls as much as possible so as not to exhaust all available sockets on the server on which it runs.
            _client = _client ?? new HttpClient();

            try
            {
                if (incomingPlate != null)
                {
                    var createdEvent = ((JObject)eventGridEvent.Data).ToObject<StorageBlobCreatedEventData>();
                    var name = GetBlobNameFromUrl(createdEvent.Url);

                    log.LogInformation($"Processing {name}");

                    byte[] licensePlateImage;
                    // Convert the incoming image stream to a byte array.
                    using (var br = new BinaryReader(incomingPlate))
                    {
                        licensePlateImage = br.ReadBytes((int)incomingPlate.Length);
                    }

                    // TODO 1: Set the licensePlateText value by awaiting a new FindLicensePlateText.GetLicensePlate method.
                    // COMPLETE: licensePlateText = await new.....

                    // Send the details to Event Grid.
                    await new SendToEventGrid(log, _client).SendLicensePlateData(new LicensePlateData()
                    {
                        FileName = name,
                        LicensePlateText = licensePlateText,
                        TimeStamp = DateTime.UtcNow
                    });
                }
            }
            catch (Exception ex)
            {
                log.LogCritical(ex.Message);
                throw;
            }

            log.LogInformation($"Finished processing. Detected the following license plate: {licensePlateText}");
        }
    }
}
