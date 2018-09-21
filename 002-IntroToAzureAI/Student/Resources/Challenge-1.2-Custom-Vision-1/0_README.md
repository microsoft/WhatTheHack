**Custom Vision API C\# Tutorial**
==================================

The goal of this tutorial is to explore a basic Windows application that uses
the Custom Vision API to create a project, add tags to it, upload images,
train the project, obtain the default prediction endpoint URL for the project,
and use the endpoint to programmatically test an image. You can use this open
source example as a template for building your own app for Windows using the
Custom Vision API.  

**Prerequisites**
-----------------

 

### Platform requirements

This example has been tested using the .NET Framework using [Visual Studio 2017,
Community Edition](https://www.visualstudio.com/downloads/)



### The Training API key

You also need to have a training API key. The training API key allows you to
create, manage, and train Custom Vision projects programatically. All operations
on <https://customvision.ai> are exposed through this library, allowing you to
automate all aspects of the Custom Vision Service. You can obtain a key by
creating a new project at <https://customvision.ai> and then clicking on the
"setting" gear in the top right.

> Note: Internet Explorer is not supported. We recommend using Edge, Firefox, or Chrome.

### The Images used for Training and Predicting

In the Resources\Images folder are three folders:

- Hemlock
- Japanese Cherry
- Test

The Hemlock and Japenese Cherry folders contain images of these types of plants that
will be trained and tagged. The Test folder contains an image that will be used to 
perform the test prediction


**Lab: Creating a Custom Vision Application**
---------------------------------------------

### Step 1: Create a console application and prepare the training key and the images needed for the example.

 

Start Visual Studio 2017, Community Edition, open the Visual Studio solution
named **CustomVision.Sample.sln** in the sub-directory of where this lab is
located:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Resources/Starter/CustomVision.Sample/CustomVision.Sample.sln
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This code defines and calls two helper methods. The method called
`GetTrainingKey` prepares the training key. The one called `LoadImagesFromDisk`
loads two sets of images that this example uses to train the project, and one
test image that the example loads to demonstrate the use of the default
prediction endpoint. On opening the project the following code should be
displayed from line 35:

 

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading;
using Microsoft.Cognitive.CustomVision;

namespace CustomVision.Sample
{
    class Program
    {
        private static List<MemoryStream> hemlockImages;

        private static List<MemoryStream> japaneseCherryImages;

        private static MemoryStream testImage;

        static void Main(string[] args)
        {
            // You can either add your training key here, pass it on the command line, or type it in when the program runs
            string trainingKey = GetTrainingKey("<your key here>", args);

            // Create the Api, passing in a credentials object that contains the training key
            TrainingApiCredentials trainingCredentials = new TrainingApiCredentials(trainingKey);
            TrainingApi trainingApi = new TrainingApi(trainingCredentials);


        }


        private static string GetTrainingKey(string trainingKey, string[] args)
        {
            if (string.IsNullOrWhiteSpace(trainingKey) || trainingKey.Equals("<your key here>"))
            {
                if (args.Length >= 1)
                {
                    trainingKey = args[0];
                }

                while (string.IsNullOrWhiteSpace(trainingKey) || trainingKey.Length != 32)
                {
                    Console.Write("Enter your training key: ");
                    trainingKey = Console.ReadLine();
                }
                Console.WriteLine();
            }

            return trainingKey;
        }

        private static string GetPredictionKey(string predictionKey, string[] args)
        {
            if (string.IsNullOrWhiteSpace(predictionKey) || predictionKey.Equals("<your key here>"))
            {
                if (args.Length >= 1)
                {
                    predictionKey = args[0];
                }

                while (string.IsNullOrWhiteSpace(predictionKey) || predictionKey.Length != 32)
                {
                    Console.Write("Enter your prediction key: ");
                    predictionKey = Console.ReadLine();
                }
                Console.WriteLine();
            }

            return predictionKey;
        }

        private static void LoadImagesFromDisk()
        {
            // this loads the images to be uploaded from disk into memory
            hemlockImages = Directory.GetFiles(@"..\..\..\..\Images\Hemlock").Select(f => new MemoryStream(File.ReadAllBytes(f))).ToList();
            japaneseCherryImages = Directory.GetFiles(@"..\..\..\..\Images\Japanese Cherry").Select(f => new MemoryStream(File.ReadAllBytes(f))).ToList();
            testImage = new MemoryStream(File.ReadAllBytes(@"..\..\..\..\Images\Test\test_image.jpg"));

        }
    }
}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

### Step 2: Create a Custom Vision Service project

To create a new Custom Vision Service project, add the following code in the
body of the `Main()` method after the call to `new TrainingApi().`

 

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Create a new project
Console.WriteLine("Creating new project:");
var project = trainingApi.CreateProject("My New Project");
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

### Step 3: Add tags to your project

To add tags to your project, insert the following code after the call to
`CreateProject("My New Project");`.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Make two tags in the new project
var hemlockTag = trainingApi.CreateTag(project.Id, "Hemlock");
var japaneseCherryTag = trainingApi.CreateTag(project.Id, "Japanese Cherry");
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

### Step 4: Upload images to the project

To add the images we have in memory to the project, insert the following code
after the call to `CreateTag(project.Id, "Japanese Cherry")` method.

 

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Add some images to the tags
Console.WriteLine("\tUploading images");
LoadImagesFromDisk();

// Images can be uploaded one at a time
foreach (var image in hemlockImages)
{
   trainingApi.CreateImagesFromData(project.Id, image, new List<string>() { hemlockTag.Id.ToString() });
}

// Or uploaded in a single batch 
trainingApi.CreateImagesFromData(project.Id, japaneseCherryImages, new List<Guid>() { japaneseCherryTag.Id });
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

### Step 5: Train the project

Now that we have added tags and images to the project, we can train it. Insert
the following code after the end of code that you added in the prior step. This
creates the first iteration in the project. We can then mark this iteration as
the default iteration.

 

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Now there are images with tags start training the project
Console.WriteLine("\tTraining");
var iteration = trainingApi.TrainProject(project.Id);

// The returned iteration will be in progress, and can be queried periodically to see when it has completed
while (iteration.Status == "Training")
{
    Thread.Sleep(1000);

    // Re-query the iteration to get it's updated status
    iteration = trainingApi.GetIteration(project.Id, iteration.Id);
}

// The iteration is now trained. Make it the default project endpoint
iteration.IsDefault = true;
trainingApi.UpdateIteration(project.Id, iteration.Id, iteration);
Console.WriteLine("Done!\n");
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

### Step 6: Get and use the default prediction endpoint

We are now ready to use the model for prediction. First we obtain the endpoint
associated with the default iteration. Then we send a test image to the project
using that endpoint. Insert the code after the training code you have just
entered.

 

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Now there is a trained endpoint, it can be used to make a prediction

// Add your prediction key from the settings page of the portal 
// The prediction key is used in place of the training key when making predictions 
string predictionKey = GetPredictionKey("<your key here>", args);

// Create a prediction endpoint, passing in a prediction credentials object that contains the obtained prediction key  
PredictionEndpointCredentials predictionEndpointCredentials = new PredictionEndpointCredentials(predictionKey);
PredictionEndpoint endpoint = new PredictionEndpoint(predictionEndpointCredentials);
// Make a prediction against the new project  
Console.WriteLine("Making a prediction:");
var result = endpoint.PredictImage(project.Id, testImage);
// Loop over each prediction and write out the results  
foreach (var c in result.Predictions)
{
    Console.WriteLine($"\t{c.Tag}: {c.Probability:P1}");
}
Console.ReadKey();
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

### Step 7: Run the example

Build and run the solution. You will be required to input your training API key
into the console app when running the solution so have this at the ready. The
training and prediction of the images can take 2 minutes. The prediction results
appear on the console.

Further Reading
---------------

The source code for the Windows client library is available on
[github](https://github.com/Microsoft/Cognitive-CustomVision-Windows/).

The client library includes multiple sample applications, and this tutorial is
based on the `CustomVision.Sample` demo within that repository.
