# What the Hack: Azure Arc enabled servers 

## Challenge 2 – Policy for Azure Arc connected servers
[Back](challenge01.md) - [Home](../readme.md) - [Next](challenge03.md)

### Introduction

In the last challenge you deployed a server somewhere other than Azure, and then enabled it as an Azure resource by using Azure Arc. Now that you have a server projected into Azure, we can start to use Azure to manage and govern this server. One of the primary ways we can do this is by using Azure Policy(https://docs.microsoft.com/en-us/azure/governance/policy/overview). By using Policy, we can automatically perform management tasks on Azure resources such as creating [tags](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources) or connecting to [Log Analytics](https://docs.microsoft.com/en-us/azure/azure-monitor/learn/tutorial-resource-logs).

### Challenge

1. Assign a policy that adds a resource tag to all resources in the resource group where your Azure Arc connected servers are located.

2. Create a suitable Log Analytics workspace to use with your Azure Arc resources. Make sure it is in the same region as your Azure Arc resources to avoid egress charges.

3. Assign a policy that automatically deploys the Log Analytics agent to Azure Arc connected servers if they do not have the agent.

4. Configure the Log Analytics agent to collect performance metrics of the connected machine.

### Success Criteria

1. Azure Arc connected servers should have a tag applied by the policy you created in Challenge #1. 

2. Azure Arc connected servers should have the Log Analytics agent deployed and working.

3. You can use the Log Analytics workspace to query performance metrics about your Azure Arc connected machine.

[Back](challenge01.md) - [Home](../readme.md) - [Next](challenge03.md)
