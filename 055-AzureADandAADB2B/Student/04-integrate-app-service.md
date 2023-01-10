# Challenge \#5 - Integrate Azure AD authentication into an Azure App Service (EasyAuth).

[< Previous Challenge](./03-invite-guest.md) - **[Home](../README.md)** - [Next Challenge>](./05-integrate-app.md)

## Introduction

App Service provides built-in authentication and authorization support, so you can sign in users with no code in your web app. Using the optional App Service authentication / authorization module simplifies authentication and authorization for your app. When you are ready for custom authentication and authorization, you build on this architecture.

## Success Criteria

1. Your app service in configured with Azure AD authentication (EasyAuth).

Please note that you will have to choose the option "Provide the details of an existing app registration" under App registration type because you will be using a different tenant than the one attached to your Azure subscription.

## Learning Resources

- [Set up App Service authentication](https://learn.microsoft.com/en-us/azure/app-service/scenario-secure-app-authentication-app-service)
- [Tokens in AAD](https://learn.microsoft.com/en-us/azure/active-directory/develop/security-tokens)