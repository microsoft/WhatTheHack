using System.Collections.Concurrent;
using System.Threading.Tasks;
using TrafficControlService.Models;

namespace TrafficControlService.Repositories
{
    public class InMemoryVehicleStateRepository : IVehicleStateRepository
    {
        private readonly ConcurrentDictionary<string, VehicleState> _state;

        public InMemoryVehicleStateRepository()
        {
            _state = new ConcurrentDictionary<string, VehicleState>();
        }
        public Task<VehicleState> GetVehicleStateAsync(string licenseNumber)
        {
            VehicleState state;
            if (!_state.TryGetValue(licenseNumber, out state))
            {
                return null;
            }
            return Task.FromResult(state);
        }

        public Task SaveVehicleStateAsync(VehicleState vehicleState)
        {
            _state.AddOrUpdate(vehicleState.LicenseNumber, vehicleState,
                (k,s) => vehicleState);
            return Task.CompletedTask;
        }
    }
}