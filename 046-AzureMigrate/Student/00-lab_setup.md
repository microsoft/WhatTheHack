# Challenge 0: Environment Setup

**[Home](../README.md)** - [Next Challenge >](./01-design.md)

## Introduction
In this challenge we confirm that we all have access to the lab environment to ensure that the next challenges can be completed succesfully. 

## Description

The SmartHotel application comprises 4 VMs, hosted inside of a Windows Azure VM with Hyper-V and nested virtualization:

- Database tier - Hosted on the smarthotelSQL1 VM, which is running Windows Server 2016 and SQL Server 2017.
- Application tier - Hosted on the smarthotelweb2 VM, which is running Windows Server 2012R2.
- Web tier - Hosted on the smarthotelweb1 VM, which is running Windows Server 2012R2.
- Web proxy - Hosted on the UbuntuWAF VM, which is running Nginx on Ubuntu 18.04 LTS.

For simplicity, there is no redundancy in any of the tiers.

Credentials:

- For the host Azure VM: `demouser`/`demo!pass123`
- For the Windows nested Hyper-V VMs: `Administrator`/`demo!pass123`
- For the Linux nested Hyper-V VM: `demouser`/`demo!pass123`

**Note:** For convenience, the Hyper-V host itself is deployed as an Azure VM. For the purposes of the lab, you should think of it as an on-premises machine.

## Success Criteria

- Verify that you have access to the Azure subscription and understand the source environment (resource groups, Azure VMs, nested Hyper-V VMs)
- Make sure you can connect to the web application from your browser

## Learning Resources

- [How to connect to an Azure Virtual Machine running Windows](https://docs.microsoft.com/azure/virtual-machines/windows/connect-logon)
