using Azure.Core;
using Azure.Identity;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Net.Http.Headers;
using System.Text;
using WTHAzureCosmosDB.Web.Pages;

namespace WTHAzureCosmosDB.Web.Helpers
{
    public class AzureLoadTestingRunHelper
    {
        private HttpClient _httpClient;

        public AzureLoadTestingRunHelper()
        {

            _httpClient = new HttpClient();
        }

        public async Task<AccessToken> GetDefaultAzureTokenAsync(string managedIdentityClientId, string url)
        {


            var credential = new DefaultAzureCredential(
                new DefaultAzureCredentialOptions()
                {
                    ManagedIdentityClientId = managedIdentityClientId,

                }); ;
            var token = await credential.GetTokenAsync(
                new Azure.Core.TokenRequestContext(
                    new[] { url }));

            return token;

        }


        public async Task<HttpResponseMessage> CreateNewTestRunAsync(string altDataPlaneEndpoint, string testId, string accessToken, IDictionary<string, string> envVariables, IDictionary<string, string> secrets, string displayName, string description, Guid? newTestRunId = null)
        {
            if (newTestRunId == null)
            {
                newTestRunId = Guid.NewGuid();
            }


            var requestBody = new
            {
                testId = testId,
                displayName = displayName,
                description = description,
                secrets = secrets,
                environmentVariables = envVariables,

            };
            var json = JsonConvert.SerializeObject(requestBody);


            _httpClient.DefaultRequestHeaders.Clear();

            _httpClient.DefaultRequestHeaders.Add("Authorization", "Bearer " + accessToken);
            _httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));


            var url = $"{altDataPlaneEndpoint}/testruns/{newTestRunId.ToString()}?api-version=2022-11-01";

            var obj = JsonConvert.DeserializeObject(json);

            //var content = new StringContent(json, Encoding.UTF8, "application/json");

            StringContent content = new StringContent(json, System.Text.Encoding.UTF8);
            MediaTypeHeaderValue mValue = new MediaTypeHeaderValue("application/merge-patch+json");
            content.Headers.ContentType = mValue;

            var response = await _httpClient.PatchAsync(url, content);

            return response;
        }

        public async Task<string> GetLastTestRunStatusAsync(string altDataPlaneEndpoint, string testRunId, string accessToken)
        {
            //get info about test
            var url = $"{altDataPlaneEndpoint}/testruns/{testRunId}?api-version=2022-11-01";

            _httpClient.DefaultRequestHeaders.Clear();

            _httpClient.DefaultRequestHeaders.Add("Authorization", "Bearer " + accessToken);
            _httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

            var response = await _httpClient.GetAsync(url);

            return await response.Content.ReadAsStringAsync();

        }
    }
}
