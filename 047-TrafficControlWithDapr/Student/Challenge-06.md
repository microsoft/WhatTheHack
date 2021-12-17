# Challenge 6 - Add a Dapr input binding

[< Previous Challenge](./Challenge-05.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-07.md)

## Introduction

In this assignment, you're going to add a Dapr **input binding** in the TrafficControlService. It'll receive entry- and exit-cam messages over the MQTT protocol.

## Description

In this assignment you'll focus on Dapr input bindings. The following diagram depicts how input bindings work:

<img src="../images/Challenge-06/input-binding.png" style="zoom: 50%;padding-top: 40px;" />

For this hands-on assignment, you will add an input binding leveraging the Dapr binding building block. In the previous assignment, you implemented a Dapr input binding. 

## Success Criteria

To complete this assignment, you must reach the following goals:

- The TrafficControlService uses the Dapr MQTT input binding to receive entry-cam and exit-cam messages over the MQTT protocol.
- The MQTT binding uses the lightweight MQTT message broker Mosquitto that runs as part of the solution in a Docker container.
- Azure IoTHub & EventHub can be substituted as the MQTT message broker.
- The Camera Simulation publishes entry-cam and exit-cam messages to the MQTT broker.

This assignment targets the operation labeled as **number 5** in the end-state setup:

**Local**

<img src="../images/Challenge-06/input-binding-operation.png" style="zoom: 67%;padding-top: 25px;" />

**Azure**

<img src="../images/Challenge-06/input-binding-operation-azure.png" style="zoom: 67%;padding-top: 25px;" />

### DIY instructions

First open the `src` folder in this repo in VS Code. Then open the [Bindings documentation](https://docs.dapr.io/developing-applications/building-blocks/bindings/) and start hacking away. As MQTT broker, you can use the lightweight MQTT broker [Mosquitto](https://mosquitto.org/). You can also use Azure IoT Hub & Event Hub.

## Learning Resources

- [Introduction to this building block](https://docs.dapr.io/developing-applications/building-blocks/bindings/)
- [Bindings chapter](https://docs.microsoft.com/dotnet/architecture/dapr-for-net-developers/bindings)
- [Dapr for .NET developers](https://docs.microsoft.com/dotnet/architecture/dapr-for-net-developers/)
