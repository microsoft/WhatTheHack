# Challenge 05 - Deploy a Virtual Machine

[< Previous Challenge](./Challenge-04.md) - [Home](../README.md) - [Next Challenge >](./Challenge-06.md)

## Introduction

In this challenge, you will put all the pieces together and extend your Bicep template to deploy a Virtual Machine in Azure.

The goals for this challenge include understanding:

+ Globally unique naming context and complex dependencies
+ Clean code with neat parameter and variable values
+ Figuring out what Azure resources it takes to build a VM

## Description

+ Extend your Bicep template to deploy a virtual machine:
  + VM requirements:
    + Linux OS
    + Use a secure secret value for the admin password from Azure Key Vault.
  + Use a resource prefix and template variables to have consistent naming of resources.

## Success Criteria

1. Verify that your virtual machine has been deployed via the Azure Portal or Azure CLI.
1. Connect to your virtual machine and verify you can login (Linux with SSH).

## Tips

+ Yes, it's generally best practice for a Linux VM to use an SSH key. But for this exercise, we want you to use an admin password to demonstrate integrating with a Key Vault.
+ You may need to open additional ports to connect to your VM depending on which OS you deployed.
+ You will need to supply your VM with a Public IP address or use the Azure Bastion service to connect to it.

## Learning Resources

+ [Define resources with Bicep and ARM templates](https://learn.microsoft.com/azure/templates/)
+ [Virtual Machine - Azure Resource Manager reference](https://learn.microsoft.com/azure/templates/microsoft.compute/virtualmachines?tabs=bicep&pivots=deployment-language-bicep)
