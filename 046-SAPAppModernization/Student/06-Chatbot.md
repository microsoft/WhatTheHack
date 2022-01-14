# Challenge 6: SAP Chatbot

[< Previous Challenge](./05-PrivateLink.md) - **[Home](../README.md)** - [Next Challenge >](./07-EventDriven.md)

## Introduction
Your existing app service front end poses a nice interface into the SAP world. Often they get deployed or embedded into internal enterprise portals for discovery and governance purposes. In the Microsoft eco systems there is no place better than the Teams Client to achieve this. Speaking of Teams: using natural language to query your SAP? Any interested? In this challenge you will implement a bot service that can leverage your existing infrastructure and process OData calls.

## Description
- Familiarize yourself with this [repos](https://github.com/ROBROICH/Teams-Chatbot-SAP-NW-Principal-Propagation).
- Setup your Azure Bot development environement (or Power Virtual Agent if you prefer and available).
- Consider moving your APIM instance from early challenges to "hybrid" mode (external but VNet integrated). You could also front it with Azure Application Gateway and keep APIM "internal".

## Success Criteria
- Functional message flow using the Bot simulator (actual deployment to Azure and Teams client cherry on the cake).
- Parameterized SAP OData request and Response using a [Microsoft Adaptive Card](https://adaptivecards.io/).
- Optional: deploy your bot to Teams and see the SAP message flow in your client.

## Learning Resources
- [Hands-On Lab: Implementing a Node.JS client as Azure Bot and leveraging principal propagation between Azure and SAP Netweaver OData services](https://github.com/ROBROICH/Teams-Chatbot-SAP-NW-Principal-Propagation)
- [Hands-On Lab: Combining the Microsoft-Graph and SAP-Graph in a Microsoft Teams and Azure Bot scenario](https://github.com/ROBROICH/TEAMS-Chatbot-Microsoft-SAP-Graph)
- [Alternative using Power Virtual Agent and on-prem components](https://blogs.sap.com/2021/04/13/principal-propagation-in-a-multi-cloud-solution-between-microsoft-azure-and-sap-business-technology-platform-btp-part-iv-sso-with-a-power-virtual-agent-chatbot-and-on-premises-data-gateway/)
