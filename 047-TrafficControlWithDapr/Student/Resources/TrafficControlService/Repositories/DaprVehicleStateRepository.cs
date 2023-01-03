using System.Collections.Concurrent;
using System.Threading.Tasks;
using TrafficControlService.Models;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Net.Http;
using System.Net.Http.Json;
using System.Net.Http.Headers;
using Microsoft.Extensions.Logging;
using System;

namespace TrafficControlService.Repositories
{
  public class DaprVehicleStateRepository : IVehicleStateRepository
  {
    private const string DAPR_STORE_NAME = "statestore";
    private readonly HttpClient _httpClient;

    public DaprVehicleStateRepository(HttpClient httpClient)
    {
      _httpClient = httpClient;
    }

    public async Task<VehicleState> GetVehicleStateAsync(string licenseNumber)
    {
      throw new NotImplementedException();
    }

    public async Task SaveVehicleStateAsync(VehicleState vehicleState)
    {
      throw new NotImplementedException();
    }
  }
}