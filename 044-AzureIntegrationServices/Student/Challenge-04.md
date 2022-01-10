# Challenge 04 - Securing backend API via OAuth


[<Previous Challenge](./Challenge-03.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge-05.md)

## Pre-requisites

- You should have completed Challenge 03

## Introduction

You would like to be able to test authorization to Hello API via OAuth.  


## Description
You should be able configure OAuth2 authorization when calling Hello API.


## Success Criteria

You should be able to:
1. Add a Function with HTTP Trigger that takes a name parameter and returns a simple message via a GET call. (e.g. "Hello [name]!")
1. Add a Function with HTTP Trigger  that sends name as a JSON payload and returns a simple message via a POST call. (e.g. "Hello [name]!")
1. Import the Functions in API Management and name it Hello API.
1. Do GET and POST calls from the APIM endpoint.
1. Enable Application Insights for Hello API, keep the default values (e.g. sampling to the default value of 100%)

## Learning Resources
- [Customize an HTTP endpoint in Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-serverless-api)
- [Import an Azure Function App as an API in Azure API Management](https://docs.microsoft.com/en-us/azure/api-management/import-function-app-as-api)
- [Automate resource deployment for your function app in Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-infrastructure-as-code)
 


## Tips 
- To test API calls, students are free to use whatever tool they prefer, e.g. Powershell [Invoke-RestMethod](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-7.2), Azure Portal ([APIM Test tab](https://docs.microsoft.com/en-us/azure/api-management/import-function-app-as-api#test-in-azure-portal)), or [Postman](https://www.postman.com/).


## Advanced Challenges

- [TODO]
