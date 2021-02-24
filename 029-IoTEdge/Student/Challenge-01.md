# Challenge 1: Deploy IoTHub/Edge

**[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Pre-requisites 

- An Azure IoT Hub created in **one of the regions where Device Streams are available**. At the time of writing, these are: Central US, Central US EUAP (Early Updates Access Program), North Europe, and Southeast Asia. Check the updated list here [Device Streams: Regional availability](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-device-streams-overview#regional-availability).

## Introduction
 This is the first step of getting an environment setup to work from. This will be a straightforward challenge to ensure you have your subscription setup and to devise a plan to work with your team if you're working as part of a group.  This will be used to work as the starting point for IoT Edge communication in subsequent modules. 

## Description
In this challenge you will establish all necessary cloud components needed to deploy an Edge device.  Consideration should be given to using automated deployment/provisioning capabilities of Azure IoT hub as a means to gain insight into activity occurring within the plant.  

## Success Criteria
  - IoT Hub created
  - IoT Edge Device Endpoint created in the hub
  - Ability to show what the device connection string is
  - Provisioning a 'virtual' IoT Edge Device

## Learning Resources
1. [Azure IoT Hub](https://docs.microsoft.com/en-us/azure/iot-hub/)
1. [Azure IoT Edge](https://docs.microsoft.com/en-us/azure/iot-edge/about-iot-edge?view=iotedge-2018-06)
1. [Azure Industrial IoT modules](https://azure.github.io/Industrial-IoT/)
1. [IoT Edge BackGround Deck for WTH](./assets/IoTHub_Edge.pptx)


## Advanced Challenges (Optional)
Consider using [Device Provisioning service](https://docs.microsoft.com/en-us/azure/iot-dps/) as a means to provision/attest the IoT Edge device to connect to a hub.  There are a number of ways in which this can be done and would demonstrate how this could be implemented to better support provisioning devices at scale.
