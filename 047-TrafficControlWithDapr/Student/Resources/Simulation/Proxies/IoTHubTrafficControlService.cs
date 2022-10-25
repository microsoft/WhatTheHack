using Microsoft.Azure.Devices.Client;
using System.Text;
using System.Text.Json;
using Simulation.Events;
using System;

namespace Simulation.Proxies
{
  public class IoTHubTrafficControlService : ITrafficControlService
  {
    private readonly DeviceClient _client;

    public IoTHubTrafficControlService(int camNumber)
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