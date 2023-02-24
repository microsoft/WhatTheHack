# What The Hack - AzureADandAADB2B

## Introduction

In this what the hack, participants will learn what Azure Active Directory (AAD) is and how to use this service to implement modern authentication in their applications.

This hack is useful for identity architects and developers who want to integrate their solutions with the Microsoft Identity Platform to allow organizational users as well as external identities to sign in to their custom developed applications.

![Azure AD Overview](./Images/aspnetwebapp-intro.svg)

## Learning Objectives

- Create an Azure Active Directory Tenant
- Register an application with Azure Active Directory
- Invite a guest user to an Azure Active Directory tenant
- Integrate Azure Active Directory authentication into an Azure App Service using App Service Authentication (EasyAuth)
- Understand how to integrate Azure Active Directory authentication into an application (ASP.Net / SPA / Desktop, etc.) via code.
- Deploy your Azure Active Directory authenticated application to Azure

## Challenges

- Challenge 00: **[Prerequisites - Ready, Set, GO!](Student/Challenge-00.md)**
     - Create an Azure AD tenant
     - Azure AD single tenant setup
- Challenge 01: **[Register new application](Student/Challenge-01.md)**
     - Register a new application in an Azure AD tenant
     - Understand the concepts of multi-tenant apps, service principals, authentication vs authorization, security tokens
- Challenge 02: **[Test the sign-in](Student/Challenge-02.md)**
	 - Supported account types set to "Accounts in this organizational directory only (single-tenant)" with redirect link to authr.biz
     - Use an authr.biz link to test the sign in
- Challenge 03: **[Invite a guest user](Student/Challenge-03.md)**
     - B2B set up / invite a new guest user
     - Use an authr.biz link to test the sign in for the guest user / test sign in using the app set up
- Challenge 04: **[Integrate Azure AD authentication into an Azure App Service (EasyAuth)](Student/Challenge-04.md)**
	 - Integrate Azure AD authentication into an Azure App Service (EasyAuth)
- Challenge 05: **[Integrate Azure AD authentication into an application](Student/Challenge-05.md)**
	 - Integrate Azure AD authentication into an application
        - ASP.Net (Authorization Code Flow)
        - SPA (Angular) (PKCI)  
        - Desktop application (Client Credential Flow)
- Challenge 06: **[Deploy to Azure](Student/Challenge-06.md)**
	 - Deploy to Azure
     - Publish the Web App to the web site update its app registration redirect URIs to include the App Service URL(s)
     - Managed identity
- Challenge 07: **[Title of Challenge](Student/Challenge-07.md)**
	 - Description of challenge


## Prerequisites

- Your own Azure subscription with Owner access
- Visual Studio Code or Visual Studio


## Contributors

- Bappaditya Banerjee
- Nicholas McCollum 
