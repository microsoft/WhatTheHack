# Challenge 0: Environment Setup

**[Home](../README.md)** - [Next Challenge >](./01-design.md)

## Description

The SmartHotel application comprises 4 VMs hosted in Hyper-V:

- Database tier - Hosted on the smarthotelSQL1 VM, which is running Windows Server 2016 and SQL Server 2017.
- Application tier - Hosted on the smarthotelweb2 VM, which is running Windows Server 2012R2.
- Web tier - Hosted on the smarthotelweb1 VM, which is running Windows Server 2012R2.
- Web proxy - Hosted on the UbuntuWAF VM, which is running Nginx on Ubuntu 18.04 LTS.

For simplicity, there is no redundancy in any of the tiers.

**Note:** For convenience, the Hyper-V host itself is deployed as an Azure VM. For the purposes of the lab, you should think of it as an on-premises machine.

## Success Criteria

- Verify that you have access to and understand the source environment (resource groups, Azure VMs, nested Hyper-V VMs)