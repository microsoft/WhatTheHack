# Challenge 06 - Bicep Modules

[< Previous Challenge](./Challenge-05.md) - [Home](../README.md) - [Next Challenge >](./Challenge-07.md)

## Introduction

The goals for this challenge include understanding:

- Bicep modules allow for granular resource management and deployment
- How Bicep modules can support separation of duties

An application may require the composition of many underlying infrastructure resources in Azure. As you have now seen with just a single VM and its dependencies, an ARM template can grow large rather quickly.

Bicep introduces the concept of *modules*. These are similar to linked templates but are much simpler to work with. When you write a Bicep file you can call another Bicep file as a module. When your template is transpiled into JSON, a single ARM template is produced including the code from your module(s).

When templates get big, they become monoliths. They are hard to manage. By breaking your templates up into smaller modules, you can achieve more flexibility in how you manage your deployments.

In many companies, deployment of cloud infrastructure may be managed by different teams. For example, a common network architecture and its security settings may be maintained by an operations team and shared across multiple application development teams.

The network architecture and security groups are typically stable and do not change frequently. In contrast, application deployments that are deployed on the network may come and go.

## Description

In this challenge you will separate your existing Bicep template deployment into two modules.

- Separate networking resources (Virtual Network and Network Security Group) into their own module.
- Separate the VM and its dependencies into their own module.
- Create a new Bicep template that deploys each of the new modules.
- Ensure parameters flow through from the new template to each of the modules.

By separating the networking resources into their own modules, an application team can test its infrastructure deployment in a test network. At a later point in time, the networking module can be replaced with a production module provided by the company's operations team.

## Success Criteria

1. Verify that the Bicep CLI does not show any errors and correctly emits an ARM JSON template that includes all of the resources in the Bicep modules.
1. Verify that all resources deploy as before when you had a single Bicep template.

## Learning Resources

- [Use Bicep modules](https://learn.microsoft.com/azure/azure-resource-manager/bicep/modules)
- [Using linked and nested ARM Templates with JSON when deploying Azure resources](https://learn.microsoft.com/azure/azure-resource-manager/templates/linked-templates?tabs=azure-cli) - Read this to appreciate how much Bicep improves upon the complexity of linked templates with ARM Templates with JSON.
