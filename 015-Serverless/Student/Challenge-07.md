# Challenge 07 - Monitoring

[< Previous Challenge](./Challenge-06.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-08.md)

## Introduction

Application Insights can be integrated with Azure Function Apps to provide robust monitoring for your functions. In this challenge, you will provision a new centralized Application Insights account and configure all of your Function Apps to send telemetry to it.

## Description

1. Create an Application Insights resource
    * Name : Similar to `TollboothMonitor`
    * _Hint : Copy the instrumentation key_
2. Add application insights to your &quot;App&quot; function app and &quot;Events&quot; function app
    * Name: APPINSIGHTS\_INSTRUMENTATIONKEY
3. Open the Live Metrics Stream for the app insights in the &quot;App&quot; function app (may take a few minutes for App Insights to appear)
4. Open the `/UploadImages` folder and execute `dotnet build` and then `dotnet run "<yourBlobConnectionString>"` with the `blobStorageConnection` string as an argument, between quotes. Press 1, then enter in the console to upload a few images.

**NOTE** Check the `/UploadImages/Program.cs` file and review the two folder paths in the `Directory.GetFiles()` method (line 124 and 131). 

5. Go back to the portal to view the telemetry.  You should start seeing new telemetry arrive, showing the number of servers online, the incoming request rate, CPU process amount, etc. You can select some of the sample telemetry in the list to the side to view output data.
6. Leave the Live Metrics Stream window open once again, and close the console window for the image upload. Re-run the `UploadImages` project, but this time press **2**, then **ENTER** in the console. This will upload 1,000 new photos.
7. Switch back to the Live Metrics Stream window and observe the activity as the photos are uploaded. It is possible that the process will run so efficiently that no more than two servers will be allocated at a time. You should also notice things such as a steady cadence for the Request Rate monitor, the Request Duration hovering below ~500ms second, and the Process CPU percentage roughly matching the Request Rate.
8. Close the console window when done.

## Success Criteria

1. You have been able to successfully monitor the execution of the functions in Application Insights.

## Learning Resources

- [Monitor Azure Functions using Application Insights](https://docs.microsoft.com/azure/azure-functions/functions-monitoring)
- [Live Metrics Stream: Monitor & Diagnose with 1-second latency](https://docs.microsoft.com/azure/application-insights/app-insights-live-stream)

## Advanced Challenges

Too comfortable?  Eager to do more?  Try these additional challenges!

- [Optional Challenge A - Scale the Cognitive Service](./Challenge-07A.md)
- [Optional Challenge B - View Data in Cosmos DB](./Challenge-07B.md)
