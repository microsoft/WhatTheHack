# Challenge 03 - Create backend API


[<Previous Challenge](./Challenge-02.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge-04.md)

## Pre-requisites

- You should have completed Challenge 02

## Introduction

Now that you have deployed your AIS in Dev environment, you would now like to be able create simple Hello World API and be able to call them thru your APIM endpoint.  Your developers would like to be able to develop APIs using Azure Functions, at a a minimum performing GET and POST operations on the API. 


## Description
You should be able to create a REST API with GET and POST operations and be able to configure and call this thru APIM.


## Success Criteria

You should be able to:
1. Add a Function with HTTP Trigger that takes a name parameter and returns a simple message via a GET call. (e.g. "Hello [name]!")
1. Add a Function with HTTP Trigger  that sends name as a JSON payload and returns a simple message via a POST call. (e.g. "Hello [name]!")
1. Import the Functions in API Management and name it Hello API.
1. Do GET and POST calls from the APIM endpoint.
1. Update your Function App and APIM Bicep modules with the changes above.

## Learning Resources
- [Customize an HTTP endpoint in Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-serverless-api)
- [Import an Azure Function App as an API in Azure API Management](https://docs.microsoft.com/en-us/azure/api-management/import-function-app-as-api)
- [Automate resource deployment for your function app in Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-infrastructure-as-code)
 


## Tips 
- To test API calls, students are free to use whatever tool they prefer, e.g. Powershell [Invoke-RestMethod](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-7.2), Azure Portal ([APIM Test tab](https://docs.microsoft.com/en-us/azure/api-management/import-function-app-as-api#test-in-azure-portal)), or [Postman](https://www.postman.com/).


## Advanced Challenges

- [TODO]
