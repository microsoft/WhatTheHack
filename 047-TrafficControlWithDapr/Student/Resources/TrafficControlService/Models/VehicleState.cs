using System;

namespace TrafficControlService.Models
{
    public class VehicleState
    {
        public string LicenseNumber { get; set; }
        public DateTime EntryTimestamp { get; set; }
        public DateTime ExitTimestamp { get; set; }
    }
}