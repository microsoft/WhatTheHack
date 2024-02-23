# Challenge 05 - Deployment

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-06.md)

## Introduction

In this challenge, you will deploy the **first** function app (.NET based, with name containing `App`)  to Azure.

## Description

- Deploy the Tollbooth app to the `App` function app you created earlier

**Make sure the publish is successful before moving to the next step**

- In the portal, add the event grid subscription to the `ProcessImage` function
  - Event Schema: Event Grid Schema.
  - Topic Type : Storage Accounts.
  - Resource : The first storage account you created.
  - Event type : Blob Created _only_
  - Endpoint type : Select your `ProcessImage` Azure Function

**NOTE** As per January 2024, the Azure Portal UI will display an error in the "Integration" section of the function, once it's published. This is due to an open bug with the [Azure Function Core Tools for .NET functions](https://github.com/Azure/azure-functions-core-tools/issues/3157#issuecomment-1843236365) which can be worked around by manually fixing the Blob Storage Input binding in `functions.json` to add `"direction":"in"` and then packaging the function ZIP file. This may not be a mandatory step, the code should work fine.

## Success Criteria

1. The solution successfully deploys to Azure
2. Open the Function's `LiveStream`, upload a License Plate image to the storage account, and validate the function is called and it can successfully extract the plate number Cognitive Services OCR. 

## Learning Resources

- [Deploy Functions to Azure](https://www.thebestcsharpprogrammerintheworld.com/2018/08/21/deploy-an-azure-function-created-from-visual-studio-2)
- [Create Event Grid Subscription in Azure Function](https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-event-grid-trigger?tabs=csharp%2Cbash#azure-portal)
- [Live Metrics Stream from VS Code](https://learn.microsoft.com/en-us/azure/azure-functions/streaming-logs?tabs=vs-code)
