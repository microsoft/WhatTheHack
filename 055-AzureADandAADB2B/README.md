# Azure Active Directory

## Introduction

In this what the hack, participants will learn what Azure Active Directory (AAD) is and how to use this service to implement Modern Authentication in your applications.

This hack is mostly useful for identity architects and developers who want to integrate their solutions with the Microsoft Identity Platform to allow organizational users as well as external identities to sign in to their custom developed applications.

![Azure AD Overview](./Images/aspnetwebapp-intro.svg)
## Learning Objectives

- Understanding how to migrate an your(SPA/ASP.NET/WebForms/Console etc) application from Windows Integrated Authentication to OpenID Connect using Azure Active Directory.
- Compare the different identity offerings.
- Choose which identity offering is most appropriate for your requirements.
- Using a Managed Identity to avoid having to manage and store credentials.


## Challenges


Challenge 1: **[Azure AD Tenant set-up](Student/00-tenant-setup.md)**

- Create an Azure AD Tenant
- Azure AD  Single Tenant setup

Challenge 2: **[Register new application](Student/01-register-app.md)**

- Register new application in Azure AD tenant
- Understand the concept about Multi-tenant apps, Service Principals, authentication vs authorization, security tokens

Challenge 3: **[Test the sign-in](Student/02-test-sign-in)**

- Supported account types to Accounts in this organizational directory only (single-tenant) With redirect link authr.biz
- Use an authr link to test the sign in

Challenge 4: **[Invite a guest user](Student/03-invite-guest.md)**

- B2B set up/Invite a new guest user
- Use an authr link to test the sign in  for the guest user/test sign in using the app set up

Challenge 5: **[Integrate Azure AD authentication into an Azure App Service (EasyAuth)](Student/04-integrate-app-service.md)**

- Integrate Azure AD authentication into an Azure App Service (EasyAuth)

Challenge 6: **[Integrate Azure AD authentication into an application](Student/05-integrate-app-service.md)**

- Integrate Azure AD authentication into an application
    - ASP.Net (Authorization Code Flow)
    - SPA (React / Angular) (PKCI)  
    - Console application (Client Credential Flow)

- un the app with your user and guest user 

Challenge 7(optional): **[Deploy to Azure](Student/06-deploy-to-azure.md)**

- Deploy to Azure
- publish the Web App  to the web site, and
- update its client(s) to call the web site instead of IIS Express
- Managed identity


## Prerequisites

- Your own Azure subscription with Owner access
- Visual Studio Code or Visual Studio


## Contributors

- Bappaditya Banerjee
- Nicholas McCollum 
