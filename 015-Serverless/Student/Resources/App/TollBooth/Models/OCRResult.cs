using System;
using System.Collections.Generic;
using System.Text;
using Newtonsoft.Json;

namespace TollBooth.Models
{
    public class OCRResult
    {
        [JsonProperty(PropertyName = "language")]
        public string Language { get; set; }
        [JsonProperty(PropertyName = "textAngle")]
        public float TextAngle { get; set; }
        [JsonProperty(PropertyName = "orientation")]
        public string Orientation { get; set; }
        [JsonProperty(PropertyName = "regions")]
        public Region[] Regions { get; set; }
    }

    public class Region
    {
        [JsonProperty(PropertyName = "boundingBox")]
        public string BoundingBox { get; set; }
        [JsonProperty(PropertyName = "lines")]
        public Line[] Lines { get; set; }
    }

    public class Line
    {
        [JsonProperty(PropertyName = "boundingBox")]
        public string BoundingBox { get; set; }
        [JsonProperty(PropertyName = "words")]
        public Word[] Words { get; set; }
    }

    public class Word
    {
        [JsonProperty(PropertyName = "boundingBox")]
        public string BoundingBox { get; set; }
        [JsonProperty(PropertyName = "text")]
        public string Text { get; set; }
    }
}
