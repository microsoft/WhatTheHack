using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Newtonsoft.Json.Linq;
using WTHAzureCosmosDB.Web.Helpers;
using Azure.Core;
using Newtonsoft.Json.Converters;
using Newtonsoft.Json;
using System.Dynamic;
using Microsoft.Extensions.Caching.Memory;
using System.Text.Json.Nodes;
using Microsoft.ApplicationInsights.AspNetCore.Extensions;

namespace WTHAzureCosmosDB.Web.Pages;

public class DevToolsIndexModel : PageModel
{

    private readonly ILogger<DevToolsIndexModel> _logger;
    private readonly AzureLoadTestingRunHelper _azureLoadTestingRunHelper;
    private readonly IConfiguration _configuration;
    private readonly MemoryCache _memoryCache;

    public const string ALT_TOKEN_ENDPOINT = "https://loadtest.azure-dev.com";
    public const string ALT_CACHE_LAST_TEST_RUN = "altLast";

    public DevToolsIndexModel(
            IConfiguration configuration,
            AzureLoadTestingRunHelper azureLoadTestingRunHelper,
            ILogger<DevToolsIndexModel> logger,
            MemoryCache memoryCache)
    {

        _configuration = configuration;
        _azureLoadTestingRunHelper = azureLoadTestingRunHelper;
        _logger = logger;
        _memoryCache = memoryCache;
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
        
        _logger.LogDebug("ALT data plane:" + _configuration["LOADT_DATA_PLANE_ENDPOINT"]);
        _logger.LogDebug("ALT test id:" + _configuration["LOADT_TEST_ID"]);

        var newTestRunId = Guid.NewGuid();

        _memoryCache.Set(ALT_CACHE_LAST_TEST_RUN, newTestRunId.ToString(), TimeSpan.FromDays(7));

        var response = await _azureLoadTestingRunHelper.CreateNewTestRunAsync(
            _configuration["LOADT_DATA_PLANE_ENDPOINT"],
            _configuration["LOADT_TEST_ID"],
            accessToken.Token,
            envVariables, secrets,
            "TestRun_From_WebApp_" + DateTime.UtcNow,
            "Launched from DevOps tooling in the WebApp",
            newTestRunId
            );

        var converter = new ExpandoObjectConverter();
        var content = await response.Content.ReadAsStringAsync();

        _logger.LogDebug("Response " + content);



        var currentUri = Request.GetUri();

        // Add single key value parameter to the url
        UriBuilder builder = new UriBuilder(currentUri);
        if (string.IsNullOrEmpty(builder.Query))
        {
            builder.Query = "openDevToolsModal=1";
        }
        else
        {
            builder.Query += "&openDevToolsModal=1";
        }

        return Redirect(builder.Uri.ToString());
    }



    public async Task<IActionResult> OnPostGetLoadTestingStatus()
    {
        _logger.LogDebug("ALT data plane:" + _configuration["LOADT_DATA_PLANE_ENDPOINT"]);

        //get a new token for given MSI 
        //we are leveraging on defined MSI in paramaters for cosmosdb
        var accessToken = await _azureLoadTestingRunHelper.GetDefaultAzureTokenAsync(
            _configuration["AZURE_CLIENT_ID"],
            ALT_TOKEN_ENDPOINT
            );
        
        string lastTestRunId;

        _memoryCache.TryGetValue(ALT_CACHE_LAST_TEST_RUN, out lastTestRunId);

        if (string.IsNullOrEmpty(lastTestRunId))
        {
            throw new Exception("Empty last test run ID in memory cache - cannot identify which testrun is applicable.");
        }

        var response = await _azureLoadTestingRunHelper.GetLastTestRunStatusAsync(
            _configuration["LOADT_DATA_PLANE_ENDPOINT"],
            lastTestRunId,
            accessToken.Token
            );

        var converter = new ExpandoObjectConverter();

        var obj = JsonConvert.DeserializeObject<ExpandoObject>(response, converter);

        return new JsonResult(obj);
    }
}