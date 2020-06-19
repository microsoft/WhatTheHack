# Challenge 5 - Deploy a Virtual Machine

[< Previous Challenge](./ARM-Challenge-04.md) - [Home](../readme.md) - [Next Challenge>](./ARM-Challenge-06.md)

## Introduction 

In this challenge, you will put all the pieces together and extend your ARM template to deploy a Virtual Machine in Azure.

The goals for this challenge include understanding:
   + Globally unique naming context and complex dependencies
   + Clean code with neat parameter and variable values
   + Figuring out what Azure resources it takes to build a VM

This is where the "choose your own adventure" part of this hackathon begins:

- If you plan to do the Powershell DSC challenges, complete this challenge by deploying a Windows VM, then divert to the [PowerShell DSC Challenge 01](./DSC-Challenge-01.md).

- If you do not plan on doing the PowerShell DSC challenges, complete this challenge by deploying a Linux VM.  The remaining ARM challenges build on the Linux VM deployment.

## Description

+	Extend your ARM Template to deploy a virtual machine
    +   VM requirements -
        +   Linux OS (Windows OS if you plan to complete the DSC Challenges)
        +   Use a secure secret value for the admin password from Azure Key Vault
    + Use a resource prefix and template variables to have consistent naming of resources

## Success Criteria

1. Verify that your virtual machine has been deployed via the Azure Portal or Azure CLI.
1. Connect to your virtual machine and verify you can login (Windows with RDP, Linux with SSH)

## Tips

- **TIP:** For a Linux VM, you can use an admin password or an SSH key to control access to the VM. It is common (and a recommended practice) to use an SSH key with Linux instead of an admin password. If you are not familiar with Linux, we recommend using an admin password for this hack to keep things simple and focus on learning ARM templates.
- **TIP:** You may need to open additional ports to connect to your VM depending on which OS you deployed.
- **TIP:** You will need to supply your VM with a Public IP address or use the Azure Bastion service to connect to it.