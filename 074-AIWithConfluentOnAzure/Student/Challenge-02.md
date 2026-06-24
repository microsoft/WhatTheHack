# Challenge 02 - Supplier Experience

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)


## Pre-requisites

You must complete **Challenge 01** before starting this challenge. The data pipeline with Flink SQL is necessary for this experience to function properly.

## Introduction

In this challenge, you will assume the role of a supplier interacting with the AI agent experience. The purpose of this challenge is to demonstrate how the data pipeline created in previous challenges provides real-time, accurate inventory information to the agent through MCP services backed by Apache Flink. As inventory levels change, Flink continuously merges data streams and updates the net inventory count table, ensuring that the supplier receives the most up-to-date information at all times.

## Description

During this challenge, you will:

- Log into the supplier agent experience and explore its capabilities
- View inventory levels for product SKUs within specific departments
- View inventory levels for individual product SKUs
- Replenish inventory for specific SKUs or entire departments through the agent
- Verify that inventory changes are reflected in Azure AI Search
- Confirm that the AI agent responds with accurate, real-time inventory values from the streaming data pipeline

## Success Criteria

To complete this challenge successfully, you should be able to:

- Verify the supplier agent can display real-time inventory levels for any SKU
- Verify the supplier agent can display real-time inventory levels per department
- Demonstrate replenishment actions result in updated inventory values in the net inventory count table
- Verify Azure AI Search reflects the updated inventory counts for specific SKUs
- Verify the agent retrieves updated values from MCP services and responds accurately after inventory changes

## Learning Resources

- [Working with Apache Flink SQL in Confluent Cloud](https://docs.confluent.io/cloud/current/flink/get-started/index.html)
- [Using Azure AI Search as a real-time index](https://learn.microsoft.com/azure/search/search-what-is-azure-search)
- [Schema Registry and data contracts](https://docs.confluent.io/platform/current/schema-registry/index.html)
- [Kafka Connect Source and Sink Connectors](https://docs.confluent.io/cloud/current/connectors/index.html)
