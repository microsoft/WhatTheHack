# Challenge \#10 - Getting Insights Into B2C

[< Previous Challenge](./09-custom-policy.md) - **[Home](./README.md)** - [Next Challenge>](./11-parameterize.md)
## Introduction

This challenge will have the team provision an App Insights resource and then enable tracking in their RelyParty policy for Delete My Account.

The team will enable this only in the Delete My Account policy file - there should not be adjustments to the base TrustFramework XML files. The Student Challenge also has a link on using Application Insights for troubleshooting and analytics. We'll use both.


## Hackflow

The team will:

1. Provision an Application Insights resource
2. Add orchestration steps in the Delete My Account journey for Successful Deletion and also for User Not Found
3. Re-run the custom policy, forcing success and user not found events to be generated
4. Examine App Insights metrics on what was captured
5. As a bonus, the team can inject App Insights and debug each step of a user journey
6. As a bonus bonus, the B2C Visual Studio Code extension can correlate App Insights events into a more readable format in VS Code.

## Tips

1. Suggest to the students to investigate the Azure AD B2C VS Code extension for App Insights viewing