# Identity for Developers

## Introduction

The Identity for Developers Hack will provide you a deep dive experience into enabling customer-facing identity solutions for your applications. Identity is a booming area of the Microsoft Cloud platform and enabling identity solutions in your engagements allows for faster production deployments. Azure Active Directory B2C enables you to provide custom identity access management solutions for your applications.


![B2C Overview](https://docs.microsoft.com/en-us/azure/active-directory-b2c/media/overview/scenario-singlesignon.png)
## Learning Objectives

In this hack, we'll enable identity solutions using Azure Active Direcotry B2C, demonstrating how to:

  1. Create and integrate out of the box user flows

  2. Create and integrate customized policies

  3. Call REST APIs for token enrichment and claims validation

  4. Monitor and report on your B2C tenant

## Challenges

Challenge 0: **[Prepare your workstation for Identity development](Student/00-pre-reqs.md)**

- Get yourself ready to develop Identity solutions

Challenge 1: **[Provision an Azure AD B2C Tenant](Student/01-provision-b2c.md)**

- Provision a B2C Tenant

Challenge 2: **[Create a Sign Up and Sign In Experience](Student/02-susi.md)**

- Create a simple Sign Up and Sign In user flow and connect it to an ASPNETCORE MVC App

Challenge 3: **[Set Up an External IdP](Student/03-external-idp.md)**

- Set up the ability for your users to log in to your app with a GitHub, Facebook, or Gmail identity

Challenge 4: **[Customize Look and Feel and Localization](Student/04-l14n.md)**

- Add a bit of flare to your sign up and sign in pages by adding your company's logo, colors, and custom layouts to the user experience along with supporting multiple languages

Challenge 5: **[Enrich Claims During Sign-Up](Student/05-claims-enrichment.md)**

- Enrich the claims that you collect about a user during the sign up process by calling out to a custom REST API

Challenge 6: **[Add Conditional Access To Your Tenant](Student/06-conditional-access.md)**

- Create and enforce Conditional Access policies in your tenant such as enforcing MFA (including Microsoft Authenticator) and detecting Risky Login Behavior

Challenge 7: **[Admin the B2C Tenant with MS Graph](Student/07-admin-graph.md)**

- Use the MS Graph API to query your B2C tenant. Also use the Graph API to update various objects in your B2C tenant, such as policies, keys, and identity providers.

Challenge 8: **[Prepare Environment for Custom Policies](Student/08-prepare-ief.md)**

- We'll need custom policies, so let's get things ready. Apply the Trust Framework and also create an OIDC IdP for your external IdP

Challenge 9: **[Stepping Up To Custom Policies](Student/09-custom-policy.md)**

- Implement a custom policy for Sign In that will call to your custom REST API to perform claims enrichment for users that signed up prior to Challenge 5. Also, we'll break the Sign Up and Sign In policy to be just a Sign Up policy.

Challenge 10: **[Tracking a User's Journey in a Policy](Student/10-appinsights.md)**

- Enable App Insights in your custom policy so you can track a user through the various steps in the Orchestration. Add custom events to your Orchestration and track them in App Insights.

Challenge 11: **[Parameterize Your Custom Policies](Student/11-parameterize.md)**

- Take your custom policies and parameterize the values that could change from environment to environment, and use the B2C extension to VS Code to generate environment-specific policy files.

Challenge 12: **[BONUS: Monitoring Your Tenant](Student/12-monitor.md)**

- Monitor your B2C tenant by combining logs and app insights logs

## Prerequisites

- Your own Azure subscription with Owner access
- Visual Studio Code
- Azure CLI

## Repository Contents (Optional)

- `../Coach`
  - Coach's Guide and related files
- `../Resources/HarnessApp`
  - Sample AspNetCore app to be used to interact with your B2C tenant
- `../Resources/MSGraphApp`
  - Sample DotNetCore Console app to be used to query your B2C tenant
- `../Resources/Verify-inator`
  - Sample AspNetCore WebApi app to be called by your B2C tenant's SignUp User Flows
- `../Resources/PageTemplates`
  - Sample HTML page template that can be used to customize User Flows and Custom Policies
- `../Student`
  - Student's Challenge Guide

## Contributors

- David Hoerster
- Nick Thomas
- Tim Sullivan
