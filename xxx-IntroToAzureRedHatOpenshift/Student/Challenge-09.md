# Challenge 09 - Azure Active Directory Integration

[< Previous Challenge](./Challenge-08.md) - **[Home](../README.md)**

## Introduction
You've made it to the last challenge. Congratulations! Guess what? You're also able to authenticate your Azure Red Hat OpenShift with Azure Active Directory! In this challenge, we will be integrating Azure AD with ARO so that we can use Microsoft credentials to login to the ARO Web Console.

## Description
In this challenge, we will be integrating Azure Active Directory with ARO so that Azure AD can be configured as authentication for the ARO Web Console. 
- **HINT:** To do this, you will need to register an Azure AD application for authentication. Please keep track of the different values you receive from the Azure Portal, they will be used to configure the ARO Web Console

## Success Criteria
- Demonstrate that you have an option to login to the ARO Web Console using Azure AD
- Demonstrate logging in with Azure AD successfully

## Learning Resources
- [Authentication in ARO](https://docs.openshift.com/container-platform/4.11/authentication/index.html)
- [Understanding Identity Provider Configuration](https://docs.openshift.com/container-platform/4.11/authentication/understanding-identity-provider.html)
- [Configuring OAuth Clients](https://docs.openshift.com/container-platform/4.11/authentication/configuring-oauth-clients.html)
- [Configure Azure AD authentication for an ARO cluster](https://learn.microsoft.com/en-us/azure/openshift/configure-azure-ad-ui)