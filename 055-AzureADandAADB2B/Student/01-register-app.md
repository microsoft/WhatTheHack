# Challenge \#1 - Register an application in Azure AD

[< Previous Challenge](./00-tenant-setup.md) - **[Home](../README.md)** - [Next Challenge>](./02-test-sign-in.md)

## Introduction

For an identity provider to know that a user has access to a particular app, both the user and the application must be registered with the identity provider. When you register your application with Azure Active Directory (Azure AD), you're providing an identity configuration for your application that allows it to integrate with the Microsoft identity platform.

After the app is registered, it's given a unique identifier that it shares with the Microsoft identity platform when it requests tokens. If the app is a confidential client application, it will also share the secret or the public key depending on whether certificates or secrets were used.

## Success Criteria

1. Your app is registered in Azure Active Directory.
2. You will know about Multi-tenant apps, Service Principals, authentication vs authorization, security tokens.

## Learning Resources

- [Register an application with the Azure AD?](https://learn.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app)
- [Security Best Practices](https://learn.microsoft.com/en-us/azure/active-directory/develop/security-best-practices-for-app-registration)
- [Details of registered application](https://learn.microsoft.com/en-us/azure/active-directory/develop/active-directory-how-applications-are-added)
- [Modern Authentication](https://github.com/Azure/FTALive-Sessions/blob/main/content/identity/identity-for-applications-AAD/modern-authentication.md)
- [Tokens in AAD](https://learn.microsoft.com/en-us/azure/active-directory/develop/security-tokens)