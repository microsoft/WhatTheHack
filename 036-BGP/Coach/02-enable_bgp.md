# Challenge 2: Enable BGP - Coach's Guide

[< Previous Challenge](./01-lab_exploration.md) - **[Home](./README.md)** - [Next Challenge >](./03-aspath_prepending.md)

## Notes and Guidance

There are three steps to this challenge:

1. Connecting VNG1 and CSR3
2. Connecting VNG2 and CSR4
3. Connecting the rest of the adjacencies

It is recommended start with step 1, and show the main diagnostic commands to the participants. Step 2 will show them the added complexity of active/active gateways.

All IPsec tunnels are already up, but BGP is not enabled. On Azure, participants need to figure out the different places where BGP needs to be configured (VNet Gateway, Local Gateway, connection).

After that, they can split in different subgroups to complete the remaining adjacencies.

There is a expected problem with routes in the iBGP adjacency between CSR3 and CSR4, where routes will not have the correct next hop IP address, and as a consequence VMs will not have connectivity. The fix is adding the `next-hop-self` configuration to the neighbor definitions in CSR3 and CSR4.

## Solution Guides

### Connecting VNG1 and CSR3

There are two steps: first configuring the VNG connection and enable BGP:

```
az network vpn-connection update -n vng1tocsr3 -g $rg --enable-bgp true
```

And second, configure CSR3:

```
csr3=$(az network public-ip show -n csr3-pip -g $rg --query ipAddress -o tsv) && echo $csr3
vpngw_bgp_json=$(az network vnet-gateway show -n vng1 -g $rg --query 'bgpSettings')
vpngw_asn=$(echo "$vpngw_bgp_json" | jq -r '.asn') && echo $vpngw_asn
vpngw_gw0_bgp_ip=$(echo "$vpngw_bgp_json" | jq -r '.bgpPeeringAddresses[0].defaultBgpIpAddresses[0]') && echo $vpngw_gw0_bgp_ip
ssh -o ServerAliveInterval=60 -o BatchMode=yes -o StrictHostKeyChecking=no "labadmin@$csr3" >/dev/null 2>&1 <<EOF
        config t
          router bgp 65100
            neighbor ${vpngw_gw0_bgp_ip} remote-as ${vpngw_asn}
            neighbor ${vpngw_gw0_bgp_ip} ebgp-multihop 5
            neighbor ${vpngw_gw0_bgp_ip} update-source GigabitEthernet1
        end
        wr mem
EOF
```

You can have a new look at the effective routes in Vnet1, now additional /16 prefixes advertised by CSR3 should be there (CSR advertises its local prefi 10.3.0.0/16 as well as the one for the MPLS core network learned from CSR5 via iBGP, 10.5.0.0/16):

<pre>
❯ az network nic show-effective-route-table -n testvm1VMNic -g $rg -o table
Source                 State    Address Prefix    Next Hop Type          Next Hop IP
---------------------  -------  ----------------  ---------------------  --------------
Default                Active   10.1.0.0/16       VnetLocal
VirtualNetworkGateway  Active   10.2.0.4/32       VirtualNetworkGateway  40.127.161.185
VirtualNetworkGateway  Active   10.2.0.5/32       VirtualNetworkGateway  40.127.161.185
VirtualNetworkGateway  Active   10.3.0.10/32      VirtualNetworkGateway  40.127.161.185
VirtualNetworkGateway  Active   10.4.0.10/32      VirtualNetworkGateway  40.127.161.185
<b>VirtualNetworkGateway  Active   10.5.0.0/16       VirtualNetworkGateway  40.127.161.185
VirtualNetworkGateway  Active   10.3.0.0/16       VirtualNetworkGateway  40.127.161.185</b>
Default                Active   0.0.0.0/0         Internet
Default                Active   10.0.0.0/8        None
Default                Active   100.64.0.0/10     None
Default                Active   192.168.0.0/16    None
Default                Active   25.33.80.0/20     None
Default                Active   25.41.3.0/25      None
</pre>

