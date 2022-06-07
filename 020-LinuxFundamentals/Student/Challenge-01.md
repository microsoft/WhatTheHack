# Challenge 01 - Create a Linux Virtual Machine

**[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Pre-requisites 

- An active Azure Subscription.

## Description

To follow along you will need access to a server running a Linux-based operating system. Note that this hackathon was validated using a Linux server running Ubuntu 20.04 ([LTS](https://ubuntu.com/about/release-cycle)), but the examples given should work on any Linux distribution. See below the steps to follow to create your Linux Virtual Machine on Azure and choose the one with which you are more familiar.

During the process of the creation of the VM, ensure the usage of **student** for the username with root privileges over the virtual machine, just to make it easier during the challenges. 

### Disclaimer

Opening port 22 to the public internet is a bad practice. We highly recommend using Azure Bastion or creating an NSG rule that limits access to the student's home IP address (or Azure Cloud Shell instance).


## Success Criteria

* Validate you was able to successfully create your **Ubuntu 20.04** Linux Virtual Machine
* Confirm you can access through SSH

## Learning Resources

* [Create a Linux virtual machine in the Azure portal](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-portal)
* [Create a Linux virtual machine with the Azure CLI](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-cli)
* [Create a Linux virtual machine in Azure with PowerShell](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-powershell)
* [Connect to a Linux VM](https://docs.microsoft.com/en-us/azure/virtual-machines/linux-vm-connect?tabs=Linux)


