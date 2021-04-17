# Challenge 7: Connect to Devices with Device Streams

[< Previous Challenge](./Challenge-06.md) - **[Home](../README.md)**


## Introduction

When you get to this challenge, you'll have used several of the core capabilities of Azure IoT and Azure IoT Edge, as well as some of the ecosystem services what are frequently used together with them, such as Azure Stream Analytics or Timeseries Insights. And if you have done IoT before, you'll know that Device Monitoring and Diagnosing problems are high on the list of requirements for production deployments.

The goal of this challenge is to experiment with a simple and secure way of connecting remotely to devices connected to Azure IoT Hub to check on their status, using one of the preview capabilities of Azure IoT Hub: **Device Streams**. You'll then lock down inbound traffic to the firewall to test this capability and confirm it's not impacted.

## Description

The [Device Streams documentation](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-device-streams-overview) has a complete description of how Device Streams work. In a simplified way, they allow clients to connect to devices via the bi-directional connection established from the device to an Azure IoT Hub. This connection is outbound (opened by the device), and thus even if a firewall blocks inbound connections, the remote connections will still be possible. You will need to have something running in the device (which we'll call "device-local proxy") to handle these connections.

For this challenge, you'll be using Device Streams to set up an SSH connection to the simulated IoT Device you've been using, and then locking down firewall to confirm that a connection is still possible.

Steps:

1. Run the steps of the quickstart [Enable SSH and RDP over an IoT Hub device stream by using a C# proxy application (preview)](https://docs.microsoft.com/en-us/azure/iot-hub/quickstart-device-streams-proxy-csharp#ssh-to-a-device-via-device-streams), in particular the section "SSH to a device via device streams". Make sure you test them and that you are able to run commands on the device via the Device Streams tunnel.
1. Block inbound SSH traffic (port 22) in your IoT Device and confirm the device is still reachable using what you created for step 1, but not if you try to reach it directly via its IP.
1. Check the Advanced Challenge if you want to have the device-local proxy running as a Linux system service.

After completing the steps above, you'll have learned about Device Streams and how they allow you to leverage Azure IoT Hub in its security and networking capabilities to remotely connect into devices without requiring third party software. The Advanced Challenge guides you through getting the device-local proxy running as a service so that it's always available.

## Success Criteria

- You are able to successfully connect via SSH over IoT Hub to your simulated IoT Device
- You have closed down SSH on the firewall and the connection was not impacted

## Learning Resources

- [IoT Hub Device Streams (Microsoft Docs)](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-device-streams-overview)
- [Introduction to Azure IoT learning path (Microsoft Learn)](https://docs.microsoft.com/en-us/learn/paths/introduction-to-azure-iot/)

## Tips

- When running the quickstart, before building the code, if you have a recent version of .Net Core, make sure the .csproj file for the device-local proxy (`~/devicestreams/iot-hub/Quickstarts/device-streams-proxy/device`) has `TargetFramework` as `netcoreapp3.1`.
- If you're installing .Net Core for the first time, you'll need to do a reboot.

## Advanced Challenges (Optional)

You're now able to connect to the device via SSH over the connection established to the Azure IoT Hub. However, the connection will only be available while the application on the device is running.

To have it permanently available you have to have it running as a system service in Linux. For this, follow the next steps. After completion, reboot the simulated IoT device and try connecting again.

The following steps must be executed in the simulated IoT Device (i.e., running Linux). They were tested on Ubuntu only.

1. From the folder with the device-local proxy (`~/devicestreams/iot-hub/Quickstarts/device-streams-proxy/device`), build/publish the code with:

    ```bash
    sudo dotnet publish --configuration Release --output /usr/bin/dlpsvc
    ```

1.	Create a SystemD service file and start the device-local proxy service

    - Change directory into the SystemD folder (`/lib/systemd/system`) and open a new file with the Nano/Vim text editor

        ```bash
        sudo nano dlpsvc.service
        ```

    -  Add the following contents manually to the file and ensure that you fill in the `{iot_hub_device_connection_string}` field with the appropriate value (note it’s the **device’s** connection string, not the IoT Hub’s connection string):

        ```
        [Unit]
        Description="Device Local Proxy Service"
        After=network.target
        [Service]
        ExecStart=/usr/bin/dotnet /usr/bin/dlpsvc/DeviceLocalProxyStreamingSample.dll "{iot_hub_device_connection_string}" localhost 22
        Restart=always
        [Install]
        WantedBy=multi-user.target
        ```

    - Reload SystemD and enable the service, so it will restart on reboots:

        ```
        sudo systemctl daemon-reload
        sudo systemctl enable dlpsvc
        ```

    - Start service

        ```
        sudo systemctl start dlpsvc
        ```

    - View service status

        ```
        systemctl status dlpsvc
        ```
    - View detailed service logs
        ```
        journalctl --unit dlpsvc --follow
        ```

After you have completed these steps, you're ready to test.

1. Test the SSH connection, to confirm it's working
1. Reboot the simulated IoT device
1. Test the SSH connection again and confirm it came back up and that you can connect.


