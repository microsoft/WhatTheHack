// 
// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license.
// 
// Microsoft Cognitive Services: https://azure.microsoft.com/en-us/services/cognitive-services
// 
// Microsoft Cognitive Services GitHub:
// https://github.com/Microsoft/Cognitive-CustomVision-Windows
// 
// Copyright (c) Microsoft Corporation
// All rights reserved.
// 
// MIT License:
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED ""AS IS"", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
// 


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
            Console.WriteLine("\\tUploading images");
            LoadImagesFromDisk();

            // Images can be uploaded one at a time  
            foreach (var image in WriteOffImages)
            {
                trainingApi.CreateImagesFromData(project.Id, image, new List< string> () { WriteOffTag.Id.ToString() });
            }

            // Or uploaded in a single batch   
            trainingApi.CreateImagesFromData(project.Id, DentImages, new List< Guid> () { DentTag.Id });

            // Now there are images with tags start training the project
            Console.WriteLine("\\tTraining");
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
                Console.WriteLine($"\\t{c.Tag}: {c.Probability:P1}");
            }
            Console.ReadKey();




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
            WriteOffImages = Directory.GetFiles(@"..\..\..\..\Images\writeoff").Select(f => new MemoryStream(File.ReadAllBytes(f))).ToList();
            DentImages = Directory.GetFiles(@"..\..\..\..\Images\Dent").Select(f => new MemoryStream(File.ReadAllBytes(f))).ToList();
            testImage = new MemoryStream(File.ReadAllBytes(@"..\..\..\..\Images\test\car1.jpg"));

        }
    }
}
