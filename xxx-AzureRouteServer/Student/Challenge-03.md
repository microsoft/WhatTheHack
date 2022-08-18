# Challenge 03 -  Connect Network Virtual Appliance to SD WAN routers

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Introduction
  
Now that we have a solid understanding of the functionality of Azure Route Server, you will integrate a simulated SDWAN environment to this solution.

While the topology in the previous challenge focused on insertion patterns for firewall NVAs, this challenge will show how to integrate an NVA that provides on-premises connectivity, such as SDWAN NVAs, and how that integration works together with an Azure Virtual Network Gateway. Designs that involve SDWAN NVAs and Azure VMware Solution or Skytap (which are connected to VNets via ExpressRoute gateways) are an example requiring this interaction between the NVA, Route Server and an Azure VNG.

## Description

Your Network Organization decided that Azure is amazing and want to establish communications with two different SDWAN Data Centers in separate geographic locations. They are advertising the exact same prefixes from both locations via BGP and they want to reach their On Premises Data Center. 
  
![ARS_SDWAN](/xxx-AzureRouteServer/Student/Resources/media/azurerouteserver-challenge3.png)
  
Please deploy the following scenareo:
- Establish two simulated SDWAN branches on different locations
- Carve out 3 non overlapping prefixes: Two of them will be advertised from your branches. The third one will only be advertised from one of them.  

  ***NOTE:** You may use the Cisco CSR 1000v templates for this challenge provided below.*

> [!IMPORTANT]
> SDWAN technologies are emerging and have a level of detail beyond the scope of this class. Just to give a very brief idea, they often use Azure as a transit infrastructure and run IPsec tunnels as an overlay amongst other protocols. They centralize control plane and management plane operations into different virtual components (v-manage, v-smart). For intent and purpose of this challenge, we will just create two separate Cisco routers on two separate Vnets without going into further complexity. 

  

## Success Criteria

At the end of this challenge you should: 

- Verify connectivity between On Premises and the SDWAN branches.
- Verify connectivity between Hubs, Spokes and SDWAN branches. 
- The SDWAN Data Center closest to Azure should be preferred.
- Ensure no asymmetric routing is found.

## Learning Resources

* [Cisco CSR 1000v SDWAN Configuration](./Resources/sdwancsr.md)

