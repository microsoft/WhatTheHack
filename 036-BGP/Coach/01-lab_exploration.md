# Challenge 1: Exploration - Coach's Guide

[< Previous Challenge](./00-lab_setup.md) - **[Home](./README.md)** - [Next Challenge >](./02-enable_bgp.md)

## Notes and Guidance

Use this to make participants familiar with the environment:

- Inspect the gateways and VPN tunnels
- Check VNets
- Check effective routes of NICs
- Connect to the CSRs and try out some commands

## Solution Guide

The effective routes in the Vnets only show the local prefixes, plus the /32 prefixes configured for the VPN tunnels:

```
az network nic show-effective-route-table -n testvm1VMNic -g $rg -o table
Source                 State    Address Prefix    Next Hop Type          Next Hop IP
---------------------  -------  ----------------  ---------------------  --------------
Default                Active   10.1.0.0/16       VnetLocal
VirtualNetworkGateway  Active   10.2.0.5/32       VirtualNetworkGateway  40.127.161.185
VirtualNetworkGateway  Active   10.2.0.4/32       VirtualNetworkGateway  40.127.161.185
VirtualNetworkGateway  Active   10.3.0.10/32      VirtualNetworkGateway  40.127.161.185
VirtualNetworkGateway  Active   10.4.0.10/32      VirtualNetworkGateway  40.127.161.185
Default                Active   0.0.0.0/0         Internet
Default                Active   10.0.0.0/8        None
Default                Active   100.64.0.0/10     None
Default                Active   192.168.0.0/16    None
Default                Active   25.33.80.0/20     None
Default                Active   25.41.3.0/25      None
```

By the way, if you look at the effective routes in Vnet2, you will notice a difference in the next hop: with active/passive gateways the next hop is the public IP of the VPN gateway, with active/active the next hops are the private IPs (not that this is too important for this challenge):

```
 az network nic show-effective-route-table -n testvm2VMNic -g $rg -o table
Source                 State    Address Prefix    Next Hop Type          Next Hop IP
---------------------  -------  ----------------  ---------------------  -------------
Default                Active   10.2.0.0/16       VnetLocal
VirtualNetworkGateway  Active   10.1.0.254/32     VirtualNetworkGateway  10.2.0.4
VirtualNetworkGateway  Active   10.1.0.254/32     VirtualNetworkGateway  10.2.0.5
VirtualNetworkGateway  Active   10.3.0.10/32      VirtualNetworkGateway  10.2.0.4
VirtualNetworkGateway  Active   10.3.0.10/32      VirtualNetworkGateway  10.2.0.5
VirtualNetworkGateway  Active   10.4.0.10/32      VirtualNetworkGateway  10.2.0.4
VirtualNetworkGateway  Active   10.4.0.10/32      VirtualNetworkGateway  10.2.0.5
Default                Active   0.0.0.0/0         Internet
Default                Active   10.0.0.0/8        None
Default                Active   100.64.0.0/10     None
Default                Active   192.168.0.0/16    None
Default                Active   25.33.80.0/20     None
Default                Active   25.41.3.0/25      None
```

Two Virtual Network Gateways have been deployed:

```
az network vnet-gateway list -o table -g $rg
ActiveActive    EnableBgp    EnablePrivateIpAddress    GatewayType    Location     Name    ProvisioningState    ResourceGroup    ResourceGuid                          VpnGatewayGeneration    VpnType
--------------  -----------  ------------------------  -------------  -----------  ------  -------------------  ---------------  ------------------------------------  ----------------------  ----------
False           True         False                     Vpn            northeurope  vng1    Succeeded            bgp1             375141c0-afb1-4cfc-81c4-41b32a7cd9a2  Generation1             RouteBased
True            True         False                     Vpn            northeurope  vng2    Succeeded            bgp1             971fd1bc-27ef-4357-a35f-99c86642763b  Generation1             RouteBased
```

Note that the deployment script enables BGP in the gateway resources, but not in the VPN connections:

