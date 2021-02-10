# Challenge 5 - Run the game continuously

[< Previous Challenge](04-RunOnAzure.md) - **[Home](README.md)** - [Next Challenge >](06-AddApplicationMonitoring.md)

## Automatically call app's URL

### Using Azure LogicApps

1. Create your workflow definition `httpRunner.json`

    ```json
    {
        "definition": {
            "$schema": "https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#",
            "actions": {
                "HTTP": {
                    "inputs": {
                        "headers": {
                            "Content-Length": "0"
                        },
                        "method": "POST",
                        "uri": "<APP-API-ENDPOINT>"
                    },
                    "runAfter": {},
                    "type": "Http"
                }
            },
            "contentVersion": "1.0.0.0",
            "outputs": {},
            "parameters": {},
            "triggers": {
                "Recurrence": {
                    "recurrence": {
                        "frequency": "Minute",
                        "interval": 5
                    },
                    "type": "Recurrence"
                }
            }
        },
        "parameters": {}
    }
    ```

2. Create a LogicApps workflow with: [az logic workflow](https://docs.microsoft.com/cli/azure/ext/logic/logic/workflow?view=azure-cli-latest#ext-logic-az-logic-workflow-create) using the already created workflow definition

    ```bash
    az logic workflow create \
        -g $resourceGroup \
        -l $location \
        -n <logic-app-workflow-name> \
        --definition "httpRunner.json"
    ```

    or

3. If you don't have a workflow definition, it is best to create it via the Azure Portal: [Create logic apps via - Portal](https://docs.microsoft.com/azure/logic-apps/quickstart-create-first-logic-app-workflow)

    ![LogicApp](assets/05-recurrentTrigger.png)

### Using Azure Functions

1. Create a local function with [Azure Functions Core Tools](https://docs.microsoft.com/azure/azure-functions/functions-run-local?tabs=macos%2Ccsharp%2Cbash)

    ```bash
    # Create a new function app
    func init <FUNCTION-APP>

    # Create a new function
    func new -l c# -n <FUNCTION-NAME> -t TimerTrigger
    ```

2. Call your app API endpoint

    ```c#
    public static class runGameHttp
    {
        private static HttpClient httpClient = new HttpClient();
        private static string apiEndpoint = Environment.GetEnvironmentVariable("API_ENDPOINT");

        [FunctionName("runGameHttp")]
        public async static void Run([TimerTrigger("0 */1 * * * *")]TimerInfo myTimer, ILogger log)
        {
            log.LogInformation($"C# Timer trigger function executed at: {DateTime.Now}");

            var content = new StringContent("", Encoding.UTF8, "application/json");
            
            HttpResponseMessage response = await httpClient.PostAsync(apiEndpoint, content);
            string result = await response.Content.ReadAsStringAsync();

            log.LogInformation(result);
        }
    }
    ```

3. Deploy function to Azure Functions App

    ```bash
    # Create Azure Function App
    az functionapp create \
        -g $resourceGroup \
        -n $funcAppName \
        --consumption-plan-location $location \
        --functions-version 3 \
        --storage-account $storageAccount
    
    # Publish your function
    func azure functionapp publish $funcAppName

    # Configure appsettings
    az functionapp config appsettings set \
        -n $funcAppName \
        -g $resourceGroup \
        --settings "API_ENDPOINT=<app-api-endpoint>"
    ```
