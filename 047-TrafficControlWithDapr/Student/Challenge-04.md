# Challenge 4 - Add Dapr state management

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

## Introduction

In this challenge, you're going to add Dapr **state management** in the TrafficControl service to store vehicle information.

## Description

Dapr includes APIs that support stateful, long-running services with key/value storage. Services can use these APIs to leverage a variety of popular state stores, without adding or learning a third party SDK.

Furthermore, the Dapr state management building block provides several other features that would otherwise be complicated and error-prone to build yourself:

- Distributed concurrency and data consistency
- Retry policies
- Bulk CRUD operations

The following diagram shows the high level architecture:

![](../images/Challenge-04/state_management.png)

Right now, this is all you need to know about this building block. If you want to get more detailed information, read [introduction to the state management building block](https://docs.dapr.io/developing-applications/building-blocks/state-management/).


## Success Criteria

To complete this challenge, you must reach the following goals:

- The `TrafficControlService` saves the state of a vehicle (`VehicleState` class) using the state management building block after vehicle entry.
- The `TrafficControlService` reads and updates the state of a vehicle using the state management building block after vehicle exit.
- The final solution uses Azure Cache for Redis as a state store

This challenge targets the operation labeled as **number 3** in the end-state setup:

![](../images/Challenge-04/dapr-setup-assignment4.png)

## Learning Resources

- [Introduction to the state management building block](https://docs.dapr.io/developing-applications/building-blocks/state-management/)
- [Dapr Redis State Store](https://docs.dapr.io/reference/components-reference/supported-state-stores/setup-redis/)
- [Configure Azure Redis for cach in Dapr](https://docs.dapr.io/getting-started/configure-state-pubsub/#tabs-3-azure)
