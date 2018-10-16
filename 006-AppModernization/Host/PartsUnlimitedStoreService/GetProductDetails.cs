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

    public static class GetProductDetails
    {
        [FunctionName("GetProductDetails")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "product/{id:int}")]HttpRequestMessage req, int? id, TraceWriter log)
        {
            GlobalConfiguration.SetConfiguration(req);

            log.Info($"GetProductDetails {id}");

            if (!id.HasValue)
                return req.CreateResponse(HttpStatusCode.BadRequest, "Please pass a valid product id");

            var db = new PartsUnlimitedContext();
            var product = await db.Products.SingleAsync(a => a.ProductId == id.Value);

            return req.CreateResponse(HttpStatusCode.OK, product);
        }
    }

}
