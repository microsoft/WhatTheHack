# Challenge 01 - Provision your Integration Environment

[<Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge>](./Challenge-02.md)

## Pre-requisites

- You should have completed Challenge 00

## Introduction
You are a cloud engineer for Runva - a global health and wellness company that provides solutions for individuals who takes running as sport, providing them a platform to track running activities, analyze performance and recommend plans to help them train smarter and safer.  They are going to embark on a six-month project to modernize their integration solution hosted on-premises and migrate them to Azure integration services.  Since this is their first foray in Azure, you are tasked to create a proof-of-concept (POC) that captures several integration patterns.


## Description
As a cloud engineer, you would like to be able to deploy this POC environment using Infrastructure-as-Code.  You have learned that you can efficiently do this in Azure using the new language called Bicep. As a baseline, you are going to deploy API Management service as gateway for your APIs, as well as a Function App where you would host your APIs.

There are two scenarios you would like to prove (just choose one):

### Scenario 01: Deploy a VNET-secured AIS environment 
This scenario is for when you need to access services deployed over a private network (e.g. APIs hosted on-premises)
- Deploy the Bicep templates of the VNET-integrated AIS which can be found at `/Challenge-01/Scenario-01` of the `Resources.zip` file provided to you by your coach.  These templates are ready for deployment, however, you might run into warning or errors about some missing parameter or variable values that you need to fill out.  Make sure to address these issues before deploying.

### Scenario 02: Deploy an identity-secured AIS environment 
This scenario is preferred for integrating with services hosted in the cloud or publicly-accessible
- Deploy the Bicep templates of the publicly-exposed AIS which can be found at `/Challenge-01/Scenario-02` of the `Resources.zip` file provided to you by your coach.  These templates are ready for deployment, however, you might run into warning or errors about some missing parameter or variable values that you need to fill out.  Make sure to address these issues before deploying.


- For both scenarios, make sure to [publish the APIM Developer portal](https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-developer-portal-customize#publish) because you may need to use this in the succeeding challenges.  The steps for publishing the APIM Developer portal for Scenario 01 (in APIM internal mode) would be different from Scenario 02 (public). Don't forget to enable CORS afterwards.
  - After publishing, browse to the Dev portal in a separate incognito/private browser and test Echo API GET operation.  

## Success Criteria
As mentioned earlier, you can choose which scenario to go for your POC environment:

### Scenario 01: Deploy a VNET-secured AIS environment
- Verify that the provided Bicep templates have deployed the following resources into your Azure subscription:
  - Application Insights resource
  - Virtual Network
  - API Management service in Developer tier, single-instance, in Internal mode
    - Deployed to a dedicated subnet
    - Configured to send monitoring data to your Application Insights resource
    - Published the Developer Portal
  - Application Gateway, single-instance, in Standard WAF2
    - Deployed to a dedicated subnet
  - Function App in Elastic Premium Plan - E1 SKU
    - Configured to send monitoring data to your Application Insights resource
  - Virtual Machine
  - Bastion
  
### Scenario 02: Deploy an identity-secured AIS environment
- Verify that the provided Bicep templates have deployed the following resources into your Azure subscription:
  - Application Insights resource
  - API Management service in Developer tier
    - Configured to send monitoring data to your Application Insights resource
    - Published the Developer Portal
  - Function App in the Consumption Plan - Y1 SKU
    - Configured to send monitoring data to your Application Insights resource
  

## Learning Resources
- [What is Bicep?](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview)

- [Azure API Management](https://docs.microsoft.com/en-us/azure/api-management/api-management-key-concepts)
  - [Azure Quickstart Templates - Create API Management Service](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.apimanagement/azure-api-management-create)
  - [Microsoft.ApiManagement service](https://docs.microsoft.com/en-us/azure/templates/microsoft.apimanagement/service?tabs=bicep)
  - [Tutorial: Access and customize the developer portal](https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-developer-portal-customize#publish)
  
- [Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-overview)
  - [Deploy Function App on Premium plan](https://docs.microsoft.com/en-us/azure/azure-functions/functions-infrastructure-as-code#deploy-on-premium-plan)
  - [Microsoft.Web sites/functions](https://docs.microsoft.com/en-us/azure/templates/microsoft.web/sites/functions?tabs=bicep)
 
- [What is Application Insights?](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview)
  - [Microsoft.Insights components](https://docs.microsoft.com/en-us/azure/templates/microsoft.insights/components?tabs=bicep)

- [Architect API integration in Azure](https://docs.microsoft.com/en-us/learn/paths/architect-api-integration/)

- [Connect to a virtual network in internal mode using Azure API Management](https://docs.microsoft.com/en-us/azure/api-management/api-management-using-with-internal-vnet?tabs=stv2)
- [Deploying Azure API Management in an Internal mode (inside VNet)](https://techcommunity.microsoft.com/t5/fasttrack-for-azure/deploying-azure-api-management-in-an-internal-mode-inside-vnet/ba-p/3033493)


## Advanced Challenges
- For either Scenario, review your bicep templates and determine which parameters could be moved out into a separate ```parameters.json``` file.  You can learn how to format your ```parameters.json``` file [here](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/parameter-files).

[Back to Top](#challenge-01---provision-your-integration-environment)