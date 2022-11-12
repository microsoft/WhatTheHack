# Challenge 7: Connect to Devices with Device Streams
[< Previous Challenge](./Challenge-06.md) - **[Home](README.md)** 
## Notes & Guidance

Keep this link in mind: <https://azure.microsoft.com/en-us/updates/iot-hub-device-streams-new-region-availability/> which tells you what regions are Device Streams available.

All the teams have to do is run through this: <https://docs.microsoft.com/en-us/azure/iot-hub/quickstart-device-streams-proxy-csharp> . This can also be done in Node.js <https://docs.microsoft.com/en-us/azure/iot-hub/quickstart-device-streams-proxy-nodejs> or C <https://docs.microsoft.com/en-us/azure/iot-hub/quickstart-device-streams-proxy-c>.

Remember that Device Streams are in **preview**.

Additionally:

- Block inbound SSH traffic (port 22) in your IoT Device. If you're running it in Azure, this can be with a Network Security Group (NSG) attached to a VNet. Confirm the device is still reachable.
