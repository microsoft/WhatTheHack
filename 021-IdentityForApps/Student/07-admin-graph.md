# Challenge \#7 - Admin Your B2C Tenant with MS Graph

[< Previous Challenge](./06-conditional-access.md) - **[Home](../readme.md)** - [Next Challenge>](./08-prepare-ief.md)

## Pre-requisites (Optional)

- Provisioned a B2C tenant
- Created a SignUp / SignIn (SUSI) User Flow
- Tested the User Flow via the Azure AD B2C Portal
- Incorporated a 3rd party IdP (e.g. GitHub, Facebook, etc.)
- Using a custom HTML template
- Localized resources along with multi-language support
- A working Profile Edit User Flow
- A functioning web harness application (either local or in Azure)
- Azure function that validates the CMC Consultant ID and also generates a Consultant Territory Name
- User SignUp process validates CMC Consultant ID and saves territory name to the user's account
- Profile Edit process allows the consultant to modify their territory name but not their CMC Consultant ID
- Conditional Access Policies that challenge users if they attempt to sign in from an Android device or block a user if they attempt to sign in from an anonymous browser session (like Tor)

## Description

It looks like you've done it - CMC IT Leadership is happy with your Identity and Access Management (IAM) policies, QA is satisfied with the functionality of your User Flow policies, and Security is happy that users are being challenged with MFA at appropriate times......BUT, IT Leadership would like some information about the consultants that have signed up. (You knew it was too soon to take some time off!)

IT Leadership would like to know what territory names have been assigned to their consultants. They'd like to see the consultant name, their CMC Consultant ID, and their Territory Name. It doesn't have to be a fancy report - just a simple output from a console app.

Leadership would like you to build an app that can query the B2C tenant and output some basic information about their consultants along with the two custom attributes you created: CMC Consultant ID and Territory Name.

Luckily, your innovative developer is still here (they haven't taken any time off either) and they've built an app that can do some of this (but you'll need to make some modifications). Luckily, the developer has parameterized the B2C bits, so you'll have to just make some updates to the configuration settings file (appsettings.json) in order to connect to your B2C tenant. You can find the developer's application in your resources folder.

## Success Criteria

IT Leadership will consider this a success and allow you to take a few hours off on a Friday afternoon sometime in the not-so-distant future if you're able to:

- Enable your B2C tenant to be queried using the MS Graph API;
- You're able to connect the developer's .NET Core app to your B2C tenant;
- You're able to output some basic information about your consultants, including:
  - Display Name
  - State
  - CMC Consultant ID
  - Territory Name

## Learning Resources

**[Create a Management Application for B2C](https://docs.microsoft.com/en-us/azure/active-directory-b2c/microsoft-graph-get-started?tabs=app-reg-ga)**

**[Managing Users via MS Graph for B2C](https://docs.microsoft.com/en-us/azure/active-directory-b2c/manage-user-accounts-graph-api)**

## Advanced Challenges (Optional)

_Too comfortable? Eager to do more? Try these additional challenges!_

**- It would be really interesting to see what phone number your consultants used for their Conditional Access registration. Can you modify the code to also query and output the consultant's registered phone number?**
