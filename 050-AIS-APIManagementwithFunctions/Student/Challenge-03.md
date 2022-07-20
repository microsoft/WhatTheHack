# Challenge 03 - Create Backend API


[<Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge>](./Challenge-04.md)

## Pre-requisites

- You should have completed Challenge 02

## Introduction
Now that you have deployed an APIM service in Dev environment, you would now like to create a simple Hello World API that can be called via the APIM gateway and routes the calls to the backend API services hosted in Function Apps.  


## Description
For both scenarios, you should be able to: 
- Add a function with HTTP Trigger that takes a name parameter and returns a simple message via a GET call. (e.g. "Hello [name]!")
- Add a function with HTTP Trigger  that sends name as a JSON payload and returns a simple message via a POST call. (e.g. "Hello [name]!")
- Import the functions in API Management and name it Hello API.
- Test API GET and POST calls.  To do this, students are free to use tools like Powershell [Invoke-RestMethod](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-7.2), [APIM Test tab](https://docs.microsoft.com/en-us/azure/api-management/import-function-app-as-api#test-in-azure-portal) in the Azure Portal, or [Postman](https://www.postman.com/) (highly recommended)
    - For Scenario 1 - send call to the public AGW endpoint.  If you are using Postman, you should install the Desktop app in the jumpbox VM.
    - For Scenario 2 - send calls to the public APIM endpoint.
- Ensure that you [have added Hello API to the Unlimited product](https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-add-products?tabs=azure-portal#add-apis-to-a-product).
- Browse to the Dev portal in a separate incognito/private broswer and test Hello API GET operation.  
- Enable Application Insights for Hello API, keep the default values (e.g. sampling to the default value of 100%)


## Success Criteria
- Verify that you are able to send GET and POST calls via the APIM endpoint and received HTTP 200 response.


## Learning Resources
- [Customize an HTTP endpoint in Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-serverless-api)
- [Import an Azure Function App as an API in Azure API Management](https://docs.microsoft.com/en-us/azure/api-management/import-function-app-as-api)
- [Automate resource deployment for your function app in Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-infrastructure-as-code)
 

## Advanced Challenges
- Use your newly acquired GitHub Action or DevOps Pipeline superpowers to deploy your Functions code to your Function app in a pipeline!
    - [Continuous delivery by using GitHub Action](https://docs.microsoft.com/en-us/azure/azure-functions/functions-how-to-github-actions?tabs=dotnet)
    - [Continuous delivery with Azure Pipelines](https://docs.microsoft.com/en-us/azure/azure-functions/functions-how-to-azure-devops?tabs=dotnet-core%2Cyaml%2Ccsharp)
    - [Deploy Azure Functions using GitHub Actions](https://github.com/Azure/functions-action)
    - [Deploy Azure Functions using Azure DevOps](https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/deploy/azure-function-app?view=azure-devops)
- Why not set up the Hello API and add it to the Unlimited API using Bicep?
    - [Microsoft.ApiManagement service/apis Bicep reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.apimanagement/service/apis?tabs=bicep)

[Back to Top](#challenge-03---create-backend-api)
