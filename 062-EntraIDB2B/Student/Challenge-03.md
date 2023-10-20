# Challenge 03 - Invite Guest Users in Entra ID tenant

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)


## Introduction

Azure Active Directory (Entra ID) B2B collaboration is a feature within External Identities that lets you invite guest users to collaborate with your organization. With B2B collaboration, you can securely share your company's applications and services with external users, while maintaining control over your own corporate data. Work safely and securely with external partners, large or small, even if they don't have Entra ID or an IT department.

![Entra ID B2B guest User Access](../Images/aad-b2b-guest-user.png)

## Description

With Entra ID B2B, the partner uses their own identity management solution, so there's no external administrative overhead for your organization. Guest users sign in to your apps and services with their own work, school, or social identities.

As an administrator, you can easily add guest users to your organization in the Azure portal.

- Create a new guest user in Entra ID, similar to how you'd add a new user.
- Assign guest users to apps or groups.
- Send an invitation email that contains a redemption link, or send a direct link to an app you want to share.

Guest users follow a few simple redemption steps to sign in.

Additionally, with a self-service sign-up user flow, you can create a sign-up experience for external users who want to access your apps. As part of the sign-up flow, you can provide options for different social or enterprise identity providers, and collect information about the user.

## Success Criteria

1. Your new guest user is invited.
2. Invited user has received and accepted the invitation.
3. Sign in with the guest user account is successful(using [Authr](https://authr.dev/)).

## Learning Resources

- [B2B Collaboration Overview](https://learn.microsoft.com/en-us/azure/active-directory/external-identities/what-is-b2b)
- [B2B Guest User ](https://learn.microsoft.com/en-us/azure/active-directory/external-identities/user-properties)
- [Real WOrld Scenario with External Identities](https://github.com/Azure/FTALive-Sessions/blob/main/content/identity/microsoft-identity-platform/11-external-identities-scenario.md)


## Advanced Challenges (Optional)

1. Self Service sign up would be enabled for your tenant.
