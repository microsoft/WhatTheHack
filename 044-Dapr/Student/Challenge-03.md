# Challenge 3 - Add pub/sub messaging

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Introduction

In this assignment, you're going to add Dapr **publish/subscribe** messaging to send messages from the TrafficControlService to the FineCollectionService.

## Description

In assignment 2, you implemented direct, synchronous communication between two microservices. This pattern is common when an immediate response is required. Communication between service doesn't always require an immediate response.

The publish/subscribe pattern allows your microservices to communicate asynchronously with each other purely by sending messages. In this system, the producer of a message sends it to a topic, with no knowledge of what service(s) will consume the message. A message can even be sent if there's no consumer for it.

Similarly, a subscriber, or consumer, will receive messages from a topic without knowledge of what producer sent it. This pattern is especially useful when you need to decouple microservices from one another. See the diagram below for an overview of how this pattern works with Dapr:

<img src="../.img/Challenge-03/pub-sub.png" style="zoom: 66%;padding-top: 50px;" />

## Success Criteria

To complete this assignment, you must reach the following goals:

1. The TrafficControlService sends `SpeedingViolation` messages using the Dapr pub/sub building block.
1. The FineCollectionService receives `SpeedingViolation` messages using the Dapr pub/sub building block.
1. Use RabbitMQ as pub/sub message broker that runs as part of the solution in a Docker container.
1. Replace it with Azure Service Bus as a message broker without code changes.

This assignment targets the operations labeled as **number 2** in the end-state setup:

<img src="../.img/Challenge-03/dapr-setup-assignment03.png" style="zoom: 67%;" />

## Tips

You might want to create the Azure resources first as sometimes it takes some times for the resources to be ready.

## Learning Resources

[Dapr documentation for publish / subscribe](https://github.com/dapr/docs)

[Azure Service Bus Messaging - Overview](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-messaging-overview)

[Dapr and Azure Service Bus](https://docs.dapr.io/reference/components-reference/supported-pubsub/setup-azure-servicebus/)

[Dapr and RabbitMQ](https://docs.dapr.io/reference/components-reference/supported-pubsub/setup-rabbitmq/)