You can inspect as well the different BGP commands on VNG1 to see its neighbors, what it is learning, and what it is advertising:

<pre>
<b>az network vnet-gateway list-bgp-peer-status -n vng1 -g $rg -o table</b>
Neighbor    ASN    State      ConnectedDuration    RoutesReceived    MessagesSent    MessagesReceived
----------  -----  ---------  -------------------  ----------------  --------------  ------------------
10.3.0.10   65100  Connected  00:02:56.0967494     2                 6               9
</pre>

<pre>
<b>az network vnet-gateway list-learned-routes -n vng1 -g $rg -o table</b>
Network       Origin    SourcePeer    AsPath    Weight    NextHop
------------  --------  ------------  --------  --------  ---------
10.1.0.0/16   Network   10.1.0.254              32768
10.2.0.4/32   Network   10.1.0.254              32768
10.2.0.5/32   Network   10.1.0.254              32768
10.3.0.10/32  Network   10.1.0.254              32768
10.4.0.10/32  Network   10.1.0.254              32768
10.5.0.0/16   EBgp      10.3.0.10     65100     32768     10.3.0.10
10.3.0.0/16   EBgp      10.3.0.10     65100     32768     10.3.0.10
</pre>

<pre>
<b>az network vnet-gateway list-advertised-routes -n vng1 -g $rg --peer 10.3.0.10 -o table</b>
Network       NextHop     Origin    AsPath    Weight
------------  ----------  --------  --------  --------
10.1.0.0/16   10.1.0.254  Igp       65001     0
10.2.0.4/32   10.1.0.254  Igp       65001     0
10.2.0.5/32   10.1.0.254  Igp       65001     0
10.4.0.10/32  10.1.0.254  Igp       65001     0
</pre>

Similarly, you can look at the different tables in CSR3. Let's start with the neighbor list. Notice that the number of prefixes received is the number of advertised routes that the `az network vnet-gateway list-advertised-routes` gave us earlier:

<pre>
ssh labadmin@$csr3 "show ip bgp summary"

BGP router identifier 10.3.0.10, local AS number 65100
BGP table version is 8, main routing table version 8
7 network entries using 1736 bytes of memory
7 path entries using 952 bytes of memory
3/3 BGP path/bestpath attribute entries using 864 bytes of memory
1 BGP AS-PATH entries using 24 bytes of memory
0 BGP route-map cache entries using 0 bytes of memory
0 BGP filter-list cache entries using 0 bytes of memory
BGP using 3576 total bytes of memory
BGP activity 7/0 prefixes, 7/0 paths, scan interval 60 secs
7 networks peaked at 09:41:39 Dec 4 2020 UTC (00:05:59.164 ago)

Neighbor        V           AS MsgRcvd MsgSent   TblVer  InQ OutQ Up/Down  State/PfxRcd
10.1.0.254      4        65001      19      21        7    0    0 00:13:55        4
10.5.0.10       4        65100    1422    1421        7    0    0 21:27:38        1
</pre>

You can safely ignore the 10.5.0.10 for now, it was pre-created by the deployment script to interconnect the branch to the MPLS core network.

We can have a look at the BGP route table, which will show the prefixes learnt over BGP. Note that the prefixes generated in the local AS (65100) have a path of `?`. Not too important, but this typically signals that the prefixes were injected via redistribution and not with a `network` command:

<pre>
ssh labadmin@$csr3 "show ip bgp"

BGP table version is 8, local router ID is 10.3.0.10
Status codes: s suppressed, d damped, h history, * valid, > best, i - internal,
              r RIB-failure, S Stale, m multipath, b backup-path, f RT-Filter,
              x best-external, a additional-path, c RIB-compressed,
              t secondary path, L long-lived-stale,
