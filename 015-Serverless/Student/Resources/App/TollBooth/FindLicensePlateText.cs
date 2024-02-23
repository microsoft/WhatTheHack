using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Drawing;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;
using TollBooth.Models;
using Polly;
using Polly.CircuitBreaker;
using Polly.Wrap;

namespace TollBooth
{
    public class FindLicensePlateText
    {
        private readonly HttpClient _client;
        private readonly ILogger _log;

        public FindLicensePlateText(ILogger log, HttpClient client)
        {
            _log = log;
            _client = client;
        }

        public async Task<string> GetLicensePlate(byte[] imageBytes)
        {
            return await MakeOCRRequest(imageBytes);
        }

        private async Task<string> MakeOCRRequest(byte[] imageBytes)
        {
            _log.LogInformation("Making OCR request");
            var licensePlate = string.Empty;
            // Request parameters.
            const string requestParameters = "language=unk&detectOrientation=true";
            // Get the API URL and the API key from settings.
            // TODO 2: Populate the below two variables with the correct AppSettings properties.
            var uriBase = Environment.GetEnvironmentVariable("");
            var apiKey = Environment.GetEnvironmentVariable("");

            var resiliencyStrategy = DefineAndRetrieveResiliencyStrategy();

            // Configure the HttpClient request headers.
            _client.DefaultRequestHeaders.Clear();
            _client.DefaultRequestHeaders.Accept.Clear();
            _client.DefaultRequestHeaders.Add("Ocp-Apim-Subscription-Key", apiKey);
            _client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

            // Assemble the URI for the REST API Call.
            var uri = uriBase + "?" + requestParameters;

            try
            {
                // Execute the REST API call, implementing our resiliency strategy.
                HttpResponseMessage response = await resiliencyStrategy.ExecuteAsync(() => _client.PostAsync(uri, GetImageHttpContent(imageBytes)));

                // Get the JSON response.
                var result = await response.Content.ReadAsAsync<OCRResult>();
                licensePlate = GetLicensePlateTextFromResult(result);
            }
            catch (BrokenCircuitException bce)
            {
                _log.LogCritical($"Could not contact the Computer Vision API service due to the following error: {bce.Message}");
            }
            catch (Exception e)
            {
                _log.LogCritical($"Critical error: {e.Message}", e);
            }

            _log.LogInformation($"Finished OCR request. Result: {licensePlate}");

            return licensePlate;
        }

        /// <summary>
        /// Request the ByteArrayContent object through a static method so
        /// it is not disposed when the Polly resiliency policy asynchronously
        /// executes our method that posts the image content to the Computer
        /// Vision API. Otherwise, we'll receive the following error when the
        /// API service is throttled:
        /// System.ObjectDisposedException: Cannot access a disposed object. Object name: 'System.Net.Http.ByteArrayContent'
        /// 
        /// More information can be found on the HttpClient class in the
        /// .NET Core library source code:
        /// https://github.com/dotnet/corefx/blob/6d7fca5aecc135b97aeb3f78938a6afee55b1b5d/src/System.Net.Http/src/System/Net/Http/HttpClient.cs#L500
        /// </summary>
        /// <param name="imageBytes"></param>
        /// <returns></returns>
        private static ByteArrayContent GetImageHttpContent(byte[] imageBytes)
        {
            var content = new ByteArrayContent(imageBytes);

            // Add application/octet-stream header for the content.
            content.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");

            return content;
        }

        /// <summary>
        /// Applies a bit of logic to strip out extraneous text from the OCR
        /// data, like State names and invalid characters.
        /// </summary>
        /// <param name="result">The extracted text.</param>
        /// <returns></returns>
        private static string GetLicensePlateTextFromResult(OCRResult result)
        {
            var text = string.Empty;
            if (result.Regions == null || result.Regions.Length == 0) return string.Empty;

            const string states = "ALABAMA,ALASKA,ARIZONA,ARKANSAS,CALIFORNIA,COLORADO,CONNECTICUT,DELAWARE,FLORIDA,GEORGIA,HAWAII,IDAHO,ILLINOIS,INDIANA,IOWA,KANSAS,KENTUCKY,LOUISIANA,MAINE,MARYLAND,MASSACHUSETTS,MICHIGAN,MINNESOTA,MISSISSIPPI,MISSOURI,MONTANA,NEBRASKA,NEVADA,NEW HAMPSHIRE,NEW JERSEY,NEW MEXICO,NEW YORK,NORTH CAROLINA,NORTH DAKOTA,OHIO,OKLAHOMA,OREGON,PENNSYLVANIA,RHODE ISLAND,SOUTH CAROLINA,SOUTH DAKOTA,TENNESSEE,TEXAS,UTAH,VERMONT,VIRGINIA,WASHINGTON,WEST VIRGINIA,WISCONSIN,WYOMING";
            string[] chars = { ",", ".", "/", "!", "@", "#", "$", "%", "^", "&", "*", "'", "\"", ";", "_", "(", ")", ":", "|", "[", "]" };
            var stateList = states.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

            // We are only interested in the first region found, and only the first two lines within the region.
            foreach (var line in result.Regions[0].Lines.Take(2))
            {
                // Exclude the state name.
                if (stateList.Contains(line.Words[0].Text.ToUpper())) continue;
                foreach (var word in line.Words)
                {
                    if (!string.IsNullOrWhiteSpace(word.Text))
                        text += (RemoveSpecialCharacters(word.Text)) + " "; // Spaces are valid in a license plate.
                }
            }

            return text.ToUpper().Trim();
        }

