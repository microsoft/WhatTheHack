# Challenge \#1 - Azure AD tenant Set up

**[Home](../README.md)** - [Next Challenge>](./01-register-app.md)

## Introduction

Azure AD is the central identity control plane for an individual organization. The organizational directory holds all your users and controls how they can sign in (that is, perform authentication) - including security and governance features like Conditional Access (CA), Multi-Factor Authentication (MFA), Privileged Access Management (PIM), etc.

Thousands of applications are natively integrated with Azure AD. This includes first party offerings like Microsoft 365 (SharePoint, Exchange, Teams, ...) and Azure, as well as third party offerings like Salesforce, ServiceNow and Box.

However, Azure AD is an open Identity Provider (IdP), which means you can also integrate your own line-of-business (LOB) applications with Azure AD and let your organizations' users sign in with their existing credentials (and taking full advantage of the governance features mentioned above). By adopting a fully externalized and cloud-scale platform (rather than a library or locally hosted identity solution), you are no longer responsible for collecting, storing and securing any credentials for your application's users.

## Success Criteria

1. You have a new Azure AD tenant created.
2. Your users are created in your tenant. Please note that you should create local users in your AD tenant, guest users will be created later.


## Learning Resources

- [What is Azure Active Directory?](https://learn.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-whatis)
- [Quickstart: Create a new tenant in Azure Active Directory](https://learn.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-access-create-new-tenant)
- [Create a user](https://learn.microsoft.com/en-us/azure/active-directory/fundamentals/add-users-azure-active-directory)
- [Tenancy in Azure Active Directory](https://learn.microsoft.com/en-us/azure/active-directory/develop/single-and-multi-tenant-apps)
- [Choosing the appropriate offering](https://github.com/Azure/FTALive-Sessions/blob/main/content/identity/microsoft-identity-platform/10-identity-offerings-choice.md)
