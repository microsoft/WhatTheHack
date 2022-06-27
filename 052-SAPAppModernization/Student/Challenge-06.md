# Challenge 06 - Self-service chatbot using data from SAP S/4 HANA system

[< Previous Challenge](./Challenge-05.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-07.md)

## Introduction
Your existing app service front end poses a nice interface into the SAP world. Often they get deployed or embedded into internal enterprise portals for discovery and governance purposes. In the Microsoft ecosystem there is no place better than the Microsoft Teams Client to achieve this. You want to use natural language to query your SAP from Microsoft Teams? Any interest in that? In this challenge you will implement a bot service that can leverage your existing infrastructure and process OData calls.

## Description
- Familiarize yourself with this [repo](https://github.com/ROBROICH/Teams-Chatbot-SAP-NW-Principal-Propagation).
- Setup your Azure Bot development environment (Note, you can use the Azure Bot Framework SDK, Azure Bot Composer, or even Power Virtual Agents if you prefer and it's available to you.)
- You should think carefully about how your bot will connect to the SAP environment, since in the last challenge we made it private. You have a couple of options.
  - Consider moving your APIM instance from early challenges to "External" mode (this will present an External IP, but leave the APIM instance VNet integrated). 
  - You could also front the Azure APIM instance with Azure Application Gateway (or even an NVA) and keep APIM "internal".
  - Our recommendation for this challenge would be to deploy an SDK or Bot Composer bot to a VNet integrated App Service instance, that will allow you to call your private APIM instance. 
  - For a Power Virtual Agents bot, you will have to either expose your APIM instance to the outside world, or deploy a Power Automation Flow that can connect to a Connector with a Data Gateway installed on your environment. We believe this is outside the scope of this article, but it is a completely valid approach.

|| [Bot Framework SDK](https://docs.microsoft.com/en-us/azure/bot-service/bot-service-quickstart-create-bot?view=azure-bot-service-4.0&tabs=csharp%2Cvs) | [Bot Framework Composer](https://docs.microsoft.com/en-us/composer/introduction?tabs=v2x) | [Power Virtual Agent (PVA)](https://docs.microsoft.com/en-us/power-virtual-agents/teams/fundamentals-what-is-power-virtual-agents-teams) |
|----------|-------------|------|---|
| coding style |  full-code | low-code | low-code |
| programming language | C#, Java, NodeJS and Python | built-in designer with PowerFX scripting language | built-in designer with PowerFX scripting language |
| complexity | high, but fully flexible | medium, more freedom than PVA but less than SDK | low |
| required dev environment setup | IDE of choice, build-environment (e.g. NPM), simulator, etc. | shipped with Composer studio | built into Microsoft Teams |

## Success Criteria
- You should have a fully functional message flow using the Bot simulator (actual deployment to Azure and Teams client are the cherry on the cake).
- You should be able to fire a parameterized SAP OData request and your bot should be able to render the response using a [Microsoft Adaptive Card](https://adaptivecards.io/).
- Optional: deploy your bot to Teams and see the SAP message flow in your client.

## Learning Resources
- [Hands-On Lab: Implementing a Node.JS client as Azure Bot and leveraging principal propagation between Azure and SAP Netweaver OData services](https://github.com/ROBROICH/Teams-Chatbot-SAP-NW-Principal-Propagation)
- [Hands-On Lab: Combining the Microsoft-Graph and SAP-Graph in a Microsoft Teams and Azure Bot scenario](https://github.com/ROBROICH/TEAMS-Chatbot-Microsoft-SAP-Graph)
- [Alternative using Power Virtual Agent and on-prem components](https://blogs.sap.com/2021/04/13/principal-propagation-in-a-multi-cloud-solution-between-microsoft-azure-and-sap-business-technology-platform-btp-part-iv-sso-with-a-power-virtual-agent-chatbot-and-on-premises-data-gateway/)