Origin codes: i - IGP, e - EGP, ? - incomplete
RPKI validation codes: V valid, I invalid, N Not found

     Network          Next Hop            Metric LocPrf Weight Path
 *>   10.1.0.0/16      10.1.0.254                             0 65001 i
 r>   10.2.0.4/32      10.1.0.254                             0 65001 i
 r>   10.2.0.5/32      10.1.0.254                             0 65001 i
 *>   10.3.0.0/16      10.3.0.1                 0         32768 ?
 r>   10.4.0.10/32     10.1.0.254                             0 65001 i
 *>i  10.5.0.0/16      10.5.0.10                0    100      0 ?
</pre>

The `r` mark in the previous table means that a certain prefix learnt over BGP will not be converted into an actual route, because another route already exists. That being said, we can now see which routes appear in the route table coming from BGP, which should essentially be the prefix for Vnet1, plus 10.5.0.0/16 from the corporate network:

<pre>
ssh labadmin@$csr3 "show ip route bgp"
[...]
B        10.1.0.0/16 [20/0] via 10.1.0.254, 00:17:17
B        10.5.0.0/16 [200/0] via 10.5.0.10, 21:31:00
</pre>

You can try other commands to see the learned routes:

<pre>
ssh labadmin@$csr3 "show ip bgp neighbor 10.1.0.254 routes"
[...]
     Network          Next Hop            Metric LocPrf Weight Path
 *>   10.1.0.0/16      10.1.0.254                             0 65001 i
 r>   10.2.0.4/32      10.1.0.254                             0 65001 i
 r>   10.2.0.5/32      10.1.0.254                             0 65001 i
 r>   10.4.0.10/32     10.1.0.254                             0 65001 i

Total number of prefixes 4
</pre>

...and the advertised routes:

<pre>
ssh labadmin@$csr3 "show ip bgp neig 10.1.0.254 advertised-routes"
[...]
     Network          Next Hop            Metric LocPrf Weight Path
 *>   10.3.0.0/16      10.3.0.1                 0         32768 ?
 *>i  10.5.0.0/16      10.5.0.10                0    100      0 ?

Total number of prefixes 3
</pre>

### Connecting VNG2 and CSR4

Same here, there are two steps: first configuring the VNG connection and enable BGP. The one difference is that since VNG2 is active/active, we need to add two neighbors to CSR4:

```
az network vpn-connection update -n vng2tocsr4 -g $rg --enable-bgp true
```

And second, configure CSR4:

```
csr4=$(az network public-ip show -n csr4-pip -g $rg --query ipAddress -o tsv) && echo $csr4
vpngw_bgp_json=$(az network vnet-gateway show -n vng2 -g $rg --query 'bgpSettings')
vpngw_asn=$(echo "$vpngw_bgp_json" | jq -r '.asn') && echo $vpngw_asn
vpngw_gw0_bgp_ip=$(echo "$vpngw_bgp_json" | jq -r '.bgpPeeringAddresses[0].defaultBgpIpAddresses[0]') && echo $vpngw_gw0_bgp_ip
vpngw_gw1_bgp_ip=$(echo "$vpngw_bgp_json" | jq -r '.bgpPeeringAddresses[1].defaultBgpIpAddresses[0]') && echo $vpngw_gw1_bgp_ip
ssh -o ServerAliveInterval=60 -o BatchMode=yes -o StrictHostKeyChecking=no "labadmin@$csr4" >/dev/null 2>&1 <<EOF
        config t
          router bgp 65100
            neighbor ${vpngw_gw0_bgp_ip} remote-as ${vpngw_asn}
            neighbor ${vpngw_gw0_bgp_ip} ebgp-multihop 5
            neighbor ${vpngw_gw0_bgp_ip} update-source GigabitEthernet1
            neighbor ${vpngw_gw1_bgp_ip} remote-as ${vpngw_asn}
            neighbor ${vpngw_gw1_bgp_ip} ebgp-multihop 5
            neighbor ${vpngw_gw1_bgp_ip} update-source GigabitEthernet1
        end
        wr mem
EOF
```

