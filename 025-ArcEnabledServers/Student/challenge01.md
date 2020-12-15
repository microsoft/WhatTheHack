# What the Hack: Azure Arc enabled servers 

## Challenge 1 - Onboarding servers with Azure Arc
[Back](challenge00.md) - [Home](../readme.md) - [Next](challenge02.md)

### Introduction

[Azure Arc enabled servers](https://docs.microsoft.com/en-us/azure/azure-arc/servers/overview) allows customers to use Azure management tools on any server running in any public cloud or on-premises environment. In order to accomplish this, a [lightweight agent](https://docs.microsoft.com/en-us/azure/azure-arc/servers/agent-overview) must be deployed onto the server. Once deployed, this agent "projects" this server as an Azure Arc resource. As an Azure resource, this server can now be managed as if it were a VM hosted natively in Azure. 

In this challenge, you will need to deploy a server to an environment other than Azure. Once deployed, you will install the Azure Arc agent on the server and confirm that the server is visible from the Azure portal as a resource by using [Resource Graph Explorer](https://docs.microsoft.com/en-us/azure/governance/resource-graph/first-query-portal).

*Note: Before continuing, be sure that you have read and completed all the necessary [prerequisites](challenge00.md).

### Challenge

1. Deploy a server running a [supported OS](https://docs.microsoft.com/en-us/azure/azure-arc/servers/agent-overview#supported-operating-systems) to a non-Azure public cloud service or to an on-prem or local environment. Be sure that the server you deploy has a public IP address.

2. Install the the Azure Arc machine agent onto the server you deployed and verify that you can see the server projected into Azure from the Azure Portal.

3. Add a tag to the server and use Resource Graph Explorer to run a query showing all resources that have that tag.

### Success Criteria

1. You have deployed a server with a public IP address running in a non-Azure public cloud or on-prem environment.
2. You are able to see the server in the Azure Portal as an Azure resource.
3. You are able to use Resource Graph Explorer to run a query that shows your server and any applied tags.

[Back](challenge00.md) - [Home](../readme.md) - [Next](challenge02.md)