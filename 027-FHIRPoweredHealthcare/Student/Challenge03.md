# Challenge 3: Deploy JavaScript app to connect to FHIR server and read FHIR data

[< Previous Challenge](./Challenge02.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge04.md)

## Introduction

In this challenge, you will deploy a sample web application to connect to FHIR server and access FHIR patient data.  You will update the public client application registration to enable the newly deployed sample web app to be authenticated via secondary tenant credentials for access to FHIR server and the persisted FHIR bundle(s).

**[Public Client Application registrations](https://docs.microsoft.com/en-us/azure/healthcare-apis/register-public-azure-ad-client-app)** are Azure AD representations of apps that can authenticate and authorize for API permissions on behalf of a user. Public clients are mobile and SPA JavaScript apps that can't be trusted to hold an application secret, so you don't need to add one.  For a SPA, you can enable implicit flow for app user sign-in with ID tokens and/or call a protected web API with Access tokens.



## Description

You will perform the following to configure and deploy a FHIR sample JavaScript app in Azure that reads patient data from the FHIR service:
- **[Create a new Web App](https://docs.microsoft.com/en-us/azure/healthcare-apis/tutorial-web-app-write-web-app#create-web-application)** in Azure Portal to host the FHIR sample JavaScript app.
- Check in secondary Azure AD tenant that a **[Resource Application](https://docs.microsoft.com/en-us/azure/healthcare-apis/register-resource-azure-ad-client-app)** has been registered for the FHIR server resource.

    Hint: 
    - If you are using the Azure API for FHIR, a Resource Application is automatically created when you deploy the service in same AAD tenant as your application.
    - In the FHIR Server Sample environment deployment, a Resource Application is automatically created for the FHIR server resource.

- **[Register a public client application](https://docs.microsoft.com/en-us/azure/healthcare-apis/tutorial-web-app-public-app-reg)** in Secondary Azure AD tenant to enable apps to authenticate and authorize for API permissions on behalf of a user.

    Hint: Ensure that the Reply URL matches the FHIR sample web app URL

    - Configure a new Web platform under Authentication blade
        - Set Redirect URIs to [sample web app URL]
        - Enable Implicit Grant by selecting Access token and ID tokens
        - Configure permissions for Azure Healthcare APIs with User_Impersonation permission (if needed)
 
- Write a new JavaScript app using index.html sample code in Student/Resources folder.
    - Update MSAL configuration for your FHIR environment

    Hint: 
    You will need the following config settings:
    - clientId - Update with your client application ID of public client app registered earlier
    - authority - Update with Authority from your FHIR Server (under Authentication)
    - FHIRendpoint - Update the FHIRendpoint to have your FHIR service name
    - Scopes - Update with Audience from your FHIR Server (under Authentication)

## Success Criteria
- You have deployed a FHIR sample Web App in Azure with a Sign-in that authenticates against your secondary Azure AD tenant to access FHIR server and retrieves patient data in a web page.

## Learning Resources

- **[Deploy a JavaSript app to read data from FHIR service](https://docs.microsoft.com/en-us/azure/healthcare-apis/tutorial-web-app-fhir-server)**
- **[Register a public client application](https://docs.microsoft.com/en-us/azure/healthcare-apis/tutorial-web-app-public-app-reg)**
**[Test FHIR API setup with Postman](https://docs.microsoft.com/en-us/azure/healthcare-apis/tutorial-web-app-test-postman)**
- **[Write Azure web app to read FHIR data](https://docs.microsoft.com/en-us/azure/healthcare-apis/tutorial-web-app-write-web-app)**
