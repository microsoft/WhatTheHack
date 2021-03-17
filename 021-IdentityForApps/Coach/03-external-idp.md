# Challenge \#3 - External Identity Providers

[< Previous Challenge](./02-susi.md) - **[Home](./README.md)** - [Next Challenge>](./04-l14n.md)
## Introduction 

This challenge will walk your attendees through creating an external IdP (Identity Provider) based on a social identity provider, like GitHub. 

## Hackflow

1. If the team is stumped on where to begin, you may want to point them to [this list](https://docs.microsoft.com/en-us/azure/active-directory-b2c/add-identity-provider) of identity providers supported by B2C. Make sure that they choose one supported by User Flows, such as GitHub, Facebook, or a Generic OpenID Connect provider.
2. Follow the steps in the proper doc page, but steps will generally follow this:
    - Create an application registration id and secret in the social IdP
    - Select the IdP you want to configure in the Azure AD B2C portal
    - Give your IdP a name and provide the client id and secret
    - If using the Generic OpenID Connect provider, you will also have to provide additional metadata, such as claim mapping data.
3. You can then add the IdP to your User Flow by editing it and selecting Properties -> Identity Providers.
4. When you run your User Flow, your social IdP should be an option for SignUp/SignIn.