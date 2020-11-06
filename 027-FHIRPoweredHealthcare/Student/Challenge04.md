# Challenge 4: Deploy SMART on FHIR app with FHIR server

[< Previous Challenge](./Challenge03.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge05.md)

## Introduction

In this challenge, you will configured the Azure AD SMART on FHIR proxy and explore the use of SMART on FHIR applications with the Azure API for FHIR.  You'll then use SMART on FHIR proxy to launch SMART on FHIR sample app in a SMART on FHIR Launcher app.

**[What is SMART on FHIR?](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir-faq#what-is-smart-on-fhir)** 
SMART ((Substitutable Medical Applications and Reusable Technology) on FHIR is a set of open specifications to integrate partner apps with FHIR servers and other Health IT systems, i.e. Electronic Health Records and Health Information Exchanges.  By creating a SMART on FHIR application, you can ensure that your application can be accessed and leveraged by a plethora of different systems. Authentication and Azure API for FHIR. To learn more about SMART, visit SMART Health IT.

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
- **[SMART](https://smarthealthit.org/)**
- **[HL7 FHIR SMART Application Launch Framework](http://www.hl7.org/fhir/smart-app-launch/)**
