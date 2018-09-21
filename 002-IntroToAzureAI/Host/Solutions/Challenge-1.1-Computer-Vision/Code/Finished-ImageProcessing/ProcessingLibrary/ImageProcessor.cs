// Below each "Step" there is code that should be entered
// Corresponds to the Steps in the instructions for 2_ImageProcessor.md
// Step 1: Add the using directives below:
using System;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.ProjectOxford.Vision;
using ServiceHelpers;

// Specify the namespace
namespace ProcessingLibrary
{
    // Specify the class
    public class ImageProcessor
    {
        // Step 2: Create the ProcessImageAsync method:
        public static async Task<ImageInsights> ProcessImageAsync(Func<Task<Stream>> imageStreamCallback, string imageId)
        {
            // Step 3: Set up an array that we'll fill in over the course of the processor:
            VisualFeature[] DefaultVisualFeaturesList = new VisualFeature[] { VisualFeature.Tags, VisualFeature.Description };

            // Step 4: Call the Computer Vision service and store the results in imageAnalysisResult:
            var imageAnalysisResult = await VisionServiceHelper.AnalyzeImageAsync(imageStreamCallback, DefaultVisualFeaturesList);

            // Step 5: Create an entry in ImageInsights:
            ImageInsights result = new ImageInsights
            {
                ImageId = imageId,
                Caption = imageAnalysisResult.Description.Captions[0].Text,
                Tags = imageAnalysisResult.Tags.Select(t => t.Name).ToArray()
            };

            // Step 6: Return results:
            return result;
        }

    }

}