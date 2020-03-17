using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Threading;
using System.Configuration;
using System.Net;
using Microsoft.Azure.Storage;
using Microsoft.Azure.Storage.Blob;
using Microsoft.Azure.Storage.DataMovement;

namespace UploadImages
{
    class Program
    {
        private static List<MemoryStream> _sourceImages;
        private static readonly Random Random = new Random();
        private static string BlobStorageConnection;

        static int Main(string[] args)
        {
            if (args.Length == 0)
            {
                Console.WriteLine("You must pass the Blob Storage connection string as an argument when executing this application.");
                Console.ReadLine();
                return 1;
            }
            else
            {
                BlobStorageConnection = args[0];
            }

            int choice = 1;
            Console.WriteLine("Enter one of the following numbers to indicate what type of image upload you want to perform:");
            Console.WriteLine("\t1 - Upload a handful of test photos");
            Console.WriteLine("\t2 - Upload 1000 photos to test processing at scale");
            int.TryParse(Console.ReadLine(), out choice);

            bool upload1000 = choice == 2;

            UploadImages(upload1000);

            Console.ReadLine();

            return 0;
        }

        private static void UploadImages(bool upload1000)
        {
            Console.WriteLine("Uploading images");
            int uploaded = 0;
            var account = CloudStorageAccount.Parse(BlobStorageConnection);
            var blobClient = account.CreateCloudBlobClient();
            var blobContainer = blobClient.GetContainerReference("images");
            blobContainer.CreateIfNotExists();

            // Setup the number of the concurrent operations.
            TransferManager.Configurations.ParallelOperations = 64;
            // Set ServicePointManager.DefaultConnectionLimit to the number of eight times the number of cores.
            ServicePointManager.DefaultConnectionLimit = Environment.ProcessorCount * 8;
            ServicePointManager.Expect100Continue = false;
            // Setup the transfer context and track the upload progress.
            //var context = new SingleTransferContext
            //{
            //    ProgressHandler =
            //        new Progress<TransferStatus>(
            //            (progress) => { Console.WriteLine("Bytes uploaded: {0}", progress.BytesTransferred); })
            //};

            if (upload1000)
            {
                LoadImagesFromDisk(true);
                for (var i = 0; i < 200; i++)
                {
                    foreach (var image in _sourceImages)
                    {
                        var filename = GenerateRandomFileName();
                        var destBlob = blobContainer.GetBlockBlobReference(filename);

                        var task = TransferManager.UploadAsync(image, destBlob);
                        task.Wait();
                        uploaded++;
                        Console.WriteLine($"Uploaded image {uploaded}: {filename}");
                    }
                }
            }
            else
            {
                LoadImagesFromDisk(false);
                foreach (var image in _sourceImages)
                {
                    var filename = GenerateRandomFileName();
                    var destBlob = blobContainer.GetBlockBlobReference(filename);

                    var task = TransferManager.UploadAsync(image, destBlob);
                    task.Wait();
                    uploaded++;
                    Console.WriteLine($"Uploaded image {uploaded}: {filename}");
                }
            }

            Console.WriteLine("Finished uploading images");
        }

        private static string GenerateRandomFileName()
        {
            const int randomStringLength = 8;
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

            var rando = new string(Enumerable.Repeat(chars, randomStringLength)
              .Select(s => s[Random.Next(s.Length)]).ToArray());
            return $"{rando}.jpg";
        }

        private static void LoadImagesFromDisk(bool upload1000)
        {
            // This loads the images to be uploaded from disk into memory.
            if (upload1000)
            {
                _sourceImages =
                    Directory.GetFiles(@"..\..\..\..\license plates\copyfrom\")
                        .Select(f => new MemoryStream(File.ReadAllBytes(f)))
                        .ToList();
            }
            else
            {
                _sourceImages =
                    Directory.GetFiles(@"..\..\..\..\license plates\")
                        .Select(f => new MemoryStream(File.ReadAllBytes(f)))
                        .ToList();
            }
        }
    }
}
