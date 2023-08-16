using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System.Net.Http.Headers;
using System.Net.Http;
using System.Xml.Linq;
using Microsoft.Extensions.Primitives;

namespace WTHAzureCosmosDB.ProxyFuncApp
{
    public static class ProxyAltRequest
    {

        private static HttpClient _httpClient;

        static ProxyAltRequest()
        {

            _httpClient = new HttpClient();
        }

        public static async Task<string> GetLastTestRunStatusAsync(string altDataPlaneEndpoint, string testRunId, string accessToken)
        {
            //get info about test
            var url = $"{altDataPlaneEndpoint}/test-runs/{testRunId}?api-version=2022-11-01";
            _httpClient.DefaultRequestHeaders.Clear();

            _httpClient.DefaultRequestHeaders.Add("Authorization", "Bearer " + accessToken);
            _httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

            var response = await _httpClient.GetAsync(url);

            return await response.Content.ReadAsStringAsync();

        }

        [FunctionName("ProxyAltRequest")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            StringValues altDataPlaneEndpoint = "", testRunId = "", accessToken = "";

            var data = await req.ReadFormAsync();

            data.TryGetValue("altDataPlaneEndpoint", out altDataPlaneEndpoint);
            data.TryGetValue("testRunId", out testRunId);
            data.TryGetValue("accessToken", out accessToken);
            

            var response = await GetLastTestRunStatusAsync(altDataPlaneEndpoint[0], testRunId[0], accessToken[0]);

            return new OkObjectResult(response);
        }
    }
}
