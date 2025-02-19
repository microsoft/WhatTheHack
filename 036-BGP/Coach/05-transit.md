# Challenge 5: Prevent Transit Routing - Coach's Guide

[< Previous Challenge](./04-filtering.md) - **[Home](./README.md)** - [Next Challenge >](./06-communities.md)

## Notes and Guidance

This is important for example when customers are connecting a private peering and a Microsoft peering to the same router. They don't want to inject routes from the Microsoft peering back into the private peering. Doing so will at best introduce suboptimal routing, at worst break certain things such as Azure SQL Managed Instance, for example.

## Solution Guide

At this point, each VNG gets the other Azure prefix from on prem as well. For example VNG1 instances get the 10.2.0.0/16 both from VNG2 and CSR3/CSR4:

<pre>
az network vnet-gateway list-learned-routes -n vng1 -g $rg -o table | grep 10.2.0.0/16
10.2.0.0/16   EBgp      10.2.0.5      65002        32768     10.2.0.5
10.2.0.0/16   EBgp      10.2.0.4      65002        32768     10.2.0.4
<b>10.2.0.0/16   EBgp      10.3.0.10     65100-65002  32768     10.3.0.10
10.2.0.0/16   EBgp      10.4.0.10     65100-65002  32768     10.4.0.10</b>
</pre>

This means that if the routes from VNG2 disappeared, VNG1 would send traffic through one of the branches (CSR3 or CSR4). Sometimes you don't want to advertise from your routers prefixes that have not originated in your own network. You can configure an outbound filter in the onprem routers so that only routes with an empty AS path (originated locally) are advertised, and everything else is denied:

```bash
# CSR3
ssh -o ServerAliveInterval=60 -o BatchMode=yes -o StrictHostKeyChecking=no "labadmin@$csr3" >/dev/null 2>&1 <<'EOF'
conf t
    ip as-path access-list 1 permit ^$
    route-map tovngs permit 20
      match as-path 1
    route-map tovngs deny 30
end
wr mem
EOF
# CSR4
ssh -o ServerAliveInterval=60 -o BatchMode=yes -o StrictHostKeyChecking=no "labadmin@$csr4" >/dev/null 2>&1 <<'EOF'
conf t
    ip as-path access-list 1 permit ^$
    route-map tovngs permit 20
      match as-path 1
    route-map tovngs deny 30
end
wr mem
EOF
```

If we check again on the learned routes in VNG1:

<pre>
az network vnet-gateway list-learned-routes -n vng1 -g $rg -o table | grep 10.2.0.0/16
10.2.0.0/16   EBgp      10.2.0.5      65002        32768     10.2.0.5
10.2.0.0/16   EBgp      10.2.0.4      65002        32768     10.2.0.4
</pre>

You can check on VNG2, it should be the same effect for 10.1.0.0/16.
