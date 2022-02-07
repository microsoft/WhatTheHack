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

- Challenge 0: [Pre-requisites - Get Set for Success](Student/00-prereqs.md)

- Challenge 1: [Rapid SAP Deployment.](Student/01-SAP-Auto-Deployment.md)

### Connect an application to your SAP Environment and consume data

- Challenge 2: [.net web frontend with OpenAPI and OData via APIM](Student/02-OpenAPIAndOdata.md)

- Challenge 3: [Geode Pattern: Global Caching and Replication of SAP Source Data](Student/03-GeodePattern.md)

### Apply common security and identity patterns to control and restrict access to your services

- Challenge 4: [Azure AD Identity - Azure AD and SAP Principal Propagation](Student/04-AzureADPrincipalPropagation.md)

- Challenge 5: [Private Link and Private Endpoint Communications for SAP](Student/05-PrivateLink.md)

### Consume your SAP data and events to drive business outcomes from your applications

- Challenge 6: [Self-service chatbot using data from SAP S/4 HANA system.](Student/06-Chatbot.md)

- Challenge 7: [Event Driven Application reacting to SAP Business Events](Student/07-EventDriven.md)

### Flow data between SAP and third party systems over Azure Integration Services

- Challenge 8: [Azure Integration, Logic Apps and EAI](Student/08-IntegrationWithAIS.md)

## Repository Contents
- `../Student`
  - Student Challenge Guides
- `../Student/Resources`
  - Student's resource files, code, and templates to aid with challenges

## Contributors
- Will Eastbury
- Martin Pankraz
- Vinod Desmuth
- Christof Claessens
- Jelle Druyts
- Martin Raepple 
