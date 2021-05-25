# Challenge \#11 - Parameterize Your Policies

[< Previous Challenge](./10-appinsights.md) - **[Home](../README.md)** - [Next Challenge>](./12-monitor.md)

## Description

Now that we have Custom Policies in place with the Delete My Account policy, our CMC management wants to allow these custom policies to be deployed to different environments, such as dev/test or production.

Instead of searching and replacing environment-specific values (such as tenant name), CMC management wants to have these values parameterized.

You've heard that there's a way to parameterize policies using an Azure AD B2C plugin for Visual Studio Code, but that's all the information you have.

In this challenge, take your existing TrustFramework policies along with your Delete My Account policy and parameterize them so that you can deploy them to different environments.

## Success Criteria

You will have successfully passed this challenge if you can:

- Parameterize values in your TrustFramework policies, including:

  - Tenant Name
  - Application Insights Instrumentation Key
  - Proxy Identity Experience Framework AppId
  - Identity Experience Framework AppId
- You can provide setting values for your current environment and have your parameter values resolve using the Visual Studio Code Azure AD B2C plugin

## Learning Resources

- [Visual Studio Code Azure AD B2C Extension](https://marketplace.visualstudio.com/items?itemName=AzureADB2CTools.aadb2c)

- [Visual Studio Code Azure AD B2C Extension GitHub Repo](https://github.com/azure-ad-b2c/vscode-extension)


## Advanced Challenges (Optional)

- Set up another B2C tenant, which we'll consider it to be 'production', and set up the Trust Framework policies along with your Delete My Account policy using your parameterized policies.
