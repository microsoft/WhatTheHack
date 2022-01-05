# Challenge 01 - Provision your Integration Environment

[< Previous Challenge](./Challenge-00.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge-02.md)

## Pre-requisites

- You should have completed Challenge 00

## Introduction

In this challenge, the students should be able to create a set of Bicep files that will be used to deploy the AIS environment.  This prepares them for the second challenge where they will be asked to create a CI/CD pipeline that will call these IaC for automated deployment.


## Description
The students should be doing the following:
- Create main.bicep - the main Bicep module that defines parameter values, and then passes those as input to the modules
- Then, create a folder entitled "module", then add several [Bicep modules](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/modules) as follows:
  - apim.bicep  - This contains the definition for creating the API management resource.  At a minimum, the module should have the following properties:
    See [Microsoft.ApiManagement service](https://docs.microsoft.com/en-us/azure/templates/microsoft.apimanagement/service?tabs=bicep)
  - function.bicep - This contains the definition for creating the Function App resource.  At a minimum, the module should have the following properties:
    See [Microsoft.Web sites/functions](https://docs.microsoft.com/en-us/azure/templates/microsoft.web/sites/functions?tabs=bicep)    
  - appInsights.bicep - defines the Application Insights resource. Make sure to define an [output parameter](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/outputs?tabs=azure-powershell) for the instrumentation key, which will then need to be passed as input into the Function App and APIM modules. 
    See [Microsoft.Insights components](https://docs.microsoft.com/en-us/azure/templates/microsoft.insights/components?tabs=bicep)
- Completed templates can be found at [/Solutions/Challenge-01/bicep](./Solutions/Challenge-01/bicep)

## Success Criteria

You should be able to create a set of Bicep templates that:
1. Creates a resource group in your region of choice
1. Deploy an API Management service in Developer tier
1. Deploy a Function App in the Elastic Premium Plan - E1 SKU
1. Deploy Application Insights resource
1. Configure APIM and Function app to use Application Insights resource

## Learning Resources

- [What is Bicep?](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview)

- [Azure API Management](https://docs.microsoft.com/en-us/azure/api-management/api-management-key-concepts)
  - [Azure Quickstart Templates - Create API Management Service](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.apimanagement/azure-api-management-create)
  - [Microsoft.ApiManagement service](https://docs.microsoft.com/en-us/azure/templates/microsoft.apimanagement/service?tabs=bicep)

- [Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-overview)
  - [Deploy Function App on Premium plan](https://docs.microsoft.com/en-us/azure/azure-functions/functions-infrastructure-as-code#deploy-on-premium-plan)
  - [Microsoft.Web sites/functions](https://docs.microsoft.com/en-us/azure/templates/microsoft.web/sites/functions?tabs=bicep)
 
- [What is Application Insights?](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview)
  - [Microsoft.Insights components](https://docs.microsoft.com/en-us/azure/templates/microsoft.insights/components?tabs=bicep)

- [Architect API integration in Azure](https://docs.microsoft.com/en-us/learn/paths/architect-api-integration/)


## Tips 

- Create one several [Bicep modules](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/modules) for deploying individual resources.
- Define parameter values in the main bicep file, then pass those as input to the modules.
- In the module that deploys an Application Insight resource, define an [output parameter](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/outputs?tabs=azure-powershell) for the instrumentation key, which will then need to be passed as input into the Function App and APIM modules. 


## Advanced Challenges

- You can look into adopting the guidance for managing the APIM lifecyle by using the [Azure API Management DevOps Resource Kit](https://github.com/Azure/azure-api-management-devops-resource-kit) boilerplate ARM templates (or you can convert those templates to Bicep as well!) 
- [For customers starting out or have simple integration scenario, use the boilerplate ARM template here](https://github.com/Azure/azure-api-management-devops-resource-kit#alternatives#:~:text=For%20customers%20who%20are%20just%20starting%20out%20or%20have%20simple%20scenarios%2C%20they%20may%20not%20necessarily%20need%20to%20use%20the%20tools%20we%20provided%20and%20may%20find%20it%20easier%20to%20begin%20with%20the%20boilerplate%20templates%20we%20provided%20in%20the%20example%20folder.)
