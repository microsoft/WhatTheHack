using Microsoft.Azure.Devices.Client;
using System.Text;
using System.Text.Json;
using Simulation.Events;

namespace Simulation.Proxies
{
    public class MqttTrafficControlService : ITrafficControlService
    {
        private readonly DeviceClient _client;

        public MqttTrafficControlService(int camNumber)
        {
            // connect to mqtt broker
            _client = DeviceClient.CreateFromConnectionString("HostName=iothub-dapr-ussc-demo.azure-devices.net;DeviceId=simulation;SharedAccessKey=/cRA4cYbcyC7If6SlnYOsjohcNV6CrfugBe8Ka2z2m8=", TransportType.Mqtt);
        }

        public void SendVehicleEntry(VehicleRegistered vehicleRegistered)
        {
            var eventJson = JsonSerializer.Serialize(vehicleRegistered);
            var message = new Message(Encoding.UTF8.GetBytes(eventJson));
            message.Properties.Add("trafficcontrol", "entrycam");
            _client.SendEventAsync(message).Wait();
        }

        public void SendVehicleExit(VehicleRegistered vehicleRegistered)
        {
            var eventJson = JsonSerializer.Serialize(vehicleRegistered);
            var message = new Message(Encoding.UTF8.GetBytes(eventJson));
            message.Properties.Add("trafficcontrol", "exitcam");
            _client.SendEventAsync(message).Wait();
        }
    }
}
