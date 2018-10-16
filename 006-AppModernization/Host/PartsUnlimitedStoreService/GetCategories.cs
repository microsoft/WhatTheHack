using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.WebJobs.Host;
using System.Data.Entity;
using PartsUnlimited.Models;

namespace PartsUnlimitedStoreService
{
    public static class GetCategories
    {
        [FunctionName("GetCategories")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "categories")]HttpRequestMessage req, TraceWriter log)
        {
            GlobalConfiguration.SetConfiguration(req);

            log.Info("Retrieving Product Categories");

            var db = new PartsUnlimitedContext();
            var categories = await db.Categories.ToListAsync();

            return req.CreateResponse(HttpStatusCode.OK, categories);
        }
    }

}
