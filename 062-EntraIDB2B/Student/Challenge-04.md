# Challenge 04 - Integrate Entra ID authentication into an Azure App Service (EasyAuth)

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)



## Introduction

App Service provides built-in authentication and authorization support, so you can sign in users with no code in your web app. Using the optional App Service authentication/authorization module simplifies authentication and authorization for your app. When you are ready for custom authentication and authorization, you build on this architecture.


## Description

Implementing a secure solution for authentication (signing-in users) and authorization (providing access to secure data) can take significant effort. You must make sure to follow industry best practices and standards and keep your implementation up to date. The built-in authentication feature for App Service and Azure Functions can save you time and effort by providing out-of-the-box authentication with federated identity providers, allowing you to focus on the rest of your application.

- Azure App Service allows you to integrate a variety of auth capabilities into your web app or API without implementing them yourself.
- It’s built directly into the platform and doesn’t require any particular language, SDK, security expertise, or even any code to utilize.
- You can integrate with multiple login providers. For example, Entra ID, Facebook, Google, Twitter.

## Success Criteria

1. Your app service in configured with Entra ID authentication (EasyAuth).

Please note that you will have to choose the option "Provide the details of an existing app registration" under App registration type because you will be using a different tenant than the one attached to your Azure subscription.

## Learning Resources

- [Set up App Service authentication](https://learn.microsoft.com/en-us/azure/app-service/scenario-secure-app-authentication-app-service)
- [Tokens in AAD](https://learn.microsoft.com/en-us/azure/active-directory/develop/security-tokens)
