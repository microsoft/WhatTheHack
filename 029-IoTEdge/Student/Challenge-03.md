# Challenge 3: Deploy Industrial IoT solution

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Introduction
Now that Contoso has a device installed in their plant and cloud services deployed to interact with the Edge device; we will need to deploy services onto the Edge device allowing communication via OPC from the simulated Plant-floor 'machine' in Challenge-2 to the Edge.  This challenge involves deploying specialized modules to the Edge to facilitate the communication with a configuration that will connect and ingest OPC data changes from the Programmable Logic Controller running the 'machine' and push them into the cloud for later analysis.

## Description
In the previous challenges you should have already build the foundation for proceeding forward with ingesting data from the Plant-floor 'machine' we're simulating.  In this challenge we need to focus on deploying the necessary components required to connect to the plant-floor machine's industrial programmable logic controller (simulated) to the Edge device.  

For this challenge you should focus on the steps below to successfully establish data flow from the IoT Edge --> Cloud.

1. Creation of an IoT Edge device on a VNET in Azure HINT: Linux VM Strongly recommended as IoT Edge was designed/built on Linux; but Windows would work if desired.
1. Configuration of IoT Edge Runtime to communicate with Azure HINT: This should be done in an automated fashion -- learning resources below.
1. Configuration of OPC module(s) as per documentation HINT: This requires customization to the deployment/modules running on the Edge.
 + Documentation on OPC Publisher Module -- challenging to locate
    - https://github.com/Azure/Industrial-IoT/blob/main/docs/modules/publisher-commandline.md
    - https://github.com/azure/iot-edge-opc-publisher


## Success Criteria
- Communication flowing, in a secure manner, from the Plant-floor to Azure via an Edge device using OPC modules
- Demonstrate how to view logs of running modules on the hub and see the current status from the portal.
- Demonstration of adding tags, adjust polling intervals and define the names for published values to IoT hub.
- Walk-through of the OPC module(s) and what they are used for.
- Explanation from the team on what protocol was choose to communicate to IoT hub and what ports at the Contoso's plants would need to be opened


## Learning Resources
* [IoT Edge Automated Module Deployments](https://docs.microsoft.com/en-us/azure/iot-edge/module-deployment-monitoring?view=iotedge-2018-06)
* [IoT Edge Runtime components ](https://docs.microsoft.com/en-us/azure/iot-edge/how-to-install-iot-edge?view=iotedge-2018-06&tabs=windows)
* [Azure Industrial IoT](https://azure.github.io/Industrial-IoT/)

## Advanced Challenges (Optional)
Think about how you can better manage many IoT Edge devices in lieu of going to a singular device one by one in the portal.  [IoT Hub supports features to deploy at scale](https://docs.microsoft.com/en-us/azure/iot-edge/how-to-deploy-at-scale?view=iotedge-2018-06) -- consider exploring this as a pathway to facilitate deploying the IoT modules needed to support this challenge to your IoT Edge device.
