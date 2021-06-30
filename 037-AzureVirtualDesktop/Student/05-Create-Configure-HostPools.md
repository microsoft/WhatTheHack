# Challenge 5: Create and Configure Host Pools and Session Hosts

[< Previous Challenge](./04-Create-Manage-Images.md) - **[Home](../README.md)** - [Next Challenge >](./06-Implement-Manage-FsLogix.md)

## Introduction

In this challenge you will create and configure host pools and session hosts for your environment.

## Description

In this challenge we will be provisioning our Host Pools and Session Hosts. You will need to create four Host Pools with three different OS. You will also need to use three different ways to deploy those HostPools.
Once you created the Host Pools you will need to add Session Hosts, assign users to the Host Pools, and configure Host Pool settings. VMs for each region should be added to the domain's region OU.

**NOTE:** ALL HOST POOLS MUST BE CONFIGURED AS VALIDATION POOLS
* East US Region
    * Pooled Host Pool via an ARM Template, Win 10 multi-session OS
        * Metadata located in East US
        * Deny Storage and printers
        * Allow Camera and Microphone

* Japan West Region
    * Personal Host Pool via the Azure Portal, with Windows 10 Enterprise
        * Metadata located in West US 2
        * Users should be assigned directly to the session host.
        * Allow Storage redirection, printing, camera and microphone.
        * Enable VM on Connect

* UK South Region
    * Pooled Host Pool for Remote Apps via the Azure CLI, with Windows Server 2019
        * Metadata located in West Europe
        * Enable Screen Capture Protection
        * Deny clipboard, storage, printers, camera and microphone

## Success Criteria

1. Host Pools are created and Session Hosts showing Available
1. Users are assigned to the HostPool's appropriate app group
1. Able to show the Host Pool settings configured.

## Learning Resources

- [Azure CLI Reference](https://docs.microsoft.com/en-us/cli/azure/reference-index?view=azure-cli-latest)