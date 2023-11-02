# Challenge 08 - Microsoft Entra ID Integration

[< Previous Challenge](./Challenge-07.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-09.md)

## Introduction
You're also able to authenticate your Azure Red Hat OpenShift with Microsoft Entra ID! In this challenge, we will be integrating Microsoft Entra ID with ARO so that we can use Microsoft credentials to login to the ARO Web Console.

**NOTE:** Azure Active Directory (Azure AD) has been renamed to Microsoft Entra ID to better communicate the multi-cloud, multi-platform functionality of the product and unify the naming of the Microsoft Entra product family.

## Description
In this challenge, we will be integrating Microsoft Entra ID with ARO so that Entra ID can be configured as authentication for the ARO Web Console. 
- **HINT:** To do this, you will need to register an Microsoft Entra application for authentication. Please keep track of the different values you receive from the Azure Portal, they will be used to configure the ARO Web Console

## Success Criteria
- Demonstrate that you have an option to login to the ARO Web Console using Microsoft Entra ID
- Demonstrate logging in with Microsoft Entra ID successfully

## Learning Resources
- [Authentication in ARO](https://docs.openshift.com/container-platform/4.11/authentication/index.html)
- [Understanding Identity Provider Configuration](https://docs.openshift.com/container-platform/4.11/authentication/understanding-identity-provider.html)
- [Configuring OAuth Clients](https://docs.openshift.com/container-platform/4.11/authentication/configuring-oauth-clients.html)
- [Configure Microsoft Entra authentication for an Azure Red Hat OpenShift 4 cluster (Portal)](https://learn.microsoft.com/en-us/azure/openshift/configure-azure-ad-ui)
