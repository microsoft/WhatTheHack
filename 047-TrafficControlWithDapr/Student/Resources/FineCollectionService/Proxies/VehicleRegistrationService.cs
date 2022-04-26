using System.Net.Http;
using System.Net.Http.Json;
using System.Threading.Tasks;
using FineCollectionService.Models;

namespace FineCollectionService.Proxies
{
    public class VehicleRegistrationService
    {
        private HttpClient _httpClient;

        public VehicleRegistrationService(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        public async Task<VehicleInfo> GetVehicleInfo(string licenseNumber)
        {
            return await _httpClient.GetFromJsonAsync<VehicleInfo>(
                $"http://localhost:6002/vehicleinfo/{licenseNumber}");
        }       
    }
}