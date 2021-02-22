
# Challenge 4 - Network Connectivity

[< Previous Challenge](./Challenge-3.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-5.md)

<br />

## Introduction

In this challenge, you will learn how to peer virtual networks and connect to external environments.

<br />

## Description

Contoso needs connectivity between their Azure cloud and on-premises workloads.  The connectivity should provide a secure and private communication channel. The network team would like a centralized architecture for network services as more workloads move to Azure, to simplify management and provide scale.

<br />

For this challenge:

- Deploy a scalable virtual network architecture. The design should scale as more organization units are onboarded to Azure cloud.

- The Payment Solutions and Finance department workloads should stll not be able to communicate with each other.

- Provide a secure solution to connect to on-premises, meeting the network team's requirements for scale and management.

<br />

## Success Criteria

- You should have established secure connectivity from on-premises to the resources in Azure.

- As new subnets and network ranges are added, connectivity should be available without needing manual updates to configuration.

-  You should be able to successfully reach Payments and Finance applications from on-premises.

<br />

## Learning Resources
[Azure virtual network gateway](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways)

[Azure virtual network peering](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-peering-overview)

[User defined routes](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview#custom-routes)

[Virtual network routing](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview)
