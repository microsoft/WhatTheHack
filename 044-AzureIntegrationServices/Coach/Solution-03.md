# Solution 03 - Create backend API

[< Previous Solution](./Solution-02.md) - **[Home](../readme.md)** - [Next Solution>](./Solution-04.md)

## Introduction

The students should be able to create upload the Bicep files to a repo and create a CI/CD pipeline that deploys the environment.


## Description
- Students can add the functions via the Azure Portal.  
    - The first function should have a HTTP Trigger that takes a name parameter and returns a simple message via a GET call. 
        ![Function with HTTP Trigger - GET](./images/Solution03_Hello_GET_Function.jpg)

    - The second function should also have a HTTP Trigger that sends name as a JSON payload and returns a simple message via a POST call. 
        ![Function with HTTP Trigger - POST](./images/Solution03_Hello_POST_Function.jpg)

- Import the Functions in API Management and name it Hello API.
- Do GET and POST calls from the APIM endpoint.  
- Update your Function App and APIM Bicep modules with the changes above.