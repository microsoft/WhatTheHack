# Identity for Developers

## Introduction

The Identity for Developers Hack will provide you a deep dive experience into enabling customer-facing identity solutions for your applications. Identity is a booming area of the Microsoft Cloud platform and enabling identity solutions in your engagements allows for faster production deployments. Azure Active Directory B2C enables you to provide custom identity access management solutions for your applications.


![Azure AD Overview](https://docs.microsoft.com/en-us/azure/active-directory-b2c/media/overview/scenario-singlesignon.png)
## Learning Objectives


## Overall Architecture

In this hack, you will build Azure AD B2C policies that enable users to be able to sign up, sign in, edit their profile, and delete their account. Along the way, you will enable API integration, conditional access checks, monitoring, and other services. The below diagram shows the various services this hack involves, along with the corresponding challenges where you will encounter these services. The section that follows this provides additional information and links to the specific challenges.

![Contoso Manufacturing Consultant App Architecture](./Images/Azure_AD_B2C_WTH_Final_Design.png)
## Challenges

Challenge 1: **[Azurer AD Tenant set-up](Student/00-tenant-setup.md)**

- Create an Azure AD Tenant
- Azure AD  Single Tenant setup

Challenge 2: **[Register new application and integrate Azure AD authentication into an Azure App Service](Student/01-register-app.md)**

- Register new application  -
- Integrate Azure AD authentication into an Azure App Service (EasyAuth)

Challenge 3: **[Test the sign-in](Student/02-test-sign-in)**

- Supported account types to Accounts in this organizational directory only (single-tenant) With redirect link authr.biz 
- Use an authr link to test the sign in

Challenge 4: **[Invite a guest user](Student/03-invite-guest.md)**

- B2B set up/Invite a new guest user
- Use an authr link to test the sign in  for the guest user/test sign in using the app set up

Challenge 5: **[Integrate Azure AD authentication into an application](Student/04-integrate-app.md)**

- Integrate Azure AD authentication into an application
    - ASP.Net (Authorization Code Flow)
    - SPA (React / Angular) (PKCI)
    - Native Client (Windows Forms)
    - Console application (Client Credential Flow)

- un the app with your user and guest user 

Challenge 6(optional): **[Deployt to Azure](Student/05-deploy-to-azure.md)**

- Deploy to Azure
- publish the Web App  to the web site, and
- update its client(s) to call the web site instead of IIS Express
- Managed identity


## Prerequisites

- Your own Azure subscription with Owner access
- Visual Studio Code
- Azure CLI

## Repository Contents

- `./Student`
  - Student's Challenge Guide
- `./Student/Resources/HarnessApp`
  - Sample AspNetCore app to be used to interact with your B2C tenant
- `./Student/Resources/MSGraphApp`
  - Sample DotNetCore Console app to be used to query your B2C tenant
- `./Student/Resources/Verify-inator`
  - Sample AspNetCore WebApi app to be called by your B2C tenant's SignUp User Flows
- `./Student/Resources/PageTemplates`
  - Sample HTML page template that can be used to customize User Flows and Custom Policies
- `./Coach`
  - Coach's Guide and related files

## Contributors

- Nicholas McCollum
- Bappaditya Banerjee
