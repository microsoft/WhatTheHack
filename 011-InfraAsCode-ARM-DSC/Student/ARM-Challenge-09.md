# Challenge 9 - Deploy a Virtual Machine Scale Set 

[< Previous Challenge](./ARM-Challenge-08.md) - [Home](../readme.md) - [Next Challenge>](./ARM-Challenge-10.md)

## Introduction

The goal for this challenge includes understanding:
- VM scales sets provide scalability for infrastructure in Azure

In the previous two challenges, you implemented high availability for the web server by adding a second VM and configuring the two VMs to be part of an Availability Set behind a load balancer. The two VMs were configured identically.

This solution does not provide an easy way scale up and add more VMs after deployment. It would require you to manually deploy additional VMs and add them to the backend pool of the Load Balancer.

Azure Virtual Machine Scale Sets (VMSS) offer a better solution for when you want to have multiple identically configured VMs with the ability to scale up or down in an automatic fashion.

## Description

- Extend the ARM template to replace the existing two virtual machines with a VM Scale Set
- Configure the VMSS to have two instances
- Ensure the load balancer is configured to allow you to SSH to the VMs in the scale set.

## Success Criteria

1. Verify the VMSS is deployed as configured in the Azure portal
1. Verify the number of VM instances via the Azure CLI
1. Verify that you can SSH into the VMSS instances.

## Tips

- Convert NAT rule to NAT pool
