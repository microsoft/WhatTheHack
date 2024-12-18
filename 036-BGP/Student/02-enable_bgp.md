# Challenge 2: Enable BGP

[< Previous Challenge](./01-lab_exploration.md) - **[Home](../README.md)** - [Next Challenge >](./03-aspath_prepending.md)

## Description

1. Connect VNG1 (an active/passive Virtual Gateway) to CSR3 via BGP. The following Cisco configuration sample could come handy. Explore the configuration and how routes are learnt and propagated.

```
router bgp ?
  neighbor ?.?.?.? remote-as ?
  neighbor ?.?.?.? ebgp-multihop 5
  neighbor ?.?.?.? update-source GigabitEthernet1
```

> **Note**: This setup is equivalent to the [Azure active-passive VPN Gateway](https://docs.microsoft.com/azure/vpn-gateway/vpn-gateway-highlyavailable#about-azure-vpn-gateway-redundancy):
> ![](Images/active-standby.png)

2. Similarly, configure the BGP adjacency between VNG2 and CSR4 (remember that VNG2 is configured as an active-active gateway). Compare this connection  to the adjacency between VNG1 and CSR3.

> **Note**: This setup is equivalent to the [Azure active-active VPN Gateway](https://docs.microsoft.com/azure/vpn-gateway/vpn-gateway-highlyavailable#active-active-azure-vpn-gateway):
> ![](Images/active-active.png)

3. Configure the rest of the BGP adjacencies, and verify full connectivity between the test VMs deployed in each Vnet. Here the adjacencies that you should configure:
    1. VNG1 to CSR4
    1. VNG2 to CSR3
    1. VNG1 to VNG2
    1. CSR3 to CSR4
1. Ensure you can inspect learned and advertised routes from each VPN gateway and each branch device

## Success Criteria

- BGP adjacencies are created between the following devices:
    - VNG1 and VNG2
    - VNG1 and CSR3
    - VNG1 and CSR4
    - VNG2 and CSR3
    - VNG2 and CSR4
    - CSR3 and CSR4
- Every virtual machine can reach all other virtual machines
- Participants can read and interpret the routing tables in each device of the setup, and show the received and advertised routes

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
