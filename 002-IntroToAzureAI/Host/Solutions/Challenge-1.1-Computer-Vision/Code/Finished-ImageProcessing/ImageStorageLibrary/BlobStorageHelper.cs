using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Threading.Tasks;

namespace ImageStorageLibrary
{
    /// <summary>
    /// Helper for accessing blob storage. Set the container name and connection string, build it, and you can then upload/retrieve data easily.
    /// </summary>
    public class BlobStorageHelper
    {
        public static String ContainerName { get; set; } = "images";
        public static String ConnectionString { get; set; }

        public static async Task<BlobStorageHelper> BuildAsync()
        {
            if (string.IsNullOrWhiteSpace(ContainerName))
                throw new ArgumentNullException("ContainerName");
            if (string.IsNullOrWhiteSpace(ConnectionString))
                throw new ArgumentNullException("ConnectionString");

            Debug.WriteLine($"Initializing storage account for container {ContainerName}");
            var helper = new BlobStorageHelper();
            helper.storageAccount = CloudStorageAccount.Parse(ConnectionString);
            helper.blobClient = helper.storageAccount.CreateCloudBlobClient();
            helper.container = helper.blobClient.GetContainerReference(ContainerName);
            await helper.container.CreateIfNotExistsAsync();
            // Set permissions to allow people to access blobs _if they know they're there_. They can't list the container.
            helper.container.SetPermissions(
                new BlobContainerPermissions { PublicAccess = BlobContainerPublicAccessType.Blob });

            return helper;
        }

        private BlobStorageHelper() { }

        private CloudStorageAccount storageAccount { get; set; }
        private CloudBlobClient blobClient { get; set; }
        private CloudBlobContainer container { get; set; }

        /// <summary>
        /// Upload image from stream into block blob, return blob reference. Image ID is used as blob "filename" so must be valid for blob names.
        /// </summary>
        /// <param name="imageStreamCallback">Functor that can produce a task which, when executed, provides the image stream.</param>
        /// <param name="imageId">Blob file name.</param>
        /// <returns></returns>
        public async Task<CloudBlockBlob> UploadImageAsync(Func<Task<Stream>> imageStreamCallback, string imageId)
        {
            CloudBlockBlob blob = container.GetBlockBlobReference(imageId);
            await blob.UploadFromStreamAsync(await imageStreamCallback());
            return blob;
        }

        /// <summary>
        /// Gets all image URIs in the blob container.
        /// </summary>
        /// <returns>List of URIs for blobs in the container.</returns>
        public async Task<IList<Uri>> GetImageURIsAsync()
        {
            return await GetImageURIsAsync("");
        }

        /// <summary>
        /// Gets all image URIs matching the given prefix. Used for walking a container's "directory tree".
        /// </summary>
        /// <param name="prefix">Blob prefix (i.e. "subdirectory")</param>
        /// <returns>List of URIs for blobs in the container matching the given prefix.</returns>
        private async Task<IList<Uri>> GetImageURIsAsync(string prefix)
        { 
            BlobContinuationToken tok = null;
            List<Uri> blobUris = new List<Uri>();
            do
            {
                BlobResultSegment curResult = await container.ListBlobsSegmentedAsync(tok);
                foreach (var result in curResult.Results)
                {
                    if (result is CloudBlobDirectory)
                    {
                        blobUris.AddRange(await GetImageURIsAsync(((CloudBlobDirectory)result).Prefix));
                    } else
                    {
                        blobUris.Add(((CloudBlob)result).Uri);
                    }
                }
                tok = curResult.ContinuationToken;
            } while (tok != null);
            return blobUris;
        }
    }
}
