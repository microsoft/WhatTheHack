# What The Hack - IoT Process Control at the Edge

## Introduction

This hack will work through a scenario where a factory...

This hack includes presentations that feature lectures introducing key topics associated with each challenge. It is recommended that the host present each lecture before attendees kick off that challenge.

## Learning Objectives


In this hack you will solve common challenges for companies planning to use Azure IoT in Industrial IoT scenarios. This includes:

**(TBD)**

1. Migrating to the cloud.
1. Containerizing an application.
1. Serverless-izing your application.
1. DevOps-ing your application.

## Challenges

- Challenge 1: **[Deploy IoTHub/Edge](Student/Challenge-01.md)** **RYAN**
  - Get familiar with the basic concepts of Azure IoT Hub and Azure IoT Edge.
  - Iot Hub Creation - Ryan
  - Edge Device creation
  - Edge Virtual Device deploy ß Linux VM w/ IoT Edge Configured

- Challenge 2: **[Deploy OPC Simulator](Student/Challenge-02.md)** **RYAN**
  - OPC Simulator deploy & Git Repo link
  - https://github.com/Azure-Samples/iot-edge-opc-plc

- Challenge 3: **[Deploy Industrial IoT solution](Student/Challenge-03.md)** - **RYAN**
  - Deploy IIoT to Edge

- Challenge 4: **[Route messages and do time-series analysis](Student/Challenge-04.md)** **RYAN/AMIT**
- IoT Routing à Event Hub --> TSI

- Challenge 5: **[Process Steaming Data](Student/Challenge-05.md)** - **ORRIN**
  - ASA – job – IoT Hub Routing
  - Route messages from IoT hub to DataLake ß Mention Data/AI WTH for follow-ups

- Challenge 6: **[Deploy devices at scale](Student/Challenge-06.md)** - **JOTA**
  - IoT Hub at scale – Deployment manifest

- Challenge 7: **[Connect to Devices with Device Streams](Student/Challenge-07.md)** - **JOTA**
  - SSH Proxy – Connect to Edge Devices using Device streams:
  - <https://github.com/MicrosoftDocs/azure-docs/blob/master/articles/iot-hub/quickstart-device-streams-proxy-c.md>

## Prerequisites

- Access to an Azure subscription with Owner access
   - If you don't have one, [Sign Up for Azure HERE](https://azure.microsoft.com/en-us/free/)
- [**Windows Subsystem for Linux (Windows 10-only)**](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
- [**Azure CLI**](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
   - (Windows-only) Install Azure CLI on Windows Subsystem for Linux
   - Update to the latest
   - Must be at least version 2.7.x
- Alternatively, you can use the [**Azure Cloud Shell**](https://shell.azure.com/)
- [**Visual Studio Code**](https://code.visualstudio.com/)
- [**Azure IoT Tools**](https://marketplace.visualstudio.com/items?itemName=vsciot-vscode.azure-iot-tools) extension for Visual Studio Code

## Repository Contents

- `../Coach/Presentations`
  - Contains all presentations listed in the Introduction above.
- `../Coach/Solutionss`
   - Example solutions to the challenges (If you're a student, don't cheat yourself out of an education!)
- `../Student`
   - Student challenges

## Contributors

- Ryan Berry
- João Pedro Martins
- Orrin Edenfield