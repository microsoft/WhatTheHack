# Challenge 03 - Kafka Connect Ecosystem and Architecture

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Introduction

Kafka Connect is a tool for scalably and reliably streaming data between Apache Kafka® and other data systems. 

It makes it simple to quickly define connectors that move large data sets in and out of Kafka. 

Kafka Connect can ingest entire databases or collect metrics from all your application servers into Kafka topics, making the data available for stream processing with low latency. 

An export connector can deliver data from Kafka topics into secondary storage outside Kafka like Azure Cognitive Search, Cosmos DB and Blob Store


## Description

In this challenge we are going to bring in the Kafka Connect ecosystem and leverage it to stream changes from CosmosDB into Kafka as well as stream new events from the Apache Kafka topics into CosmosDB. In this challenge, create a Kafka Connect Sink and Source for the Cosmos DB resource you have deployed.

For the Cosmos DB Source Connector, configure it to stream changes from the following collections into their equivalent Kafka cluster topics
- Users
- Products

For the Cosmos DB Sink Connector, configure it to stream changes from the following topics into their equivalent Cosmos DB collections:
- Purchases
- Returns
- Inventory Replenishment
- Users
- Product Ratings
- Products
- Product Inventory Capacity (contains the expected number of inventory, the maximum and minimum)
- Inventory on Hand
- Top 5 Products


To complete this challenge successfully, you should be able to:
- Verify that all the users and products from the Cosmos DB database have been loaded into the Kafka topics.
- Verify that all the generated events have been successfully stored in the Cosmos DB collections.
- Verify that all the records from the users and products collections in Cosmos DB are accounted for in the Azure Cognitive Search instance

## Learning Resources

- [Kafka Connect 101 Course](https://developer.confluent.io/learn-kafka/kafka-connect/intro/)
- [Kafka Connect Overview](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/kafka-connector)
- [Azure Cognitive Search Sink Connector](https://docs.confluent.io/kafka-connectors/azure-search/current/overview.html)
- [Cosmos DB Source Connector](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/kafka-connector-source)
- [Cosmos DB Sink Connector](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/kafka-connector-sink)
