# Challenge 04 - Integrate Entra ID authentication into an Azure App Service (EasyAuth) - Coach's Guide 

[< Previous Solution](./Solution-03.md) - **[Home](./README.md)** - [Next Solution >](./Solution-05.md)

## Notes & Guidance

For this tutorial, they need a web app deployed to App Service. They can use an existing web app, or they can follow one of the quickstarts to create and publish a new web app to App Service.

  - [ASP.Net Core](https://learn.microsoft.com/en-us/azure/app-service/quickstart-dotnetcore?pivots=development-environment-vs&tabs=net70)
  - [Node.js](https://learn.microsoft.com/en-us/azure/app-service/quickstart-nodejs?pivots=development-environment-vscode&tabs=windows)
  - [Java](https://learn.microsoft.com/en-us/azure/app-service/quickstart-java?pivots=platform-linux-development-environment-maven&tabs=javase)

Create the Web app in the Microsoft tenant using a Microsoft account. Please note that they will not be able to create the web app in their newly created Entra ID tenant as there is no subscription associated with it.

Whether they use an existing web app or create a new one, take note of the following:

 - Web app name
 - Resource group that the web app is deployed to

Enable authentication and authorization for the web app by navigating to Authentication - Add Identity Provider. Select Microsoft as the identity provider.

In the App registration type, select "Provide the details of an existing app registration".

 - Copy and paste the Client Id from the registered app from Challenge #1.
 - Create a client secret for the app by navigating to App registration - Certificates & Secrets. Copy the value of the secret and put in the previous screen
 - Issuer URL should be https://login.microsoftonline.com/tenant-id


Add the redirect URL in the app registration as https://web-app-name.azurewebsites.net/.auth/login/aad/callback.

Sign In with the web app with their user or a guest user.
