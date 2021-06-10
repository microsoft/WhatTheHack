# Challenge 2: Implement and Manage Networking for AVD

[< Previous Challenge](./01-Plan-AVD-Architecture.md) - **[Home](./README.md)** - [Next Challenge >](./03-Implement-Manage-Storage.md)

## Notes & Guidance

* Setup HUB virtual network will be deployed via a PowerShell script with its network components including Gateways, Bastion, and Domain Controllers.
* Setup a client VPN to your Hub virtual network - This VPN resource will be a [Point-to-Site VPN](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-howto-point-to-site-resource-manager-portal) to simulate an on-prem connection. 
* Spoke Virtual Networks should be [globally peered]( https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-peering-overview) back to the Hub.
* Network Watcher is automatically enabled, verify students have [Network Watcher](https://docs.microsoft.com/en-us/azure/network-watcher/network-watcher-create) enabled in their respected user regions. 
* Students have to enable Network Security Groups on the AVD subnets in the spoke Virtual Networks.
* NSG template for the Spoke Subnets are available in the Solution section incase students aren't able to figure out all the correct rules.
