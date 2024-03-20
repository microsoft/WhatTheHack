# Challenge 01 - Data Definition and Core Concepts for Storage

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Introduction

Just like SQL tables, Apache Kafka has topics that serves to hold the events that are sent to be stored/buffered on the Kafka cluster.
The Confluent Schema Registry is a resources that helps to keep track of the different versions of messages/events that are stored in these topics.

## Description

There are some Azure functions that have been deployed to push retail activity data into the cluster. 

These functions are currently disabled. These functions will be generating activities and events in the following categories, so we need to set up topics to store the events:
- Purchases
- Returns
- Inventory Replenishment
- Users
- Product Ratings
- Products
- Inventory on Hand

Each topic should have 4 partitions.

You will need to create topics and set up a schema registry instance and create topics for these event/message types on the cluster that will hold these event streams from the data generators (Azure Functions). 

Enable the functions and restart the function app with the correct configurations after your schema registry instance and Kafka topics have been created.

## Success Criteria

To complete this challenge successfully, you should be able to:
- Verify each of the topics listed are created using valid topic names.
- Verify that you can write events and read events from each topic using the CLI tools.
- Verify that the Schema Registry is aware of the data structure in each Kafka topic.

## Learning Resources

*Sample IoT resource links:*

- [Confluent Schema Registry](https://docs.confluent.io/platform/current/schema-registry/index.html)
- [Kafka CLI Tools](https://docs.confluent.io/kafka/operations-tools/kafka-tools.html)
- [Confluent Developer Courses](https://developer.confluent.io/learn-kafka/) 
