# Challenge 3: Deploy web apps to connect to FHIR server and read FHIR data

[< Previous Challenge](./Challenge02.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge04.md)

## Introduction

In this challenge, you will register a public client application to access your previously deployed FHIR server and create a web application to access FHIR data.

**[Client application registrations](https://docs.microsoft.com/en-us/azure/healthcare-apis/register-public-azure-ad-client-app)** are Azure AD representations of apps that can authenticate and authorize for API permissions on behalf of a user. Public clients are mobile and SPA JavaScript apps that can't be trusted to hold an application secret, so you don't need to add one.  For a SPA, you can enable implicit flow for app user sign-in with ID tokens and/or call a protected web API with Access tokens.

## Description

You will perform the following to configure and deploy a sample JavaScript app in Azure to reads data from a FHIR service:
- **[Register a resource applicaiton in Azure AD](https://docs.microsoft.com/en-us/azure/healthcare-apis/register-resource-azure-ad-client-app)** for FHIR server resource.  
    Note: If you are using the Azure API for FHIR, a resource application is automatically created when you deploy the service in same AAD tenant as your application.
- **[Register a public client application](https://docs.microsoft.com/en-us/azure/healthcare-apis/tutorial-web-app-public-app-reg)** to enable apps to authenticate and authorize for API permissions on behalf of a user.
- **[Test FHIR API setup with Postman](https://docs.microsoft.com/en-us/azure/healthcare-apis/tutorial-web-app-test-postman)**
- Create a **[web app](https://docs.microsoft.com/en-us/azure/healthcare-apis/tutorial-web-app-write-web-app#create-web-application)** that connects to a FHIR server and reads FHIR data

## Success Criteria
- You have deployed a sample web app in Azure that connects to your FHIR server and reads FHIR patient data.

## Learning Resources

- **[Deploy a JavaSript app to read data from FHIR service](https://docs.microsoft.com/en-us/azure/healthcare-apis/tutorial-web-app-fhir-server)**
- **[Register a public client application](https://docs.microsoft.com/en-us/azure/healthcare-apis/tutorial-web-app-public-app-reg)**
**[Test FHIR API setup with Postman](https://docs.microsoft.com/en-us/azure/healthcare-apis/tutorial-web-app-test-postman)**
- **[Write Azure web app to read FHIR data](https://docs.microsoft.com/en-us/azure/healthcare-apis/tutorial-web-app-write-web-app)**
