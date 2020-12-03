# Challenge 6: Create a new React Single Page App (SPA) for patient search

[< Previous Challenge](./Challenge05.md) - **[Home](../readme.md)** 

## Introduction

In this challenge, you will create a new React Singe Page App (SPA) and use FHIR Server msal configurations from previous JavaScript app to connect, read and search for FHIR data.

## Description

- Create a new React Single Page App (SPA) using `Create React App` frontend build pipeline.
- Create a patient lookup by Given name for SPA.
- Build and deploy the new React Patient Search React app to Azure App Services.

    Hint: 
    For patient search by Given name example, your code should call the following FHIR Server API operation:
    
    `GET {{fhirurl}}/Patient?given:contains=[pass-your-search-text]`

- (Optional) Include any other modern UI features to improve the user experience.
- Test the React Patient Search app:
  - Browse to App Service website URL in In-private mode
  - Sign in with your secondary tenant used in deploying FHIR Server Samples reference architecture
  - You should see a list of patients that were loaded into FHIR Server
  - Enter full or partial Given name in the Search box and click Search button
    - This will filter patient data that contains the specified Given name and return search results to browser

## Success Criteria
- You have created a React Patient Search app
- You have built and deployed the React app to Azure App Service.
- You have tested the new patient search web app.

## Learning Resources

- **[Create React App frontend build pipeline](https://reactjs.org/docs/create-a-new-react-app.html#create-react-app)**
- **[react aad msal getting started](https://www.npmjs.com/package/react-aad-msal#checkered_flag-getting-started)**
- **[react aad msal sample applications](https://www.npmjs.com/package/react-aad-msal#cd-sample-applications)**
- **[Create a Node.js web app in Azure](https://docs.microsoft.com/en-us/azure/app-service/quickstart-nodejs?pivots=platform-linux)**