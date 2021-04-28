# What The Hack - Using BGP for Hybrid Connectivity - Coach's Guides

## Notes and Guidance

- At the very minimum participants should be able to configure and explore BGP
- Make sure they understand how BGP route selection works
- Make sure participants understand the difference between eBGP and iBGP
- The challenges will illustrate these concepts:
    - Route learning and advertising
    - AS path prepending
    - Filtering based on AS path
    - Filtering based on prefix length
    - BGP communities
    - Connection weights and BGP weight
    - eBGP multipath in the branch devices
    - iBGP between gateway instances

## Coach's Guides

- Challenge 0: **[Environment Setup](00-lab_setup.md)**
   - Deploy the required infrastructure for the exercises
- Challenge 1: **[Exploration](01-lab_exploration.md)**
   - Deploy the required infrastructure for the exercises
- Challenge 2: **[Enable BGP](02-enable_bgp.md)**
    - Configure BGP in the missing connections
- Challenge 3: **[Influence Routing](03-aspath_prepending.md)**
    - Use AS-path prepending to influence routing
- Challenge 4: **[Route Filtering](04-filtering.md)**
    - Filter incoming routes in the onprem routers
- Challenge 5: **[Prevent Transit Routing](05-transit.md)**
    - Prevent your on-premises network from acting as transit between external AS
- Challenge 6: **[BGP Communities](06-communities.md)**
    - Explore the usage of BGP communities
- Challenge 7: **[Default Routing](07-default.md)**
    - Advertise a default route over BGP
- Challenge 8: **[iBGP between Virtual Network Gateways](08-vng_ibgp.md)**
    - Troubleshoot a connectivity problem between Virtual Network Gateways
