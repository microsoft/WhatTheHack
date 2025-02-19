# Challenge 7: Default Routing - Coach's Guide

[< Previous Challenge](./06-communities.md) - **[Home](./README.md)** - [Next Challenge >](./08-vng_ibgp.md)

## Notes and Guidance

Injecting a default route over VPN is a common scenario:

- Forced Tunnelling to an on-prem firewall
- Security Partners in Virtual WAN such as zScaler

Make sure the participants note that nothing needed to be configured at the VPN Gateway as [this document](https://docs.microsoft.com/azure/vpn-gateway/vpn-gateway-forced-tunneling-rm) describes for static routing site-to-site connections, with the "default site" concept.

## Solution Guide

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
ssh -o ServerAliveInterval=60 -o BatchMode=yes -o StrictHostKeyChecking=no "labadmin@$csr3" >/dev/null 2>&1 <<'EOF'
config t
    router bgp 65100
      neighbor 10.1.0.254 default-originate
      neighbor 10.2.0.4 default-originate
      neighbor 10.2.0.5 default-originate
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

> The 0.0.0.0/0 might appear twice, but after some minutes it will stabilize and one of the two routes will disappear leaving only one

And in Vnet2:

```bash
❯ az network nic show-effective-route-table -n testvm2VMNic -g $rg -o table | grep 0.0.0.0/0
VirtualNetworkGateway  Active   0.0.0.0/0         VirtualNetworkGateway  10.2.0.4
VirtualNetworkGateway  Active   0.0.0.0/0         VirtualNetworkGateway  10.2.0.5
```

As you can see, configuring the default site in the VNG is not required when propagating a default route over BGP.
