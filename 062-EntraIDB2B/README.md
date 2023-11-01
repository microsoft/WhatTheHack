# What The Hack - EntraIDB2B

## Introduction

In this What the Hack, participants will learn what Entra ID (AAD) is and how to use this service to implement modern authentication in their applications.

This hack is useful for identity architects and developers who want to integrate their solutions with the Microsoft Identity Platform to allow organizational users as well as external identities to sign in to their custom developed applications.

![Entra ID Overview](./Images/aspnetwebapp-intro.svg)

## Learning Objectives

- Create an Entra ID Tenant
- Register an application with Entra ID
- Invite a guest user to an Entra ID tenant
- Integrate Entra ID authentication into an Azure App Service using App Service Authentication (EasyAuth)
- Understand how to integrate Entra ID authentication into an application (ASP.Net/SPA/Desktop, etc.) via code.
- Deploy your Entra ID authenticated application to Azure

## Challenges

- Challenge 00: **[Prerequisites - Ready, Set, GO!](Student/Challenge-00.md)**
     - Create an Entra ID tenant
     - Entra ID single tenant setup
- Challenge 01: **[Register a new application](Student/Challenge-01.md)**
     - Register a new application in an Entra ID tenant
     - Understand the concepts of multi-tenant apps, service principals, authentication vs. authorization, security tokens
- Challenge 02: **[Test the sign-in](Student/Challenge-02.md)**
	 - Supported account types set to "Accounts in this organizational directory only (single-tenant)" with a redirect link to authr.dev
     - Use an authr.dev link to test the sign in
- Challenge 03: **[Invite a guest user](Student/Challenge-03.md)**
     - Complete B2B setup and invite a new guest user
     - Use an authr.dev link to test the sign in for the guest user and test sign in using the app set up
- Challenge 04: **[Integrate Entra ID authentication into an Azure App Service (EasyAuth)](Student/Challenge-04.md)**
	 - Integrate Entra ID authentication into an Azure App Service (EasyAuth)
- Challenge 05: **[Integrate Entra ID authentication into an application](Student/Challenge-05.md)**
	 - Integrate Entra ID authentication into an application
        - ASP.Net (Authorization Code Flow)
        - SPA (Angular) (PKCI)  
        - Desktop application (Client Credential Flow)
- Challenge 06: **[Deploy to Azure](Student/Challenge-06.md)**
	 - Deploy to Azure
     - Publish the Web App to the web site update its app registration redirect URIs to include the App Service URL(s)
     - Managed identity


## Prerequisites

- Your own Azure subscription with Owner access
- Visual Studio Code or Visual Studio


## Contributors

- Bappaditya Banerjee
- Nicholas McCollum 
