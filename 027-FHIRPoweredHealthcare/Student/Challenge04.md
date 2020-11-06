# Challenge 3: Deploy SMART on FHIR app with FHIR server

[< Previous Challenge](./Challenge02.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge04.md)

## Introduction

In this challenge, you will configured the Azure AD SMART on FHIR proxy and explore the use of SMART on FHIR applications with the Azure API for FHIR.  You'll then use SMART on FHIR proxy to launch SMART on FHIR sample app in a SMART on FHIR Launcher app.

**[Client application registrations](https://docs.microsoft.com/en-us/azure/healthcare-apis/register-public-azure-ad-client-app)** are Azure AD representations of apps that can authenticate and authorize for API permissions on behalf of a user. Public clients are mobile and SPA JavaScript apps that can't be trusted to hold an application secret, so you don't need to add one.  For a SPA, you can enable implicit flow for app user sign-in with ID tokens and/or call a protected web API with Access tokens.

Azure API for FHIR has a built-in **[Azure AD SMART on FHIR proxy](https://docs.microsoft.com/en-us/azure/healthcare-apis/use-smart-on-fhir-proxy)** to integrate partner apps with FHIR servers and EMR systems through FHIR interfaces. This set of open specifications describes how an app should discover authentication endpoints for FHIR server and start an authentication sequence.  Specifically, the proxy enables the **[EHR launch sequence](https://hl7.org/fhir/smart-app-launch/#ehr-launch-sequence)**.  

## Description

You will perform the following to explore the use of SMART on FHIR applications with the Azure API for FHIR:
- Configure **[SMART on FHIR proxy](https://docs.microsoft.com/en-us/azure/healthcare-apis/use-smart-on-fhir-proxy)** to act as an intermediary between the SMART on FHIR app and Azure AD. 
- **[Test the SMART on FHIR proxy](https://docs.microsoft.com/en-us/azure/healthcare-apis/use-smart-on-fhir-proxy#test-the-smart-on-fhir-proxy)** using a sample SMART on FHIR app launched through a **[SMART on FHIR app launcher](https://docs.microsoft.com/en-us/azure/healthcare-apis/use-smart-on-fhir-proxy#download-the-smart-on-fhir-app-launcher)**.   


## Success Criteria
- You have enabled SMART on FHIR proxy to act as an intermediary between the SMART on FHIR app and Azure AD.
- You have test the SMART on FHIR proxy with sample app launched through SMART on FHIR app launcher.

## Learning Resources

- **[Use Azure AD SMART on FHIR proxy](https://docs.microsoft.com/en-us/azure/healthcare-apis/use-smart-on-fhir-proxy)**
- **[Download the SMART on FHIR app launcher](https://docs.microsoft.com/en-us/azure/healthcare-apis/use-smart-on-fhir-proxy#download-the-smart-on-fhir-app-launcher)**
- **[Test the SMART on FHIR proxy](https://docs.microsoft.com/en-us/azure/healthcare-apis/use-smart-on-fhir-proxy#test-the-smart-on-fhir-proxy)**
- **[Register a public client application](https://docs.microsoft.com/en-us/azure/healthcare-apis/tutorial-web-app-public-app-reg)**
