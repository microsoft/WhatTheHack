# Challenge 04 - Quota Monitoring and Enforcement

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

## Pre-requisites (Optional)

This challenge assumes that all requirements for Challenges 01, 02 and 03 were successfully completed.

## Introduction

When building any application for production scenarios, there may be scenarios where the quota for the LLMs have to be distributed fairly to prevent or minimize opportunities for starvation amongst the consumers.

For this challenge, our goal is to ensure that for the automated exam grading for each school district, each school district is not exceeding the allocated quota.

The are 4 school districts and they do not have equal number of schools or students so the goal is to ensure that the resource allocation is distributed fairly and equally to each school district.

You will ensure that each school district does not process more than 4 submissions within a 5-minute period. 

If this quota is reached, the service bus queue will need to be suspended for a certain amount of time and then processing for that school district can resume again after the cool down period has elapsed.

## Description

In this challenge, we will do the following:
- modify the application configuration to enable quota enforcement. This is done by changing the LLM_QUOTA_ENFORCEMENT to 1
- modify the application configuration to specify the llm transaction aggregate window: This is done by changing the LLM_QUOTA_ENFORCEMENT to 1
- modify the application configuration to specify the number of transactions allowed for each school district within the window : This is done by changing the LLM_QUOTA_ENFORCEMENT to 1
- modify the application configuration to specify the cool down period when the transaction threshold is reach:  This is done by changing the LLM_QUOTA_ENFORCEMENT to 1


For this challenge our goal is to make sure quotas are adhered to and no school district is able to process more than 4 submissions within a 5 minute period.

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
