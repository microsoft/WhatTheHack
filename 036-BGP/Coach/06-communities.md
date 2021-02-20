# Challenge 6 - BGP Communities

[< Previous Challenge](./05-transit.md) - **[Home](./README.md)** - [Next Challenge >](./07-vng_ibgp.md)

BGP communities are like route tags. There are some well-known communities like `no-export` or `no-advertise` that instruct BGP to do specific things. Outside of those you can use your own custom communities to use them as filters later on in your network.

In this challenge we will mark the routes corresponding to VNet1 with a specific label, and the routes for VNet2 with another one. We will do the marking in the onprem edge (CSR3 and CSR4), and we will verify that CSR5 can see the communities.

Deploy this configuration to CSR3 and CSR4:

```bash
# CSR3
ssh -o BatchMode=yes -o StrictHostKeyChecking=no "$csr3" >/dev/null 2>&1 <<'EOF'
config t
    route-map fromvngs permit 5
      match ip address prefix-list Vnet1
      set community 65100:1
    route-map fromvngs permit 6
      match ip address prefix-list Vnet2
      set community 65100:2
    ip prefix-list Vnet1 permit 10.1.0.0/16
    ip prefix-list Vnet2 permit 10.2.0.0/16
    router bgp 65100
      neighbor 10.5.0.10 send-community
end
wr mem
EOF
# CSR4
ssh -o BatchMode=yes -o StrictHostKeyChecking=no "$csr4" >/dev/null 2>&1 <<'EOF'
conf t
    route-map fromvngs permit 5
      match ip address prefix-list Vnet1
      set community 65100:1
    route-map fromvngs permit 6
      match ip address prefix-list Vnet2
      set community 65100:2
    ip prefix-list Vnet1 permit 10.1.0.0/16
    ip prefix-list Vnet2 permit 10.2.0.0/16
    router bgp 65100
      neighbor 10.5.0.10 send-community
end
wr mem
EOF
```

We can clear the BGP adjacencies to make sure that our new config is effective:

```bash
# Restart BGP adjacencies
ssh -n $csr3 "clear ip bgp *"
ssh -n $csr4 "clear ip bgp *"
```

We can see whether CSR5 could leverage this information to configure its routing policies. The first thing to see if whether CSR5 can see the communities that CSR3 and CSR4 applied to the routes:

<pre>
❯ csr5=$(az network public-ip show -n csr5-pip -g $rg --query ipAddress -o tsv)
❯ ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no "$csr5" "sh ip bgp 10.1.0.0/16"

BGP routing table entry for 10.1.0.0/16, version 76
Paths: (2 available, best #2, table default)
Multipath: eiBGP
  Not advertised to any peer
  Refresh Epoch 1
  65001
    10.4.0.10 from 10.4.0.10 (10.4.0.10)
      Origin IGP, metric 0, localpref 100, valid, internal, multipath(oldest)
      <b>Community: 4266393601</b>
      rx pathid: 0, tx pathid: 0
      Updated on Dec 6 2020 11:16:26 UTC
  Refresh Epoch 1
  65001
    10.3.0.10 from 10.3.0.10 (10.3.0.10)
      Origin IGP, metric 0, localpref 100, valid, internal, multipath, best
      <b>Community: 4266393601</b>
      rx pathid: 0, tx pathid: 0x0
      Updated on Dec 6 2020 11:16:21 UTC
</pre>

You can use communities as arbitrary tags (such as hte ones used in the Microsoft peering of ExpressRoute), and you can configure filters that match on community (in Cisco IOS with the command `ip community-list`). There are some with well-known meanings though, see [Well Known BGP Communities](https://www.iana.org/assignments/bgp-well-known-communities/bgp-well-known-communities.xhtml).

### Advertise a default route from onprem via BGP (Forced Tunneling)

First, verify that the default route in the Azure Vnets is pointing to the public internet:

```bash
$ az network nic show-effective-route-table -n testvm1VMNic -g $rg -o table | grep 0.0.0.0/0
Default                Active   0.0.0.0/0         Internet
```

And the same thing for Vnet2:

```bash
$ az network nic show-effective-route-table -n testvm2VMNic -g $rg -o table | grep 0.0.0.0/0
Default                Active   0.0.0.0/0         Internet
```

We can configure one or both of the branch CSRs to propagate a default. In this case we will use CSR3:

```bash
# CSR3
ssh -o BatchMode=yes -o StrictHostKeyChecking=no "$csr3" >/dev/null 2>&1 <<'EOF'
config t
    ip prefix-list S2B permit 0.0.0.0/0
    router bgp 65100
      default-information originate
end
clear ip bgp *
wr mem
EOF
```

You will need to wait a few minutes for the BGP adjacencies to recover (the previous commands tear them down). After some seconds, you should see 0.0.0.0/0 from the VNGs coming to the Azure Vnets:

```bash
 az network nic show-effective-route-table -n testvm1VMNic -g $rg -o table | grep 0.0.0.0/0
VirtualNetworkGateway  Active   0.0.0.0/0         VirtualNetworkGateway  13.70.194.156
```

> The 0.0.0.0/0 might appear twice, but after some minutes it will estabilize and one of the two routes will disappear leaving only one

And in Vnet2:

```bash
❯ az network nic show-effective-route-table -n testvm2VMNic -g $rg -o table | grep 0.0.0.0/0
VirtualNetworkGateway  Active   0.0.0.0/0         VirtualNetworkGateway  10.2.0.4
VirtualNetworkGateway  Active   0.0.0.0/0         VirtualNetworkGateway  10.2.0.5
```

As you can see, configuring the default site in the VNG is not required when propagating a default route over BGP.
