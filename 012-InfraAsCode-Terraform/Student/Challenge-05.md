# Challenge 5 - Deploy a Virtual Machine

[< Previous Challenge](./Challenge-04.md) - [Home](../README.md) - [Next Challenge >](./Challenge-06.md)

## Introduction

In this challenge, you will put all the pieces together and extend your Terraform manifests to deploy a Virtual Machine in Azure.

The goals for this challenge include understanding:

+ Globally unique naming context and complex dependencies
+ Clean code with neat parameter and variable values
+ What Azure resources it takes to build a VM

## Description

+ Extend your Terraform to deploy a virtual machine:
  + VM requirements:
    + Linux OS
    + Have Terraform generate an SSH key and pass the public key to the VM. Store the private SSH key in the Azure Key Vault.
      + Extra credit:  write your SSH private key to a local file
  + Use a resource prefix and template variables to have consistent naming of resources.

## Success Criteria

1. Verify that your virtual machine has been deployed via the Azure Portal or Azure CLI.
1. Connect to your virtual machine and verify you can login (Linux with SSH).  (You will need to grab the SSH private key from the Key Vault)

## Hints

+ It's up to you if you want to start with a clean slate set of manifests or if you want to extend your current manifests to include a VM
+ Note that you will need to create a VNET, subnet, public IP, and NIC in addition to your VM
+ You will need to open port 22 in your NSG to be able to SSH to the VM
+ You will need to supply your VM with a Public IP address or use the Azure Bastion service to connect to it

## Learning Resources

+ [Quickstart: Use Terraform to create a Linux VM](https://learn.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-terraform)
+ [azurerm_linux_virtual_machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine)
+ [tls_private_key - used to create ssh keys](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key)
+ [Virtual Machine - Azure Resource Manager reference](https://learn.microsoft.com/azure/templates/microsoft.compute/virtualmachines)
