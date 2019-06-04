# What the Hack: Infrastructure As Code with Ansible
Ansible allows you to automate the creation, configuration and deployment of Azure resources via Ansible playbooks. 

## Introduction

DevOps is a journey not a destination. 

Infrastructure-as-Code is one of the first steps you need to take on your DevOps journey!

This hack will help you learn:
- How Azure Ansible works to deploy infrastructure in Azure
- How Ansible can be used for Configuration Management of software on a VM

## Challenges
 
## Challenge 1: Create an Azure resource group using Ansible

Create a YAML file named rg.yml. Using Ansible and the YAML file you created, create a resource group named ansible-rg in the East US 2 Azure region. Deploy the resource group using ansible-playbook

## Challenge 2: Create an Azure Virtual Network

Create an Azure Virtual Network using Ansible. Create a YAML file named WTHVNetAN.yml. The virtual network should have an address space of 10.2.0.0/16 and be named "WTHVNetAN". Add one subnet to it with an address range of 10.2.0.0/24 and name it "default"

## Challenge 3: Create a public IP address

Create a public IP address using Ansible that you will use to access your Azure VM via SSH later. Put it in the resource group ansible-rg. Name the public IP address ansible-pip. Use static allocation for the public IP address.

## Challenge 4: Create a Network Security Group

Create a Network Security Group using Ansible that you will use to protect your Azure VM so that it is only accessible via TCP port 22 inbound. Put the NSG in the resource group ansible-rg. Name the NSG ansible-nsg-ssh. Set the priority to 1001. 

## Challenge 5: Create a Linux Virtual Machine

Create a Linux VM using Ansible. You will first need to create a Network Interface Card. Use the following settings for the NIC:

Resource group: ansible-rg
Name: ansible-VM-nic 
Public IP address: ansible-pip 
VNet: WTHVNETAN
Subnet: default
Security Group: ansible-nsg-ssh

The VM will use all of the Azure resources you have previously created. Use the following settings:

 VM Name: anlinuxvm01
 Resource Group: ansible-rg
 VM Size: Standard_DS1_v2 
 Admin username: azureuser
 SSH password enabled: false
 SSH public keys: [use the public key you created in the prequisites section]
 Network interfaces: ansible-VM-nic
 Image: CentOS 7.5 (or Ubuntu 18.04 if you prefer)

Ensure that you can SSH to the VM using its public IP address with ssh azureuser@[public ip address]

Hint: You can use the Azure CLI command az vm list-ip-addresses to find the IP address for the newly created VM. 




