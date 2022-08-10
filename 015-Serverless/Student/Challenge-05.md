# Challenge 05 - Deployment

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-06.md)

## Introduction

In this challenge, you will deploy the VS project to Azure.

## Description

1. Deploy the Tollbooth project to the &quot;App&quot; function app you created earlier

**Make sure the publish is successful before moving to the next step**

2. In the portal, add the event grid subscription to the &quot;Process Image&quot; function
  * Event Schema: Event Grid Schema.
  * Topic Type : Storage Accounts.
  * Resource : The first storage account you created.
  * Event type : Blob Created _only_
  * Endpoint type : Select your ProcessImage Azure Function

## Success Criteria

1. The solution successfully deploys to Azure

## Learning Resources

- [Deploy Functions to Azure](https://www.thebestcsharpprogrammerintheworld.com/2018/08/21/deploy-an-azure-function-created-from-visual-studio-2)
- [Create Event Grid Subscription in Azure Function](https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-event-grid-trigger?tabs=csharp%2Cbash#azure-portal)