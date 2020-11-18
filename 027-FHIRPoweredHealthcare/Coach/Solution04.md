# Coach's Guide: Challenge 4 - Connect to FHIR Server and read FHIR data through a JavaScript app

[< Previous Challenge](./Solution03.md) - **[Home](./readme.md)** - [Next Challenge>](./Solution05.md)

## Notes & Guidance

In this challenge, you will deploy a sample JavaScript app to connect and read FHIR patient data.  You will configure public client application registration to allow JavaScript app to access FHIR Server.

**[Public Client Application registrations](https://docs.microsoft.com/en-us/azure/healthcare-apis/register-public-azure-ad-client-app)** are Azure AD representations of apps that can authenticate and authorize for API permissions on behalf of a user. Public clients are mobile and SPA JavaScript apps that can't be trusted to hold an application secret, so you don't need to add one.  For a SPA, you can enable implicit flow for app user sign-in with ID tokens and/or call a protected web API with Access tokens.

**You will deploy a FHIR sample JavaScript app in Azure to read patient data from the FHIR service.**
- **[Create a new Azure Web App](https://docs.microsoft.com/en-us/azure/healthcare-apis/tutorial-web-app-write-web-app#create-web-application)** in Azure Portal to host the FHIR sample JavaScript app.
- Check in secondary Azure AD tenant (can be primary tenant if you already have directory admin privilege) that a **[Resource Application](https://docs.microsoft.com/en-us/azure/healthcare-apis/register-resource-azure-ad-client-app)** has been registered for the FHIR Server resource.

    Note: 
    - If you are using the Azure API for FHIR, a Resource Application is automatically created when you deploy the service in same AAD tenant as your application.
    - In the FHIR Server Sample environment deployment, a Resource Application is automatically created for the FHIR Server resource.

- **[Register a public client application](https://docs.microsoft.com/en-us/azure/healthcare-apis/tutorial-web-app-public-app-reg)** in secondary Azure AD tenant (can be primary tenant if you already have directory admin privilege) to allow the deployed Web App to authenticate and authorize for FHIR Server API access.
  - Go to Azure AD and switch to your secondary Azure AD tenant (can be primary tenant if you already have directory admin privilege)
  - Click App Registration and add a new Public client/native (mobile & desktop) registration or open existing one if already exist (from FHIR Server Samples deployment).
    - Capture client ID and tenant ID from Overview blade for use in later step.
  - Connect with web app
    - Select Authentication blade, click Add a new platform and select Web
      - Add `https://\<WEB-APP-NAME>.azurewebsites.net` to redirect URI list.
      - Select Access tokens and ID tokens check boxes and click Configure.
  - Add API Permissions
    - Select API permissions blade and click Add a new permission
    - Select APIs my organization uses, search for Azure Healthcare APIs and select it.
    - Select user_impersonation and click add permissions.
- Write a new JavaScript app to connect and read FHIR patient data
  - Open and copy `index.html` sample JavaScript code in Student/Resources folder from your local repo 
  - Open App Service resource for sample web app in Azure Portal.
    - Select App Service Editor and select `index.html` file to open it in the editor.
    - Paste the sample code into the editor to replace the content.
    - **[Initialize MSAL ((Mirosoft Authentication Library)](https://docs.microsoft.com/en-us/graph/toolkit/providers/msal)** provider configuration object for your FHIR environment:
        - clientId - Update with your client application ID of public client app registered earlier
        - authority - Update with Authority from your FHIR Server (under Authentication)
        - FHIRendpoint - Update the FHIRendpoint to have your FHIR service name
        - Scopes - Update with Audience from your FHIR Server (under Authentication)
      
      Note: App Services Editor automatically saves changes.
- Test sample JavaScript app
  - Browse to App Service website URL in In-private mode
  - Sign in with your secondary tenant used in deploying FHIR Server Samples reference architecture
  - You should see a list of patients that were loaded into FHIR Server.
  
