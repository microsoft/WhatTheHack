# What The Hack: Infrastructure As Code with Terraform

## Introduction

DevOps is a journey not a destination. Implementing Infrastructure-as-Code is one of the first steps you will need to take!

When implementing an application environment in the cloud, it is important to have a repeatable way to deploy the underlying infrastructure components as well as your software into the target environment.  This includes resources such as:
- Virtual Networks, Network Security Groups (Firewalls), Public IPs, Virtual Machines, Storage (Disks)
- PaaS Services (Azure Container Apps, Azure SQL, App Service, etc)
- Configuration Management (installing & configuring software on VMs)

The best way to make deployments repeatable is to define them with code, hence the term "Infrastructure as Code" (aka IAC).  There are multiple technologies that enable you to achieve this. Some of these include:
- ARM Templates
- Bicep Templates
- HashiCorp's Terraform
- Ansible, Chef, Puppet, Salt Stack, and others

This hack is focused on using Terraform to implement your IaC.

## Learning Objectives

This hack will help you learn:
- How Terraform can be used to deploy Azure infrastructure

The challenges build upon each other incrementally. You will start by creating basic Terraform manifests to get you familiar with the tools & syntax.  Then you extend your manifests incrementally to deploy multiple infrastructure resources to Azure.

### Challenges

- Challenge 0: **[Pre-Requisites - Ready, Set, Go!](./Student/Challenge-00.md)**
   - Prepare your workstation to work with Azure and Terraform
- Challenge 1: **[Basic Terraform](./Student/Challenge-01.md)**
   - Develop a simple Terraform manifest that takes inputs to create an Azure Storage Account and returns outputs
- Challenge 2: **[Terraform expressions and referencing resources](./Student/Challenge-02.md)**
   - Learn Terraform expressions, conditionals, and referencing resources
- Challenge 3: **[Advanced resource declarations](./Student/Challenge-03.md)**
   - Advanced resource declarations including iteration
- Challenge 4: **[Secret Values with Azure Key Vault](./Student/Challenge-04.md)**
   - Create and reference an Azure Key Vault
- Challenge 5: **[Deploy a Virtual Machine](./Student/Challenge-05.md)**
   - Create a complex deployment with multiple dependencies
- Challenge 6: **[Terraform Modules](./Student/Challenge-06.md)**  
   - Learn how create reusable modules for granular resource management
 - Challenge 7: **[Azure Container Apps (ACA)](./Student/Challenge-07.md)**
   - Create an ACA environment and deploy a simple `hello world` application to it
 - Challenge 8: **[Advanced ACA](./Student/Challenge-08.md)**
   - Provision an Azure Container Registry, import images to it, then provision and deploy a multi-microservice (frontend and backend) containerized application




## Prerequisites

You will want to prepare your machine with the following to help complete the Challenges for this hack:

* Azure Subscription
* _optional_ [Windows Subsystem for Linux (Windows 10-only)](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
* [Visual Studio Code](https://code.visualstudio.com/)


## Repository Contents 
- `../Student`
  - Terraform challenges
- `../Student/Resources`
  - Shell scripts needed to complete the challenges

