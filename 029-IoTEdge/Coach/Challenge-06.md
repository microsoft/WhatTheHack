# Challenge 6: Deploy to devices at scale 
[< Previous Challenge](./Challenge-05.md) - **[Home](README.md)** - [Next Challenge >](./Challenge-07.md)
## Notes & Guidance

Detailed steps:

1. Create a new IoT Edge device on your IoT Hub
1. Add a tag to the new device's *device twin*: `environment` with value `development`. This will allow you to do a targeted deployment later on. 
1. Deploy a new VM running Azure IoT Edge, in the same region/resource group you've used before
    - After deployment, SSH to the VM and confirm that iotedge is running and check its version. It should be the latest (at the time of writing, 1.0.10.4).
    - Check what module(s) are running on the device and understand *why*, comparing with what you see in the IoT Edge device page in your IoT Hub, on the Azure Portal
1. Create a new deployment manifest. This deployment manifest should include the following modules:

    - `edgeHub` and `edgeAgent` (IoT Edge's system modules)
    - OPC Simulator module (from a previous challenge) and any required routes/configurations
    - Simulated Temperature Sensor module and any required routes (*note: this does not require building the container, you should use the Microsoft-provided one*)

1. Using either the Azure CLI or the Azure Portal, deploy your deployment manifest. **Make sure to specify a target condition such that only devices with `environment` equal to `development` will receive the deployment**.

    - You can test the targeting condition using the *query editor* in the IoT Hub page that lists the IoT Edge devices.

1. Access the new IoT Edge device via SSH and confirm that the modules running are the ones you specified in your deployment manifest.

1. Access the IoT Edge device you created in the previous challenges and confirm that the modules running there have not been modified.