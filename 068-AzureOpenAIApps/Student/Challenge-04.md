# Challenge 04 - Quota Monitoring and Enforcement

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

## Pre-requisites

This challenge assumes that all requirements for Challenge 01 were successfully completed.

## Introduction

When building any application for production scenarios, there may be scenarios where the quota for the LLMs have to be distributed fairly to prevent or minimize opportunities for starvation amongst the consumers.

For this challenge, our goal is to ensure that for the automated exam grading for each school district, each school district is not exceeding the allocated quota.

The are 4 school districts and they do not have equal number of schools or students so the goal is to ensure that the resource allocation is distributed fairly and equally to each school district.

You will ensure that each school district does not process more than 5 submissions within a 2-minute period. 

If this quota is reached, the service bus queue will need to be suspended for a certain amount of time and then processing for that school district can resume again after the cool down period has elapsed.

## Description

In this challenge, we will modify the application configuration file (`local.settings.json`) in the following ways:

- Modify the application configuration to enable quota enforcement. This is done by changing the `LLM_QUOTA_ENFORCEMENT` to 1
- Modify the application configuration to specify the llm transaction aggregate window: This is done by changing the `LLM_QUOTA_ENFORCEMENT_WINDOW_SECONDS` to 120
- Modify the application configuration to specify the number of transactions allowed for each school district within the window : This is done by changing the `LLM_QUOTA_ENFORCEMENT_MAX_TRANSACTIONS` to 5
- Modify the application configuration to specify the cool down period when the transaction threshold is reach:  This is done by changing the `LLM_QUOTA_ENFORCEMENT_COOL_DOWN_SECONDS` to 300


| Configuration Name | Examples| Description|
|--------------|-----------|------------|
| `LLM_QUOTA_ENFORCEMENT` | 1     | Whether or not Quota enforcement is enabled for the app        |
| `LLM_QUOTA_ENFORCEMENT_WINDOW_SECONDS`      | 120  | The number of seconds that define the transaction aggregation window for quota enforcement       |
| `LLM_QUOTA_ENFORCEMENT_MAX_TRANSACTIONS`      | 5  | The number of transactions allowed per school district within the transaction window       |
| `LLM_QUOTA_ENFORCEMENT_COOL_DOWN_SECONDS`      | 300  | The number of seconds the district needs to wait before processing can resume. Should be greater than the transaction window       |


For this challenge our goal is to make sure quotas are adhered to and no school district is able to process more than 5 submissions within a 2 minute period.

Any violation of this policy will result in a cool down period of 5 minutes.

## Success Criteria

The service bus queue for each district should be suspended by disabling the receive queue when this threshold is reached

A successfully completed solution should accomplish the following goals:

- The quota enforcement is adhered to and that no school district exceeds the quota limit. You should not see any new grading activity by the LLM during the cool down period.



## Learning Resources

- [Timer trigger for Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/functions-bindings-timer)
- [Suspend and reactivate messaging entities (disable)](https://learn.microsoft.com/en-us/azure/service-bus-messaging/entity-suspend#suspension-states)
- [Redis Strings](https://redis.io/docs/data-types/strings/)
- [Redis lists](https://redis.io/docs/data-types/lists/)


