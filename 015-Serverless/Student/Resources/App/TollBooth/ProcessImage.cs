// Default URL for triggering event grid function in the local environment.
// http://localhost:7071/runtime/webhooks/EventGrid?functionName={functionname}

// Learn how to locally debug an Event Grid-triggered function:
//    https://aka.ms/AA30pjh

// Use for local testing:
//   https://{ID}.ngrok.io/runtime/webhooks/EventGrid?functionName=ProcessImage

using System;
using System.IO;
using System.Net.Http;
using System.Threading.Tasks;
using Azure.Messaging.EventGrid;
using Azure.Messaging.EventGrid.SystemEvents;
using Microsoft.Extensions.Logging;
using TollBooth.Models;
using Microsoft.Azure.Functions.Worker;
using System.Linq;

namespace TollBooth
{
    public class ProcessImage
    {
        private readonly ILogger log;

        public ProcessImage(ILogger<ProcessImage> logger)
        {
            log = logger;
        }

        private static HttpClient _client;
        private static string GetBlobNameFromUrl(string bloblUrl)
        {
            var uri = new Uri(bloblUrl);
            //return uri.Segments.Last();
            return uri.LocalPath;
        }

        // Reference https://github.com/Azure/azure-functions-dotnet-worker/blob/main/samples/Extensions/Blob/BlobInputBindingSamples.cs
        [Function("ProcessImage")]
        public async Task Run([EventGridTrigger] EventGridEvent eventGridEvent, [BlobInput(blobPath: "{data.url}",
                Connection = "blobStorageConnection")] Stream incomingPlate)
        {
            var licensePlateText = string.Empty;
            // Reuse the HttpClient across calls as much as possible so as not to exhaust all available sockets on the server on which it runs.
            _client = _client ?? new HttpClient();

            try
            {
                if (incomingPlate != null)
                {
                    var createdEvent = eventGridEvent.Data.ToObjectFromJson<StorageBlobCreatedEventData>();
                    var name = GetBlobNameFromUrl(createdEvent.Url);
                    log.LogInformation($"Processing {name}");

                    byte[] licensePlateImage;
                    // Convert the incoming image stream to a byte array.
                    using (var br = new BinaryReader(incomingPlate))
                    {
                        licensePlateImage = br.ReadBytes((int)incomingPlate.Length);
                    }

                    // TODO 1: Set the licensePlateText value by awaiting a new FindLicensePlateText.GetLicensePlate method.
                    // licensePlateText = await new ...

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
