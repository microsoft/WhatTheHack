## 2_ImageProcessor
Estimated Time: 30-45 minutes

## Cognitive Services

Cognitive Services can be used to infuse your apps, websites and bots with algorithms to see, hear, speak, understand, and interpret your user needs through natural methods of communication. 

There are five main categories for the available Cognitive Services:
- **Vision**: Image-processing algorithms to identify, caption and moderate your pictures
- **Knowledge**: Map complex information and data in order to solve tasks such as intelligent recommendations and semantic search
- **Language**: Allow your apps to process natural language with pre-built scripts, evaluate sentiment and learn how to recognize what users want
- **Speech**: Convert spoken audio into text, use voice for verification, or add speaker recognition to your app
- **Search**: Add Bing Search APIs to your apps and harness the ability to comb billions of webpages, images, videos, and news with a single API call

You can browse all of the specific APIs in the [Services Directory](https://azure.microsoft.com/en-us/services/cognitive-services/directory/). 

As you may recall, the application we'll be building today will use [Computer Vision](https://www.microsoft.com/cognitive-services/en-us/computer-vision-api) to grab tags and a description.

Let's talk about how we're going to call  Cognitive Services in our application.

### **Image Processing Library** ###

Under resources>code>Starting-ImageProcessing, you'll find the `Processing Library`. This is a [Portable Class Library (PCL)](https://docs.microsoft.com/en-us/dotnet/standard/cross-platform/cross-platform-development-with-the-portable-class-library), which helps in building cross-platform apps and libraries quickly and easily. It serves as a wrapper around several services. This specific PCL contains some helper classes (in the ServiceHelpers folder) for accessing the Computer Vision API and an "ImageInsights" class to encapsulate the results. Later, we'll create an image processor class that will be responsible for wrapping an image and exposing several methods and properties that act as a bridge to the Cognitive Services. 

![Processing Library PCL](./resources/assets/ProcessingLibrary.png)

After creating the image processor (in Lab 2.1), you should be able to pick up this portable class library and drop it in your other projects that involve Cognitive Services (some modification will be required depending on which Cognitive Services you want to use). 


**ProcessingLibrary: Service Helpers**

Service helpers can be used to make your life easier when you're developing your app. One of the key things that service helpers do is provide the ability to detect when the API calls return a call-rate-exceeded error and automatically retry the call (after some delay). They also help with bringing in methods, handling exceptions, and handling the keys.

You can find additional service helpers for some of the other Cognitive Services within the [Intelligent Kiosk sample application](https://github.com/Microsoft/Cognitive-Samples-IntelligentKiosk/tree/master/Kiosk/ServiceHelpers). Utilizing these resources makes it easy to add and remove the service helpers in your future projects as needed.


**ProcessingLibrary: The "ImageInsights" class**

Take a look at the "ImageInsights" class. You can see that we're calling for `Caption` and `Tags` from the images, as well as a unique `ImageId`. "ImageInsights" pieces only the information we want together from the Computer Vision API (or from Cognitive Services, if we choose to call multiple).

Now let's take a step back for a minute. It isn't quite as simple as creating the "ImageInsights" class and copying over some methods/error handling from service helpers. We still have to call the API and process the images somewhere. For the purpose of this lab, we are going to walk through creating `ImageProcessor.cs`, but in future projects, feel free to add this class to your PCL and start from there (it will need modification depending what Cognitive Services you are calling and what you are processing - images, text, voice, etc.).



### Lab 2.1: Creating `ImageProcessor.cs`


Right-click on the solution and select "Build Solution". If you have errors related to `ImageProcessor.cs`, you can ignore them for now, because we are about to address them.

Navigate to `ImageProcessor.cs` within `ProcessingLibrary`. 

**Step 1**: Add the following [`using` directives](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/keywords/using-directive) **to the top** of the class, above the namespace:

```
using System;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.ProjectOxford.Vision;
using ServiceHelpers;
```

[Project Oxford](https://blogs.technet.microsoft.com/machinelearning/tag/project-oxford/) was the project where many Cognitive Services got their start. As you can see, the NuGet Packages were even labeled under Project Oxford. In this scenario, we'll call `Microsoft.ProjectOxford.Vision` for the Computer Vision API. Additionally, we'll reference our service helpers (remember, these will make our lives easier). You'll have to reference different packages depending on which Cognitive Services you're leveraging in your application.

**Step 2**: In `ImageProcessor.cs` we will start by creating a method we will use to process the image, `ProcessImageAsync`. Paste the following code within the `ImageProcessor` class (between the `{ }`):

```
public static async Task<ImageInsights> ProcessImageAsync(Func<Task<Stream>> imageStreamCallback, string imageId)
        {

        
```
> Hint: Visual Studio will throw an error, due to the open bracket. Add what is necessary to the end of the method. Ask a neighbor if you need help.  

In the above code, we use `Func<Task<Stream>>` because we want to make sure we can process the image multiple times (once for each service that needs it), so we have a Func that can hand us back a way to get the stream. Since getting a stream is usually an async operation, rather than the Func handing back the stream itself, it hands back a task that allows us to do so in an async fashion.
  
**Step 3**: In `ImageProcessor.cs`, within the `ProcessImageAsync` method, we're going to set up a [static array](https://stackoverflow.com/questions/4594850/definition-of-static-arrays) that we'll fill in throughout the processor. As you can see, these are the main attributes we want to call for `ImageInsights.cs`. Add the code below between the `{ }` of `ProcessImageAsync`:

```
VisualFeature[] DefaultVisualFeaturesList = new VisualFeature[] { VisualFeature.Tags, VisualFeature.Description };
```

**Step 4**: Next, we want to call the Cognitive Service (specifically Computer Vision) and put the results in `imageAnalysisResult`. Use the code below to call the Computer Vision API (with the help of `VisionServiceHelper.cs`) and store the results in `imageAnalysisResult`. Near the bottom of `VisionServiceHelper.cs`, you will want to review the available methods for you to call (`RunTaskWithAutoRetryOnQuotaLimitExceededError`, `DescribeAsync`, `AnalyzeImageAsync`, `RecognizeTextAsyncYou`). Replace the "_" with the method you need to call in order to return the visual features.

```
var imageAnalysisResult = await VisionServiceHelper._(imageStreamCallback, DefaultVisualFeaturesList);
```
**Step 5**: Now that we've called the Computer Vision service, we want to create an entry in "ImageInsights" with only the following results: ImageId, Caption, and Tags (you can confirm this by revisiting `ImageInsights.cs`). Paste the following code below `var imageAnalysisResult` and try to fill in the code for `ImageId`, `Caption`, and `Tags`:


```
            ImageInsights result = new ImageInsights
            {
                ImageId = ,
                Caption = ,
                Tags = 
            };
```
Depending on your C# dev background, this may not be an easy task. Here are some hints:

1.  When you defined the method, you specified a result. This should help you determine what ImageId is (it's actually really simple).
2.  For Caption and Tags, start with `imageAnalysisResult.`. When you put the `.`, you're able to use the dropdown menu to help.
3.  For Caption, you have to specify that you want only the first caption by using `[0]`.
4.  For Tags, you have to put the tags into an array with `Select(t => t.Name).ToArray()`.

  
Still stuck? You can take a peek at the solution at [resources>code>Finished-ImageProcessing>ProcessingLibrary>ImageProcessor.cs](./resources/code/Finished-ImageProcessing/ProcessingLibrary/ImageProcessor.cs) 

So now we have the caption and tags that we need from the Computer Vision API, and each image's result (with imageId) is stored in "ImageInsights".

**Step 6**: Lastly, we need to close out the method by adding the following line to the end of the method:
```
return result;
```

Now that you've built `ImageProcessor.cs`, don't forget to save it! 

Want to make sure you set up `ImageProcessor.cs` correctly? You can find the full class [here](./resources/code/Finished-ImageProcessing/ProcessingLibrary/ImageProcessor.cs).


### Continue to [3_TestCLI](./3_TestCLI.md)



Back to [README](./0_README.md)
