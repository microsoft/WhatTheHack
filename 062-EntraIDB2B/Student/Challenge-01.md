# Challenge 01 - Register the App

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)


## Introduction

For an identity provider to know that a user has access to a particular app, both the user and the application must be registered with the identity provider. When you register your application with Entra ID (AAD), you're providing an identity configuration for your application that allows it to integrate with the Microsoft identity platform.

After the app is registered, it's given a unique identifier that it shares with the Microsoft identity platform when it requests tokens. If the app is a confidential client application, it will also share the secret or the public key depending on whether certificates or secrets were used.

## Description

Registering your application establishes a trust relationship between your app and the Microsoft identity platform. The trust is unidirectional: your app trusts the Microsoft identity platform, and not the other way around.

When registration finishes, the Azure portal displays the app registration's Overview pane. You see the Application (client) ID. Also called the client ID, this value uniquely identifies your application in the Microsoft identity platform.

## Success Criteria

1. Your app is registered in Entra ID.

## Learning Resources

- [Register an application with the Entra ID?](https://learn.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app)
- [Security Best Practices](https://learn.microsoft.com/en-us/azure/active-directory/develop/security-best-practices-for-app-registration)
- [Details of registered application](https://learn.microsoft.com/en-us/azure/active-directory/develop/active-directory-how-applications-are-added)
