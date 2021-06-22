# Challenge \#2 - Sign Me Up! Sign Me In!

[< Previous Challenge](./01-provision-b2c.md) - **[Home](../README.md)** - [Next Challenge>](./03-external-idp.md)

## Introduction

Now that you've created your B2C tenant, Contoso Manufacturing's consultant management website requires the ability for the consultants to sign-up and sign-in to the site.

In addition to providing some basic demographic information about the consultant (such as first and last name, display name, email address), you also want to collect the consultant's CMC Consultant ID during the sign-up process. The CMC Consultant ID is a 10 digit alphanumeric string that is assigned by Contoso Manufacturing to each of their consultants. When the consultant signs up on the management website, they need to provide this ID.

## Description

CMC's IT Management has asked you to set up the newly created B2C tenant to allow CMC consultants to sign-up for an account and also to be able to sign-in to the B2C tenant.

They are asking that you collect the following attributes of each consultant:

- First Name
- Last Name
- Display Name
- Email Address
- City
- State
- CMC Consultant ID (named "ConsultantID")

It should be noted that CMC only is licensed to do business in the following states: **New York (NY), Ohio (OH) and Pennsylvania (PA)** (values between parentheses represent the values that should be stored in the directory).

CMC IT Management has also asked that First and Last Name are displayed BEFORE Display Name on the sign up form. There's also a rumor that IT Management really likes the Slate Gray User Flow template.

CMC IT Management also wants the same attributes returned when the user successfully logs in, along with the Identity Provider name.
## Success Criteria

In order to be successful, CMC IT Management is requiring that consultants can:

- Sign-up for a new management website account
- Sign-in with their newly created account
- Ensure that the consultant provides a CMC ID
- Ensure that consultants in the states that CMC is certified in are allowed to sign up.
- Ensure that the email provided is a valid email address.
- Ensure that the user attributes are displayed in preferred order along with the proper template being used.
- Ensure a successful signin returns the attributes collected during signup, along with the Identity Provider name.

There isn't a consultant management web application yet (the developers are a bit behind schedule), so IT Management is fine with testing our sign-up and sign-in capabilities in the B2C tenant portal (for now!).

## Learning Resources

- [Azure AD B2C User Flow Overview](https://docs.microsoft.com/en-us/azure/active-directory-b2c/user-flow-overview)
- [Azure AD B2C Custom Attributes](https://docs.microsoft.com/en-us/azure/active-directory-b2c/user-flow-custom-attributes)

## Advanced Challenges (Optional)

_Too comfortable? Eager to do more? Try these additional challenges!_

- IT Management has decided that the sign-up policy doesn't require Email Verification (I mean, who would enter a non-existent email address??). Disable this in your sign-up policy.
- IT Management is also considering allowing users to edit their account after creation. Get a head start on this by putting together an Edit Profile User Flow and test it in the B2C Tenant Portal.
