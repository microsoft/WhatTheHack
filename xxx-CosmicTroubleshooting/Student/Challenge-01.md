# Challenge 01 - What is going on?

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Introduction

XXX have deployed their newly designed web application on Azure, using Azure Cosmos DB as the database backend, since they were looking for a NoSQL database to suite their requirements.  In the first few weeks, all was going quite well, until their first marketing campaign. The number of customers visiting the web application increased exponentially and a host of issues and complaints started arriving. The web application was constantly very slow, multiple error messages were being generated and overall customer experience was severely degraded.

## Description

In this challenge, you will have to identify how the current system has been set up and what problems does this create.

**Note** You will need to run the Load Test defined in the Azure Load Testing service that is deployed in your Resource Group to gather data. The load test simulates the following user actions:
- The user views a product
- The user adds the product to the cart
- The user views the cart
- The user submits their order
- The user views their orders

As we would like to simulate real-life traffic, we should load test with a representative load (the load test runs a 1000 user test across the web app). Please scale up the Azure App Service Plan hosting the Web App to P1V3 for the duration of the test. You may then scale back down to S1.


## Success Criteria

To complete this challenge successfully, you should be able to:
- Load Test was successfully run
- Diagnostics correctly setup
- Identify and define the current data model used by the database.
- Identify and describe the types of queries executed from the application, along with associated database cost.
- Discuss your findings and identify potential ways that could alleviate the various problems found.
- Should you not change anything in the application, identify the scale factor the database would need to operate correctly.
- Evaluate the user experience while the load test is running.

## Learning Resources


- [Data modeling in Azure Cosmos DB](https://docs.microsoft.com/en-us/azure/cosmos-db/sql/modeling-data)
- [How to model and partition data on Azure Cosmos DB using a real-world example](https://docs.microsoft.com/en-us/azure/cosmos-db/sql/how-to-model-partition-example)
- [Partitioning and horizontal scaling in Azure Cosmos DB](https://docs.microsoft.com/en-us/azure/cosmos-db/partitioning-overview)
- [Troubleshoot issues with diagnostics queries](https://docs.microsoft.com/en-us/azure/cosmos-db/cosmosdb-monitor-logs-basic-queries)
- [Troubleshoot issues with advanced diagnostics queries for the SQL (Core) API](https://docs.microsoft.com/en-us/azure/cosmos-db/cosmos-db-advanced-queries)
- [Indexing in Azure Cosmos DB](https://docs.microsoft.com/en-us/azure/cosmos-db/index-overview)
- [Optimize request cost in Azure Cosmos DB](https://docs.microsoft.com/en-us/azure/cosmos-db/optimize-cost-reads-writes)
- [Create & Run a load test in Azure Load Testing Service](https://docs.microsoft.com/en-us/azure/load-testing/quickstart-create-and-run-load-test)
