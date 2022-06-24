# Challenge 07 - Event-driven notifications from SAP business events

[< Previous Challenge](./Challenge-06.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-08.md)

## Introduction
Until this point we have always been pulling data from the SAP backend or writing back to it from our application. But nowadays immediate feedback on important changes on the backend is desired.

In this challenge you will enable your application to act on SAP Business Events by connecting your SAP backend to your Azure PaaS service of choice (CosmosDB, Service Bus, Event Hub, Event Grid etc.) using the ABAP SDK for Azure. Feel free to leverage a partner solution for the event processing if you happen to have any instead.

Be aware that SAP's materials for this integration pattern will always point towards SAP Event Mesh. An [integration between SAP Event Mesh and Azure Event Grid](https://blogs.sap.com/2021/10/08/inviting-you-register-soon-to-explore-your-event-driven-pathway-between-sap-and-microsoft-azure/) is possible. We suggest the ABAP SDK to avoid further dependencies and put you in charge of the event handling.

## Description
- Familiarise yourself with this [repository](https://github.com/thzandvl/xbox-shipping)
- Read this associated blog post [Hey SAP, where is my Xbox?](https://blogs.sap.com/2021/12/09/hey-sap-where-is-my-xbox-an-insight-into-capitalizing-on-event-driven-architectures/)
- Import/Configure ABAP SDK for Azure
- Maintain SDK config for your Azure PaaS
- Inject custom Event receiver into SAP Workflow Event Framework to forward event to Azure via ABAP SDK
- Raise SAP Business Event (e.g. business partner created)
- Consume event in your app and act upon it

## Success Criteria
- At least one downstream action kicked off based on the business event received from SAP in your app

## Stretch Goal
- You could use the Business Events type model to update an external store (e.g CosmosDB) by exposing an additional write-back endpoint that consumes events inside SAP as the source of the truth, but that keeps another more dynamically scalable store in sync.

- In a distributed environment, you could combine this with the [Cache Aside pattern](https://docs.microsoft.com/en-us/azure/architecture/patterns/cache-aside) to simplify your cache updates by simply reacting to the event and removing the cached version of the updated object from the APIM cache. Then the next request should reload it into the cache or if you already know what the new cache data looks like as part of the event, you could simply update it in place. 

## Learning Resources
- [ABAP SDK for Azure](https://github.com/Microsoft/ABAP-SDK-for-Azure)
- [ABAP Git to install ABAP SDK for Azure](https://github.com/microsoft/ABAP-SDK-for-Azure/blob/master/ABAP%20SDK%20for%20Azure%20-%20Github.md#heading--1-7)
- [ABAP snippets for eventing](https://github.com/thzandvl/xbox-shipping/tree/main/ABAPCode)
- [Hey SAP, where is my Xbox?](https://blogs.sap.com/2021/12/09/hey-sap-where-is-my-xbox-an-insight-into-capitalizing-on-event-driven-architectures/)
