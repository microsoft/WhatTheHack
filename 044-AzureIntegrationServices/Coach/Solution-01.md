# Challenge 01 - Provision your Integration Environment

[< Previous Challenge](./Challenge-00.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge-02.md)

## Pre-requisites

- You should have completed Challenge 00

## Introduction

In this challenge, the students should be able to create a set of Bicep files that will be used to deploy the AIS environment.  This prepares them for the second challenge where they will be asked to create a CI/CD pipeline that will call these IaC for automated deployment.


## Description
The students should be doing the following:
- Create main.bicep - The main Bicep file.  In there, you will reference the modules, define parameter values, and then pass those values as input to the modules.

- Then, create a folder entitled "module", then add several [Bicep modules](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/modules) as follows:
  - apim.bicep  - This contains the definition for creating the API management resource.  At a minimum, the module should have the following properties:

    See [Microsoft.ApiManagement service](https://docs.microsoft.com/en-us/azure/templates/microsoft.apimanagement/service?tabs=bicep)
  - function.bicep - This contains the definition for creating the Function App resource.  At a minimum, the module should have the following properties:

    See [Microsoft.Web sites/functions](https://docs.microsoft.com/en-us/azure/templates/microsoft.web/sites/functions?tabs=bicep)    
  - appInsights.bicep - defines the Application Insights resource. Make sure to define an [output parameter](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/outputs?tabs=azure-powershell) for the instrumentation key, which will then need to be passed as input into the Function App and APIM modules. 

    See [Microsoft.Insights components](https://docs.microsoft.com/en-us/azure/templates/microsoft.insights/components?tabs=bicep)

- You can recommend the students to follow this [MS Learn Bicep tutorial](https://docs.microsoft.com/en-us/learn/modules/build-first-bicep-template/8-exercise-refactor-template-modules?pivots=cli) to guide them on how to author the files above.

- Otherwise, you can give them snippets from the completed templates which can be found at [/Solutions/Challenge-01/bicep](./Solutions/Challenge-01/bicep)