Let's start with the effective route table in the VM deployed in Vnet2:

<pre>
az network nic show-effective-route-table -n testvm2VMNic -g $rg -o table
Source                 State    Address Prefix    Next Hop Type          Next Hop IP
---------------------  -------  ----------------  ---------------------  -------------
Default                Active   10.2.0.0/16       VnetLocal
VirtualNetworkGateway  Active   10.1.0.254/32     VirtualNetworkGateway  10.2.0.5
VirtualNetworkGateway  Active   10.1.0.254/32     VirtualNetworkGateway  10.2.0.4
VirtualNetworkGateway  Active   10.3.0.10/32      VirtualNetworkGateway  10.2.0.4
VirtualNetworkGateway  Active   10.3.0.10/32      VirtualNetworkGateway  10.2.0.5
VirtualNetworkGateway  Active   10.4.0.10/32      VirtualNetworkGateway  10.2.0.4
VirtualNetworkGateway  Active   10.4.0.10/32      VirtualNetworkGateway  10.2.0.5
<b>VirtualNetworkGateway  Active   10.5.0.0/16       VirtualNetworkGateway  10.2.0.5
VirtualNetworkGateway  Active   10.5.0.0/16       VirtualNetworkGateway  10.2.0.4
VirtualNetworkGateway  Active   10.4.0.0/16       VirtualNetworkGateway  10.2.0.5
VirtualNetworkGateway  Active   10.4.0.0/16       VirtualNetworkGateway  10.2.0.4</b>
Default                Active   0.0.0.0/0         Internet
Default                Active   10.0.0.0/8        None
Default                Active   100.64.0.0/10     None
Default                Active   192.168.0.0/16    None
Default                Active   25.33.80.0/20     None
Default                Active   25.41.3.0/25      None
</pre>

We can have a look at the BGP neighbor adjacencies in VNG2. As you can see in the table, it is a bit more complex than in VNG1, because we have an active/active gateway. The Azure CLI command concatenates the adjacencies of both gateways, for reading clarity the table has been color-coded to differentiate the adjacencies of each gateway:

<pre>
az network vnet-gateway list-bgp-peer-status -n vng2 -g $rg -o table
Neighbor    ASN    State      ConnectedDuration    RoutesReceived    MessagesSent    MessagesReceived
----------  -----  ---------  -------------------  ----------------  --------------  ------------------
<p style="color:blue">10.4.0.10   65100  Connected  00:06:17.5755203     4                 9               14
10.2.0.4    65002  Connected  20:21:58.1068813     7                 1426            1426
10.2.0.5    65002  Unknown                         0                 0               0
<p style="color:red">10.4.0.10   65100  Connected  00:06:16.9122216     4                 10              14
10.2.0.4    65002  Unknown                         0                 0               0
10.2.0.5    65002  Connected  20:21:58.2603366     7                 1424            1428
</pre>

As you can see, other than the eBGP adjacency to CSR4, the gateways have an iBGP adjacency between each other. We can explore what they advertise to CSR4 and what they receive from it:

<pre>
az network vnet-gateway list-advertised-routes -n vng2 -g $rg --peer 10.4.0.10 -o table
Network        NextHop    Origin    AsPath    Weight
-------------  ---------  --------  --------  --------
<p style="color:blue">10.2.0.0/16    10.2.0.4   Igp       65002     0
10.1.0.254/32  10.2.0.4   Igp       65002     0
10.3.0.10/32   10.2.0.4   Igp       65002     0
<p style="color:red">10.2.0.0/16    10.2.0.5   Igp       65002     0
10.1.0.254/32  10.2.0.5   Igp       65002     0
10.3.0.10/32   10.2.0.5   Igp       65002     0
</pre>

And the learned routes:

