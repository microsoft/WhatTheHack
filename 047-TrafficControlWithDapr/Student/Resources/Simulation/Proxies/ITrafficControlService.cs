using Simulation.Events;

namespace Simulation.Proxies
{
    public interface ITrafficControlService
    {
        public void SendVehicleEntry(VehicleRegistered vehicleRegistered);
        public void SendVehicleExit(VehicleRegistered vehicleRegistered);
    }
}