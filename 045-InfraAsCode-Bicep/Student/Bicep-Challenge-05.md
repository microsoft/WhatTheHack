# Challenge 5 - Deploy a Virtual Machine

[< Previous Challenge](./Bicep-Challenge-04.md) - [Home](../README.md) - [Next Challenge>](./Bicep-Challenge-06.md)

## Introduction 

In this challenge, you will put all the pieces together and extend your Bicep template to deploy a Virtual Machine in Azure.

The goals for this challenge include understanding:
   + Globally unique naming context and complex dependencies
   + Clean code with neat parameter and variable values
   + Figuring out what Azure resources it takes to build a VM

## Description

+	Extend your Bicep template to deploy a virtual machine
    +   VM requirements -
        +   Linux OS
        +   Use a secure secret value for the admin password from Azure Key Vault
    + Use a resource prefix and template variables to have consistent naming of resources

## Success Criteria

1. Verify that your virtual machine has been deployed via the Azure Portal or Azure CLI.
1. Connect to your virtual machine and verify you can login (Linux with SSH)

## Tips

- For a Linux VM, you can use an admin password or an SSH key to control access to the VM. It is common (and a recommended practice) to use an SSH key with Linux instead of an admin password. If you are not familiar with Linux, we recommend using an admin password for this hack to keep things simple and focus on learning ARM Bicep templates.
- You may need to open additional ports to connect to your VM depending on which OS you deployed.
- You will need to supply your VM with a Public IP address or use the Azure Bastion service to connect to it.

## Learning Resources

- [Define resources with Bicep and ARM templates](https://docs.microsoft.com/en-us/azure/templates/)
- [Virtual Machine - Azure Resource Manager reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.compute/virtualmachines?tabs=bicep)