<pre>
az network vnet-gateway list-learned-routes -n vng2 -g $rg -o table
Network        Origin    SourcePeer    AsPath    Weight    NextHop
-------------  --------  ------------  --------  --------  ---------
<p style="color:blue">10.2.0.0/16    Network   10.2.0.5                32768
10.1.0.254/32  Network   10.2.0.5                32768
10.1.0.254/32  IBgp      10.2.0.4                32768     10.2.0.4
10.3.0.10/32   Network   10.2.0.5                32768
10.3.0.10/32   IBgp      10.2.0.4                32768     10.2.0.4
10.4.0.10/32   Network   10.2.0.5                32768
10.4.0.10/32   IBgp      10.2.0.4                32768     10.2.0.4
10.5.0.0/16    EBgp      10.4.0.10     65100     32768     10.4.0.10
10.5.0.0/16    IBgp      10.2.0.4      65100     32768     10.2.0.4
10.4.0.0/16    EBgp      10.4.0.10     65100     32768     10.4.0.10
10.4.0.0/16    IBgp      10.2.0.4      65100     32768     10.2.0.4
<p style="color:red">10.2.0.0/16    Network   10.2.0.4                32768
10.1.0.254/32  Network   10.2.0.4                32768
10.1.0.254/32  IBgp      10.2.0.5                32768     10.2.0.5
10.3.0.10/32   Network   10.2.0.4                32768
10.3.0.10/32   IBgp      10.2.0.5                32768     10.2.0.5
10.4.0.10/32   Network   10.2.0.4                32768
10.4.0.10/32   IBgp      10.2.0.5                32768     10.2.0.5
10.5.0.0/16    EBgp      10.4.0.10     65100     32768     10.4.0.10
10.5.0.0/16    IBgp      10.2.0.5      65100     32768     10.2.0.5
10.4.0.0/16    EBgp      10.4.0.10     65100     32768     10.4.0.10
10.4.0.0/16    IBgp      10.2.0.5      65100     32768     10.2.0.5
</pre>

We can test VM connectivity now. VNet1 should have access to VNets 3 and 5, and VNet2 to Vnets 4 and 5:

```
❯ testvm1=$(az network public-ip show -n testvm1-pip -g $rg --query ipAddress -o tsv)
❯ ssh -n -o ServerAliveInterval=60 -o BatchMode=yes -o StrictHostKeyChecking=no "labadmin@$testvm1" "ping 10.3.1.4 -c 3"
Warning: Permanently added '94.245.106.184' (ECDSA) to the list of known hosts.
PING 10.3.1.4 (10.3.1.4) 56(84) bytes of data.
64 bytes from 10.3.1.4: icmp_seq=1 ttl=63 time=8.63 ms
64 bytes from 10.3.1.4: icmp_seq=2 ttl=63 time=5.62 ms
64 bytes from 10.3.1.4: icmp_seq=3 ttl=63 time=4.91 ms

--- 10.3.1.4 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 4.913/6.391/8.635/1.614 ms
❯ ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no "labadmin@$testvm1" "ping 10.5.1.4 -c 3"
PING 10.5.1.4 (10.5.1.4) 56(84) bytes of data.
64 bytes from 10.5.1.4: icmp_seq=1 ttl=62 time=10.3 ms
64 bytes from 10.5.1.4: icmp_seq=2 ttl=62 time=8.55 ms
64 bytes from 10.5.1.4: icmp_seq=3 ttl=62 time=9.01 ms

--- 10.5.1.4 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 8.557/9.304/10.338/0.762 ms
```

