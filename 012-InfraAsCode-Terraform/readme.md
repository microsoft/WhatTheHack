# What the Hack:  Infrastructure as Code with Terraform
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

This hack is focused on using Ansible playbooks to implement your IaC. It does not mean this is the only way to implement IaC.  It is just one way amongst many. If you want to learn how to do IaC in Azure with other technologies, try one of our other IaC hacks for [ARM Templates](../011-InfraAsCode-ARM-DSC) or [Ansible](../013-InfraAsCode-Ansible/).


## Learning Objectives
This hack will help you learn:
- How Terraform works to deploy infrastructure in Azure
- How Terraform can be used to trigger the install of software on a VM

## Challenges
0. Get your machine ready 
   - Configure Terraform on Linux subsystem, credentials
1. ["Hello World" Terraform](./Student/Challenge-01.md)
   - Create an Azure resource group using Terraform 
1. [Deploy a Virtual Network](./Student/Challenge-02.md)
   - Learn how to find Terraform syntax to deploy an Azure resource
1. [Open Some Ports](./Student/Challenge-03.md)
   - Learn about variables, dependencies, idempotency
1. [Secret Values with Azure Key Vault](./Student/Challenge-04.md) 
   - Learn how to not lose your job
1. [Create a Linux Virtual Machine](./Student/Challenge-05.md)
   - Learn what an Azure Virtual Machine is composed of
1. [Install NGINX on a Linux Virtual Machine](./Student/Challenge-06.md)
   - Learn about custom script extensions
1. [Add a Data Disk and mount to OS](./Student/Challenge-07.md)
   - Learn persistent storage, reinforce script injection, teach mounting a disk 
1. [Implement High Availability](./Student/Challenge-08.md)
   - Availability set 2 VMs load balancer and learn loops
1. [Deploy Azure Database for PostgreSQL](./Student/Challenge-09.md) 
   - Learn how to deploy a PaaS service
1. [Nested Playbooks](./Student/Challenge-10.md)
   - Learn how to create smaller playbooks for granular resource management

## Prerequisites
- Your own Azure subscription with Owner access
- Visual Studio Code
- Azure CLI
- Terraform

## Repository Contents
- `../Coach`
  - Coach's Guide and related files
- `../Coach/Solutions`
  - Complete solution files for each challenge
- `../Student`
  - Ansible challenges


## Contributors
- Pete Rodriguez
- Ariel Luna
- Peter Laudati


