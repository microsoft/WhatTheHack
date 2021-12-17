using System.Net.Http;
using System.Net.Http.Json;
using System.Text.Json;
using Simulation.Events;

namespace Simulation.Proxies
{
    public class HttpTrafficControlService : ITrafficControlService
    {
        private HttpClient _httpClient;

        public HttpTrafficControlService(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        public void SendVehicleEntry(VehicleRegistered vehicleRegistered)
        {
            var eventJson = JsonSerializer.Serialize(vehicleRegistered);
            var message = JsonContent.Create<VehicleRegistered>(vehicleRegistered);
            _httpClient.PostAsync("http://localhost:6000/entrycam", message).Wait();
        }

        public void SendVehicleExit(VehicleRegistered vehicleRegistered)
        {
            var eventJson = JsonSerializer.Serialize(vehicleRegistered);
            var message = JsonContent.Create<VehicleRegistered>(vehicleRegistered);
            _httpClient.PostAsync("http://localhost:6000/exitcam", message).Wait();
        }
    }
}