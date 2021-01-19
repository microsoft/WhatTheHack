# Challenge 3: Deploy Industrial IoT solution

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Pre-requisites (Optional)
+ Creation of IoT Hub + Edge device
+ Deployment of OPC endpoint to an endpoint the Edge device has network permission to connect


## Introduction
Now that Contoso has a device installed in their plant and cloud services deployed to interact with the Edge device; we will need to deploy services onto the Edge device using the Edge Docker modules allowing communication via OPC from the simulated Plant-floor PLC machine in Challenge-2 to the Edge.  This involves building deployments of modules to the Edge to facilitate the communication and properly configuring the Edge modules to load a configuration on start that will ingest OPC data changes from the PLC and push them into the cloud.

## Success Criteria
1. Creation of IoT Hub and Edge device in the Azure portal and the ability to describe where to navigate to find keys/connection strings and validation of understanding on how IoT Edge module would be deployed to the device.
1. Creation of an IoT Edge device on a VNET in Azure (Linux VM Strongly recommended as IoT Edge was designed/built on Linux; but Windows would work)
1. Configuration of IoT Edge Runtime to communicate with deployed hub in an automated fashion (preferred)
1. Configuration of OPC module(s) as per documentation -- this requires customization to the deployment/modules running on the Edge as shown in the tips below.
1. Demonstrate how to view logs of running modules on the hub and see the current status from the portal.
1. Demonstration of adding tags, adjust polling intervals and define the names for published values to IoT hub.
1. Walkthrough of the OPC module(s) and what they are used for.
1. Explanation from the team on what protocol was choose to communicate to IoT hub and what ports at the Contoso's plants would need to be opened


## Tips (optional)
* Documentation on OPC Publisher Module -- challenging to locate
    - https://github.com/Azure/iot-edge-opc-publisher/blob/main/CommandLineArguments.md
    - https://github.com/azure/iot-edge-opc-publisher
* [IoT Edge Runtime components ](https://docs.microsoft.com/en-us/azure/iot-edge/how-to-install-iot-edge?view=iotedge-2018-06&tabs=windows)

## Advanced Challenges (Optional)
Consider using [Device Provisioning service](https://docs.microsoft.com/en-us/azure/iot-dps/) as a means to provision/attest the IoT Edge device to connect to a hub.  There are a number of ways in which this can be done and would demonstrate how this could be implemented to better support provisioning devices at scale.