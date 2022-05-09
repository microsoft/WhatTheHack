# What The Hack - SAP on Azure Application Modernization

## Introduction 

This hack is designed to help build skills in connecting other Azure services to SAP instances hosted on the Microsoft Azure platform. Connecting services to SAP systems hosted either on-premises or in the cloud should not be overly difficult, yet often the correct tools and processes are poorly understood and / or documented.

Following on from 042-SAPOnAzure, many SAP S/4 HANA or ECC customers wish to use Azure to build build applications and integrations that connect to or from an SAP environment to add new levels of scalability, elasticity or new features and functionality to their SAP backends. 

## Learning Objectives

The SAP on Azure Application Modernization WTH challenges will help you build on your prior knowledge of SAP and build applications and integrations that can connect SAP to Azure Services and dotnet applications using industry standard protocols such as OData, OpenApi, OAuth2, OpenID Connect. 

You will learn how to front SAP systems with Azure Gateways such as Azure API Management and how to authenticate, authorize and cache data from these services for use in modern distributed web architectures. Once you have completed these challenges you will be ready to move away from legacy ABAP-based code integrations and towards modern, open protocols.

You will then move on to building interactive applications and intelligent agents that can both consume and react to the raw data and event streams, that are produced from the SAP Platform services that you have connected to. 

## Challenges

### Setup and deploy an SAP Environment

- Challenge 00: **[Pre-requisites - Get Set for Success](./Challenge-00.md)**
	 - Check that your team has followed the pre-requisites and are setup for success before we begin.
- Challenge 01: **[Rapid SAP Deployment](./Challenge-01.md)**
	 - Deploy a functional SAP S/4 HANA Instance via the SAP Cloud Appliance Library (CAL).

### Connect an application to your SAP Environment and consume data

- Challenge 02: **[.net web frontend with OpenAPI and OData via APIM](./Challenge-02.md)**
	 - Connect a .net frontend application to your new SAP S/4 HANA Instance.
- Challenge 03: **[Geode Pattern: Global Caching and Replication of SAP Source Data](./Challenge-03.md)**
	 - Accelerate and offload SAP data via global data caches using CosmosDB and Azure FrontDoor.

### Apply common security and identity patterns to control and restrict access to your services

- Challenge 04: **[Azure AD Identity - Azure AD and SAP Principal Propagation](./Challenge-04.md)**
	 - Extend your corporate Azure Active Directory services into SAP for Authorization of your apps.
- Challenge 05: **[Private Link and Private Endpoint Communications for SAP](./Challenge-05.md)**
	 - Deploy SAP Environments with no external attack surface inside your VNet.

### Consume your SAP data and events to drive business outcomes from your applications

- Challenge 06: **[Self-service chatbot using data from SAP S/4 HANA system](./Challenge-06.md)**
	 - Adding AI to SAP Systems.
- Challenge 07: **[Event Driven Notifications from SAP Business Events](./Challenge-07.md)**
	 - Moving to an event-driven messaging service architecture to allow your business to be flexible.

### Flow data between SAP and third party systems over Azure Integration Services
- Challenge 08: **[Azure Integration, Logic Apps and EAI](./Challenge-08.md)**
	 - Classic integration with Logic Apps and the SAP Gateway solutions - invoke and run your SAP ABAP code remotely.

## Repository Contents
- `../Student`
  - Student Challenge Guides
- `../Student/Resources`
  - Student's resource files, code, and templates to aid with challenges

## Prerequisites
- Your own Azure subscription with Owner access
- Visual Studio Code
- You have an Azure, Microsoft 365 subscription
- All team members can access your Azure resource group.
- You can login to the SAP Cloud Appliance Library with your S- or P-User, which is linked to your subscription.
- All team members can login and create a Power Virtual Agents Bot. 

## Contributors
- Will Eastbury
- Martin Pankraz
- Vinod Desmuth
- Christof Claessens
- Jelle Druyts
- Martin Raepple 