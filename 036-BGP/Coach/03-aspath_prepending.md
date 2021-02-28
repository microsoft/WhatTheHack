# Challenge 3 - Influencing Routing

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

Solution guide [here](./Solutions/03_Solution.md).
