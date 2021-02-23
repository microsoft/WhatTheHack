# Challenge \#6 - Conditional Access - Are You Who You Say You Are?

[< Previous Challenge](./05-claims-enrichment.md) - **[Home](../README.md)** - [Next Challenge>](./07-admin-graph.md)

## Description

As a result of incorporating the CMC Consultant ID Verify-inator, QA has been satisfied with the fixes and CMC IT Leadership is happy again......BUT (here we go), they have realized that the site might need a little more tightening up.

IT Leadership has requested that we (you) incorporate policies in your SignUp / SignIn User Flow that will require users to verify who they are, using either a code sent to their phone or to their email address.

As a result, during the sign in process, a user should be prompted to enter a verification code (acquired either via a phone call, text message, or email). IT Leadership wants the conditional access policy to be based on user location, although for now, they want all locations to force a MFA challenge.

After some tests, IT Leadership decided to change your conditional access policies to only force a MFA challenge for all locations but only for users using Android devices. (Most of leadership has iPhones, so there's that.)

Lastly, IT Leadership has asked to block risky users, which we've decided to rely on Azure AD's risk detection in order to determine what users are risky. Leadership has decided to upgrade our B2C tenant to a P2 pricing tier (if it wasn't there already) and have asked you to implement an additional Conditional Access policy to detect medium and high risk users and block them from logging in to any application. A typical scenario for medium and high risk user activities could be using anonymous browsers (such as a [Tor browser](https://www.torproject.org/download/)) to access our apps.

## Success Criteria

CMC IT Leadership considers your efforts a success (and your odds of a promotion more likely) if you accomplish the following:

- You've implemented a Conditional Access policy that prompts for a MFA challenge for users from any location and on any device;
- You then modify your Conditional Access policy to only force a MFA for users from an Android device;
- You've created another Conditional Access policy to block users from accessing any B2C app for Medium and High risk users

## Learning Resources

- [Conditional Access in B2C](https://docs.microsoft.com/en-us/azure/active-directory-b2c/conditional-access-identity-protection-overview)
- [Create and Test a B2C Conditional Access Policy](https://docs.microsoft.com/en-us/azure/active-directory-b2c/conditional-access-user-flow)

## Advanced Challenges (Optional)

_Too comfortable? Eager to do more? Try these additional challenges!_

- You can create several different app registrations in your B2C tenant and then configure Conditional Access policies that are specific to each app registration. For one app reg, always force MFA; for another, only force MFA for iOS devices; for a third, force MFA for risky behaviors.
