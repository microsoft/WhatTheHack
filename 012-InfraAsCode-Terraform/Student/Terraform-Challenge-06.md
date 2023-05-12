# Challenge 6 - Terraform Modules

[< Previous Challenge](./Challenge-05.md) - [Home](../README.md) - [Next Challenge >](./Challenge-07.md)

## Introduction

The goals for this challenge include understanding how Terraform modules allow for granular resource management and deployment, and support separation of duties.

An application may require the composition of many underlying infrastructure resources in Azure. As you have now seen with just a single VM and its dependencies, a Terraform manifest can grow large rather quickly.

Terraform supports the concept of [*modules*](https://developer.hashicorp.com/terraform/language/modules). When you write a Terraform template you can call another Terraform file as a module.

When templates get big, they become monoliths. They are hard to manage.  By breaking your templates up into smaller modules, you can achieve more flexibility in how you manage your deployments.

In many companies, deployment of cloud infrastructure may be managed by different teams. For example, a common network architecture and its security settings may be maintained by an operations team and shared across multiple application development teams.

The network architecture and security groups are typically stable and do not change frequently. In contrast, application deployments that are deployed on the network may come and go.

## Description

In this challenge you will separate your existing Terraform manifests deployment into modules

- Move the VM and its dependencies (VM, NIC, public-ip) into their own module. (i.e., move into a subdirectory).  
    - The module should take the following inputs: `resource group, location, vmname, admin username, ssh public key, subnet id`
    - The module should output: `vm_public_ip_address`
- Move the vnet, subnet, and NSG definitions into their own module. The module should take the following parameters:
    - `resource group, location, vnet name, address space, subnet name, subnet address prefix`

By separating the networking resources into their own modules, an application team can test its infrastructure deployment in a test network. At a later point in time, the networking module can be replaced with a production module provided by the company's operations team.

## Success Criteria

1. Verify that all resources deploy as before when you had a single Terraform template.

## Learning Resources

- [Learn Terraform modules](https://developer.hashicorp.com/terraform/tutorials/modules/module)
- [Azure Terraform Verified Modules](https://github.com/Azure/terraform-azure-modules)

