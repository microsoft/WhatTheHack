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

Terraform is a tool (templating language) for building, changing, and versioning infrastructure safely and efficiently. Using Terraform, you can automate the tasks of building, changing and de-provisioning the infrastructure

This hack is focused on using Terraform to implement your IaC. It does not mean this is the only way to implement IaC.  It is just one way amongst many. If you want to learn how to do IaC in Azure with other technologies, try one of our other IaC hacks for [ARM Templates](../011-InfraAsCode-ARM-DSC) or [Ansible](../013-InfraAsCode-Ansible/).


## Learning Objectives
This hack will help you learn:
- How Terraform works to deploy infrastructure in Azure
- How Terraform can be used to trigger the install of software on a VM

## Challenges
0. [Get your machine ready](./Student/prerequisite.md) 
   - Configure Terraform on Linux subsystem, credentials
1. ["Hello World" Terraform](./Student/readme.md)
   - Create an Azure resource group using Terraform 
1. [Deploy a Virtual Network](./Student/readme.md)
   - Learn how to find Terraform HCL syntax to deploy an Azure resource
1. [Open Some Ports](./Student/readme.md)
   - Learn about variables, dependencies, idempotency
1. [Create a Linux Virtual Machine](./Student/readme.md)
   - Learn what an Azure Virtual Machine is composed of
1. [Use Packer to Create a Linux image with NGINX installed](./Student/readme.md)
   - Learn about custom build images with Packer

## Prerequisites
- Your own Azure subscription with Owner access
- Visual Studio Code
- Azure CLI
- Terraform

## Repository Contents

- `../Coach/Solutions`
  - Complete solution files for each challenge
- `../Student`
  - Terraform challenges


## Contributors
- Pete Rodriguez


