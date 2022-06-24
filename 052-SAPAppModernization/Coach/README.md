# What The Hack - SAP App Modernization - Coach Guide

## Introduction

Welcome to the coach's guide for the SAP App Modernization What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides
- Challenge 00: **[Pre-requisites - get set for success](./Solution-00.md)**
	 - Check that your team has followed the pre-requisites and are setup for success before we begin.
- Challenge 01: **[Rapid SAP deployment](./Solution-01.md)**
	 - Deploy a functional SAP S/4 HANA Instance via the SAP Cloud Appliance Library (CAL).
- Challenge 02: **[.NET Web frontend with OpenAPI and OData via APIM](./Solution-02.md)**
	 - Connect a .net frontend application to your new SAP S/4 HANA Instance.
- Challenge 03: **[Geode Pattern: Global Caching and replication of SAP source data](./Solution-03.md)**
	 - Accelerate and offload SAP data via global data caches using CosmosDB and Azure FrontDoor.
- Challenge 04: **[Azure AD Identity - Azure AD and SAP principal propagation](./Solution-04.md)**
	 - Extend your corporate Azure Active Directory services into SAP for Authorization of your apps.
- Challenge 05: **[Private link and private endpoint communications for SAP](./Solution-05.md)**
	 - Deploy SAP Environments with no external attack surface inside your VNet.
- Challenge 06: **[Self-service chatbot using data from SAP S/4 HANA system](./Solution-06.md)**
	 - Adding AI to SAP Systems.
- Challenge 07: **[Event-driven notifications from SAP business events](./Solution-07.md)**
	 - Moving to an event-driven messaging service architecture to allow your business to be flexible.
- Challenge 08: **[Azure integration, Logic Apps and EAI](./Solution-08.md)**
	 - Classic integration with Logic Apps and the SAP Gateway solutions - invoke and run your SAP ABAP code remotely.

## Coach Prerequisites 

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.  

### Additional Coach Prerequisites

Check the following repos are available and accessible as the hack will be significantly accelerated by having these samples available.

- [Azure SAP OData Reader](https://github.com/MartinPankraz/AzureSAPODataReader)
- [Teams Chatbot and SAP Principal Propagation](https://github.com/ROBROICH/Teams-Chatbot-SAP-NW-Principal-Propagation)
- [Xbox Shipping](https://github.com/thzandvl/xbox-shipping)

## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

- Every team should have an Azure subscription with at least $650 credit available. Any team member can share a subscription with other members by providing contributor access to other team members.
- Each team also requires access to the Microsoft Power Platform. At least one team member should have [M365 E5 subscription](https://go.microsoft.com/fwlink/p/?LinkID=698279)  and add other team members temporarily during the hack. Each team member should have licenses for Microsoft Power Apps plan 2 Trial, for Microsoft Power Automate free and ideally a Microsoft 365 E5 developer tenant.
- [Challenge 1](../Student/Challenge-01.md), the Participant will need authorization to create an Azure Active Directory Service Principal with the Contributor Role (or have one provided prior to beginning the challenge). 
- Challenge 1, one of the participants will require access to the [SAP Cloud Appliance Library](https://cal.sap.com) with an appropriate user linked to their subscription. That can be either an S-User given to you by your admin or a so called P-User, that you can create from the SAP community yourself. For the P-User navigate to the [SAP community](https://community.sap.com/), click login and register a new user, activate it using the activation email. Depending on existing relationships to [SAP Universal ID](https://account.sap.com/core/create/landing), you will need to use that password.
- All team members can use a default Power App environment or if your license permits can create other environments.
- (Optionally) Identify or deploy a [developer instance of Azure APIM](https://docs.microsoft.com/en-us/azure/api-management/get-started-create-service-instance) to save time.

## Repository Contents

- `./Coach`
  - Coach's Guide and related files
- `./Student`
  - Student's Challenge Guide
