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

 

### Training client library

You may need to install the client library depending on your settings within
Visual Studio. The easiest way to get the training client library is to install
the
[Microsoft.Cognitive.CustomVision.Training](https://www.nuget.org/packages/Microsoft.Cognitive.CustomVision.Training/)
package from nuget.

You can install it through the Visual Studio Package manager. Access the package
manager by navigating through:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Tools -> Nuget Package Manager -> Package Manager Console
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In that Console, add the nuget with:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Install-Package Microsoft.Cognitive.CustomVision.Training -Version 1.0.0
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

### The Training API key

You also need to have a training API key. The training API key allows you to
create, manage, and train Custom Vision projects programatically. All operations
on <https://customvision.ai> are exposed through this library, allowing you to
automate all aspects of the Custom Vision Service. You can obtain a key by
creating a new project at <https://customvision.ai> and then clicking on the
"setting" gear in the top right.

### The Images used for Training and Predicting

In the Resources\Images folder are three folders:

- Dent
- writeoff
- test

The Dent and writeoff folders contain images of these types of damages to vehicles
that will be trained and tagged. The Test folder contains an image that will be used 
to perform the test prediction.


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
        private static List<MemoryStream> WriteOffImages;

        private static List<MemoryStream> DentImages;

        private static MemoryStream testImage;

        static void Main(string[] args)
        {
            // You can either add your training key here, pass it on the command line, or type it in when the program runs
            string trainingKey = GetTrainingKey("<your key here>", args);

            // Create the Api, passing in a credentials object that contains the training key
            TrainingApiCredentials trainingCredentials = new TrainingApiCredentials(trainingKey);
            TrainingApi trainingApi = new TrainingApi(trainingCredentials);

            // Create a new project  
            Console.WriteLine("Creating new project:");
            var project = trainingApi.CreateProject("Car Assessment");

            // Make two tags in the new project  
            var WriteOffTag = trainingApi.CreateTag(project.Id, "WriteOff");
            var DentTag = trainingApi.CreateTag(project.Id, "Dent");

            // Add some images to the tags  
            Console.WriteLine("\tUploading images");
            LoadImagesFromDisk();

            // Images can be uploaded one at a time  
            foreach (var image in WriteOffImages)
            {
                trainingApi.CreateImagesFromData(project.Id, image, new List< string> () { WriteOffTag.Id.ToString() });
            }

            // Or uploaded in a single batch   
            trainingApi.CreateImagesFromData(project.Id, DentImages, new List< Guid> () { DentTag.Id });

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
            Console.WriteLine("Done!\\n");

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




        }



    }
}

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

### Step 2: Add code to get and manage the training key

On Line 127, create a method `GetTrainingKey` with two parameters of `trainingKey` 
with a data type of string, and a second parameter of args with the data type
of string, using the value from the trainingkey variable.
The code can include control of flow logic to either use the key if it already
defined, or to prompt for the key should it be missing. Add the
following code at the bottom of the cs file, underneath the } that is third from
the bottom from the file.
 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

### Step 3: Add code to get and manage the prediction key

On Line 147, create a method `GetPredictionKey` with two parameters of `predictionKey` 
with a data type of string, and a second parameter of args with the data type
of string, using the value from the predictionkey variable.
The code can include control of flow logic to either use the key if it already
defined, or to prompt for the key should it be missing. Create 
code at the bottom of the cs file, underneath the code you have just created for step 2.

`--NOTE THAT THE CODE IS MISSING BY DESIGN`
 

### Step 4: Create code that will upload images from the local disk

To upload files form disk, review and insert the following code after the code
you have just inserted "return trainingKey; }"

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        private static void LoadImagesFromDisk()
        {
            // this loads the images to be uploaded from disk into memory
            WriteOffImages = Directory.GetFiles(@"..\..\..\..\Images\writeoff").Select(f => new MemoryStream(File.ReadAllBytes(f))).ToList();
            DentImages = Directory.GetFiles(@"..\..\..\..\Images\Dent").Select(f => new MemoryStream(File.ReadAllBytes(f))).ToList();
            testImage = new MemoryStream(File.ReadAllBytes(@"..\..\..\..\Images\test\car1.jpg"));

        }
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 


### Step 4: Run the example

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
