# Challenge 7 - Monitoring

## Prerequisities

1. [Challenge 6 - Create Functions in the Portal](./06-PortalFunctions.md) should be done successfuly.

## Introduction
Application Insights can be integrated with Azure Function Apps to provide robust monitoring for your functions. In this challenge, you will provision a new Application Insights account and configure your Function Apps to send telemetry to it.

1. Create an Application Insights resource
    * Name : Similar to TollboothMonitor
    * _Hint : Copy the instrumentation key_
2. Add application insights to your &quot;App&quot; function app and &quot;Events&quot; function app
    * Name: APPINSIGHTS\_INSTRUMENTATIONKEY
3. Open the Live Metrics Stream for the app insights in the &quot;App&quot; function app (may take a few minutes for App Insights to appear)
4. Go back to the solution in Visual Studio.  Start a new instance of the UploadImages project.  Enter the &quot;blobStorageConnection&quot;string.  Press 1 then enter in the console.
5. Go back to the portal to view the telemetry.  You should start seeing new telemetry arrive, showing the number of servers online, the incoming request rate, CPU process amount, etc. You can select some of the sample telemetry in the list to the side to view output data.
6. Leave the Live Metrics Stream window open once again, and close the console window for the image upload. Debug the UploadImages project again, then enter **2** and press **ENTER**. This will upload 1,000 new photos.
7. Switch back to the Live Metrics Stream window and observe the activity as the photos are uploaded. It is possible that the process will run so efficiently that no more than two servers will be allocated at a time. You should also notice things such as a steady cadence for the Request Rate monitor, the Request Duration hovering below ~500ms second, and the Process CPU percentage roughly matching the Request Rate.
8. Close the console window when done.


## Success Criteria
1. You have been able to successfully monitor the execution of the functions in Application Insights.

## Tips


|                                                               |                                                                                  |
| ------------------------------------------------------------- | :------------------------------------------------------------------------------: |
| **Description**                                               |                                    **Links**                                     |
| Monitor Azure Functions using Application Insights            |     <https://docs.microsoft.com/azure/azure-functions/functions-monitoring>      |
| Live Metrics Stream: Monitor & Diagnose with 1-second latency | <https://docs.microsoft.com/azure/application-insights/app-insights-live-stream> |

[Next optional challenge A (Scale the Cognitive Service) >](./0A-ScaleCognitive.md)

Or

[Next optional challenge B (View Data in Cosmos DB) >](./0B-Cosmos.md)

Or

[Next challenge (Data Export Workflow) >](./08-Workflow.md)
