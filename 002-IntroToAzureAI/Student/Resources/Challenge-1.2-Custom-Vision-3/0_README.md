**Custom Vision API C\# Tutorial**
==================================
**Challenge Exercise**
----------------------

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

- Racing
- Mountain
- test

The Racing and Mountain folders contain images of these types of bikes 
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

This code calls two helper methods which we will define below. The method called
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
        private static List<MemoryStream> MbikesImages;

        private static List<MemoryStream> RbikesImages;

        private static MemoryStream testImage;

        static void Main(string[] args)
        {
            // You can either add your training key here, pass it on the command line, or type it in when the program runs
            string trainingKey = GetTrainingKey("<your key here>", args);

            // Create the Api, passing in a credentials object that contains the training key
            TrainingApiCredentials trainingCredentials = new TrainingApiCredentials(trainingKey);
            TrainingApi trainingApi = new TrainingApi(trainingCredentials);


        }


    }
}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

### Step 2: Add code to validate and manage the training key

Create a method `GetTrainingKey()` with two parameters of `trainingKey` 
with a data type of string, and a second parameter of args with the data type
of string, using the value from the trainingkey variable.
The code can include control of flow logic to either use the key if it is already
defined, or to prompt for the key should it be missing. Create the
following code at the bottom of the cs file, underneath the } that is third from
the bottom of the file.

### Step 3: Add code to validate and manage the prediction key

On Line 147, create a method `GetPredictionKey` with two parameters of `predictionKey` 
with a data type of string, and a second parameter of args with the data type
of string, using the value from the predictionkey variable.
The code can include control of flow logic to either use the key if it already
defined, or to prompt for the key should it be missing. Add the
following code at the bottom of the cs file, underneath the code you have just added
for the training key in step 2.
  

### Step 4: Create code that will upload images from the local disk

Create a method named `LoadImagesFromDisk()` that creates two variables named
`MbikesImages` and `RbikesImages`. Each of thes variables should use the `GetFiles()`
method to retrieve the images located in the Images\Mountain and Images\Racing
folder of your Github location respectively. A third variable named `testImage` 
should be created that defines a new MemoryStream which loads the image bike1.jpg 
from the Images\test folder of your Github location. Create code underneath the 
code created in step 2


### Step 5: Create a Custom Vision Service project

Create a new Custom Vision Service project named "Bike Type", create the
code in the body of the `Main()` method after the call to `new TrainingApi().`


### Step 6: Add tags to your project

Create two variable named `MbikesTag` and `RbikesTag` that call the `CreateTag`
method of the class `trainingAPI` for the current project. The MbikesTag 
variable should be set to "Mountain". The RbikesTag variable should be set 
to "Racing". To add tags to your project, create the code after the call to
`CreateProject("Bike Type");`.


### Step 7: Upload images to the project

To add the images we have in memory to the project, call the `LoadImagesFromDisk()`
that either uploads images one at a time, or as a batch. The variables `MbikesImages`
and `RbikesImages` should be used as the source of the image upload to the project.
The variables `MbikesTag` and `RbikesTag` can be used to associate the tags to the images
using the `CreateImagesFromData` method from the `trainingApi` class.
Add the code after the call to `CreateTag(project.Id, "Racing")` method.


### Step 8: Train the project

Use the `TrainProject` method of the `trainingApi` class against the current projectid
to start the training of the images. Use a while clause with the Status method of 
the iteration class to check the progress of the training. Then set the iteration as
Default using the `IsDefault` method of the iteration class. Finally update the iteration
and set it as default within the project using the `UpdateIteration` method of the 
`trainingApi` class. Insert your code after the end of code that you added in the prior step. 


### Step 9: Create a variable named predictionKey that holds the prediction key value

Create a variable named `predictionKey` thats calls the method `GetPredictionKey` and passes
two parameters of a string literal `"<your key here>"`, and a second parameter of `args` 
with the data type of string.

### Step 10: Use the default prediction endpoint

We are now ready to use the model for prediction. First we obtain the endpoint
associated with the default iteration. Then we send a test image to the project
using that endpoint. Insert the code after the training code you have just
entered.

### Step 11: Run the example

Build and run the solution. You will be required to input your training API key
into the console app when running the solution so have this at the ready. The
training and prediction of the images can take 2 minutes. If you've completed the 
lab successfully, the prediction results should appear on the console.

Further Reading
---------------

The source code for the Windows client library is available on
[github](https://github.com/Microsoft/Cognitive-CustomVision-Windows/).

The client library includes multiple sample applications, and this tutorial is
based on the `CustomVision.Sample` demo within that repository.
