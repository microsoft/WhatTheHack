# Challenge 01 - Develop a Load Testing Strategy

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Introduction

When some people think of load testing, the first thought that comes to mind is pointing a tool at your site and cranking the load to the max and see what happens.  While that might be exciting at the moment, it’s critical to take a step back and develop a load testing strategy that is tailored to the application. This means breaking down the architecture, internal/external dependencies, high availability design, scaling and the data tier.  Having a plan not only helps you prepare while you are testing the application but also provides context as to why and how you are testing the application for anyone in the future.  

## Description

Create a load testing strategy to describe your plan and goals.  Below are some examples of topics to think of.  Are there any additional you can think of adding?

- Define what services and the scope of your testing
- Identify the load characteristics and scenario
- Identify the test failure criteria
- Identify how you will be monitoring your application
- Identify potential bottlenecks/limitations in advance
- Please note any assumptions 

Below is the sample application that we will be using:

The sample app is a single page web application that displays the number of times the endpoint has been hit and is used as a tracker for the number of guests have visited your site. There are three endpoints for this application:

- (Get) Get - carries a get operation from the database to retrieve the current count
- (Post) Add - Updates the database with the number of visitors.  You will need to pass the number of visits to increment.
- (Get) lasttimestamp - Updates the time stamp since this was accessed.

This is deployed on App Service with Cosmos DB as the database.
## Success Criteria

- Present your comprehensive load testing plan - paying special attention to how the load test will ‘touch’ the various application and components.
- Explain what potential bottlenecks you might encounter during the test. For each bottleneck, how will you tweak or mitigate the bottleneck?
- Explain how a service failure or degradation might impact the performance of the application and/or load test

## Learning Resources

- [Azure subscription and service limits, quotas, and constraints](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits)
- [How to write a test plan for load testing](https://www.flood.io/blog/how-to-write-a-test-plan-for-load-testing)