# Challenge 01 - Provision your Integration Environment

[< Previous Challenge](./Challenge-00.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge-02.md)

## Pre-requisites (Optional)

**You should have completed Challenge 00**

## Introduction (Optional)

**You are a cloud engineer for Runva - a global health and wellness company that provides solutions for individuals who takes running as sport, providing them a platform to track running activities, analyze performance and recommend plans to help them train smarter and safer.  They are going to embark on a six-month project to modernize their integration solution hosted on-premises and migrate them to Azure integration services.  Since this is their first foray in Azure, you are tasked to create a proof-of-concept (POC) that captures several integration patterns.**


## Description

*The challenge description and details go here.  This should NOT be step-by-step but rather a simple stating of the technical goals of the challenge.  If this is more than 2-3 paragraphs, it's likely you are not doing it right.*

*Optionally, you may provide learning resources and/or tips and code snippets in the sections below. These are meant  as learning aids for the attendees to help them complete the challenge and maintain momentum as they may fall behind the rest of their squad cohorts.*

**As a cloud engineer, you would like to be able to deploy this POC environment using Infrastructure-as-Code.  You have learned that you can efficiently do this in Azure using the new language called Bicep. As a baseline, you are going to deploy API Management service as gateway for your APIs, as well as an 3 Function Apps where you would host your APIs**


## Success Criteria

*Success criteria goes here. This is a list of things an coach can verfiy to prove the attendee has successfully completed the challenge.*
**You should be able to create a set of Bicep templates that:**
**- Creates a resource group in your region of choice**
**- Deploy an API Management service in Developer tier**
**- Deploy an App Service in Standard Plan**
**- Deploy three Function Apps in the App Service Plan**

## Learning Resources

**- [Azure API Management DevOps Resource Kit](https://github.com/Azure/azure-api-management-devops-resource-kit)**
**- [For customers starting out or have simple integration scenario, use the boilerplate ARM template here](https://github.com/Azure/azure-api-management-devops-resource-kit#alternatives#:~:text=For%20customers%20who%20are%20just%20starting%20out%20or%20have%20simple%20scenarios%2C%20they%20may%20not%20necessarily%20need%20to%20use%20the%20tools%20we%20provided%20and%20may%20find%20it%20easier%20to%20begin%20with%20the%20boilerplate%20templates%20we%20provided%20in%20the%20example%20folder.)**
**- [Azure API Management](https://docs.microsoft.com/en-us/azure/api-management/api-management-key-concepts)**
**- [Quickstart: Create a new Azure API Management service instance using an ARM template](https://docs.microsoft.com/en-us/azure/api-management/quickstart-arm-template)**
**- [Azure App Service](https://docs.microsoft.com/en-au/azure/app-service/overview)**
**- [Deploy a Windows App Service using Bicep](https://github.com/Azure/bicep/tree/main/docs/examples/101/web-app-windows)**
**- [Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-overview)**
**- [What is Bicep?](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview)**
**- [Architect API integration in Azure](https://docs.microsoft.com/en-us/learn/paths/architect-api-integration/)**
**- [Azure Quickstart Templates - Create API Management Service](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.apimanagement/azure-api-management-create)**
**- [Azure Quickstart Templates - Create Function App Dedicated](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.web/function-app-create-dedicated)**


## Tips (Optional)

*Add tips and hints here to give students food for thought.*

**- Use the Azure APIM DevOps resource toolkit boilerplate ARM templates and convert them to Bicep**
**- The quick brown fox**

