# Challenge 4: Virtual Secure Hubs

[< Previous Challenge](./03-isolated_vnet.md) - **[Home](../README.md)** - [Next Challenge >](./05-nva.md)

## Description

Convert both of your VWAN hubs to secured hubs. Fulfill these requirements:

* These flows need to go through the Azure Firewall:

* VNet-to-VNet in the same hub (aka VHV)
* VNet-to-Branch in the same hub (aka VHB)
* VNet-to-Internet

Note that Virtual Secure Hub does not support VHHV or VHHB traversing the firewall

Sample topology:

![topology](pictures/vwan05.png)

## Success Criteria


## Learning Resources

* [VWAN routing through NVA VNet](https://docs.microsoft.com/azure/virtual-wan/scenario-route-through-nva)
- [VWAN secure virtual hub](https://docs.microsoft.com/azure/virtual-wan/scenario-route-between-vnets-firewall)