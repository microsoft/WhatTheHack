# Challenge 5: Network Virtual Appliances

[< Previous Challenge](./04-secured_hub.md) - **[Home](../README.md)**

## Description

Deploy an NVA or an Azure Firewall instance in the Common Services VNet. Create two additional VNets in each region and peer them to the Common Services VNet.

If you need, make sure that the traffic is not going through the Azure Firewall deployed in the virtual hub during the previous challenge, but only through the NVA deployed in the Common Services VNet.

Sample topology:

![topology](./Images/vwan04.png)

## Success Criteria

- The indirect spokes in one hub can reach the indirect spokes in the other hub.
- The indirect spokes can reach all branches
- Verify if the indirect spokes can reach the Development and Production VNets of both regions
- Send traffic between the Dev and Production VNets of one region through the NVA. Is it working?
- Send Internet traffic from the Dev/Prod VNets through the NVA in Common Services. Is it working?

## Learning Resources

- [Virtual WAN routing through NVA - Indirect spokes](https://docs.microsoft.com/azure/virtual-wan/scenario-route-through-nva)
- [Virtual WAN routing through NVA - Custom routing](https://docs.microsoft.com/en-us/azure/virtual-wan/scenario-route-through-nvas-custom)
