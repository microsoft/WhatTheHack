# Challenge 6: Deploy to devices at scale

[< Previous Challenge](./Challenge-05.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-07.md)


## Introduction

Production IoT solutions typically include hundreds or thousands of devices, potentially running slightly different versions of the base operating system or software components. Azure IoT includes support for simplified deployment of new devices and for the installation of software/updates at scale. The first is achieved with the [Device Provisioning Service](https://docs.microsoft.com/en-us/azure/iot-dps/), the second with [Deployment Manifests](https://docs.microsoft.com/en-us/azure/iot-edge/module-deployment-monitoring?view=iotedge-2018-06) and integration with DevOps.

This challenge focuses on **Deployment Manifests**, showing you how to do deployments at scale to devices running Azure IoT Edge.

## Description

In the previous challenges, you have installed the OPC Simulator by directly adding it to the VM running IoT Edge in the Azure Portal. An alternative to doing this is creating a **deployment manifest** configuration and then telling Azure IoT Hub to apply it to a set of devices according to some targeting rule (e.g., devices in a given region or with a given set of capabilities).

The deployment manifest is a Json file that specifies a set of modules (i.e., docker containers) that must be downloaded/executed - including the two base modules that are part of Azure IoT Edge: `edgeHub` and `edgeAgent`. It also specifies a set of related configurations such as routes (how to route messages inside the device and into IoT Hub) or what folders to map between the modules and the device.

In this challenge, you'll provision a new VM running Azure IoT Edge, simulating an IoT device, create a Deployment Manifest to deploy a few sample modules, and push the deployment to the new device VM using a targeted deployment.

High-level steps:

1. Provision a new Ubuntu VM running the latest version of IoT Edge and add it to an IoT Hub. You'll want to do a targeted deployment later on, so you'll want to look at adding a tag in the device twin properties.

1. Create a new deployment manifest. This deployment manifest should include the following modules:

    - OPC Simulator module (from a previous challenge) and any required routes/configurations
    - Simulated Temperature Sensor module and any required routes

1. Push the deployment manifest to the IoT Hub, making sure that you only target the tag you created in step 1, i.e., only the devices with that tag receive the deployment.

1. Check the new IoT Edge device confirm that the modules running are the ones you specified in your deployment manifest.

1. Check the IoT Edge device(s) you created in the previous challenges and confirm that the modules running there have not been modified.

After completing the steps above, you'll have learned about Deployment Manifests and using Device Twin properties of edge devices for targeted deployments. These are the core components of deploying to IoT devices at scale in Azure. The Advanced Challenge shows you how to integrate this with a CI/CD pipeline.

## Success Criteria

- A deployment manifest has been created and deployed, applying to subset of IoT Edge devices
- The new IoT Edge device VM has the 4 modules listed above running on it
- The previously created IoT Edge device VM has not been modified and will still be running the previously installed modules

## Learning Resources

- [Learn how to deploy modules and establish routes in IoT Edge](https://docs.microsoft.com/en-us/azure/iot-edge/module-composition?view=iotedge-2018-06)
- [Understand IoT Edge automatic deployments for single devices or at scale](https://docs.microsoft.com/en-us/azure/iot-edge/module-deployment-monitoring?view=iotedge-2018-06)
- [Understand and use device twins in IoT Hub](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-devguide-device-twins?view=iotedge-2018-06)

## Tips

- Easy deployment of an Ubuntu VM with the latest version of IoT Edge can be achieved quickly with [Run Azure IoT Edge on Ubuntu Virtual Machines](https://docs.microsoft.com/en-us/azure/iot-edge/how-to-install-iot-edge-ubuntuvm?view=iotedge-2018-06)

- The Simulated Temperature Sensor module is available for use and published in a Microsoft-owned Azure Container Registry. It **does not** have to be built from scratch. See: <https://docs.microsoft.com/en-us/azure/iot-edge/quickstart-linux?view=iotedge-2018-06>

## Advanced Challenges (Optional)

The deployment process to IoT can be fully automated using a DevOps -- from building and publishing containers to generating a deployment manifest and pushing it with target conditions to sets of devices.

The Azure Portal's DevOps Starter includes an end-to-end example of how this can be achieved with Azure DevOps.

As part of this stretch challenge, follow the instructions here to learn about CI/CD for Azure IoT: [Create a CI/CD pipeline for IoT Edge with Azure DevOps Starter](https://docs.microsoft.com/en-us/azure/iot-edge/how-to-devops-starter?view=iotedge-2018-06) .
