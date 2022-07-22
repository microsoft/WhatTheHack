# Challenge 1: First Thing is First - A Resource Group

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Introduction

All work in Azure begins with the resource group. A resource group is a container that holds related resources for an Azure solution. The resource group includes those resources that you want to manage as a group. You decide which resources belong in a resource group based on what makes the most sense for your organization.

## Description

- Figure out which Azure data center is closest to you. You will be using it for this hack.
- Put the “scripting name” for the Azure Data Center that the Azure CLI uses in a variable called loc
  - **HINT:** South Central US scripting name is `southcentralus`
- In your shell, create a Resource Group in that data center
- **TIP:** Create a 6 to 8 letter label that is unique to you that can be used to compose names for Azure resources, since several items we are creating today will have public DNS names that must be globally unique.
- **TIP:** Again, you might want to put the resource group name in a shell variable.

## Success Criteria

1. You have a new resource group created using the Azure region closest to you.

## Learning Resources

- [Overview of the Azure Resource Manager](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/overview)
- [Resource Groups](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/overview#resource-groups)
- [Azure Naming Conventions](https://docs.microsoft.com/en-us/azure/architecture/best-practices/naming-conventions)
