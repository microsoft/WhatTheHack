using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using ProcessingLibrary;
using Newtonsoft.Json;

namespace TestCLI
{
    /// <summary>
    /// ImageMetadata stores the image data from Cognitive Services into CosmosDB.
    /// </summary>
    public class ImageMetadata
    {
        /// <summary>
        /// Build from an image path, storing the full local path, but using the filename as ID.
        /// </summary>
        /// <param name="imageFilePath">Local file path.</param>
        public ImageMetadata(string imageFilePath)
        {
            this.LocalFilePath = imageFilePath;
            this.FileName = Path.GetFileName(imageFilePath);
            this.Id = this.FileName; // TODO: Worry about collisions, but ID can't handle slashes.
        }

        /// <summary>
        /// Public parameterless constructor for serialization-friendliness.
        /// </summary>
        public ImageMetadata()
        {
            
        }

        /// <summary>
        /// Store the ImageInsights into the metadata - pulls out tags and caption, stores number of faces and face details.
        /// </summary>
        /// <param name="insights"></param>
        public void AddInsights(ImageInsights insights)
        {
            this.Caption = insights.Caption;
            this.Tags = insights.Tags;

        }

        [JsonProperty(PropertyName = "id")]
        public string Id { get; set; }

        public Uri BlobUri { get; set; }

        public string LocalFilePath { get; set; }

        public string FileName { get; set; }

        public string Caption { get; set; }

        public string[] Tags { get; set; }

        public override string ToString()
        {
            return JsonConvert.SerializeObject(this);
        }
    }

    static class Util
    {
        /// <summary>
        /// Simple resize method for use when we're trying to run the cognitive services against large images. 
        /// We resize downward to avoid too much data over the wire.
        /// </summary>
        /// <param name="imageFile">Image file to resize.</param>
        /// <param name="maxDim">Maximum height/width - will retain aspect ratio.</param>
        /// <returns>Revised width/height and resized image filename.</returns>
        public static Tuple<Tuple<double, double>, string> ResizeIfRequired(string imageFile, int maxDim)
        {
            using (var origImg = Image.FromFile(imageFile))
            {
                var width = origImg.Width;
                var height = origImg.Height;
                if (width > maxDim || height > maxDim)
                {
                    if (width >= height)
                    {
                        width = maxDim;
                        height = (int)((float)(maxDim * origImg.Height) / ((float)origImg.Width));
                    }
                    else
                    {
                        height = maxDim;
                        width = (int)((float)(maxDim * origImg.Width) / ((float)origImg.Height));
                    }

                    var resizedImageFile = Path.GetTempFileName();
                    using (var resultingImg = (Image)(new Bitmap(origImg, new Size(width, height))))
                        resultingImg.Save(resizedImageFile, ImageFormat.Png);

                    return Tuple.Create(Tuple.Create((double)origImg.Width / width, (double)origImg.Height / height), resizedImageFile);
                }
                else
                {
                    // No need to resize
                    return Tuple.Create((Tuple<double,double>)null, imageFile);
                }
            }
        }

        /// <summary>
        /// If we resize the image, we should resize the face rectangles in our insights appropriately.
        /// </summary>
        /// <param name="insights"></param>
        /// <param name="resizeTransform"></param>

    }
}
