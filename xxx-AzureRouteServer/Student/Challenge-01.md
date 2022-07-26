# Challenge 01 - Building a Basic Hub and Spoke Topology utilizing a central Network Virtual Appliance

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Introduction

In this challenge you will be setting up a basic hub and spoke topology with a Central Network Virtual Appliance. You will also establish connectivity to onprem via VPN site-to-site or Express Route Circuit if you have access to one.

## Description

In this challenge you will create the topology described in this diagram:

![hubnspoke noARS](/xxx-AzureRouteServer/Student/Resources/media/azurerouteserver-challenge1.png)

This hack offers configuration templates using Cisco CSR 1000v (no license required) that you can leverage (below) for each component, the Central Network Virtual Appliance and the On Premises environment simulation "onprem vnet". If you prefer or are experienced with other vendor, please feel free to deploy and provide your own configuration. 

The number of spokes is up to the student. Two is the suggested number. 

> ***NOTE:** Please keep in mind, the vendor of your choice will be the one used through the course of this hack.*

## Success Criteria

At the end of this challenge, you should:

- Have a basic Hub and Spoke Topology in Azure connecting to a simulated On Premises Environment. 
- Verify all traffic is going through the Central Network Virtual Appliance:
  - spoke-to-spoke
  - spokes-to-onprem
  - onprem-to-hub
  - onprem-to-spokes


## Learning Resources

* [Virtual Network peering](https://docs.microsoft.com/azure/virtual-network/virtual-network-peering-overview)
* [Hub and Spoke topology in Azure](https://docs.microsoft.com/azure/architecture/reference-architectures/hybrid-networking/hub-spoke)
* [What is VPN Gateway](https://docs.microsoft.com/azure/vpn-gateway/vpn-gateway-about-vpngateways)
* [Cisco CSR 1000v On Premises Template](./Resources/wthcsronprem.md)
* [Cisco CSR 1000v Central NVA](./Resources/centralnva.md)
* [Create a Site-to-Site connection in the Azure portal](https://docs.microsoft.com/azure/vpn-gateway/vpn-gateway-howto-site-to-site-resource-manager-portal)
* [Configure BGP for VPN Gateways](https://docs.microsoft.com/azure/vpn-gateway/bgp-howto)
* [View BGP status and metrics](https://docs.microsoft.com/azure/vpn-gateway/bgp-diagnostics)
* [Subnet calculator](https://www.davidc.net/sites/default/subnets/subnets.html)


