# Challenge 6: Create a new React Single Page App (SPA) for patient search

[< Previous Challenge](./Challenge05.md) - **[Home](../readme.md)** 

## Introduction

In this challenge, you will create a new React Single Page App (SPA) integrated with Microsoft Authentication Library (MSAL) to connect, read and search for FHIR patient data.

## Description

- Create a new React Single-Page App (SPA) 

  Hint:
  You can use **[`Create React App`](https://reactjs.org/docs/create-a-new-react-app.html#create-react-app)** frontend build pipeline (toolchain) to quickly create a new single-page app.

- Integrate and configure the Microsoft Authentication Library (MSAL) with your React application to access FHIR Server.
- Create a patient lookup by Given name in SPA.

    Hint: 
    - You need to use the acquired access token as a bearer in your HTTP request to call the protected FHIR patient search API
    - You can explore FHIR API collection imported in Postman earlier to obtain the appropriate request for the patient search.

- (Optional) Include any other modern UI features to improve the user experience.
- Build and deploy React Patient Search app to Azure App Service.
- Test the React Patient Search app:
  - Browse to App Service website URL in a new in-private/Incognito window.
  - Sign in with your secondary tenant used in deploying FHIR Server Samples reference architecture.
  - Enter full or partial Given name in the Search box and click Search button.
  - You should see a list of patients from your FHIR Server that meets your search criteria.

## Success Criteria
- You have created a React Patient Search app and deployed it to Azure.
- You have tested React Patient Search web app with a search term.

## Learning Resources

- **[Create a New React App](https://reactjs.org/docs/create-a-new-react-app.html)**
- **[Create React App integrated toochain](https://reactjs.org/docs/create-a-new-react-app.html#create-react-app)**
- **[Microsoft Authentication Library for React (@azure/msal-react)](https://www.npmjs.com/package/@azure/msal-react)**
- **[Initialize of MSAL (@azure/msal-react) in React app](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/initialization.md)**
- **[Microsoft Authentication Library for JavaScript (MSAL.js) 2.0 for Browser-Based Single-Page Applications](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/README.md#advanced-topics)**
- **[Getting Started: Using `React AAD MSAL` library components to integrate MSAL with AAD in your React app](https://www.npmjs.com/package/react-aad-msal#checkered_flag-getting-started)**
- **[`React AAD MSAL` sample applications](https://www.npmjs.com/package/react-aad-msal#cd-sample-applications)**
- **[Single-page application: Call a web API](https://docs.microsoft.com/en-us/azure/active-directory/develop/scenario-spa-call-api?tabs=javascript#call-a-web-api)**
- **[How to create a simple search app in React](https://medium.com/developer-circle-kampala/how-to-create-a-simple-search-app-in-react-df3cf55927f5)**
- **[Sample React simple search app](https://github.com/lytes20/meal-search-app)**
- **[Create a Node.js web app in Azure](https://docs.microsoft.com/en-us/azure/app-service/quickstart-nodejs?pivots=platform-linux)**