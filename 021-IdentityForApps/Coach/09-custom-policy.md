# Challenge \#9 - Creating Custom Policies

[< Previous Challenge](./08-prepare-ief.md) - **[Home](./README.md)** - [Next Challenge>](./10-appinsights.md)
## Introduction

In this challenge, we'll deploy a custom policy to allow a user to Delete Their Account.

This challenge uses a custom policy found in the Azure AD B2C Custom Policy gallery GitHub Repo, linked in the challenge.

Also note that the solution for the custom policies are located in the [Challenge-09](./Solutions/Challenge-09) which includes the applicable TrustFramework policies along with the specific policy for the "DeleteMyAccount" requirement.

## Hackflow

1. Review the Delete My Account Custom Policy in the GitHub repo.
2. Download the policy files
3. Review the XML in the policy files
4. Modify for your tenant
5. Upload new policy to your B2C Tenant
6. Create a new user using an existing SUSI policy
7. Now run the Delete My Account policy
8. Incorporate the Delete My Account into the harness web app and wire up the Button on the LoginPartial view via the appsettings.json file

