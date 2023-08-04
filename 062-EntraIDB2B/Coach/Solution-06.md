# Challenge 06 - Deploy your app to Azure!! - Coach's Guide 

[< Previous Solution](./Solution-05.md) - **[Home](./README.md)**

## Notes & Guidance

Follow the QuickStart for the deployment of the app.

QuickStarts are available for ASP.NET and other languages.

For Angular or any other SPA app, build the Angular app, create an Azure App Service, configure the App Service. Under the "Settings" section, click on "Configuration". Here, they need to set the Node.js version to match the Angular app's requirements. Select the "General Settings" tab and choose the desired Node.js version.

Deploy the Angular app using the Azure CLI or the Azure Portal.

If they have a desktop application that they want to deploy, Azure App Service is not the appropriate service for that purpose.

Add the App Service Url as the Redirect Url in the registered app in your tenant as part of the previous challenge.

Sign In with the users they created in the previous challenge.
