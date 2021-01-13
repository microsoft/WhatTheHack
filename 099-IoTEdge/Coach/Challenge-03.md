# Challenge 3: Deploy Industrial IoT solution

**[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)


## Learning Resources
This module involves participants deploying the Industrial IoT Edge modules to their Edge devices.  Use the 2 links below to understand how modules are deployed as well as documentation on the Industrial IoT solutions available from Microsoft.  
* https://docs.microsoft.com/en-us/azure/iot-edge/iot-edge-modules?view=iotedge-2018-06
* https://azure.github.io/Industrial-IoT/


Encourage participants to [use deployments](https://docs.microsoft.com/en-us/azure/iot-edge/how-to-deploy-at-scale?view=iotedge-2018-06) to deploy their modules and IoT Runtime updates to understand how this works at scale versus doing it in the portal 1 by 1 for each device.
* * * 
It would also make sense to discuss the [Device Provisioning service](https://docs.microsoft.com/en-us/azure/iot-dps) and understand how this could be used to provision Edge devices in 'plants' around the globe using TPM or certificate based attestation.  While it's too challenging to perform these tasks as part of this lab; there are some paths that could be employed to provision a VM in Azure with a virtual TPM chip.  This would be a stretch assignment but something that could be explored with advanced teams.  [Details](https://docs.microsoft.com/en-us/azure/iot-dps/concepts-tpm-attestation)
* * *

For this module to be successful, participants must have the following tasks completed:
1. Creation of IoT Hub and Edge device in the Azure portal and the ability to describe where to navigate to find keys/connection strings and validation of understanding from participants on how they plan to deploy modules to the device for Challenge 4.  Additionally, 
1. Creation of an IoT Edge device on a VNET in Azure (Linux VM Strongly recommended as IoT Edge was designed/built on Linux; but Windows would work)
1. Deployment of [IoT Edge Runtime components ](https://docs.microsoft.com/en-us/azure/iot-edge/how-to-install-iot-edge?view=iotedge-2018-06&tabs=windows)
1. Configuration of IoT Edge Runtime to 


## Tips (optional)
+ IoT Edge needs to be running the following modules:
![image info](../assets/iothub_modules.png)

+ mcr.microsoft.com/iotedge/opc-publisher:latest
+ mcr.microsoft.com/iotedge/opc-twin:latest
+ mcr.microsoft.com/iotedge/discovery:latest  

* * *  
### Configuring the OPC Publisher file
You can see the endpoint by opening the service
![image info](../assets/pn.json)




## Advanced Challenges (Optional)