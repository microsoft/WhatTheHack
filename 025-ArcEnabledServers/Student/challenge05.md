# What the Hack: Azure Arc enabled servers 

## Challenge 5 – Arc Value Add: Enable Lighthouse *Coming Soon*
[Back](challenge04.md) - [Home](../readme.md) - [Next](challenge06.md)

### Introduction

[Azure Lighthouse](https://docs.microsoft.com/en-us/azure/lighthouse/overview) enables cross- and multi-tenant management, allowing for higher automation, scalability, and enhanced governance across resources and tenants.

With Azure Lighthouse, service providers can deliver managed services using comprehensive and robust management tooling built into the Azure platform. Customers maintain control over who can access their tenant, what resources they can access, and what actions can be taken. This offering can also benefit enterprise IT organizations managing resources across multiple tenants.

   >**Note**: You can simplify the provisioning process by using [sample templates](https://techcommunity.microsoft.com/t5/azure-paas-blog/azure-lighthouse-step-by-step-guidance-onboard-customer-to/ba-p/1793055)

### Challenge

1. Pair with another member of your team and [Oonboard their Azure subscription](https://docs.microsoft.com/en-us/azure/lighthouse/how-to/onboard-customer) into your Azure Lighthouse subscription. They should enable delegated access of your Azure Arc enabled server to you.

### Success Criteria

1. In the *provider* subscription, on the Azure Lighthouse > My customers blade, verify that you can locate the *customer's** subscription.

2. In the *customer* subscription, on the Service Providers blade, verify that you can locate the *provider's* offer.

[Back](challenge04.md) - [Home](../readme.md)
