# Challenge 8: Plan and Implement BCDR

[< Previous Challenge](./07-Install-Configure-Apps.md) - **[Home](../README.md)** - [Next Challenge >](./09-Automate-AVD-Tasks.md)

## Introduction
In this challenge you need to design and implement an Disaster Recovery and BackUp strategy for your HostPools and your FsLogix profiles. For this challenge you will only be focusing on Japan West HostPool for Disaster Recovery and you will use the spoke Vnet in East US and the same Subnet for those machines. This is just to get the understanding on how to replicate those machines.  

## Description

- Plan and implement DR for your Japan West HostPool to EastUS Spoke Vnet.
- Backup your Session Host VMs once every 24 hours. 
- Implement backup strategy for your FsLogix profiles in all regions to once a day using Azure Backup. 

**NOTE:**
The reason we are not focusing on DR and Backup for the Pooled/Remote hostpools is because they are multisession and they're lots of ways to DR/Backup Pooled HostPools. There is no reason to backup Multisession VMs. You could use Azure Site Recovery but because there is no data being saved directly to the VMs and with the image being replicated to the secondary site with Share Image Gallery, which was completed in challenge four, you could build new. With using FsLogix Profiles using CLoud Cache, the profiles would be available in both regions and the uses in the Pooled Hostpool would still have direct access to their data.  

## Success Criteria

- Japan West HostPool is being replicated to the secondary site.
- Session Hosts in Japan West HostPool are being backed up.
- Fslogix profiles are being backed up with Azure Backup.  
