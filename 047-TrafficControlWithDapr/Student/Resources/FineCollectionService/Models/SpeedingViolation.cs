using System;

namespace FineCollectionService.Models
{
    public class SpeedingViolation
    {
        public string VehicleId { get; set; }
        public string RoadId { get; set; }
        public int ViolationInKmh { get; set; }
        public DateTime Timestamp { get; set; }
    }
}