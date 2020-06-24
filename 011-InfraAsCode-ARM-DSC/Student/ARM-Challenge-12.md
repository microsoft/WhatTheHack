# Challenge 12 - Linked Templates

[< Previous Challenge](./ARM-Challenge-11.md) - [Home](../readme.md)

## Introduction

The goals for this challenge include understanding:
- Linked templates allow for granular resource management and deployment
- Staging artifacts in a location accessible to the Azure Resource Manager

An application may require the composition of many underlying infrastructure resources in Azure. As you have now seen with just a single VMSS and its dependencies, an ARM template can grow large rather quickly.

When templates get big, they become monoliths. They are hard to manage.  By breaking your templates up into smaller linked templates, you can achieve more flexibility in how you manage your deployments.

In many companies, deployment of cloud infrastructure may be managed by different teams. For example, a common network architecture and its security settings may be maintained by an operations team and shared across multiple application development teams.

The network architecture and security groups are typically stable and do not change frequently. In contrast, application deployments that are deployed on the network may come and go.

## Description

In this challenge you will separate your existing ARM template deployment into two sets of linked templates. 

- Separate networking resources (Virtual Network & Network Security Groups) in to their own template.
- Separate the load balancer, VMSS, and its dependencies into their own template
- Create a new template that deploys each of the new sub-templates.
- Ensure parameters flow through from the new template to each of the sub-templates

By separating the networking resources into their own template, an application team can test its infrastructure deployment in a test network. At a later point in time, the linked networking template can be replaced with a production template provided by the company's operations team.

## Success Criteria

1. Verify that all resources deploy as before when you had a single ARM template

## Learning Resources

- [Using linked and nested templates when deploying Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/linked-templates)

## Tips

- Use an Azure Blob Storage account as the artifact location
- Secure access to the artifact location with a SAS token
- Pass these values to the ARM Template as parameters
