# Challenge 03 - Create Backend API


[<Previous Challenge](./Challenge-02.md) - **[Home](./README.md)** - [Next Challenge>](./Challenge-04.md)

## Pre-requisites

- You should have completed Challenge 02

## Introduction

Now that you have deployed your AIS in Dev environment, you would now like to be able create simple Hello World API and be able to call them thru your APIM endpoint.  Your developers would like to be able to develop APIs using Azure Functions, at a a minimum performing GET and POST operations on the API. 


## Description
You should be able to create a REST API with GET and POST operations and be able to configure and call this thru APIM.


## Success Criteria

For both scenarios, you should be able to: 
1. Add a Function with HTTP Trigger that takes a name parameter and returns a simple message via a GET call. (e.g. "Hello [name]!")
1. Add a Function with HTTP Trigger  that sends name as a JSON payload and returns a simple message via a POST call. (e.g. "Hello [name]!")
1. Import the Functions in API Management and name it Hello API.
1. Test API GET and POST calls
    - For Scenario 1 - send call to the public AGW endpoint
    - For Scenario 2 - send calls to the public APIM endpoint
1. Enable Application Insights for Hello API, keep the default values (e.g. sampling to the default value of 100%)
1. Add Hello API to Unlimited Product.

## Learning Resources
- [Customize an HTTP endpoint in Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-serverless-api)
- [Import an Azure Function App as an API in Azure API Management](https://docs.microsoft.com/en-us/azure/api-management/import-function-app-as-api)
- [Automate resource deployment for your function app in Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-infrastructure-as-code)
 


## Tips 
- To test API calls, students are free to use whatever tool they prefer, e.g. Powershell [Invoke-RestMethod](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-7.2), Azure Portal ([APIM Test tab](https://docs.microsoft.com/en-us/azure/api-management/import-function-app-as-api#test-in-azure-portal)), or [Postman](https://www.postman.com/) (highly recommended)
    - For those doing Scenarion 01: If using Postman, you should install the Desktop app in the jumpbox VM as well.
- Ensure that you [added Hello API to the Unlimited product](https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-add-products?tabs=azure-portal#add-apis-to-a-product).
- Browse to the Dev portal in a separate incognito/private broswer and test Hello API GET operation.  

## Advanced Challenges

- Use your newly acquired GitHub Action or DevOps Pipeline superpowers to deploy your Functions code to your Function app in a pipeline!
    - [Deploy Azure Functions using GitHub Actions](https://github.com/Azure/functions-action).
    - [Deploy Azure Functions using Azure DevOps](https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/deploy/azure-function-app?view=azure-devops).
- Why not set up the Hello API and add it to the Unlimited API using Bicep?
    - [Microsoft.ApiManagement service/apis Bicep reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.apimanagement/service/apis?tabs=bicep).

[Back to Top](#challenge-03---create-backend-api)
