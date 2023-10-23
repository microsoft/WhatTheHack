# Challenge 04—Securing Resources, Quota Monitoring and Enforcement

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

## Pre-requisites (Optional)

This challenge assumes that all requirements for Challenges 01, 02 and 03 were successfully completed.

## Introduction

When building any application for production scenarios, it is always a good idea to build it responsibly and securely.

For this challenge, the goal will be to ensure that no credentials or keys for Blob Store, Azure Cognitive Search, Cosmos DB or OpenAI is stored in environment variables.
The goal will be to use Azure-Managed Identities to authenticate against these resources from the application.

We will also make sure that for the automated exam grading for each school district, each school district is not exceeding the allocated quota.

You will ensure that each school district does not process more than 4 submissions within a 5-minute period. If this quota is reached, the service bus queue will need to be suspended for 5 minutes and then processing for that school district can resume again.
## Description

In this challenge, we will do the following:
- updating the application connection setup for Azure Cosmos DB, Azure Blob Store, Azure OpenAI and Azure Service Bus to use managed identities and not credentials from environment variables
- enforcing that the quotas are adhered to and no school district is able to process more than 4 submissions within a 5 minute period.

## Success Criteria

A successfully completed solution should accomplish the following goals:

- Connection to Azure Cosmos DB, Azure Blob Store, Azure OpenAI and Azure Service Bus are using only managed identities
- The quota enforcement is adhered to and that no school district exceeds the quota limit



## Learning Resources

https://learn.microsoft.com/en-us/azure/azure-functions/functions-bindings-timer?

https://learn.microsoft.com/en-us/azure/service-bus-messaging/entity-suspend#suspension-states

https://redis.io/docs/data-types/strings/

https://redis.io/docs/data-types/lists/

## Tips
- Suspend the service bus queue and keep track of this in Redis Cache
- Use Timers to check if the Service Bus Queue suspension can be lifted.
