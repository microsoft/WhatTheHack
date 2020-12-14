# Challenge 6: Create a new Single Page App (SPA) for patient search

[< Previous Challenge](./Challenge05.md) - **[Home](../readme.md)** 

## Introduction

In this challenge, you will create a new JavaScript Single Page App (SPA) integrated with Microsoft Authentication Library (MSAL) to connect, read and search for FHIR patient data.

![JavaScript SPA App - Implicit Flow](../images/JavaScriptSPA-ImplicitFlow.jpg)

## Description

- Create a new JavaScript Single-Page App (SPA) 

  Hint:
  You can clone a sample **[Node.js JavaScript SPA with MSAL](https://docs.microsoft.com/en-us/azure/active-directory/develop/tutorial-v2-javascript-spa)** or use **[Create React App](https://reactjs.org/docs/create-a-new-react-app.html#create-react-app)** frontend build pipeline (toolchain) to quickly create a new JavaScript SPA app.

- Integrate and configure the Microsoft Authentication Library (MSAL) with your JavaScript SPA app to fetch data from protected FHIR web API.
- Create a patient lookup by Given or Family name in JavaScript SPA app.

    Hint: 
    - You need to use the acquired access token as a bearer in your HTTP request to call the protected FHIR web API
    - You can explore the FHIR API collection imported into Postman earlier to obtain the appropriate API request for the patient search query.

- (Optional) Include any other modern UI features to improve the user experience.
- Build and test JavaScript SPA app locally.
  - To run locally, you'll need to change the `redirectUri` property to : `http://localhost:3000/`.
- Deploy JavaScript SPA app to Azure App Service.
  - To run on Azure, you'll need to change the `redirectUri` property to : `<YOUR_AZURE_APP_SERVICE_WEBSITE_URL>`.
- Register the local and Azure web app URLs in the `redirectURIs` setting in your 'Public Client' App Registration.
- Test the JavaScript SPA Patient Search app:
  - Browse to App Service website URL in a new in-private/Incognito window.
  - Sign in with your admin tenant credential from challenge 1.
  - Enter name in the patient search box and click the search button.
  - You should see a list of FHIR patient(s) that matches your search criteria.

## Success Criteria
- You have created a JavaScript SPA Patient Search app and deployed it to Azure App Service.
- You have tested patient lookup in the Patient Search web app.

## Learning Resources

- **[Create a new JavaSCript SPA using MSAL to call protected Web API](https://docs.microsoft.com/en-us/azure/active-directory/develop/tutorial-v2-javascript-spa)**
- **[GitHub Azure Samples - MSAL JavaScript Single-page Application using Implicit Flow](https://github.com/Azure-Samples/active-directory-javascript-graphapi-v2/)**
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
- **[Deploy Node.js to Azure App Service using Visual Studio Code](https://docs.microsoft.com/en-us/azure/developer/javascript/tutorial/deploy-nodejs-azure-app-service-with-visual-studio-code?tabs=bash)**
- **[Deploy and host your Node.js app on Azure]*(https://docs.microsoft.com/en-us/azure/developer/javascript/how-to/deploy-web-app)**
- **[Deploying React apps to Azure with Azure DevOps](https://devblogs.microsoft.com/premier-developer/deploying-react-apps-to-azure-with-azure-devops/)**