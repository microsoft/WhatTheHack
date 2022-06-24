# Challenge 08 - Azure integration, Logic Apps and EAI

[< Previous Challenge](./Challenge-07.md) - **[Home](../README.md)** 

## Introduction
At this point we will talk about other methods of streaming and sending data to and from SAP systems using Azure as an integration 'Broker'.

## Description
We can use SAP's gateway services and Logic Apps to directly call existing code from Azure services in a convenient manner.

Install a new Virtual Machine into your vnet or use an existing already running Windows VM and install the Logic Apps On-premises data gateway [instructions here](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-gateway-install)
Once installed, connect it back to your logic apps account to authorize it.
Create a new Azure Logic App using the request trigger and use the SAP connector to invoke an SAP business process. There is a tutorial on this [here](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-using-sap-connector))
 
## Success Criteria
- Working logic app invoking an SAP RFC or BAPI module remotely and returning data.

## Stretch Goals
- An Integrated application remotely calling the SAP Connector and reading/updating data using an RFC/BAPI
- Insertion of an SAP IDoc via the SAP Connector.
- Protect your logic app with Azure API Management to avoid potentially opening an additional attack vector into your SAP system.

## Learning Resources
- [ABAP SDK for Azure](https://github.com/Microsoft/ABAP-SDK-for-Azure)
- [Logic Apps SAP Connector](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-using-sap-connector)
- [SAP Connector Reference](https://docs.microsoft.com/en-us/connectors/sap/)
