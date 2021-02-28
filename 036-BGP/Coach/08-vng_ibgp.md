# Challenge 8 - iBGP Between VNG Instances

[< Previous Challenge](./07-default.md) - **[Home](./README.md)**

## Notes and Guidance

A mistake that is sometimes done in Azure is breaking iBGP between Virtual Network Gateways by having the wrong route in the GatewaySubnet. One relatively common situation when customers do this is when having shared services in the hub VNet. Customers might define a UDR for the whole VNet range pointing to an NVA, and put it on all subnets (including the GatewaySubnet).

## Solution Guide

Solution guide [here](./Solutions/08_Solution.md).
