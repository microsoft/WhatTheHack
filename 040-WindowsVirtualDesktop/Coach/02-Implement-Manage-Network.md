# Challenge 2: Implement and Manage Network

[< Previous Challenge](./01-Plan-WVD-Architecture.md) - **[Home](README.md)** - [Next Challenge >](./06-Implement-Manage-Storage.md)

## Notes and Guidance

* Setup HUB virtual network will be deployed via a PowerShell script with its network components including Gateways, Bastion, and Domain Controllers.

* Setup a client VPN to your Hub virtual network - This VPN resource will be a point-to-site VPN to simulate an on-prem connection. https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-howto-point-to-site-resource-manager-portal
* Spoke Virtual Networks should be globally peered to their respected user regions. https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-peering-overview
* Network Watcher is automatically enabled, verify students have network watcher enabled in their respected user regions. https://docs.microsoft.com/en-us/azure/network-watcher/network-watcher-create
* Students have to enable Network Security Groups on the WVD subnets in the spoke Virtual Networks.
* NSG template for the Spoke Subnets are available in the Solution section incase students aren't able to figure out all the correct rules. 