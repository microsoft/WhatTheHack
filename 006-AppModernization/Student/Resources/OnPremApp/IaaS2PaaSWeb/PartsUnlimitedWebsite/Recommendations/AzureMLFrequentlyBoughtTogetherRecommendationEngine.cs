using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using Newtonsoft.Json;
using PartsUnlimited.Utils;

namespace PartsUnlimited.Recommendations
{
    /// <summary>
    /// This class implements Azure ML Frequently Bought Together recommendation engine
    /// Details can be found at https://datamarket.azure.com/dataset/amla/mba
    /// </summary>
    public class AzureMLFrequentlyBoughtTogetherRecommendationEngine : IRecommendationEngine
    {
        private readonly IHttpClient client;
        private readonly ITelemetryProvider telemetry;

        private class AzureMLFrequentlyBoughtTogetherServiceResponse
        {
            public List<string> ItemSet { get; set; }
            public int Value { get; set; }
        }

        public AzureMLFrequentlyBoughtTogetherRecommendationEngine(IHttpClient httpClient, ITelemetryProvider telemetryProvider)
        {
            client = httpClient;
            telemetry = telemetryProvider;
        }

        public async Task<IEnumerable<string>> GetRecommendationsAsync(string productId)
        {
            string modelName = ConfigurationHelpers.GetString("MachineLearning.ModelName");
            //The Azure ML service takes in a recommendation model name (trained ahead of time) and a product id
            string uri = string.Format("https://api.datamarket.azure.com/data.ashx/amla/mba/v1/Score?Id=%27{0}%27&Item=%27{1}%27", modelName, productId);

            try
            {
                //The Azure ML service returns a set of numbers, which indicate the recommended product id
                var response = await client.GetStringAsync(uri);
                AzureMLFrequentlyBoughtTogetherServiceResponse deserializedResponse = JsonConvert.DeserializeObject<AzureMLFrequentlyBoughtTogetherServiceResponse>(response);
                //When there is no recommendation, The Azure ML service returns a JSON object that does not contain ItemSet
                var recommendation = deserializedResponse.ItemSet;
                if (recommendation == null)
                {
                    return Enumerable.Empty<string>();
                }
                else
                {
                    return recommendation;
                }
            }
            catch (HttpRequestException e)
            {
                telemetry.TrackException(e);

                return Enumerable.Empty<string>();
            }
        }
    }
}