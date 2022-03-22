# Challenge 01 - Develop a Load Testing Strategy

**[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Introduction

Before we jump into load testing, it’s critical to take a step back and develop a load testing strategy that is tailored to the application. This means breaking down the architecture, internal/external dependencies, high availability design, scaling and the data tier.  You may use your own application design or the sample application design located [here](https://github.com/Azure-Samples/nodejs-appsvc-cosmosdb-bottleneck).

## Description

Create a load testing strategy to describe your plan and goals.

- Define what services and the scope of your testing
- Identify the load characteristics and scenario
- Identify the test failure criteria
- Identify how you will be monitoring your application
- Identify potential bottlenecks/limitations in advance
- Please note any assumptions 


## Success Criteria

- Present your comprehensive load testing plan - paying special attention to how the load test will ‘touch’ the various application tiers (front-end, APIs, database) and components (microservices, backend workers/jobs, serverless).
- Explain what potential bottlenecks you might encounter during the test. For each bottleneck, how will you tweak or mitigate the bottleneck?
- Explain how a service failure or degradation might impact the performance of the application and/or load test

## Learning Resources

[Azure subscription and service limits, quotas, and constraints](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits)