# Challenge 00 - Prerequisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)


## Introduction

Thank you for participating in the Entra ID B2B What The Hack. Before you can hack, you will need to set up some prerequisites.

## Common Prerequisites

We have compiled a list of common tools and software that will come in handy to complete most What The Hack Azure-based hacks!

You might not need all of them for the hack you are participating in. However, if you work with Azure on a regular basis, these are all things you should consider having in your toolbox.

<!-- If you are editing this template manually, be aware that these links are only designed to work if this Markdown file is in the /xxx-HackName/Student/ folder of your hack. -->

- [Azure Subscription](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-subscription)
- [Windows Subsystem for Linux](../../000-HowToHack/WTH-Common-Prerequisites.md#windows-subsystem-for-linux)
- [Managing Cloud Resources](../../000-HowToHack/WTH-Common-Prerequisites.md#managing-cloud-resources)
  - [Azure Portal](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-portal)
- [Visual Studio Code](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code)

## Description

Entra ID is the central identity control plane for an individual organization. The organizational directory holds all your users and controls how they can sign in (that is, perform authentication) - including security and governance features like Conditional Access (CA), Multi-Factor Authentication (MFA), Privileged Access Management (PIM), etc.

Thousands of applications are natively integrated with Entra ID. This includes first party offerings like Microsoft 365 (SharePoint, Exchange, Teams, ...) and Azure, as well as third party offerings like Salesforce, ServiceNow and Box.

However, Entra ID is an open Identity Provider (IdP), which means you can also integrate your own line-of-business (LOB) applications with Entra ID and let your organization's users sign in with their existing credentials and take full advantage of the governance features mentioned above. By adopting a fully externalized and cloud-scale platform (rather than a library or locally hosted identity solution), you are no longer responsible for collecting, storing and securing any credentials for your application's users.

## Success Criteria

1. You have a new Entra ID tenant created.
2. Your users are created in your tenant. Please note that you should create local users in your AD tenant. Guest users will be created later.

## Learning Resources

- [What is Entra ID?](https://learn.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-whatis)
- [Quickstart: Create a new tenant in Entra ID](https://learn.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-access-create-new-tenant)
- [Create a user](https://learn.microsoft.com/en-us/azure/active-directory/fundamentals/add-users-azure-active-directory)
- [Tenancy in Entra ID](https://learn.microsoft.com/en-us/azure/active-directory/develop/single-and-multi-tenant-apps)
- [Choosing the appropriate offering](https://github.com/Azure/FTALive-Sessions/blob/main/content/identity/microsoft-identity-platform/10-identity-offerings-choice.md)
