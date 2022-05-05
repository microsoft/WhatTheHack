using System;

namespace Simulation.Events
{
    public class VehicleRegistered
    {
        public int Lane { get; set; }
        public string LicenseNumber { get; set; }
        public DateTime Timestamp { get; set; }
    }
}