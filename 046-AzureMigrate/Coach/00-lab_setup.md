# Challenge 0: Environment Setup - Coach's Guide

**[Home](./README.md)** - [Next Challenge >](./01-design.md)

## Before you start

- Introduce housekeeping: breaks, lunch, cameras on ideally, etc

## Solution Guide

- As a coach you would have created 3 (?) RGs in our sub as well as a couple of accounts which have contributor access to each (easier than giving cx accounts access?):
    - OnPrem <- has the Hyper-V / on-prem environment
    - Target <- potentially has the target vnet
    - Test <- potentially another vnet to do test failovers to
- Make sure participants test connectivity to Azure
- Connectivity to Azure host VM:
    - RDP vs Bastion? <- start with RDP, only if necessary consider Bastion (i.e. if outbound RDP blocked)
    - Accept RDP open to internet is a security risk
