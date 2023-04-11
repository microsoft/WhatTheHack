using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using FineCollectionService.DomainServices;
using FineCollectionService.Helpers;
using FineCollectionService.Models;
using FineCollectionService.Proxies;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Dapr.Client;

namespace FineCollectionService.Controllers
{
  [ApiController]
  [Route("")]
  public class CollectionController : ControllerBase
  {
    private static string _fineCalculatorLicenseKey;
    private readonly ILogger<CollectionController> _logger;
    private readonly IFineCalculator _fineCalculator;
    private readonly VehicleRegistrationServiceProxy _vehicleRegistrationServiceProxy;

    public CollectionController(ILogger<CollectionController> logger,
        IFineCalculator fineCalculator, VehicleRegistrationServiceProxy vehicleRegistrationServiceProxy)
    {
      _logger = logger;
      _fineCalculator = fineCalculator;
      _vehicleRegistrationServiceProxy = vehicleRegistrationServiceProxy;

      // set finecalculator component license-key
      if (_fineCalculatorLicenseKey == null)
      {
        _fineCalculatorLicenseKey = "HX783-K2L7V-CRJ4A-5PN1G";
      }
    }

    [Route("collectfine")]
    [HttpPost()]
    public async Task<ActionResult> CollectFine(SpeedingViolation speedingViolation) //TODO: inject Dapr client as a parameter here
    {
      decimal fine = _fineCalculator.CalculateFine(_fineCalculatorLicenseKey, speedingViolation.ViolationInKmh);

      // get owner info
      var vehicleInfo = await _vehicleRegistrationServiceProxy.GetVehicleInfo(speedingViolation.VehicleId);

      // log fine
      string fineString = fine == 0 ? "tbd by the prosecutor" : $"{fine} Euro";
      _logger.LogInformation($"Sent speeding ticket to {vehicleInfo.OwnerName}. " +
          $"Road: {speedingViolation.RoadId}, Licensenumber: {speedingViolation.VehicleId}, " +
          $"Vehicle: {vehicleInfo.Brand} {vehicleInfo.Model}, " +
          $"Violation: {speedingViolation.ViolationInKmh} Km/h, Fine: {fineString}, " +
          $"On: {speedingViolation.Timestamp.ToString("dd-MM-yyyy")} " +
          $"at {speedingViolation.Timestamp.ToString("hh:mm:ss")}.");

      // send fine by email
      //TODO: add Dapr output bindings here

      return Ok();
    }
  }
}
