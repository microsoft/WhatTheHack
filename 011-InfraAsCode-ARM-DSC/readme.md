# What the Hack: Infrastructure As Code with ARM Templates & PowerShell DSC

## Introduction

DevOps is a journey not a destination. Implementing Infrastructure-as-Code is one of the first steps you will take on your DevOps journey!

When implementing an application environment in the cloud, it is important to have a repeatable way to deploy the underlying infrastructure components as well as your software into the target environment.  This includes resources such as:
- Virtual Networks, Network Security Groups (Firewalls), Public IPs, Virtual Machines, Storage (Disks)
- PaaS Services (Azure SQL, App Service, etc)
- Configuration Management (installing & configuring software on VMs)

The best way to make deployments repeatable is to define them with code, hence the term "Infrastructure as Code" (aka IAC).  There are multiple technologies that enable you to define your IaC. Some of these include:
- Azure Resource Manager (ARM) Templates
- PowerShell Desired State Configuration (DSC)
- HashiCorp's Terraform & Packer
- Ansible, Chef, Puppet, Salt Stack, and others

This hack is focused on using ARM Templates and PowerShell DSC to implement your IaC. It does not mean this is the only way to implement IaC.  It is just one way amongst many. If you want to learn how to do IaC in Azure with other technologies, try one of our other IaC hacks for [Terraform](../012-InfraAsCode-Terraform/) or [Ansible](../013-InfraAsCode-Ansible).

## Learning Objectives

This hack will help you learn:
- How Azure Resource Manager (ARM) Templates work to deploy Azure infrastructure
- How PowerShell Desired State Configuration (DSC) can be used for Configuration Management of software on a Windows VM
- How ARM Templates and PowerShell DSC work together to help automate deployment of your cloud environments!

## Challenges

This hack is split into two parts: 
1. [ARM Template Challenges](#arm-template-challenges)
1. [PowerShell DSC Challenges](#powershell-dsc-challenges)

The challenges build upon each other incrementally. You will start by creating a "Hello World" ARM template to get you familiar with the tools & syntax.  Then you extend your template incrementally to deploy multiple infrastructure resources in Azure.

If you don't have time to complete all of the ARM template challenges, we recommend switching gears and getting hands on with PowerShell DSC after you have successfully completed the ARM template challenge to deploy a Windows VM in Azure.

The PowerShell DSC challenges start by having you deploy a simple DSC script. Further incremental challenges will help you configure a Windows VM to become a File Server.

### ARM Template Challenges

1. ["Hello World" ARM Template](./Student/ARM-Challenge-01.md)
   - Develop a simple template that takes an input and returns an output
1. [Deploy a Virtual Network](./Student/ARM-Challenge-02.md)
   - Learn how to find Azure resource values
1. [Open Some Ports](./Student/ARM-Challenge-03.md)
   - Learn about variables, dependencies, and idempotency
1. [Secret Values with Azure Key Vault](./Student/ARM-Challenge-04.md)
   - Learn how to not lose your job
1. [Deploy a Virtual Machine](./Student/ARM-Challenge-05.md)
   - Windows, Linux, or both. It's your choice. If you choose Windows, you can switch gears and do the PowerShell DSC challenges afterwards
1. [Configure a Linux Server](./Student/ARM-Challenge-06.md)
   - Learn about custom script extensions
1. [Implement High Availability](./Student/ARM-Challenge-07.md)
   - Learn about availability sets, looping, and load balancers
1. [SSH to your Highly Available VMs](./Student/ARM-Challenge-08.md)
   - Learn about network access policies
1. [Deploy a Virtual Machine Scale Set](./Student/ARM-Challenge-09.md)
   - Learn about scalability for Infrastructure on Azure
1. [Configure VM Scale Set to run a Web Server](./Student/ARM-Challenge-10.md)
   - Learn about custom script extensions
1. [Implement Auto Scaling](./Student/ARM-Challenge-11.md)
   - Learn about declarative management of policies and actions
1. [Linked Templates](./Student/ARM-Challenge-12.md)
   - Learn how create smaller templates for granular resource management

### PowerShell DSC Challenges

1. [Deploy a Windows Virtual Machine](./Student/DSC-Challenge-01.md)
   - Get yourself ready to develop your IoT solution
2. [Simple DSC](./Student/DSC-Challenge-02.md)
   - Learn about built in DSC Resources on Windows Server
3. [File Server DSC](./Student/ARM-Challenge-03.md)
   - Learn about external DSC Resources from PowerShell Gallery

## Prerequisites

You will want to prepare your machine with the following to help complete the Challenges for this hack:

* Azure Subscription
* [Windows Subsystem for Linux (Windows 10-only)](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
* [PowerShell Cmdlets for Azure](https://docs.microsoft.com/en-us/powershell/azure/install-azurerm-ps)
* [Visual Studio Code](https://code.visualstudio.com/)
* ARM Template plugins for VS Code
	* [ARM Tools](https://marketplace.visualstudio.com/items?itemName=msazurermtools.azurerm-vscode-tools)
	* [ARM Snippets](https://marketplace.visualstudio.com/items?itemName=samcogan.arm-snippets)
* [Azure Storage Explorer](https://azure.microsoft.com/en-us/features/storage-explorer/)

For more details, see: [IaC ARM-DSC Hack - Prerequisites](./Student/Prerequisites.md)

## Repository Contents 
- `../Coach`
  - Coach's Guide and related files
- `../Coach/Solutions`
  - Complete solution files for each challenge
- `../Student`
  - ARM Template challenges and PowerShell DSC challenges
- `../Student/Resources`
  - Sample templates and shell scripts needed to complete the challenges

## Contributors
- Peter Laudati
- Gino Filicetti
- Albert Wolchesky
- Ali Hussain