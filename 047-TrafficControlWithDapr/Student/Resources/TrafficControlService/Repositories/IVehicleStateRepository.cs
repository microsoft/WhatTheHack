using System.Threading.Tasks;
using TrafficControlService.Models;

namespace TrafficControlService.Repositories
{
    public interface IVehicleStateRepository
    {
         Task SaveVehicleStateAsync(VehicleState vehicleState);
         Task<VehicleState> GetVehicleStateAsync(string licenseNumber);
    }
}