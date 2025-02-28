# Challenge 4: Route Filtering - Coach's Guide

[< Previous Challenge](./03-aspath_prepending.md) - **[Home](./README.md)** - [Next Challenge >](./05-transit.md)

## Notes and Guidance

Frame this in the context of customer examples:

1. Customers that do not want to get the 0.0.0.0/0 sent from Azure to onprem
1. Customers that do not want too specific prefixes to be sent from Azure to onprem, since this can be seen as a security vulnerability to route poisoning attacks

Since you cannot configure route filters on Azure VPN gateways (or ExpressRoute gateways for that matter), configuring route filters onprem is the only way to protect the customer's network from unwanted prefixes.

## Solution Guide

As you can see, CSR3 and CSR4 get some /32 prefixes from BGP:

```
ssh -o ServerAliveInterval=60 labadmin@$csr3 "sh ip bgp | i /32"
 rmi  10.1.0.254/32    10.4.0.10                0    100      0 65002 i
 r i  10.2.0.4/32      10.1.0.254               0    100      0 65001 i
 r i  10.2.0.5/32      10.1.0.254               0    100      0 65001 i
 r>i  10.3.0.10/32     10.1.0.254               0    100      0 65001 i
 r    10.4.0.10/32     10.2.0.4                               0 65002 i
```

The objective is not to accept /32 prefixes advertised by Azure neighbors. To that purpose we can add a route-map for the inbound traffic:

```bash
# CSR3
ssh -o ServerAliveInterval=60 -o BatchMode=yes -o StrictHostKeyChecking=no "labadmin@$csr3" >/dev/null 2>&1 <<EOF
conf t
    router bgp 65100
      neighbor 10.1.0.254 route-map fromvngs in
      neighbor 10.2.0.4 route-map fromvngs in
      neighbor 10.2.0.5 route-map fromvngs in
    route-map fromvngs permit 10
      match ip address prefix-list max24
    ip prefix-list max24 permit 0.0.0.0/0 le 24
    end
wr mem
EOF
# CSR4
ssh -o ServerAliveInterval=60 -o BatchMode=yes -o StrictHostKeyChecking=no "labadmin@$csr4" >/dev/null 2>&1 <<EOF
conf t
    router bgp 65100
      neighbor 10.1.0.254 route-map fromvngs in
      neighbor 10.2.0.4 route-map fromvngs in
      neighbor 10.2.0.5 route-map fromvngs in
    route-map fromvngs permit 10
      match ip address prefix-list max24
    ip prefix-list max24 permit 0.0.0.0/0 le 24
    end
wr mem
EOF
```

The line `ip prefix-list max24 permit 0.0.0.0/0 le 24` matches any prefix with a subnet mask lower or equal (`le`) to 24. This is what you would typically configure to prevent the other side from sending you too specific routes that would take precedence over the rest of the routes in your network.

Restart the BGP adjacencies (`clear ip bgp *`) to accelerate the convergence process. For example in CSR3:

```bash
ssh -n labadmin@$csr3 "clear ip bgp *"
ssh -n labadmin@$csr4 "clear ip bgp *"
```

And now you can check that there are no /32 prefixes in the BGP table:

```
ssh labadmin@$csr3 "sh ip bgp"

BGP table version is 20, local router ID is 10.3.0.10
Status codes: s suppressed, d damped, h history, * valid, > best, i - internal,
              r RIB-failure, S Stale, m multipath, b backup-path, f RT-Filter,
              x best-external, a additional-path, c RIB-compressed,
              t secondary path, L long-lived-stale,
Origin codes: i - IGP, e - EGP, ? - incomplete
RPKI validation codes: V valid, I invalid, N Not found

     Network          Next Hop            Metric LocPrf Weight Path
 * i  10.1.0.0/16      10.1.0.254               0    100      0 65001 i
 *                     10.2.0.4                               0 65002 65001 i
 *                     10.2.0.5                               0 65002 65001 i
 *>                    10.1.0.254                             0 65001 i
 *mi  10.2.0.0/16      10.4.0.10                0    100      0 65002 i
 *>                    10.2.0.4                               0 65002 i
 *m                    10.2.0.5                               0 65002 i
 *                     10.1.0.254                             0 65001 65002 i
 *>   10.3.0.0/16      10.3.0.1                 0         32768 ?
 *>i  10.4.0.0/16      10.4.0.1                 0    100      0 ?
 *>i  10.5.0.0/16      10.5.0.10                0    100      0 ?
```
