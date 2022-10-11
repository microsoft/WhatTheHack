# Challenge \#8 - Preparation for Identity Experience Framework

[< Previous Challenge](./07-admin-graph.md) - **[Home](./README.md)** - [Next Challenge>](./09-custom-policy.md)
## Introduction

This challenge lays the groundwork for using Custom Policies in Azure AD B2C. In the next challenge, we'll create a "Delete My Account" Custom Policy that will use the TrustFramework that we deploy in this step.

## Hackflow

1. Following the link to get started with Custom Policies, copy the TrustFramework XML files
2. Create the appropriate application registrations and policy keys in the B2C tenant for the TrustFramework
3. Modify the TrustFramework XML files to:

    - modify the social IdP if it's not Facebook
    - apply your policy key names and trust framework application ids
    - use your tenant name

4. Deploy your Trustframework XML files
5. Test out your TrustFramework deploy by running the sample SignIn policy from the Azure AD B2C portal

