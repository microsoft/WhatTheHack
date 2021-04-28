# Challenge 5: Network Virtual Appliances

[< Previous Challenge](./04-secured_hub.md) - **[Home](../README.md)**

## Description

Deploy an NVA or an Azure Firewall instance in the Common Services VNet. Create two additional VNets in each region and peer them to the Common Services VNet.

Sample topology:

![topology](../Images/vwan04.png)

## Success Criteria

- The indirect spokes in one hub can reach the indirect spokes in the other hub.
- The indirect spokes can reach all branches
- Verify if the indirect spokes can reach the Development and Production VNets

## Learning Resources

- [VWAN routing through NVA VNet](https://docs.microsoft.com/azure/virtual-wan/scenario-route-through-nva)