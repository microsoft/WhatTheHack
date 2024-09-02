using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;

namespace TollBooth
{
    public class ExportLicensePlates
    {
        private readonly ILogger log;

        public ExportLicensePlates(ILogger<ExportLicensePlates> logger)
        {
            log = logger;
        }

        [Function("ExportLicensePlates")]
        public async Task<HttpResponseData> Run([HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequestData req)
        {
            int exportedCount = 0;
            log.LogInformation("Finding license plate data to export");

            var databaseMethods = new DatabaseMethods(log);
            var licensePlates = databaseMethods.GetLicensePlatesToExport();
            if (licensePlates.Any())
            {
                log.LogInformation($"Retrieved {licensePlates.Count} license plates");
                var fileMethods = new FileMethods(log);
                var uploaded = await fileMethods.GenerateAndSaveCsv(licensePlates);
                if (uploaded)
                {
                    await databaseMethods.MarkLicensePlatesAsExported(licensePlates);
                    exportedCount = licensePlates.Count;
                    log.LogInformation("Finished updating the license plates");
                }
                else
                {
                    log.LogInformation("Export file could not be uploaded. Skipping database update that marks the documents as exported.");
                }

                log.LogInformation($"Exported {exportedCount} license plates");
            }
            else
            {
                log.LogWarning("No license plates to export");
            }

            if (exportedCount == 0) {
                var response = req.CreateResponse(HttpStatusCode.NoContent);
                response.WriteString("No license plates to export");
                return response;
            }
            else {
                var response = req.CreateResponse(HttpStatusCode.OK);
                response.WriteString($"Exported {exportedCount} license plates");
                return response;
            }
        }
    }
}
