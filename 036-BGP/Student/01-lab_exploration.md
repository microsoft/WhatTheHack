# Challenge 1: Exploration

[< Previous Challenge](./00-lab_setup.md) - **[Home](../README.md)** - [Next Challenge >](./02-enable_bgp.md)

## Description

Explore the topology deployed.

![](Images/bgp.png)

## Success Criteria

Participants have explored the following:

- The state of the VPN tunnels and the Azure VPN gateway configuration
- Effective routes in at least one of the Azure VMs
- The neighbor adjacencies (or lack thereof) of the VNGs and at least one CSR
- The routing table of at least one CSR

## Learning Resources

- [About BGP with Azure VPN Gateway](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-bgp-overview)
- CLI commands for Virtual Network Gateways:
    - [Virtual Network Gateways - Get Bgp Peer Status](https://docs.microsoft.com/cli/azure/network/vnet-gateway?view=azure-cli-latest#az_network_vnet_gateway_list_bgp_peer_status)
    - [Virtual Network Gateways - List Advertised Routes](https://docs.microsoft.com/cli/azure/network/vnet-gateway?view=azure-cli-latest#az_network_vnet_gateway_list_advertised_routes)
    - [Virtual Network Gateways - List Learned Routes](https://docs.microsoft.com/cli/azure/network/vnet-gateway?view=azure-cli-latest#az_network_vnet_gateway_list_learned_routes)
- Powershell commands for Virtual Network Gateways:
    - [Virtual Network Gateways - Get Bgp Peer Status](https://docs.microsoft.com/powershell/module/az.network/get-azvirtualnetworkgatewaybgppeerstatus?view=azps-5.1.0)
    - [Virtual Network Gateways - List Advertised Routes](https://docs.microsoft.com/powershell/module/az.network/get-azvirtualnetworkgatewayadvertisedroute?view=azps-5.1.0)
    - [Virtual Network Gateways - List Learned Routes](https://docs.microsoft.com/powershell/module/az.network/get-azvirtualnetworkgatewaylearnedroute?view=azps-5.1.0)
- [Some useful CLI commands for Cisco routers](./Resources/cisco_cheatsheet.md)
