using System.Net.Mqtt;
using System.Text.Json;
using Simulation.Events;
using System.Text;
using System.Net.Http;
using System;

namespace Simulation.Proxies
{
  public class MqttTrafficControlService : ITrafficControlService
  {
    private IMqttClient _mqttClient;
    public MqttTrafficControlService(int cameraNumber)
    {
      throw new NotImplementedException();
    }

    public void SendVehicleEntry(VehicleRegistered vehicleRegistered)
    {
      throw new NotImplementedException();
    }

    public void SendVehicleExit(VehicleRegistered vehicleRegistered)
    {
      throw new NotImplementedException();
    }
  }
}