using System.Net.Mqtt;
using System.Text.Json;
using Simulation.Events;
using System.Text;
using System.Net.Http;
using System;
using System.Threading.Tasks;

namespace Simulation.Proxies
{
  public class MqttTrafficControlService : ITrafficControlService
  {
#pragma warning disable CS0169
    private IMqttClient _mqttClient;
#pragma warning restore CS0169
    public MqttTrafficControlService(int cameraNumber)
    {
      throw new NotImplementedException();
    }

    public async Task SendVehicleEntryAsync(VehicleRegistered vehicleRegistered)
    {
      throw await Task.FromException<NotImplementedException>(new NotImplementedException());
    }

    public async Task SendVehicleExitAsync(VehicleRegistered vehicleRegistered)
    {
      throw await Task.FromException<NotImplementedException>(new NotImplementedException());
    }
  }
}