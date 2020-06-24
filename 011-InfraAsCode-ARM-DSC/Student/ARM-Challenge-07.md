
# Challenge 7 - Implementing High Availability

[< Previous Challenge](./ARM-Challenge-06.md) - [Home](../readme.md) - [Next Challenge>](./ARM-Challenge-08.md)

## Introduction

In this challenge, you will implement high availability for your webserver solution. In Azure high availability is typically defined as:

- 2 or more VMs in an Availability Set configured behind a Load Balancer
-OR-
- 2 or VMs spread across Availability Zones configured behind a Standard Load Balancer

The goals for this challenge include understanding:
- Resource ownership and dependencies
- Creating multiple identical resources within ARM templates
- High Availability in Azure

## Description

-	Extend ARM template to:
    - Add a second webserver VM 
    - Add a public Load Balancer
        - Put the webservers in a backend pool
        - Create frontend pool enabling port 80 to website
    - Ensure the VMs are highly available!
    
## Success Criteria

1. Verify you can access the website at the public IP address of the Load Balancer.
`http://<LoadBalancerPublicIP>/wth.html`
1. Verify you can still access the website if one of the VMs is turned off

## Learning Resources

- [Availability options for virtual machines in Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/availability)
- [Overview of load-balancing options in Azure](https://docs.microsoft.com/en-us/azure/architecture/guide/technology-choices/load-balancing-overview)
- [What is Azure Load Balancer?](https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-overview)
