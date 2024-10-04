# Challenge 05 - Deployment

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-06.md)

## Introduction

By now, you have configured the Function App in Azure and updated the TollBooth application code. Now it's time to start assembling the pieces of the puzzle by publishing the TollBooth application code to Azure and configuring the other Azure PaaS services to trigger it. 

## Description

In this challenge, you will deploy the TollBooth function code to the **first** Function App (.NET based, with name containing `App`) in Azure.  You will also configure Event Grid so that when a file is uploaded to the Blob Storage container, it triggers the `ProcessImage` function hosted in the Function App in Azure.

### Deploy TollBooth function code to Azure

- Deploy the Tollbooth app to the `App` function app you created earlier

**NOTE:** You must make sure the publish is successful before moving to the next step!

### Configure Event Grid Subscription to Trigger `ProcessImage` Function

In the portal, add an event grid subscription to the `ProcessImage` function with the following specifications:
- Event Schema: Event Grid Schema.
- Topic Type : Storage Accounts.
- Resource : The first storage account you created.
- Event type : Blob Created _only_
- Endpoint type : Select your `ProcessImage` Azure Function
- Filters: none

**HINT:** There are multiple ways to configure an Event Grid Subscription to a System Topic. One of the easiest is to start from the Storage Account. Navigate to the Events pane, then to the "Event Subscriptions" tab. You can pick any name for the Subscription or the System Topic Name.

### Run Water Through The Pipes

Once the TollBooth application is published and configured, upload a license plate image to the storage account to trigger the function.

## Success Criteria

1. The solution successfully deploys to Azure
2. Open the Function's `LiveStream`, upload a License Plate image to the storage account, and validate the function is called and it can successfully extract the plate number Cognitive Services OCR. 

## Learning Resources

- [Deploy Functions to Azure](https://www.thebestcsharpprogrammerintheworld.com/2018/08/21/deploy-an-azure-function-created-from-visual-studio-2)
- [Create Event Grid Subscription in Azure Function](https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-event-grid-trigger?tabs=csharp%2Cbash#azure-portal)
- [Live Metrics Stream from VS Code](https://learn.microsoft.com/en-us/azure/azure-functions/streaming-logs?tabs=vs-code)
