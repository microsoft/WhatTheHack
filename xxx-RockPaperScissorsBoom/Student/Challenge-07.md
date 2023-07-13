# Challenge 07 - Implement Azure AD B2C

[< Previous Challenge](./Challenge-06.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-08.md)

## Introduction

Right now your application on Azure is wide open for anyone to use. Your application allows you to add, edit and delete competitors. Let's make sure only authenticated users can do this. If you try to perform one of these actions in your application, you'll get some errors; you need to complete the feature!

The application has the code in place to authenticate users against Azure AD B2C, you just need to create an Azure AD B2C application, build the user journeys and policy and then set the right configuration values.

## Description

- Create an `Azure AD B2C` application in the Azure portal.
- Optional: Allow users to authenticate with an SSO ID via an `OpenIDConnect Account`.
- Make sure it works in your on Azure App Service
  - **DO NOT** store credentials in your code or appsettings file.

## Success Criteria

To complete this challenge successfully, you should be able to:

- When a user hits the 'Sign In' link, they are redirected to login.
- A user can successfully authenticate, get redirected back to your application and see a personalized greeting.
- A user can successfully add or edit a bot in the Competitor views.
- In Azure DevOps (Boards), from the Boards view, you could now drag and drop the user story associated to this Challenge to the `Resolved` or `Closed` column, congrats! ;)

## Learning Resources

- [Set up AAD B2C with a Microsoft Account](https://docs.microsoft.com/en-us/azure/active-directory-b2c/active-directory-b2c-setup-msa-app) - In step 6, you may to format the Redirect URL as: `https://login.microsoftonline.com/te/<your-tenant>.onmicrosoft.com/oauth2/authresp`
- [Working with Azure App Service Application Settings](https://blogs.msdn.microsoft.com/cjaliaga/2016/08/10/working-with-azure-app-services-application-settings-and-connection-strings-in-asp-net-core/)
- [Cloud authentication with Azure Active Directory B2C in ASP.NET Core](https://docs.microsoft.com/en-us/aspnet/core/security/authentication/azure-ad-b2c?view=aspnetcore-2.1)
- [Bulk set App Service configuration values](https://learn.microsoft.com/en-us/azure/app-service/configure-common?tabs%253Dcli#edit-app-settings-in-bulk)
- [How to create a self-signed certificate locally for use in your ASP.NET application](https://github.com/dotnet/dotnet-docker/blob/main/samples/run-aspnetcore-https-development.md)

## Tips

- Make sure you are calling the application with `https` for the authentication redirects to work.
- Remember to keep your configuration secrets OUT of your code or config files.
- If you can't find your AAD B2C Azure resources after you create them, make sure you switch AAD Tenants in the Azure portal.
- Don't forget `/signin-oidc` in your redirect URL
