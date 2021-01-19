# What The Hack - IoT Process Control at the Edge - Coaches Guide


## Learning Objectives

+ [Slide Deck to use for Delivery](../Student/assets/IoTHub_Edge.pptx)

In this hack you will solve common challenges for companies planning to use Azure IoT in Industrial IoT scenarios. This includes:

1. Deploying and configuring the IoT Edge runtime
1. Deploying modules to the running IoT Edge device
1. Managing/monitoring/configuring IoT Edge devices at scale from IoT Hub
1. Configuring an OPC (simulator) to generate factory data
1. Interfacing IoT Edge to the factory simulator to capture data and push to the cloud
1. Consuming data published to the cloud for analysis and reporting

## Challenges

- Challenge 1: **[Deploy IoTHub/Edge](Challenge-01.md)**
  - Get familiar with the basic concepts of Azure IoT Hub and Azure IoT Edge.
  - Iot Hub Creation
  - Edge Device creation

- Challenge 2: **[Deploy OPC Simulator](Challenge-02.md)** 
  - OPC Simulator to serve as our virtual 'factory'

- Challenge 3: **[Deploy Industrial IoT solution](Challenge-03.md)**
  - Deploy Industrial IoT platform to the IoT Edge

- Challenge 4: **[Route messages and do time-series analysis](Challenge-04.md)** 
    - Route IoT Hub data to Event Hub
    - Route Event Hub to a time series data store

- Challenge 5: **[Process Steaming Data](Challenge-05.md)**
  - Stream processing
    - Reading from IoT Hub
    - Aggregating/filtering data (querying)
    - Output data to data lake & Power BI

- Challenge 6: **[Deploy to devices at scale](Challenge-06.md)**
  - Use Deployment manifests to deploy modules to IoT Edge devices at scale

- Challenge 7: **[Connect to Devices with Device Streams](Challenge-07.md)**
  - Use Azure IoT Hub device streams (in preview) to connect to IoT Devices over SSH
  - Close down SSH connectivity in a Firewall to confirm remote access is not impacted

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
- `../Coach/`
  - Example solutions to the challenges (If you're a student, don't cheat yourself out of an education!)
- `../Student`
  - Student challenges

