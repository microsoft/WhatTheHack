using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Newtonsoft.Json.Linq;
using WTHAzureCosmosDB.Web.Helpers;

namespace WTHAzureCosmosDB.Web.Pages;

public class DevToolsIndexModel : PageModel
{

    private readonly ILogger<DevToolsIndexModel> _logger;
    private readonly AzureLoadTestingRunHelper _azureLoadTestingRunHelper;
    private readonly IConfiguration _configuration;

    private const string ALT_TOKEN_ENDPOINT = "https://loadtest.azure-dev.com";

    public DevToolsIndexModel(
            IConfiguration configuration,
            AzureLoadTestingRunHelper azureLoadTestingRunHelper,
            ILogger<DevToolsIndexModel> logger)
    {

        _configuration = configuration;
        _azureLoadTestingRunHelper = azureLoadTestingRunHelper;
        _logger = logger;
    }

    public void OnGet()
    {
    }
    public async Task<IActionResult> OnPostCreateNewLoadTestAsync(int users, int loops)
    {
        if (!ModelState.IsValid)
        {
            return RedirectToPage("/Index");
        }

        IDictionary<string, string> secrets = new Dictionary<string, string>();
        IDictionary<string, string> envVariables = new Dictionary<string, string>(){
                        {"webProtocol","https"},
                        {"webHost", _configuration["WEBSITE_HOSTNAME"]},
                        {"webPath", "test-from-ALT/"},
                        {"loops", $"{loops}"},
                        {"threads", $"{users}"},
                    };


        //get a new token for given MSI 
        //we are leveraging on defined MSI in paramaters for cosmosdb
        var accessToken = await _azureLoadTestingRunHelper.GetDefaultAzureTokenAsync(
            _configuration["AZURE_CLIENT_ID"], 
            ALT_TOKEN_ENDPOINT
            );
        _logger.LogDebug(accessToken.ToString());
        _logger.LogDebug("ALT data plane:" + _configuration["LOADT_DATA_PLANE_ENDPOINT"]);
        _logger.LogDebug("ALT test id:" + _configuration["LOADT_TEST_ID"]);

        var response = await _azureLoadTestingRunHelper.CreateNewTestRunAsync(
            _configuration["LOADT_DATA_PLANE_ENDPOINT"],
            _configuration["LOADT_TEST_ID"],
            accessToken.Token,
            envVariables, secrets,
            "TestRun_From_WebApp_" + DateTime.UtcNow,
            "Launched from DevOps tooling in the WebApp"
            );

        _logger.LogDebug("Response " + response.ToString());




        return RedirectToPage();
    }
}