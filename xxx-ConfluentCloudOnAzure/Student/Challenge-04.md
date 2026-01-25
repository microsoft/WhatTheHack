# Challenge 04 - Bringing it All Together, Processing Streams in Realtime with KSQLDB

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

## Introduction
Kafka Streams is a client library for processing and analyzing data stored in Kafka. It builds upon important stream processing concepts such as properly distinguishing between event time and processing time, windowing support, and simple yet efficient management and real-time querying of application state

ksqlDB is a database that's purpose-built for stream processing applications. It is built on top of Kafka Streams and provides a SQL interface for defining and processing streams from Kafka topics and writing them back to destination topics.

## Description

In this challenge, our goal is to figure out in near-real-time how much inventory we have on-hand based on the activities from the following event streams:
- Inventory Replenishment
- Order Returns/Refunds
- Product Purchases from new orders

We will use events from 3 topics to compute in real time the amount of inventory at hand based on purchases, returns and replenishment events and store this data in a new topic called Inventory on Hand. This will have the name of the product, the product identifier and how much inventory we have on hand (an integer)

We will also create a new topic that stores the current top 5 products based on ratings at any given time. This topic will contain the following pieces of data
- Product name
- Unit Price
- Total Ratings: how many customers rated the product
- Highest Rating
- Lowest Rating
- Most Recent Rating
- Rating Score (average of all ratings so far)


## Success Criteria

To complete this challenge successfully, you should be able to:
- Verify that the inventory counts are accurate based on retail purchases, returns and inventory replenishment.
- Verify that the ratings displayed are accurate.

## Learning Resources

- [Kafka Streams](https://kafka.apache.org/34/documentation/streams/core-concepts)
- [KSQLDB Overview](https://ksqldb.io/overview.html)
- [kSQLDB Documentation](https://docs.ksqldb.io/en/latest/)
