using System;
using System.Collections.Generic;
using System.Text;
using Newtonsoft.Json;

namespace TollBooth.Models
{
    public class Event<T> where T : class
    {
        [JsonProperty(PropertyName = "id")]
        public string Id { get; set; }
        [JsonProperty(PropertyName = "subject")]
        public string Subject { get; set; }
        [JsonProperty(PropertyName = "eventType")]
        public string EventType { get; set; }
        [JsonProperty(PropertyName = "data")]
        public T Data { get; set; }
        [JsonProperty(PropertyName = "eventTime")]
        public DateTime EventTime { get; set; }
    }
}
