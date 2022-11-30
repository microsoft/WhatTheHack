using System;
using System.Text.Json.Serialization;

namespace Simulation.Events
{
    public class VehicleRegistered
    {
        public int Lane { get; set; }
        public string LicenseNumber { get; set; }
        public DateTime Timestamp { get; set; }
        
        [JsonIgnore]
        public string BackgroundColor { get; set; }
    }
}