# Challenge 3: Influencing Routing - Coach's Guide

[< Previous Challenge](./02-enable_bgp.md) - **[Home](./README.md)** - [Next Challenge >](./04-filtering.md)

## Notes and Guidance

The problem is that VNG1 has two equally good routes to go to each of the branches. For example, for branch3 (`10.3.0.0/16`) the first two routes of the following output are equal:

<pre>
<b>az network vnet-gateway list-learned-routes -n vng1 -g $rg -o table | grep 10.3.0.0/16</b>
10.3.0.0/16   EBgp      10.3.0.10     65100        32768     10.3.0.10
10.3.0.0/16   EBgp      10.4.0.10     65100        32768     10.4.0.10
10.3.0.0/16   EBgp      10.2.0.5      65002-65100  32768     10.2.0.5
10.3.0.0/16   EBgp      10.2.0.4      65002-65100  32768     10.2.0.4
</pre>

The problem here is that for VNG1 both routes from CSR3 and CSR4 are identical, so it would take the longer way (through CSR4) for 50% of the packets.

## Solution Guide

In order to fix this we can configure CSR3 and CSR4 to advertise a worse metric (AS path) for the routes from the other branches. You can put this config in CSR3:

```bash
# CSR3
ssh -o ServerAliveInterval=60 -o BatchMode=yes -o StrictHostKeyChecking=no "labadmin@$csr3" >/dev/null 2>&1 <<EOF
conf t
    router bgp 65100
      neighbor 10.1.0.254 route-map tovngs out
      neighbor 10.2.0.4 route-map tovngs out
      neighbor 10.2.0.5 route-map tovngs out
    route-map tovngs
      match ip address prefix-list branch4
      set as-path prepend 65100
    route-map tovngs permit 20
    ip prefix-list branch4 permit 10.4.0.0/16
end
wr mem
EOF
```

And this on CSR4:

```bash
# CSR4
ssh -o ServerAliveInterval=60 -o BatchMode=yes -o StrictHostKeyChecking=no "labadmin@$csr4" >/dev/null 2>&1 <<EOF
conf t
    router bgp 65100
      neighbor 10.1.0.254 route-map tovngs out
      neighbor 10.2.0.4 route-map tovngs out
      neighbor 10.2.0.5 route-map tovngs out
    route-map tovngs
      match ip address prefix-list branch3
      set as-path prepend 65100
    route-map tovngs permit 20
    ip prefix-list branch3 permit 10.3.0.0/16
    end
wr mem
EOF
```

You might need to restart your BGP adjacencies to make the change take effect quicker:

```bash
ssh -o ServerAliveInterval=60 -n labadmin@$csr3 "clear ip bgp *"
ssh -o ServerAliveInterval=60 -n labadmin@$csr4 "clear ip bgp *"
```

Now let's look again at how VNG1 learns 10.3.0.0/16:

<pre>
az network vnet-gateway list-learned-routes -n vng1 -g $rg -o table | grep 10.3.0.0/16
10.3.0.0/16   EBgp      10.3.0.10     65100        32768     10.3.0.10
10.3.0.0/16   EBgp      10.2.0.5      65002-65100  32768     10.2.0.5
10.3.0.0/16   EBgp      10.2.0.4      65002-65100  32768     10.2.0.4
10.3.0.0/16   EBgp      10.4.0.10     <b>65100-65100</b>  32768     10.4.0.10
</pre>

You can check the route 10.4.0.0/16 on VNG1, as well as the same routes in VNG2.
