# Challenge 1: Deploy IoTHub/Edge

**[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Pre-requisites 

- An Azure IoT Hub created in **one of the regions where Device Streams are available**. At the time of writing, these are: Central US, Central US EUAP (Early Updates Access Program), North Europe, and Southeast Asia. Check the updated list here [Device Streams: Regional availability](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-device-streams-overview#regional-availability).

## Introduction
 This is the first step of getting an environment setup to work from. This will be a straightforward challenge to ensure you have your subscription setup and to devise a plan to work with your team if you're working as part of a group.  This will be used to work as the starting point for IoT Edge communication in subsequent modules. 


## Success Criteria
1. IoT Hub created
1. IoT Edge Device Endpoint created in the hub
1. Ability to show what the device connection string is
1. Provisioning a 'virtual' IoT Edge Device

## Learning Resources
1. [Azure IoT Hub](https://docs.microsoft.com/en-us/azure/iot-hub/)
1. [Azure IoT Edge](https://docs.microsoft.com/en-us/azure/iot-edge/about-iot-edge?view=iotedge-2018-06)
1. [Azure Industrial IoT modules](https://azure.github.io/Industrial-IoT/)
1. [IoT Edge BackGround Deck for WTH](./assets/IoTHub_Edge.pptx)


## Tips (optional)

## Advanced Challenges (Optional)
Think about how you can better manage many IoT Edge devices in lieu of going to a singular device one by one in the portal.  [IoT Hub supports features to deploy at scale](https://docs.microsoft.com/en-us/azure/iot-edge/how-to-deploy-at-scale?view=iotedge-2018-06) -- consider exploring this as a pathway to facilitate deploying the IoT modules needed to support this challenge to your IoT Edge device.