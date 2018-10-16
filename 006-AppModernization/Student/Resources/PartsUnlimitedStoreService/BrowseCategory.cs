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
    public static class BrowseCategory
    {
        [FunctionName("BrowseCategory")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "categories/{id:int}")]HttpRequestMessage req, int? id, TraceWriter log)
        {
            GlobalConfiguration.SetConfiguration(req);

            log.Info($"Get Product Category {id}");

            if (!id.HasValue)
                return req.CreateResponse(HttpStatusCode.BadRequest, "Please pass a valid category ID");

            var db = new PartsUnlimitedContext();
            var genreModel = await db.Categories.Include("Products").SingleAsync(g => g.CategoryId == id.Value);

            return req.CreateResponse(HttpStatusCode.OK, genreModel);
        }
    }

}
