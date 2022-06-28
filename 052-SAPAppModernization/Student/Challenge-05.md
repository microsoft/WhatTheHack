# Challenge 05 - Private link and private endpoint communications for SAP

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-06.md)

## Introduction
Quite some progess! You have created a nice cloud native setup surrounding your SAP instance. As such it is designed to run externally whilst exposed to the Internet while still being secured. One example with global scale would be your Office365 for instance. But some times there are security regulations that prohibit such setups. In this challenge you will move your sensitive components into a private virtual network (VNet) and connect the Azure PaaS services via private endpoints.

## Description
- Integrate your app service instance with your existing SAP VNet using Regional Vnet Integration. 
- Set your Azure APIM instance's Virtual Network settings to internal mode.
- Change the configuration of your web app to point to the internal IP address of the Azure APIM instance. 
- Remove the external IP address from the SAP S/4 HANA hosting Virtual Machine to force all inbound traffic through the Azure API Management instance.
- Change the target address of the SAP OData endpoint in APIM to point to the Internal address of the SAP S/4 HANA system. 
- Connect your sourrounding services (CosmosDB, Service Bus, APIM etc.) either through VNet integration where possible or deploy private endpoints. *Note that there is a section in the docs instructions for APIM in VNet internal mode, around configuration of DNS that is CRITICAL for Private Endpoints to work.
- Test if the supporting services of your internet-facing app can now only be called from within the boundaries of your private VNet.

## Success Criteria
- Your Azure App Service website can be called from the internet, and can connect to private VNet integrated services.
- Your SAP S/4 HANA system can no longer be called from the Internet.
- Your Azure APIM system can no longer be called from the internet.
- Your surrounding services (CosmosDB, Service Bus, APIM etc.) can no longer be called from the Internet


## Optional Stretch Goals
- Lock down your Azure App Service website(s) so they can only be called from your Azure Front Door Instance.
- Apply a Rule to your Azure Front Door instance, so it can only be called from your current client hosting IP Address ranges.
 
## Learning Resources
- [MS Docs Configuring APIM to use VNet Internal mode](https://docs.microsoft.com/en-us/azure/api-management/api-management-using-with-internal-vnet)
- [Private VNet section of APIM blog post](https://blogs.sap.com/2021/08/12/.net-speaks-odata-too-how-to-implement-azure-app-service-with-sap-odata-gateway/)
- [Azure Docs on private endpoints](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview)
- [SAP BTP connectivity with Azure Private Link service](https://blogs.sap.com/2021/12/29/getting-started-with-btp-private-link-service-for-azure/)
