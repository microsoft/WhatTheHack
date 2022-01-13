# Challenge 5: Private Link and Private Endpoints

[< Previous Challenge](./04-AzureADPrincipalPropagation.md) - **[Home](../README.md)** - [Next Challenge >](./06-Chatbot.md)

## Introduction
Quite some progess! You have created a nice cloud native setup surrounding your SAP. As such it is desigened to run "free" on the Internet while still being secure. One example with global scale would be your Office365 for instance. But some times there are security regulations that prohibit such setups regardless. In this challenge you will move your sensitive components into a private virtual network (VNet) and connect the Azure PaaS services via private endpoints.

## Description
- Integrate your app service with your existing SAP VNet (ensure it is set to private -> no public IPs for inbound).
- Set your Azure APIM instance to internal mode.
- Connect your sourrounding services (CosmosDB, Service Bus, APIM etc.) either through VNet integration where possible or deploy private endpoints.
- Test if the supporting services of your internet-facing app can now only be called from within the boundaries of your private VNet.

## Success Criteria
- your app service can no longer be called from the Internet
- your surrounding services (CosmosDB, Service Bus, APIM etc.) can no longer be called from the Internet

## Learning Resources
- [Private VNet section of APIM blog post](https://blogs.sap.com/2021/08/12/.net-speaks-odata-too-how-to-implement-azure-app-service-with-sap-odata-gateway/)
- [Azure Docs on private endpoints](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview)
