# Challenge 6: Deploy to devices at scale

[< Previous Challenge](./Challenge-05.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-07.md)

## Pre-requisites (Optional)

IoT Hub at scale – Deployment manifest

## Introduction

Many IoT solutions include hundred or thousands of devices, potentially running slightly different versions of base operating system or software components. Azure IoT includes support for simplified deployment of new devices and installation of software at scale. The first is achieved with the [Device Provisioning Service](https://docs.microsoft.com/en-us/azure/iot-dps/), the second with [Deployment Manifests](https://docs.microsoft.com/en-us/azure/iot-edge/module-deployment-monitoring?view=iotedge-2018-06) and integration with DevOps.

This challenge focuses on Deployment Manifests used together with devices running Azure IoT Edge.

## Description

In the previous challenges, you have installed the OPC Simulator by directtly adding it to the VM running IoT Edge in the Azure Portal. An alternative to doing this is creating a **deployment manifest** and then telling Azure IoT Hub to apply it to a set of devices according to some rule (e.g., devices in a given region or with a given set of capabilities).

The deployment manifest is a Json file that specifies a set of modules (i.e., docker containers) that must be downloaded/executed. It also specifies a set of related properties/configurations such as routes, and also includes the two base modules that are part of Azure IoT Edge: `edgeHub` and `edgeAgent`.

In this challenge, you'll provision a new VM running Azure IoT Edge, simulating an IoT device, create a Deployment Manifest to deploy a few sample modules, and deploy it to the new VM using a targetted deployment.

## Success Criteria

## Learning Resources

## Tips (optional)

## Advanced Challenges (Optional)

the devops pipeline inside the portal?