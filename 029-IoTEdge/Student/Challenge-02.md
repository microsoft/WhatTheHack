# Challenge 2: Deploy OPC Simulator

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Pre-requisites
+ Creation of IoT Hub + Edge device

## Introduction
Now that there's a cloud environment in place we need to build out a sample Contoso Virtual Factory.  Typically, factories and industrial control applications have Programmable Logic Controllers (PLC) running operations and the interfacing mechanism used by commercial software is via an OPC Server provided by the PLC vendor.  In this challenge, you will deploy a simulated OPC server that produces data via tags that can be referenced from the IoT Edge device in a later lab to capture.  

## Description
This challenge involves identifying software that would work to serve as a simulation environment for our plant-floor 'machine' offering a connection point that our Edge device will be able to pull data from.  There are a variety of paths that could be explored to make this work with some of them outlined in the learning resources below.  

## Success Criteria
- Deployment of an OPC UA server of some sort producing simulated data. 
- Plan for network ports that need to be opened and OPC tags that will be consumed from the Edge deployed into the factory.
- Explanation of the OPC Address that would be used to connect the IoT Edge device to

## Learning Resources
1. [Video of how tags work in a modern OPC server](https://www.inductiveuniversity.com/videos/creating-opc-tags/8.1)


## Tips
 - Options for OPC Simulators 
 1. [ProsysOPC UA Simulator](https://www.prosysopc.com/) -Free and supports many simulated endpoints
 1. [Microsoft OPC PLC Simulator](https://github.com/Azure-Samples/iot-edge-opc-plc)  - Can be deployed as a container
 

