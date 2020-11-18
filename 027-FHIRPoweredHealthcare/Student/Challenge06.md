# Challenge 6: Add patient lookup function to the JavaScript app

[< Previous Challenge](./Challenge05.md) - **[Home](../readme.md)** 

## Introduction

In this challenge, you will extend the previously deployed sample JavaScript app to add patient lookup.

## Description

- Update sample JavaScript app to add a patient Lookup feature.

    Hint: 
    For patient search by Given name example, you code should call the following FHIR Server API operation:
    `GET {{fhirurl}}/Patient?given:contains=[pass-your-search-text]`

- (Optional) Include any other modern UI features to improve the user experience.
- Test updated sample JavaScript app with patient Lookup feature
  - Browse to App Service website URL in In-private mode
  - Sign in with your secondary tenant used in deploying FHIR Server Samples reference architecture
  - You should see a list of patients that were loaded into FHIR Server
  - Enter full or partial Given name in the Search box and click Search button
    - This will filter patient data that contains the specified Given name and return search results to browser

## Success Criteria
- You have added patient lookup to the sample JavaScript app.
- You have tested the new patient lookup in the web app.

## Learning Resources

- **[Quickstart: Create an Azure Cognitive Search index in Node.js using REST APIs](https://docs.microsoft.com/en-us/azure/search/search-get-started-nodejs)**
- **[Azure Search JavaScript Samples for Accessing an Azure Search Service](https://github.com/liamca/azure-search-javascript-samples)**
- **[Create a Node.js web app in Azure](https://docs.microsoft.com/en-us/azure/app-service/quickstart-nodejs?pivots=platform-linux)**

