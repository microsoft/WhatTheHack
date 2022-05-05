using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Verify_inator.Services;

namespace Verify_inator.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class TerritoryController : ControllerBase
    {

        private readonly ILogger<TerritoryController> _logger;
        private readonly B2cGraphService _b2cGraphService;
        private const string CMCID_REGEX = "[0-9]{3}[a-z,A-Z]{4}[0-9]{3}";
        public TerritoryController(ILogger<TerritoryController> logger, B2cGraphService b2cGraphService)
        {
            _logger = logger;
            _b2cGraphService = b2cGraphService;
        }

        [HttpPost()]
        public IActionResult Post([FromBody] JsonElement body)
        {
            try
            {
                this._logger.LogInformation("A CMC Consultant ID code is being redeemed.");

                // Look up the invitation code in the incoming request.
                var cmcId = default(string);
                var territoryName = default(string);
                this._logger.LogInformation("Request properties:");
                foreach (var element in body.EnumerateObject())
                {
                    this._logger.LogInformation($"- {element.Name}: {element.Value.ToString()}");
                    // The element name should be the full extension name as seen by the Graph API (e.g. "extension_appid_ConsultantID").
                    if (element.Name.Equals(this._b2cGraphService.GetUserAttributeExtensionName(this._b2cGraphService.ConsultantIDUserAttribute), StringComparison.InvariantCultureIgnoreCase))
                    {
                        cmcId = element.Value.GetString();
                    }
                }

                if (string.IsNullOrWhiteSpace(cmcId) || !Regex.IsMatch(cmcId, CMCID_REGEX))
                {
                    this._logger.LogInformation($"The provided CMC ID \"{cmcId}\" is invalid.");
                    return GetValidationErrorApiResponse("UserInvitationRedemptionFailed-Invalid", "The invitation code you provided is invalid.");
                }
                else
                {
                    territoryName = GetRandoName();
                    return GetContinueApiResponse("UserInvitationRedemptionSucceeded", "The invitation code you provided is valid.", cmcId, territoryName);
                }
            }
            catch (Exception exc)
            {
                this._logger.LogError(exc, "Error while processing request body: " + exc.ToString());
                return GetBlockPageApiResponse("UserInvitationRedemptionFailed-InternalError", "An error occurred while validating your invitation code, please try again later.");
            }
        }


        private IActionResult GetContinueApiResponse(string code, string userMessage, string cmcId, string territoryName)
        {
            return GetB2cApiConnectorResponse("Continue", code, userMessage, 200, cmcId, territoryName);
        }

        private IActionResult GetValidationErrorApiResponse(string code, string userMessage)
        {
            return GetB2cApiConnectorResponse("ValidationError", code, userMessage, 400, null, null);
        }

        private IActionResult GetBlockPageApiResponse(string code, string userMessage)
        {
            return GetB2cApiConnectorResponse("ShowBlockPage", code, userMessage, 200, null, null);
        }

        private IActionResult GetB2cApiConnectorResponse(string action, string code, string userMessage, int statusCode, string cmcId, string territoryName)
        {
            var responseProperties = new Dictionary<string, object>
            {
                { "version", "1.0.0" },
                { "action", action },
                { "userMessage", userMessage },
                { this._b2cGraphService.GetUserAttributeExtensionName(this._b2cGraphService.ConsultantIDUserAttribute), cmcId }, // Note: returning just "extension_<AttributeName>" (without the App ID) would work as well!
                { this._b2cGraphService.GetUserAttributeExtensionName(this._b2cGraphService.TerritoryNameUserAttribute), territoryName } // Note: returning just "extension_<AttributeName>" (without the App ID) would work as well!
            };
            if (statusCode != 200)
            {
                // Include the status in the body as well, but only for validation errors.
                responseProperties["status"] = statusCode.ToString();
            }
            return new JsonResult(responseProperties) { StatusCode = statusCode };
        }

        private string GetRandoName()
        {
            var randGen = new Random();

            var adjIdx = randGen.Next(0, Adjective.Length - 1);
            var nounIdx = randGen.Next(0, Noun.Length - 1);

            return $"{Adjective[adjIdx]}-{Noun[nounIdx]}";
        }
        private static readonly string[] Adjective = new[]
        {
            "Fast",
            "Speedy",
            "Graceful",
            "Brilliant",
            "Reserved",
            "Benevolent",
            "Extreme",
            "Fiery",
            "Unquenchable",
            "Fantabulous",
            "Truthful",
            "Honorable",
            "Rambling"
        };
        private static readonly string[] Noun = new[]
        {
            "Turtle",
            "Prairie",
            "Skyline",
            "Theater",
            "Ensemble",
            "Tricycle",
            "Autumn",
            "Universe",
            "Sweatlodge",
            "River",
            "Earthworm"
        };
    }
}