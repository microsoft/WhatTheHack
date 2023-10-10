using Microsoft.Azure.Devices.Client;
using System.Text;
using System.Text.Json;
using Simulation.Events;
using System;
using System.Threading.Tasks;

namespace Simulation.Proxies
{
  public class IoTHubTrafficControlService : ITrafficControlService
  {
#pragma warning disable CS0169
    private readonly DeviceClient _client;
#pragma warning restore CS0169

    public IoTHubTrafficControlService(int camNumber)
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