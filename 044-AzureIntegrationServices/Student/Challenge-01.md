# Challenge 01 - Provision your Integration Environment

[<Previous Challenge](./Challenge-00.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge-02.md)

## Pre-requisites

- You should have completed Challenge 00

## Introduction

You are a cloud engineer for Runva - a global health and wellness company that provides solutions for individuals who takes running as sport, providing them a platform to track running activities, analyze performance and recommend plans to help them train smarter and safer.  They are going to embark on a six-month project to modernize their integration solution hosted on-premises and migrate them to Azure integration services.  Since this is their first foray in Azure, you are tasked to create a proof-of-concept (POC) that captures several integration patterns.


## Description
As a cloud engineer, you would like to be able to deploy this POC environment using Infrastructure-as-Code.  You have learned that you can efficiently do this in Azure using the new language called Bicep. As a baseline, you are going to deploy API Management service as gateway for your APIs, as well as a Function App where you would host your APIs.

There are two scenarios you would like to prove:

Scenario 1: Deploy a VNET-secured AIS environment - should you need to services deployed over a private network (e.g. APIs hosted on-premises)
Scenario 2: Deploy an identity-secured AIS environment - preferred for integrating with services hosted in the cloud or publicly-accessible


## Success Criteria

As mentioned earlier, you can choose which scenario to go for you POC environment:

- Scenario 1: Deploy a VNET-secured AIS environment, you should be able to create a set of Bicep templates that:
  1. Creates a resource group in your region of choice
  1. Deploy a Virtual Network
  1. Deploy an API Management service in Developer tier, single-instance, in Internal mode. 
  1. Deploy an Application Gateway, single-instance, in Standard WAF2.
  1. Configure both APIM and Application Gateway in their respective VNET subnets.
  1. Deploy a Function App in the Elastic Premium Plan - E1 SKU
  1. Deploy Application Insights resource
  1. Configure APIM and Function app to use Application Insights resource
  1. Configure APIM Developer Portal

- Scenario 2: Deploy an identity-secured AIS environment, you should be able to create a set of Bicep templates that:
  1. Creates a resource group in your region of choice
  1. Deploy an API Management service in Developer tier
  1. Deploy a Function App in the Consumption Plan - Y1 SKU
  1. Deploy Application Insights resource
  1. Configure APIM and Function app to use Application Insights resource
  1. Configure APIM Developer Portal

## Learning Resources

- [What is Bicep?](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview)

- [Azure API Management](https://docs.microsoft.com/en-us/azure/api-management/api-management-key-concepts)
  - [Azure Quickstart Templates - Create API Management Service](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.apimanagement/azure-api-management-create)
  - [Microsoft.ApiManagement service](https://docs.microsoft.com/en-us/azure/templates/microsoft.apimanagement/service?tabs=bicep)
  - [Tutorial: Access and customize the developer portal](https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-developer-portal-customize)
  
- [Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-overview)
  - [Deploy Function App on Premium plan](https://docs.microsoft.com/en-us/azure/azure-functions/functions-infrastructure-as-code#deploy-on-premium-plan)
  - [Microsoft.Web sites/functions](https://docs.microsoft.com/en-us/azure/templates/microsoft.web/sites/functions?tabs=bicep)
 
- [What is Application Insights?](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview)
  - [Microsoft.Insights components](https://docs.microsoft.com/en-us/azure/templates/microsoft.insights/components?tabs=bicep)

- [Architect API integration in Azure](https://docs.microsoft.com/en-us/learn/paths/architect-api-integration/)

- [Connect to a virtual network in internal mode using Azure API Management](https://docs.microsoft.com/en-us/azure/api-management/api-management-using-with-internal-vnet?tabs=stv2)
- [Deploying Azure API Management in an Internal mode (inside VNet)](https://techcommunity.microsoft.com/t5/fasttrack-for-azure/deploying-azure-api-management-in-an-internal-mode-inside-vnet/ba-p/3033493)

## Tips 
- Talk among yourselves which Scenario you would go for.  
  - If going with Scenario 01 - deploy the Bicep templates of the VNET-integrated AIS which can be found at [Student/Resources/Challenge-01/Scenario-01](../Student/Resources/Challenge-01/Scenario-01).  This is the shortcut method - the templates are ready to deployed and all they need to do is plug-in the parameter values.  
  - If going with Scenario 02 - you can deploy the Bicep templates of the publicly-exposed AIS which can be found at [Student/Resources/Challenge-01/Scenario-02](../Student/Resources/Challenge-01/Scenario-02).  Some parameter or variable values in the templates are blank, so the students need to fill these out.
    - Create several [Bicep modules](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/modules) for deploying individual resources, the file structure should be as follows:
      - main.bicep
        - modules
          - functions.bicep
          - apim.bicep
          - appinsights.bicep

      You can use the starter Bicep files at at [/Resources/Challenge-01](./Resources/Challenge-01)  
    - The resources should have the following properties at a minimum:
      - name
      - location
      - sku/kind
      - resource-specific properties
    - Function app and APIM needs to configured with Application insights. Therefore, ensure that you create this resource first, and make sure that you define [output parameters](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/outputs?tabs=azure-powershell) for instrumentation key and resource id.  You would need to pass values as input to the Function App and APIM modules. 

  - Make sure to [publish the APIM Developer portal](https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-developer-portal-customize#publish) because you may need to use this in the succeeding challenges.  The steps for publishing the APIM Developer portal for Scenario 01 (in APIM internal mode) would be different from Scenario 02 (public). Don't forget to enable CORS afterwards.
  - After publishing, browse to the Dev portal in a separate incognito/private browser and test Echo API GET operation.  

## Advanced Challenges

  - For either Scenario, move the parameters needed for your Bicep files into a seperate ```parameters.json``` file. Review your bicep templates and determine which of these parameters you could move out into a seperate file. You can learn how to format your ```parameters.json``` file [here](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/parameter-files).
<!-- - You can look into adopting the guidance for managing the APIM lifecyle by using the [Azure API Management DevOps Resource Kit](https://github.com/Azure/azure-api-management-devops-resource-kit) boilerplate ARM templates (or you can convert those templates to Bicep as well!) 
- [For customers starting out or have simple integration scenario, use the boilerplate ARM template here](https://github.com/Azure/azure-api-management-devops-resource-kit#alternatives#:~:text=For%20customers%20who%20are%20just%20starting%20out%20or%20have%20simple%20scenarios%2C%20they%20may%20not%20necessarily%20need%20to%20use%20the%20tools%20we%20provided%20and%20may%20find%20it%20easier%20to%20begin%20with%20the%20boilerplate%20templates%20we%20provided%20in%20the%20example%20folder.) -->
