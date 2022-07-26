# Challenge 02 -  Introduce Azure Route Server and peer with a Network Virtual appliance

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

In this challenge you will introduce Azure Route Server in the topology you have built previously in order to establish dynamic routing accross the Hub and Spoke Topology. 


## Description

In this challenge you will insert Azure Route Server as described in this diagram:

![hubnspoke noARS](/xxx-AzureRouteServer/Student/Resources/media/azurerouteserver-challenge2.png)


Please perform the following actions:
- Configure Azure Route Server
- Successfully establish BGP relationship between ARS and the Central Network Virtual Appliance
- Analyze the different routing advertisements (VPN Gateway and ARS)

*For this section, student will also be provided the necessary configuration for a Cisco CSR 1000v to establish BGP relationship with Azure Route Server and remove any stale configuration from the last section. Again, if the student has another third pary NVA preference, please provide the necessary configuration.*

## Success Criteria

At the end of this challenge you should: 
- Verify our environment has no UDRs. 
- Validate the following traffic is still going through the NVA. 
  - spoke-to-spoke
  - spokes-to-onprem
  - onprem-to-hub
  - onprem-to-spokes
- Demonstrate to your coach you understand the behavior of the Route Server for this excercise. 

## Learning Resources

- [What is Azure Route Server](https://docs.microsoft.com/en-us/azure/route-server/overview)
- [Configure Azure Route Server](https://docs.microsoft.com/en-us/azure/route-server/quickstart-configure-route-server-portal)
- [Configure Route Server with Quagga](https://docs.microsoft.com/en-us/azure/route-server/tutorial-configure-route-server-with-quagga)
- [ARS with ExR and VPN](https://docs.microsoft.com/en-us/azure/route-server/expressroute-vpn-support)
- [Route Injections](https://docs.microsoft.com/en-us/azure/route-server/route-injection-in-spokes)
- [Troubleshooting](https://docs.microsoft.com/en-us/azure/route-server/troubleshoot-route-server)
- [Cisco CSR 1000v Central NVA Config for Route Server and Route Propagation](./Resources/whatthehackcentralnvachallenge2.md)
- [Can I Advertise the exact prefixes as my VNET?](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-bgp-overview#can-i-advertise-the-exact-prefixes-as-my-virtual-network-prefixes)
- [VPN BGP Transit Routing in Azure](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-bgp-overview#does-azure-vpn-gateway-support-bgp-transit-routing)

## Tips

- The best tip to understand the functionality of Azure Route Server is to look at the routing tables accross the board. You can find a way to do it through Power Shell, CLI or Azure portal if the functionality is available.  
- Look at what routes are learned and advertised by the Vnet Gateway. 
- Look at the routes that are learned and advertised to the NVA by Azure Route Server. One of the articles above has some useful commands for this.
- Look at what gets programmed into the effective routes on the Nics.

> [!IMPORTANT]
>Take a moment to think about how to influence traffic through the NVA using BGP advertisements. There's several ways to do it!!!!. Think in terms of supernets or default routes.
>Also think about the consequences of each method carefully. Take a look the Cisco CSR config file for both options to gain more insight about pros and cons of each method. 

