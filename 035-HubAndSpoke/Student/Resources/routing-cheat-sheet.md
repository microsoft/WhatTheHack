# Description

Azure cheat sheet for routing precedence and route path control.

# Routing Precedence

1.  **LPM (Longest Prefix Match) rules\!**
    1.  Routes with the longest prefix match of the destination will be taken
    2.  LPM == "more specific route"
    3.  10.0.0.0/24 is more specific than 10.0.0.0/16
2.  **Tie breaker - Static \>\> BGP \>\> System**
    1.  Static routes
        1.  User-defined routes
        2.  Private Endpoints
        3.  Service endpoints\*
        4.  Vnet Peering\*
        5.  (\*) Added by the system in Effective Routes table, but you can override with UDRs - **Cannot override 168.63.129.16 or 169.254.169.254**
    2.  BGP / Gateway routes
        1.  BGP routes advertised via ExpressRoute, VPN, or by Route Server --\> Inject into the whole Vnet
        2.  VPN gateway static routes
    3.  System routes
        1.  Intra-Vnet direct & default to Internet
3.  **Hub-and-Spoke routing**
    1.  Prefer Vnet peering over ExpressRoute or VPN Vnet-to-Vnet
    2.  Prefer Vnet Service Endpoints (Storage & SQL) over BGP routes (forced tunneling)
    3.  Prefer ExpressRoute over VPN in coexistence scenarios
    4.  Prefer ExpressRoute connections with higher connection weight
    5.  Prefer "shortest" path - honor AS PATH prepending
    6.  Spoke-to-spoke via a single hub is NOT connected by default - **Vnet peering is non-transitive**
    7.  Spoke-to-spoke via a single hub can be enabled by UDR (0.0.0.0/0 or specific spoke Vnet address space) to an NVA. 

# Route Path Control

1.  **ECMP - Equal-Cost, Multi-Path**
    1.  "When in doubt, spread..."
    2.  Multiple paths (next hops) to the same destination
        1.  Two UDR routes to different virtual appliances
        2.  Active-active VPN gateway
        3.  Multipath topology via BGP routing
    3.  Spreading is on "flows"
        1.  Packets of one flow always follow the same path (gateways, tunnels)
        2.  Flow - 5-tuple (TCP/UDP)
2.  **Prefer one path over the others**
    1.  MUST be done on BOTH ends
        1.  Prevent asymmetric routing
    2.  Azure --\> on-premises network
        1.  AS-prepending - create longer AS paths for certain routes
        2.  Azure gateways will favor or prefer routes with shorter AS paths
        3.  ExpressRoute connection weight - prefer connections with higher weights to the closer ExpressRoute circuits
    3.  On-premises network --\> Azure
        1.  Local preference

# BGP table vs Routing table vs Forwarding table

**What's the difference between them?**

Let's go through the definition of each before we try to find the differences between them and how do they all fit together.  

- **BGP table**: The BGP table contains a list of prefixes that our peer has advertised to us on a BGP session.  

- **Routing table**: The routing table contains a list of routes we have learned from many sources, including static configuration and those learned from BGP.  

- **Forwarding table**: This is the actual table a router uses to make a decision on forwarding packets. Wrongly referred by many people as the "routing table". The forwarding table contains a list of effective routes.  

**Interaction between tables**


  - Routes from the BGP table would be put into the routing table unless they're malformed or some ACL (or other configuration bits) explicitly prevented it.
  - Routes from the routing table would be put into the forwarding table only when they're considered valid.
  - An example of an invalid route would be one that defines the next-hop IP address as an IP address that's not directly reachable on any of the router's interfaces. That route might exist in the routing table and even in the BGP table if that's how we learned it, but would never exist in the forwarding table.
  - Other routes that might be in the routing table and not on the forwarding table would be overlapping routes. Based on other route's attributes like weight or AS PATH, the router would choose which route -from two routes with same destination and prefix length- should be put in the forwarding table.
  - Routes in the forwarding table are considered active and effective and should be the ones initially reviewed when troubleshooting routing issues.
  - The forwarding table is the source of truth for packet forwarding.
