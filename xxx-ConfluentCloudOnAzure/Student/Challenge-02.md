# Challenge 02 - Data Manipulation Reading and Writing Data Directly with Topics

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

When interacting with Kafka topics, clients generally fall into two categories:
- Producers
- Consumers

An Apache Kafka® Producer is a client application that publishes (writes) events to a Kafka cluster.

The producer is thread safe and sharing a single producer instance across threads will generally be faster than having multiple instances.

It typically publishes messages to topics as key-value pairs. The keys are used to route the events to different partitions of that topic.

A Kafka Consumer is a client that consumes or reads records from a Kafka cluster. This client transparently handles the failure of Kafka brokers, and transparently adapts as topic partitions it fetches migrate within the cluster. This client also interacts with the broker to allow groups of consumers to load balance consumption using consumer groups. The consumer maintains TCP connections to the necessary brokers to fetch data. Failure to close the consumer after use will leak these connections. The consumer is not thread-safe. See Multi-threaded Processing for more details.

## Description

Contoso Retail needs to create two Kafka clients that can perform the tasks of continually writing a review by sending in a rating between 1 to 5 stars every 15 seconds for a random product (1 out of 10 products in the database). This app will pick a random user out of the Cosmos DB database to write the review (rating) each time.

The first Kafka client will do the following:
- Create a product rating entry containing the product id, user id, rating and current date.
- Rating score should be between 1 and 5 inclusive
- Sent to the Product Ratings topic

The second Kafka client should do the following, combining data from the Cosmos DB collections:
- Retrieve the product rating from the topic as soon as it is written
- Display the full name, email address and country of the user as well as the full price, product name and rating of the product.
- Also display the offset, the key, partition id where the rating event was stored
- Start with one consumer, then 2 consumers and then increase to 7 consumers. Make a note of what you observe when the number of consumers exceed the number of partitions in the topic.

## Success Criteria

To complete this challenge successfully, you should be able to:
- Verify that the clients are able to write successfully to the topics
- Verify that the clients are able to read successfully from the topics
- 

## Learning Resources
- [Kafka Consumer](https://docs.confluent.io/platform/current/clients/consumer.html)
- [Kafka Producer](https://docs.confluent.io/platform/current/clients/producer.html)
- [Schemas and Serializers](https://docs.confluent.io/platform/current/clients/app-development.html)
