# Challenge \#8 - Preparation for Identity Experience Framework

[< Previous Challenge](./07-admin-graph.md) - **[Home](../README.md)** - [Next Challenge>](./09-custom-policy.md)

## Description

Custom policies are configuration files that define the behavior of your AAD B2C tenant. Leadership at CMC wants you to enable your tenant to allow custom policies to be used in the future. These may be used to allow different types of user interactions other than the pre-set User Flows defined in the Azure portal. Custom policies are a set of XML files that define technical profiles and user journeys in your AAD B2C tenant. Microsoft provides a starter pack of custom policies you can find down below in the learning resources.

In this challenge, CMC IT Leadership will be asking for a feature that will require B2C's Custom Policies. Being proactive, you want to prepare your environment for Custom Policies by deploying the TrustFramework into your B2C tenant.

You'll want to deploy the SocialAndLocalAccounts flavor of the TrustFramework, and also configure a social IdP (preferably the one that you configured in [Challenge 3](./03-external-idp.md) ) so that you can work with the accounts that you created earlier.


## Success Criteria

Your success criteria can be measured in the following ways:

- Successfully added `IdentityExperienceFramework`, `ProxyIdentityExperienceFramework`, and granted the proper permissions
- Cloned the GitHub repository of the Microsoft-provided custom policy starter pack
- Added the Application IDs from your `IdentityExperienceFramework` and `ProxyIdentityExperienceFramework` to the appropriate files from the starter pack
- You are able to SignUp and SignIn using the sample SUSI policy in the TrustFramework, both local accounts and social identity accounts
- You will not have to integrate the sample SUSI policy into your harness application - you can just test and run this policy via the Azure AD B2C portal

## Learning Resources

- [Get started with Custom Policies in Azure AD B2C](https://docs.microsoft.com/en-us/azure/active-directory-b2c/custom-policy-get-started)

- [Register an app with the MS identity platform](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app#register-a-new-application-using-the-azure-portal)

- [Custom Policy Starter Pack](https://github.com/Azure-Samples/active-directory-b2c-custom-policy-starterpack)
