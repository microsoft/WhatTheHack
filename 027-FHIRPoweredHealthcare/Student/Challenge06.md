# Challenge 6: Add patient lookup function to the JavaScript app

[< Previous Challenge](./Challenge05.md) - **[Home](../readme.md)** 

## Introduction

In this challenge, you will extend the previously deployed sample JavaScript app to add patient Lookup.

## Description

- Update sample JavaScript app to add a patient Lookup feature.

    Hint: 
    For patient search by Given name example, your code should call the following FHIR Server API operation:
    
    `GET {{fhirurl}}/Patient?given:contains=[pass-your-search-text]`

- (Optional) Include any other modern UI features to improve the user experience.
- Test updated sample JavaScript app with patient Lookup feature:
  - Browse to App Service website URL in In-private mode
  - Sign in with your secondary tenant used in deploying FHIR Server Samples reference architecture
  - You should see a list of patients that were loaded into FHIR Server
  - Enter full or partial Given name in the Search box and click Search button
    - This will filter patient data that contains the specified Given name and return search results to browser

## Success Criteria
- You have added patient Lookup to the sample JavaScript app.
- You have tested the new patient Lookup in the web app.

## Learning Resources

- **[Create a new react app](https://reactjs.org/docs/create-a-new-react-app.html#create-react-app)**
- **[react aad msal getting started](https://www.npmjs.com/package/react-aad-msal#checkered_flag-getting-started)**
- **[react aad msal sample applications](https://www.npmjs.com/package/react-aad-msal#cd-sample-applications)**
- **[Create a Node.js web app in Azure](https://docs.microsoft.com/en-us/azure/app-service/quickstart-nodejs?pivots=platform-linux)**