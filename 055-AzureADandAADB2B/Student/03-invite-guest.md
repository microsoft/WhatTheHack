# Challenge \#3 - External Identity Providers

[< Previous Challenge](./02-susi.md) - **[Home](../README.md)** - [Next Challenge>](./04-l14n.md)

## Introduction

In addition to creating local accounts, Azure Active Directory B2C allows your users to sign in with credentials from enterprise or social identity providers (IdP), supporting OAuth 1.0 and 2.0, OpenID Connect, and SAML protocols.

![Identity Providers Supported by B2C](https://docs.microsoft.com/en-us/azure/active-directory-b2c/media/technical-overview/external-idps.png)
## Description

CMC IT Leadership is very excited with the SignUp / SignIn flow that you developed....BUT, they want some more features. They've decided that they would like to streamline the ability of consultants to sign in and sign up by allowing the consultants to use their social identity to sign up and sign in.

CMC IT has empowered you to determine which 3rd party Identity Provider (IdP) to integrate into your User Flow. Some examples that IT Leadership provided included Facebook, GitHub, and Twitter, but it's your decision.

CMC IT Leadership has asked that the consultant can choose, during sign-up, to either create a new account or use their 3rd party identity. IF they choose to use a 3rd party identity, they would be directed to the 3rd party IdP to authenticate before their Azure AD B2C user account is created. You should also collect the same information that you're collecting for new account creation (see Challenge 2), but most importantly is collecting the CMC Consultant ID. Other attributes are optional (as they may depend on the 3rd party IdP being integrated), but the CMC Consultant ID is **required** to be collected.

## Success Criteria

CMC IT Leadership will judge your success based on:

- Successful integration of a 3rd party IdP of your choosing for account SignUp and SignIn
- You are collecting additional attributes for the user, and the CMC Consultant ID is a required attribute. If the user does not provide it, do not allow the user to proceed.
- You are still enforcing the certified states and not allowing a user to choose a state that CMC is not certified.
- You can sign-up with both 3rd party social identities and also create a new account; you can sign-in with both 3rd party identities and also local accounts.

## Learning Resources

- [Integrate Facebook with Azure AD B2C](https://docs.microsoft.com/en-us/azure/active-directory-b2c/identity-provider-facebook)
- [Integrate GitHub with Azure AD B2C](https://docs.microsoft.com/en-us/azure/active-directory-b2c/identity-provider-github)

## Advanced Challenges (Optional)

_Too comfortable? Eager to do more? Try these additional challenges!_

- Instead of using a 3rd party social IdP, integrate an [Azure Active Directory](https://docs.microsoft.com/en-us/azure/active-directory-b2c/identity-provider-azure-ad-single-tenant). This could be a new AAD Tenant that you create for this challenge, but you will need permission to create Application Registrations.
