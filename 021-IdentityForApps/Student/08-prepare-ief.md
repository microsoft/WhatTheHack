# Challenge \#8 - Preparation for Identity Experience Framework

[< Previous Challenge](./07-admin-graph.md) - **[Home](../readme.md)** - [Next Challenge>](./09-custom-policy.md)

## Pre-requisites

- Provisioned a B2C tenant

## Description

Custom policies are configuration files that define the behavior of your AAD B2C tenant. Leadership at CMC wants you to enable your tenant to allow custom policies to be used in the future. These may be used to allow different types of user interactions other than the pre-set User Flows defined in the Azure portal. Custom policies are a set of XML files that define technical profiles and user journeys in your AAD B2C tenant. Microsoft provides a starter pack of custom policies you can find down below in the learning resources.

## Success Criteria

Your success criteria can be measured in the following ways:

- Successfully added `IdentityExperienceFramework`, `ProxyIdentityExperienceFramework`, and granted the proper permissions
- Cloned the GitHub repository of the Microsoft-provided custom policy starter pack
- Added the Application IDs from your `IdentityExperienceFramework` and `ProxyIdentityExperienceFramework` to the appropriate files from the starter pack

## Learning Resources

**[Get started with Custom Policies in Azure AD B2C](https://docs.microsoft.com/en-us/azure/active-directory-b2c/custom-policy-get-started)**

**[Register an app with the MS identity platform](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app#register-a-new-application-using-the-azure-portal)**

**[Custom Policy Starter Pack](https://github.com/Azure-Samples/active-directory-b2c-custom-policy-starterpack)**
