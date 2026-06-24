# Challenge 03 - Customer Experience

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)


## Pre-requisites

You must complete **Challenge 01** and **Challenge 02** before starting this challenge. The data pipeline with Flink SQL is necessary for this experience to function properly.


## Introduction

In this challenge, you will assume the role of a customer interacting with the customer agent experience. The purpose of this challenge is to demonstrate real-time event processing as purchase and return actions affect inventory levels. When a customer makes a purchase or return, Apache Flink processes the streaming events and updates the net sales and net inventory count tables, which are then indexed into Azure AI Search and made available to the agent.

## Description

During this challenge, you will:

- Log into the customer agent experience and explore its capabilities
- View inventory levels for specific product SKUs before making purchases
- Purchase product SKUs from different departments and record the quantities purchased
- Return product SKUs from each department and record the quantities returned
- Validate that inventory and sales data update in real time after each action
- Ensure that all inventory updates are visible within a three-second window

## Success Criteria

To complete this challenge successfully, you should be able to:

- Verify the customer agent displays the inventory level of a SKU before a purchase
- Verify after a purchase, inventory is reduced and net sales are updated
- Verify after a return, inventory and net sales are updated following the business rules defined in the Flink merge logic
- Verify all inventory updates are visible within three seconds of the action being completed
- Verify the agent retrieves accurate, real-time values via MCP services backed by Azure AI Search

## Learning Resources

- [Confluent Cloud Flink quickstart](https://docs.confluent.io/cloud/current/flink/get-started/index.html)
- [Event processing and upsert patterns in Apache Flink](https://nightlies.apache.org/flink/flink-docs-stable/docs/dev/table/sql/queries/insert/)
- [Azure AI Search indexing concepts](https://learn.microsoft.com/azure/search/search-what-is-azure-search)
- [Kafka event streaming fundamentals](https://kafka.apache.org/documentation/)