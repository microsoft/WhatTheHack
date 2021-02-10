# Challenge \#10 - Getting Insights Into B2C

[< Previous Challenge](./09-custom-policy.md) - **[Home](../readme.md)** - [Next Challenge>](./11-parameterize.md)

## Pre-requisites (Optional)

- Provisioned a B2C tenant
- Deployed the Identity Experience Framework (IEF)
- Deployed the Challenge 9 Delete My Account Policy

## Description

You've been asked to add some debugging to the Delete My Account policy in order to see what happens when a user tries to log in with a social identity that doesn't exist in the B2C tenant. For example, if the user tries to delete the account "name@github.com" (which is a valid GitHub login) but that account doesn't exist in the B2C tenant, what step is this being handled in the User Journey?

The CMC Product Team would like to know:

- How can we tell, by using metrics, how many "user not found" events were encountered by users?
- How many "successful delete" events were encountered by users?

## Success Criteria

You will be successful with this challenge if you are able to:

- Inject Application Insights into your User Journey
- Record specific events for "user not found" and "successful delete"
- Display the recorded events to your Coach

## Learning Resources

**- [Using Application Insights to Collect B2C Logs](https://docs.microsoft.com/en-us/azure/active-directory-b2c/troubleshoot-with-application-insights)**
**- [Use Application Insights to track user behavior](https://docs.microsoft.com/en-us/azure/active-directory-b2c/analytics-with-application-insights)**

## Tips

**- Make sure your Custom Policy is in `Developer` deployment mode.**