```
❯ testvm2=$(az network public-ip show -n testvm2-pip -g $rg --query ipAddress -o tsv)
❯ ssh -n -o ServerAliveInterval=60 -o BatchMode=yes -o StrictHostKeyChecking=no "$labadmin@testvm2" "ping 10.4.1.4 -c 3"
Warning: Permanently added '137.135.128.45' (ECDSA) to the list of known hosts.
PING 10.4.1.4 (10.4.1.4) 56(84) bytes of data.
64 bytes from 10.4.1.4: icmp_seq=1 ttl=63 time=6.13 ms
64 bytes from 10.4.1.4: icmp_seq=2 ttl=63 time=4.23 ms
64 bytes from 10.4.1.4: icmp_seq=3 ttl=63 time=4.77 ms

--- 10.4.1.4 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2002ms
rtt min/avg/max/mdev = 4.232/5.046/6.137/0.805 ms
❯ ssh -n -o ServerAliveInterval=60 -o BatchMode=yes -o StrictHostKeyChecking=no "labadmin@$testvm2" "ping 10.5.1.4 -c 3"
PING 10.5.1.4 (10.5.1.4) 56(84) bytes of data.
64 bytes from 10.5.1.4: icmp_seq=1 ttl=62 time=10.2 ms
64 bytes from 10.5.1.4: icmp_seq=2 ttl=62 time=12.1 ms
64 bytes from 10.5.1.4: icmp_seq=3 ttl=62 time=12.2 ms

--- 10.5.1.4 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2001ms
rtt min/avg/max/mdev = 10.286/11.557/12.232/0.908 ms
```

You can check, but VNet1 shouldnt have connectivity to Vnet2, nor VNet3 to VNet4. The reason is because while both CSR3 and CSR4 are connected via iBGP to VNet5, iBGP will not readvertised the routes learned from another iBGP neighbor. In other words, CSR will not readvertise to CSR4 whatever it learned from CSR3, and vice versa.

### Connecting the rest of the adjacencies

We can enable BGP in the rest of the Azure VPN connections:

<pre>
az network vpn-connection update -n vng1tocsr4 -g $rg --enable-bgp true
az network vpn-connection update -n vng2tocsr3 -g $rg --enable-bgp true
az network vpn-connection update -n vng1tovng2a -g $rg --enable-bgp true
az network vpn-connection update -n vng1tovng2b -g $rg --enable-bgp true
az network vpn-connection update -n vng2tovng1a -g $rg --enable-bgp true
</pre>

And the Cisco routers:

```
csr3=$(az network public-ip show -n csr3-pip -g $rg --query ipAddress -o tsv) && echo $csr3
csr4=$(az network public-ip show -n csr4-pip -g $rg --query ipAddress -o tsv) && echo $csr4
vpngw_bgp_json=$(az network vnet-gateway show -n vng2 -g $rg --query 'bgpSettings')
vpngw_asn=$(echo "$vpngw_bgp_json" | jq -r '.asn') && echo $vpngw_asn
vpngw_gw0_bgp_ip=$(echo "$vpngw_bgp_json" | jq -r '.bgpPeeringAddresses[0].defaultBgpIpAddresses[0]') && echo $vpngw_gw0_bgp_ip
vpngw_gw1_bgp_ip=$(echo "$vpngw_bgp_json" | jq -r '.bgpPeeringAddresses[1].defaultBgpIpAddresses[0]') && echo $vpngw_gw1_bgp_ip
ssh -o ServerAliveInterval=60 -o BatchMode=yes -o StrictHostKeyChecking=no "labadmin@$csr3" >/dev/null 2>&1 <<EOF
        config t
          router bgp 65100
            neighbor ${vpngw_gw0_bgp_ip} remote-as ${vpngw_asn}
            neighbor ${vpngw_gw0_bgp_ip} ebgp-multihop 5
            neighbor ${vpngw_gw0_bgp_ip} update-source GigabitEthernet1
            neighbor ${vpngw_gw1_bgp_ip} remote-as ${vpngw_asn}
            neighbor ${vpngw_gw1_bgp_ip} ebgp-multihop 5
            neighbor ${vpngw_gw1_bgp_ip} update-source GigabitEthernet1
            neighbor 10.4.0.10 remote-as 65100
            neighbor 10.4.0.10 update-source GigabitEthernet1
        end
        wr mem
EOF
vpngw_bgp_json=$(az network vnet-gateway show -n vng1 -g $rg --query 'bgpSettings')
vpngw_asn=$(echo "$vpngw_bgp_json" | jq -r '.asn') && echo $vpngw_asn
vpngw_gw0_bgp_ip=$(echo "$vpngw_bgp_json" | jq -r '.bgpPeeringAddresses[0].defaultBgpIpAddresses[0]') && echo $vpngw_gw0_bgp_ip
ssh -o ServerAliveInterval=60 -o BatchMode=yes -o StrictHostKeyChecking=no "labadmin@$csr4" >/dev/null 2>&1 <<EOF
        config t
          router bgp 65100
            neighbor ${vpngw_gw0_bgp_ip} remote-as ${vpngw_asn}
            neighbor ${vpngw_gw0_bgp_ip} ebgp-multihop 5
            neighbor ${vpngw_gw0_bgp_ip} update-source GigabitEthernet1
            neighbor 10.3.0.10 remote-as 65100
            neighbor 10.3.0.10 update-source GigabitEthernet1
        end
        wr mem
EOF
```

