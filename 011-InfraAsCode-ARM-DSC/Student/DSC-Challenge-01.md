
# Challenge 1 - Deploy a Windows Virtual Machine

 [Home](../readme.md) - [Next Challenge>](./DSC-Challenge-02.md)

## Pre-requisites

This set of challenges focuses on Configuration Management of Windows Server using PowerShell Desired State Configuration (aka DSC).

These challenges were designed to be a follow-on to the [ARM Template challenges](../readme.md). It is assumed you have completed [ARM Challenges](../readme.md) 1-4 for ARM template basics, before attempting this set of challenges.

## Introduction

The goals of this challenge are understanding:

- Globally unique naming context and complex dependencies
- Clean code with neat parameter and variable values
- Figuring out what Azure resources it takes to build a VM

## Description

+	Extend your ARM Template to deploy a virtual machine
    +   VM requirements -
        +   Windows OS
        +   Use a secure secret value for the admin password from Azure Key Vault
    + Use a resource prefix and template variables to have consistent naming of resources

## Success Criteria

1. Verify that your VM has been deployed in the Azure Portal or Azure CLI
1. Verify that you can connect to your VM using Remote Desktop

## Tips

- Keep your parameters and variables clean so it's easier to trace when things go wrong.
- You may need to open additional ports to connect to your VM depending on which OS you deployed.
- You will need to supply your VM with a Public IP address or use the Azure Bastion service to connect to it.
