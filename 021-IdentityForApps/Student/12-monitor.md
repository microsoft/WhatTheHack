# Challenge \#12 - Hey, What's Going On In My B2C Tenant??

[< Previous Challenge](./11-parameterize.md) - **[Home](../README.md)**

## Introduction
Azure Active Directory sign-in and auditing logs can be routed to many different monitoring solutions, such as a Log Analytics Workspace. You can then use the power of Log Analytics to query data, create alerts, and produce workbooks and visualizations.

![Azure AD B2C Log Export](https://docs.microsoft.com/en-us/azure/active-directory-b2c/media/azure-monitor/azure-monitor-flow.png)
## Description

We've done a lot with Azure AD B2C and CMC Leadership is really thrilled with everything. They have one last ask -- is there a way we can monitor our B2C activity around logins, conditional access request, failed logins, etc.

They are already Log Analytics users, so if there's a way to incorporate B2C monitoring into Log Analytics, that would be fantastic.

Also, CMC would like to see some workbooks providing different views of the B2C activity - can we visualize certain events in our B2C tenant?

## Success Criteria

To successfully complete this challenge, enable Azure Monitor for your B2C tenant. Take a look at the Learning Resources section in order for some ideas on how to incorporate your B2C logs into a Log Analytics workspace.

At the end of this challenge, you should be able to:

- Export B2C logs into a Log Analytics workspace;
- Create some queries and/or visualizations for events such as failed logins, coniditional access requests.
- **BONUS**: Using the Learning Resources below, create a Workbook to collect different events. This is not required for successfully completing this challenge.

## Learning Resources

_List of relevant links and online articles that should give the attendees the knowledge needed to complete the challenge._

- [Enabling Azure Monitor for Azure AD B2C](https://docs.microsoft.com/en-us/azure/active-directory-b2c/azure-monitor)

- [Azure AD B2C Reports and Alerts GitHub Repo](https://github.com/azure-ad-b2c/siem#phone-authentication-failures)

- [Creating Alerts for Your Azure AD B2C Monitoring](https://docs.microsoft.com/en-us/azure/active-directory-b2c/azure-monitor#create-alerts)

## Advanced Challenges (Optional)

_Too comfortable? Eager to do more? Try these additional challenges!_

- Can you create a custom dashboard that has some views from the various B2C workbooks?

- Configure Azure Sentinel for the Log Analytics Workspace where you are exporting your B2C logs to. What additional information does Sentinel provide?

- Can you create some alerts in your Log Analytics workspace for certain B2C events?