We can check the neighbor tables:

<pre>
az network vnet-gateway list-bgp-peer-status -n vng1 -g $rg -o table
Neighbor    ASN    State      ConnectedDuration    RoutesReceived    MessagesSent    MessagesReceived
----------  -----  ---------  -------------------  ----------------  --------------  ------------------
10.2.0.5    65002  Connected  00:01:51.9049121     6                 13              8
10.3.0.10   65100  Connected  00:32:28.5519667     4                 45              50
10.4.0.10   65100  Connected  00:01:01.3476157     5                 8               12
10.2.0.4    65002  Connected  00:01:51.9361933     6                 15              10
</pre>

<pre>
az network vnet-gateway list-bgp-peer-status -n vng2 -g $rg -o table
Neighbor    ASN    State      ConnectedDuration    RoutesReceived    MessagesSent    MessagesReceived
----------  -----  ---------  -------------------  ----------------  --------------  ------------------
<p style="color:blue">10.1.0.254  65001  Connected  00:02:12.8925106     7                 6               10
10.3.0.10   65100  Connected  00:01:34.3342228     6                 8               11
10.4.0.10   65100  Connected  00:13:13.0890798     5                 24              30
10.2.0.4    65002  Connected  21:58:03.4434893     7                 1537            1539
10.2.0.5    65002  Unknown                         0                 0               0
<p style="color:red">10.1.0.254  65001  Connected  00:02:12.9501653     7                 8               9
10.3.0.10   65100  Connected  00:01:31.8210057     6                 8               11
10.4.0.10   65100  Connected  00:13:16.7998186     5                 23              30
10.2.0.4    65002  Unknown                         0                 0               0
10.2.0.5    65002  Connected  21:58:03.5277380     7                 1537            1539
</pre>

<pre>
ssh labadmin@$csr3 "sh ip bgp summ"
[...]
Neighbor        V           AS MsgRcvd MsgSent   TblVer  InQ OutQ Up/Down  State/PfxRcd
10.1.0.254      4        65001      46      51       16    0    0 00:33:04        5
10.2.0.4        4        65002       8      11       16    0    0 00:01:47        5
10.2.0.5        4        65002       9      11       16    0    0 00:01:49        5
10.4.0.10       4        65100       9       9       16    0    0 00:01:33        7
10.5.0.10       4        65100    1443    1445       16    0    0 21:46:47        1
</pre>

<pre>
ssh labadmin@$csr4 "sh ip bgp summ"
[...]
Neighbor        V           AS MsgRcvd MsgSent   TblVer  InQ OutQ Up/Down  State/PfxRcd
10.1.0.254      4        65001      46      51       16    0    0 00:33:04        5
10.2.0.4        4        65002       8      11       16    0    0 00:01:47        5
10.2.0.5        4        65002       9      11       16    0    0 00:01:49        5
10.4.0.10       4        65100       9       9       16    0    0 00:01:33        7
10.5.0.10       4        65100    1443    1445       16    0    0 21:46:47        1
</pre>
