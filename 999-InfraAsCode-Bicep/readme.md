# Fast Hack: Infrastructure As Code with Bicep & PowerShell 

## Introduction

DevOps is a journey not a destination. Implementing Infrastructure-as-Code is one of the first steps you will need to take!

When implementing an application environment in the cloud, it is important to have a repeatable way to deploy the underlying infrastructure components as well as your software into the target environment.  This includes resources such as:
- Virtual Networks, Network Security Groups (Firewalls), Public IPs, Virtual Machines, Storage (Disks)
- PaaS Services (Azure SQL, App Service, etc)
- Configuration Management (installing & configuring software on VMs)

The best way to make deployments repeatable is to define them with code, hence the term "Infrastructure as Code" (aka IAC).  There are multiple technologies that enable you to achieve this. Some of these include:
- Bicep
- PowerShell Desired State Configuration (DSC)
- HashiCorp's Terraform & Packer
- Ansible, Chef, Puppet, Salt Stack, and others

This hack is focused on using Bicep to implement your IaC. It does not mean this is the only way to implement IaC, it's just one of many ways. If you want to learn how to do IaC in Azure with other technologies, try one of our other IaC hacks for [Terraform](../03-Terraform/).

## Learning Objectives

This hack will help you learn:
- How Bicep can be used to deploy Azure infrastructure

The challenges build upon each other incrementally. You will start by creating a basic Bicep file to get you familiar with the tools & syntax.  Then you extend your template incrementally to deploy multiple infrastructure resources to Azure.

### Bicep Challenges

1. [Basic Bicep](./Student/Bicep-Challenge-01.md)
   - Develop a simple Bicep file that takes inputs to create an Azure Storage Account, and returns outputs
1. [Bicep expressions and referencing resources](./Student/Bicep-Challenge-02.md)
   - Learn Bicep expressions and referencing resources
1. [Advanced resource declarations](./Student/Bicep-Challenge-03.md)
   - Advanced resource declarations
1. [Deploy a Virtual Machine Scale Set](./Student/Bicep-Challenge-04.md)
   - Create complex deployment with Bicep using modules
1. [Configure VM Scale Set to run a Web Server](./Student/Bicep-Challenge-05.md)
   - Learn about custom script extensions
1. [Configure VM Scale Set to run a Web Server using cloud-init](./Student/Bicep-Challenge-06.md)
   - How cloud-init scripts can be run on a Virtual Machine Scale Set (VMSS)
1. [Deploy resources to different scopes](./Student/Bicep-Challenge-07.md)
   - Learn how to deploy resources to different scopes


## Prerequisites

You will want to prepare your machine with the following to help complete the Challenges for this hack:

* Azure Subscription
* [Windows Subsystem for Linux (Windows 10-only)](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
* [PowerShell Cmdlets for Azure](https://docs.microsoft.com/en-us/powershell/azure/?view=azps-5.6.0)
* [Visual Studio Code](https://code.visualstudio.com/)
* Bicep plugins for VS Code
	* [Bicep VS Code Extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep)
	* [Bicep CLI](https://github.com/Azure/bicep/blob/main/docs/installing.md)

For more details, see: [IaC Bicep Hack - Prerequisites](./Student/Prerequisites.md)

## Repository Contents 
- `../Student`
  - Bicep challenges
- `../Student/Resources`
  - Shell scripts needed to complete the challenges