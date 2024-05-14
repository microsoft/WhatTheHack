# Challenge 02 - Time to Fix Things

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

Now that we have identified some issues, it is time to mitigate them. Based on your findings from the previous challenge, you will need to define a plan to fix most if not all of these issues.

## Description

In this challenge, you will properly configure your Azure Cosmos DB so that it minimizes cost as well as optimizes performance. You will also need to make some changes in the application code itself to take advantage of the changes.

Lastly, you will compare your previous findings on performance/cost with the newer metrics. You will need to re-run the Load Test defined in your Azure Load Testing service. As in [Challenge 01](./Challenge-01.md), we would like to simulate real-life traffic, we should load test with a representative load (the load test runs a 1000 user test across the web app). **Please scale up the Azure App Service Plan hosting the Web App to P1V3 for the duration of the test**. You may then scale back down to S1.

## Success Criteria

To complete this challenge successfully:
- You should present your plan to apply a new data model that minimizes downtime for the application.
- You should implement the actions in your plan so that the data model is reflected in the Azure Cosmos DB database as well application code changes to the advantage of the improvements.
- Present how the new design has optimized the database and application performance and cost. Refer to your previous findings and sample queries. What is the associated cost after your changes?

## Learning Resources

- [Change feed in Azure Cosmos DB](https://docs.microsoft.com/en-us/azure/cosmos-db/change-feed)
- [Serverless event-based architectures with Azure Cosmos DB and Azure Functions](https://docs.microsoft.com/en-us/azure/cosmos-db/sql/change-feed-functions)
