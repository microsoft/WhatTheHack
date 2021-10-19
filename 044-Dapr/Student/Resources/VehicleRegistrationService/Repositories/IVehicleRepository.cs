using VehicleRegistrationService.Models;

namespace VehicleRegistrationService.Repositories
{
    public interface IVehicleInfoRepository
    {
        VehicleInfo GetVehicleInfo(string licenseNumber);
    }
}