```
az network vpn-connection list -g $rg -o table
ConnectionProtocol    ConnectionType    DpdTimeoutSeconds    EgressBytesTransferred    EnableBgp    ExpressRouteGatewayBypass    IngressBytesTransferred    Location     Name         ProvisioningState    ResourceGroup    ResourceGuid                          RoutingWeight    UseLocalAzureIpAddress    UsePolicyBasedTrafficSelectors
--------------------  ----------------  -------------------  ------------------------  -----------  ---------------------------  -------------------------  -----------  -----------  -------------------  ---------------  ------------------------------------  ---------------  ------------------------  --------------------------------
IKEv2                 IPsec             0                    0                         False        False                        0                          northeurope  vng1tocsr3   Succeeded            bgp1             625db16e-96f5-4d1a-b063-944811f007fe  10               False                     False
IKEv2                 IPsec             0                    0                         False        False                        0                          northeurope  vng1tocsr4   Succeeded            bgp1             37ce8935-f34b-4eec-9959-96444f24b009  10               False                     False
IKEv2                 IPsec             0                    0                         False        False                        0                          northeurope  vng1tovng2a  Succeeded            bgp1             8325e684-c79c-486c-b8b4-3aff53c150dd  10               False                     False
IKEv2                 IPsec             0                    0                         False        False                        0                          northeurope  vng1tovng2b  Succeeded            bgp1             bb9452f7-96f6-43bc-bfc2-e50a83776455  10               False                     False
IKEv2                 IPsec             0                    0                         False        False                        0                          northeurope  vng2tocsr3   Succeeded            bgp1             372a0138-bdf0-47da-9ef1-5aa608227710  10               False                     False
IKEv2                 IPsec             0                    0                         False        False                        0                          northeurope  vng2tocsr4   Succeeded            bgp1             5cbdb91e-cfcd-4c87-a224-33e48724be34  10               False                     False
IKEv2                 IPsec             0                    0                         False        False                        0                          northeurope  vng2tovng1a  Succeeded            bgp1             563f9ac4-6209-4c8f-9ef7-0d5082f8e8bc  10               False                     False
```

The onprem routers know some routes, but not the Vnet prefixes. For example, CSR3 knows about CSR4 and about CSR5 (the onprem prefix 10.5.0.0/16) because the script connected CSR4 and CSR5 via iBGP, but not about Vnets 1 and 2:

```
❯ csr4=$(az network public-ip show -n csr4-pip -g $rg --query ipAddress -o tsv)
❯ ssh labadmin@$csr4 "sh ip route"
Codes: L - local, C - connected, S - static, R - RIP, M - mobile, B - BGP
       D - EIGRP, EX - EIGRP external, O - OSPF, IA - OSPF inter area
       N1 - OSPF NSSA external type 1, N2 - OSPF NSSA external type 2
       E1 - OSPF external type 1, E2 - OSPF external type 2, m - OMP
       n - NAT, Ni - NAT inside, No - NAT outside, Nd - NAT DIA
       i - IS-IS, su - IS-IS summary, L1 - IS-IS level-1, L2 - IS-IS level-2
       ia - IS-IS inter area, * - candidate default, U - per-user static route
       H - NHRP, G - NHRP registered, g - NHRP registration summary
       o - ODR, P - periodic downloaded static route, l - LISP
       a - application route
       + - replicated route, % - next hop override, p - overrides from PfR

Gateway of last resort is 10.4.0.1 to network 0.0.0.0

S*    0.0.0.0/0 [254/0] via 10.4.0.1
      10.0.0.0/8 is variably subnetted, 9 subnets, 3 masks
S        10.1.0.254/32 is directly connected, Tunnel410
S        10.2.0.4/32 is directly connected, Tunnel420
S        10.2.0.5/32 is directly connected, Tunnel421
S        10.3.0.10/32 is directly connected, Tunnel43
S        10.4.0.0/16 [1/0] via 10.4.0.1
C        10.4.0.0/24 is directly connected, GigabitEthernet1
L        10.4.0.10/32 is directly connected, GigabitEthernet1
B        10.5.0.0/16 [200/0] via 10.5.0.10, 21:06:14
S        10.5.0.10/32 is directly connected, Tunnel45
      13.0.0.0/32 is subnetted, 3 subnets
S        13.69.215.204 [1/0] via 10.4.0.1
S        13.70.194.156 [1/0] via 10.4.0.1
S        13.79.225.230 [1/0] via 10.4.0.1
      40.0.0.0/32 is subnetted, 2 subnets
S        40.85.112.200 [1/0] via 10.4.0.1
S        40.85.126.53 [1/0] via 10.4.0.1
      109.0.0.0/32 is subnetted, 1 subnets
S        109.125.122.99 [1/0] via 10.4.0.1
      168.63.0.0/32 is subnetted, 1 subnets
S        168.63.129.16 [254/0] via 10.4.0.1
      169.254.0.0/32 is subnetted, 1 subnets
S        169.254.169.254 [254/0] via 10.4.0.1
```

You can verify connectivity between the VMs in the branches and the core MPLS network. In this example, we are testing connectivity between the vnets of CSR3 and CSR5:

```
❯ testvm3=$(az network public-ip show -n testvm3-pip -g $rg --query ipAddress -o tsv)
❯ ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no "labadmin@$testvm3" "ping 10.5.1.4 -c 5"
10.5.1.4 (10.5.1.4) 56(84) bytes of data.
64 bytes from 10.5.1.4: icmp_seq=1 ttl=62 time=15.7 ms
64 bytes from 10.5.1.4: icmp_seq=2 ttl=62 time=9.87 ms
64 bytes from 10.5.1.4: icmp_seq=3 ttl=62 time=10.0 ms
64 bytes from 10.5.1.4: icmp_seq=4 ttl=62 time=9.90 ms
64 bytes from 10.5.1.4: icmp_seq=5 ttl=62 time=11.8 ms

--- 10.5.1.4 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4004ms
rtt min/avg/max/mdev = 9.879/11.494/15.776/2.271 ms
```
