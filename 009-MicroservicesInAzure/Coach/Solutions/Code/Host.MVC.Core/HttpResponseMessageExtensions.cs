using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;

namespace ContosoTravel.Web.Host.MVC.Core
{
    public static class HttpResponseMessageExtension
    {
        public static async Task<T> ContentReadAs<T>(this HttpResponseMessage httpResponse, ILogger logger)
        {
            if (httpResponse.IsSuccessStatusCode)
            {
                return Newtonsoft.Json.JsonConvert.DeserializeObject<T>(await httpResponse.Content.ReadAsStringAsync());
            }
            else
            {
                logger.LogError($"Failed Http Call: Status {httpResponse.StatusCode.ToString()}:{((int)httpResponse.StatusCode)} - Message {await httpResponse.Content?.ReadAsStringAsync() ?? ""}");
                httpResponse.EnsureSuccessStatusCode();
                return default;
            }
        }
    }

    public static class HttpClientExtension
    {
        public static async Task<T> GetAsyncAs<T>(this HttpClient httpClient, string uri, CancellationToken cancellationToken, ILogger logger)
        {
            logger.LogInformation($"GET to {httpClient.BaseAddress}/{uri}");
            var httpResponse = await httpClient.GetAsync(uri, cancellationToken);
            return await httpResponse.ContentReadAs<T>(logger);
        }

        public static async Task<T> PostAsyncAs<T>(this HttpClient httpClient, string uri, HttpContent content, CancellationToken cancellationToken, ILogger logger)
        {
            logger.LogInformation($"POST to {httpClient.BaseAddress}/{uri}");
            var httpResponse = await httpClient.PostAsync(uri, content, cancellationToken);
            return await httpResponse.ContentReadAs<T>(logger);
        }

        public static async Task<T> PutAsyncAs<T>(this HttpClient httpClient, string uri, HttpContent content, CancellationToken cancellationToken, ILogger logger)
        {
            logger.LogInformation($"PUT to {httpClient.BaseAddress}/{uri}");
            var httpResponse = await httpClient.PutAsync(uri, content, cancellationToken);
            return await httpResponse.ContentReadAs<T>(logger);
        }
    }
}
