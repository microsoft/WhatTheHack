# Challenge 1: Deploy IoTHub/Edge

**[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Pre-requisites 
For this challenge you will need the following:

- - Access to an Azure subscription with Owner access
  - If you don't have one, [Sign Up for Azure HERE](https://azure.microsoft.com/en-us/free/)
- [**Windows Subsystem for Linux (Windows 10-only)**](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
- [**Azure CLI**](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
  - (Windows-only) Install Azure CLI on Windows Subsystem for Linux
  - Update to the latest
  - Must be at least version 2.7.x
- Alternatively, you can use the [**Azure Cloud Shell**](https://shell.azure.com/)
- [**Visual Studio Code**](https://code.visualstudio.com/)
- [**Azure IoT Tools**](https://marketplace.visualstudio.com/items?itemName=vsciot-vscode.azure-iot-tools) extension for Visual Studio Code

- A SSH client installed. On Windows, this is available out-of-the-box in recent builds of Windows 10 and in the Windows Subsystem for Linux (both 1 and 2). You can also download a simple client if needed, such as [PuTTY](https://www.putty.org/). It should also be available out-of-the-box in most Linux distributions and MacOS.

- .NET Core SDK 2.1.0 or later installed on your development machine. This can be downloaded from [here](https://www.microsoft.com/net/download/all) for multiple platforms.


## Introduction
 This is the first step of getting an environment setup to work from. This will be a straightforward challenge to ensure you have your subscription setup and to devise a plan to work with your team if you're working as part of a group. This will be used to work as the starting point for IoT Edge communication in subsequent modules. 

## Description
In this challenge you will establish all necessary cloud components needed to deploy an Edge device. Consideration should be given to using automated deployment/provisioning capabilities of Azure IoT hub as a means to gain insight into activity occurring within the plant with an Edge endpoint & provision of a virtual IoT edge device.  

Azure IoT Hub will be needed that is created in **one of the regions where Device Streams are available**. At the time of writing, these are: 
  - Central US
  - Central US EUAP (Early Updates Access Program)
  - North Europe
  - Southeast Asia. 
     
Check for the updated list of supported regions here: [Device Streams: Regional availability](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-device-streams-overview#regional-availability).

## Success Criteria
  - IoT Hub created
  - IoT Edge Device Endpoint created in the hub
  - Ability to show what the device connection string is
  - Provisioning a 'virtual' IoT Edge Device

## Learning Resources
1. [Azure IoT Hub](https://docs.microsoft.com/en-us/azure/iot-hub/)
1. [Azure IoT Edge](https://docs.microsoft.com/en-us/azure/iot-edge/about-iot-edge?view=iotedge-2018-06)
1. [Azure Industrial IoT modules](https://azure.github.io/Industrial-IoT/)
1. [IoT Edge Background Deck for WTH](../Coach/Presentations/IoTHub_Edge.pptx?raw=true)


## Advanced Challenges (Optional)
Consider using [Device Provisioning service](https://docs.microsoft.com/en-us/azure/iot-dps/) as a means to provision/attest the IoT Edge device to connect to a hub.  There are a number of ways in which this can be done and would demonstrate how this could be implemented to better support provisioning devices at scale.
