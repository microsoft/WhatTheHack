# Challenge 05 - Deployment

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-06.md)

## Introduction

In this challenge, you will deploy the VS project with the **first** function app (.NET based, with name containing &quot;App&quot;)  to Azure.

## Description

1. Deploy the Tollbooth project to the &quot;App&quot; function app you created earlier

**Make sure the publish is successful before moving to the next step**

2. In the portal, add the event grid subscription to the &quot;Process Image&quot; function
  * Event Schema: Event Grid Schema.
  * Topic Type : Storage Accounts.
  * Resource : The first storage account you created.
  * Event type : Blob Created _only_
  * Endpoint type : Select your ProcessImage Azure Function

3. **NOTE** As per January 2024, there's an open bug with the [Azure Function Core Tools for .NET functions](https://github.com/Azure/azure-functions-core-tools/issues/3157#issuecomment-1843236365) which can be worked around by manually fixing the Blob Storage Input binding in `functions.json` to add `"direction":"in"` and then packaging the function ZIP file

## Success Criteria

1. The solution successfully deploys to Azure
2. Open the Function's LiveStream, upload a License Plate JPG to the storage account, and validate the function is called and it can successfully extract the plate number Cognitive Services OCR. 

## Learning Resources

- [Deploy Functions to Azure](https://www.thebestcsharpprogrammerintheworld.com/2018/08/21/deploy-an-azure-function-created-from-visual-studio-2)
- [Create Event Grid Subscription in Azure Function](https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-event-grid-trigger?tabs=csharp%2Cbash#azure-portal)
- [Live Metrics Stream from VS Code](https://learn.microsoft.com/en-us/azure/azure-functions/streaming-logs?tabs=vs-code)