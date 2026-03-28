# Challenge 04 - Employee Experience

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** 


## Pre-requisites

You must complete **Challenge 02** and **Challenge 03** before starting this challenge. The data pipeline from the replenishments, returns and purchases is necessary for this experience to be complete and successful.


## Introduction

In this challenge, you will assume the role of an employee interacting with the employee agent experience. The objective is to demonstrate the employee's ability to access comprehensive operational insights, including inventory, cumulative metrics, and net sales for each product SKU. The employee agent uses the same MCP service and data pipeline powered by Apache Flink, with data originating from real-time events such as purchases, returns, and replenishments.

This challenge requires interaction across multiple personas. You will switch between customer, supplier, and employee tabs or windows to simulate real-world concurrent activity. Each action triggers updates to the net inventory count and net sales tables, and the employee agent should always return accurate, real-time data.

## Description

During this challenge, you will:

- Log into the employee agent experience and explore its comprehensive capabilities
- Query real-time inventory and cumulative transaction metrics for any product SKU
- View inventory levels for individual SKUs and entire departments
- Use other personas (customer and supplier) to trigger purchase, return, and replenishment events
- Retrieve cumulative purchase, return, and replenishment units for any SKU after events occur
- Confirm that the employee agent responds with accurate net inventory counts and net sales values
- Verify that all data matches what is observed in Azure AI Search and Flink output

## Success Criteria

To complete this challenge successfully, you should be able to:

- Verify the employee agent can display inventory levels for individual SKUs
- Verify the employee agent can display inventory levels for all SKUs in a department
- Verify cumulative purchase, return, and replenishment values for any SKU are retrieved accurately
- Verify the agent provides accurate net inventory counts and net sales values after transactions
- Verify inventory and sales values shown by the agent match what is observed in Azure AI Search and Flink output

## Learning Resources

- [Confluent Cloud Flink quickstart](https://docs.confluent.io/cloud/current/flink/get-started/index.html)
- [Flink SQL upsert and aggregate patterns](https://nightlies.apache.org/flink/flink-docs-stable/docs/dev/table/sql/queries/insert/)
- [Azure AI Search indexing concepts](https://learn.microsoft.com/azure/search/search-what-is-azure-search)
- [Kafka event streaming fundamentals](https://kafka.apache.org/documentation/)