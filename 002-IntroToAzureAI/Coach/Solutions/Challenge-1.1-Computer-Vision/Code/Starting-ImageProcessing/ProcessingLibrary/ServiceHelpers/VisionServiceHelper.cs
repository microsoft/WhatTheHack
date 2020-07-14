using Microsoft.ProjectOxford.Vision;
using Microsoft.ProjectOxford.Vision.Contract;
using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;

namespace ServiceHelpers
{
    public static class VisionServiceHelper
    {
        public static int RetryCountOnQuotaLimitError = 6;
        public static int RetryDelayOnQuotaLimitError = 500;

        private static VisionServiceClient visionClient { get; set; }

        static VisionServiceHelper()
        {
            InitializeVisionService();
        }

        public static Action Throttled;

        private static string apiKey;
        public static string ApiKey
        {
            get
            {
                return apiKey;
            }

            set
            {
                var changed = apiKey != value;
                apiKey = value;
                if (changed)
                {
                    InitializeVisionService();
                }
            }
        }

        private static void InitializeVisionService()
        {
            visionClient = new VisionServiceClient(apiKey);
        }

        // handle throttling issues
        private static async Task<TResponse> RunTaskWithAutoRetryOnQuotaLimitExceededError<TResponse>(Func<Task<TResponse>> action)
        {
            int retriesLeft = VisionServiceHelper.RetryCountOnQuotaLimitError;
            int delay = VisionServiceHelper.RetryDelayOnQuotaLimitError;

            TResponse response = default(TResponse);

            while (true)
            {
                try
                {
                    response = await action();
                    break;
                }
                catch (Microsoft.ProjectOxford.Vision.ClientException exception) when (exception.HttpStatus == (System.Net.HttpStatusCode)429 && retriesLeft > 0)
                {
                    ErrorTrackingHelper.TrackException(exception, "Vision API throttling error");
                    if (retriesLeft == 1 && Throttled != null)
                    {
                        Throttled();
                    }

                    await Task.Delay(delay);
                    retriesLeft--;
                    delay *= 2;
                    continue;
                }
            }

            return response;
        }

        // Pull in the methods to call
        private static async Task RunTaskWithAutoRetryOnQuotaLimitExceededError(Func<Task> action)
        {
            await RunTaskWithAutoRetryOnQuotaLimitExceededError<object>(async () => { await action(); return null; } );
        }

        public static async Task<AnalysisResult> DescribeAsync(Func<Task<Stream>> imageStreamCallback)
        {
            return await RunTaskWithAutoRetryOnQuotaLimitExceededError<AnalysisResult>(async () => await visionClient.DescribeAsync(await imageStreamCallback()));
        }

        public static async Task<AnalysisResult> AnalyzeImageAsync(string imageUrl, IEnumerable<VisualFeature> visualFeatures = null, IEnumerable<string> details = null)
        {
            return await RunTaskWithAutoRetryOnQuotaLimitExceededError<AnalysisResult>(() => visionClient.AnalyzeImageAsync(imageUrl, visualFeatures, details));
        }

        public static async Task<AnalysisResult> AnalyzeImageAsync(Func<Task<Stream>> imageStreamCallback, IEnumerable<VisualFeature> visualFeatures = null, IEnumerable<string> details = null)
        {
            return await RunTaskWithAutoRetryOnQuotaLimitExceededError<AnalysisResult>(async () => await visionClient.AnalyzeImageAsync(await imageStreamCallback(), visualFeatures, details ));
        }

        public static async Task<AnalysisResult> DescribeAsync(string imageUrl)
        {
            return await RunTaskWithAutoRetryOnQuotaLimitExceededError<AnalysisResult>(() => visionClient.DescribeAsync(imageUrl));
        }

        public static async Task<OcrResults> RecognizeTextAsync(string imageUrl)
        {
            return await RunTaskWithAutoRetryOnQuotaLimitExceededError<OcrResults>(() => visionClient.RecognizeTextAsync(imageUrl));
        }

        public static async Task<OcrResults> RecognizeTextAsync(Func<Task<Stream>> imageStreamCallback)
        {
            return await RunTaskWithAutoRetryOnQuotaLimitExceededError<OcrResults>(async () => await visionClient.RecognizeTextAsync(await imageStreamCallback()));
        }
    }
}