        /// <summary>
        /// Fast method to remove invalid special characters from the
        /// license plate text.
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        private static string RemoveSpecialCharacters(string str)
        {
            var buffer = new char[str.Length];
            int idx = 0;

            foreach (var c in str)
            {
                if ((c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z')
                    || (c >= 'a' && c <= 'z') || (c == '-'))
                {
                    buffer[idx] = c;
                    idx++;
                }
            }

            return new string(buffer, 0, idx);
        }

        /// <summary>
        /// Creates a Polly-based resiliency strategy that does the following when communicating
        /// with the external (downstream) Computer Vision API service:
        /// 
        /// If requests to the service are being throttled, as indicated by 429 or 503 responses,
        /// wait and try again in a bit by exponentially backing off each time. This should give the service
        /// enough time to recover or allow enough time to pass that removes the throttling restriction.
        /// This is implemented through the WaitAndRetry policy named 'waitAndRetryPolicy'.
        /// 
        /// Alternately, if requests to the service result in an HttpResponseException, or a number of
        /// status codes worth retrying (such as 500, 502, or 504), break the circuit to block any more
        /// requests for the specified period of time, send a test request to see if the error is still
        /// occurring, then reset the circuit once successful.
        /// 
        /// These policies are executed through a PolicyWrap, which combines these into a resiliency
        /// strategy. For more information, see: https://github.com/App-vNext/Polly/wiki/PolicyWrap
        /// 
        /// NOTE: A longer-term resiliency strategy would have us share the circuit breaker state across
        /// instances, ensuring subsequent calls to the struggling downstream service from new instances
        /// adhere to the circuit state, allowing that service to recover. This could possibly be handled
        /// by a Distributed Circuit Breaker (https://github.com/App-vNext/Polly/issues/287) in the future,
        /// or perhaps by using Durable Functions that can hold the state.
        /// </summary>
        /// <returns></returns>
        private AsyncPolicyWrap<HttpResponseMessage> DefineAndRetrieveResiliencyStrategy()
        {
            // Retry when these status codes are encountered.
            HttpStatusCode[] httpStatusCodesWorthRetrying = {
               HttpStatusCode.InternalServerError, // 500
               HttpStatusCode.BadGateway, // 502
               HttpStatusCode.GatewayTimeout // 504
            };

            // Immediately fail (fail fast) when these status codes are encountered.
            HttpStatusCode[] httpStatusCodesToImmediatelyFail = {
               HttpStatusCode.BadRequest, // 400
               HttpStatusCode.Unauthorized, // 401
               HttpStatusCode.Forbidden // 403
            };

            // Define our waitAndRetry policy: retry n times with an exponential backoff in case the Computer Vision API throttles us for too many requests.
            var waitAndRetryPolicy = Policy
                .Handle<HttpRequestException>()
                .OrResult<HttpResponseMessage>(e => e.StatusCode == HttpStatusCode.ServiceUnavailable ||
                    e.StatusCode == (System.Net.HttpStatusCode)429 || e.StatusCode == (System.Net.HttpStatusCode)403)
                .WaitAndRetryAsync(10, // Retry 10 times with a delay between retries before ultimately giving up
                    attempt => TimeSpan.FromSeconds(0.25 * Math.Pow(2, attempt)), // Back off!  2, 4, 8, 16 etc times 1/4-second
                                                                                  //attempt => TimeSpan.FromSeconds(6), // Wait 6 seconds between retries
                    (exception, calculatedWaitDuration) =>
                    {
                        _log.LogWarning($"Computer Vision API server is throttling our requests. Automatically delaying for {calculatedWaitDuration.TotalMilliseconds}ms");
                    }
                );

            // Define our first CircuitBreaker policy: Break if the action fails 4 times in a row.
            // This is designed to handle Exceptions from the Computer Vision API, as well as
            // a number of recoverable status messages, such as 500, 502, and 504.
            var circuitBreakerPolicyForRecoverable = Policy
                .Handle<HttpResponseException>()
                .OrResult<HttpResponseMessage>(r => httpStatusCodesWorthRetrying.Contains(r.StatusCode))
                .CircuitBreakerAsync(
                    handledEventsAllowedBeforeBreaking: 3,
                    durationOfBreak: TimeSpan.FromSeconds(3),
                    onBreak: (outcome, breakDelay) =>
                    {
                        _log.LogWarning($"Polly Circuit Breaker logging: Breaking the circuit for {breakDelay.TotalMilliseconds}ms due to: {outcome.Exception?.Message ?? outcome.Result.StatusCode.ToString()}");
                    },
                    onReset: () => _log.LogInformation("Polly Circuit Breaker logging: Call ok... closed the circuit again"),
                    onHalfOpen: () => _log.LogInformation("Polly Circuit Breaker logging: Half-open: Next call is a trial")
                );

            // Combine the waitAndRetryPolicy and circuit breaker policy into a PolicyWrap. This defines our resiliency strategy.
            return Policy.WrapAsync(waitAndRetryPolicy, circuitBreakerPolicyForRecoverable);
        }
    }
}
