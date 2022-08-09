using System;
using System.Collections.Generic;
using System.Text;
using Newtonsoft.Json;

namespace TollBooth.Models
{
    public class LicensePlateData
    {
        [JsonProperty(PropertyName = "fileName")]
        public string FileName { get; set; }
        [JsonProperty(PropertyName = "licensePlateText")]
        public string LicensePlateText { get; set; }
        [JsonProperty(PropertyName = "timeStamp")]
        public DateTime TimeStamp { get; set; }
        [JsonProperty(PropertyName = "licensePlateFound")]
        public bool LicensePlateFound => !string.IsNullOrWhiteSpace(LicensePlateText);
    }
}
