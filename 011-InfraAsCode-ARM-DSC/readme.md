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

This hack is focused on using ARM Templates and PowerShell DSC to implement your IaC. It does not mean this is the only way to implement IaC.  It is just one way amongst many. If you want to learn how to do IaC in Azure with other technologies, try one of our other IaC hacks for Terraform or Ansible.

## Learning Objectives

This hack will help you learn:
- How Azure Resource Manager (ARM) Templates work to deploy Azure infrastructure
- How PowerShell Desired State Configuration (DSC) can be used for Configuration Management of software on a Windows VM
- How ARM Templates and PowerShell DSC work together to help automate deployment of your cloud environments!


## What The Hack Format

During this hack, you will work on a series of technical challenges to gain hands on experience with the technology. The challenges are not step-by-step hands on lab tutorials that you will blindly follow.  It is up to the participants to figure out how to complete them. Believe it or not, we have been told that this fosters better knowledge retention.  

If you are participating as part of hackathon event, the Proctors will assist you and provide guidance, but they will not give you the answers (unless you are completely stuck).  If you are learning solo, you can find the solutions in the ["Hosts"](./Host/) folder of this repo.  However, please give it your best shot and don't cheat yourself by skipping to the answers! 

## Challenges

The challenges build upon each other incrementally. You will start by creating a "Hello World" ARM template to get you familiar with the tools & syntax.  Then you extend your template incrementally to deploy multiple infrastructure resources in Azure.

If you don't have time to complete all of the ARM template challenges, we recommend switching gears and getting hands on with PowerShell DSC after you have successfully completed the ARM template challenge to deploy a Windows VM in Azure.

The PowerShell DSC challenges will start by having you deploy a simple DSC script. Then further incremental challenges will help you configure a Windows VM to become a File Server.

## Prerequisites
 
You will want to prepare your machine with the following to help complete the Challenges for this hack:

* **Azure Subscription**
* [**Windows Subsystem for Linux (Windows 10-only)**](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
* [**Azure CLI**](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
* [**PowerShell Cmdlets for Azure**](https://docs.microsoft.com/en-us/powershell/azure/install-azurerm-ps)
* [**Visual Studio Code**](https://code.visualstudio.com/)
* **ARM Template plugins for VS Code**
	* [**ARM Tools**](https://marketplace.visualstudio.com/items?itemName=msazurermtools.azurerm-vscode-tools)
	* [**ARM Snippets**](https://marketplace.visualstudio.com/items?itemName=samcogan.arm-snippets)
* [**Azure Storage Explorer**](https://azure.microsoft.com/en-us/features/storage-explorer/)

For more details, see: [**IaC ARM-DSC Hack - Prerequisites**](./Student/Guides/Prerequisites.md)


 ## Repo Contains
 
 - [ARM Template Challenges](./Student/Guides/armChallenges.md)
 - [PowerShell DSC Challenges](./Student/Guides/dscChallenges.md)
 - [Proctor Guides](./Host/Guides/)
 - [Solution templates & DSC script files](./Host/Solutions/)