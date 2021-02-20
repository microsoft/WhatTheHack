
# Networking Hackathon - Info for coaches

## Before you start

- Try to get participants to use code (PS or CLI)
- Make sure they have a way to share code, ideally via git
- If there is any concept not clear for everybody, try to make participants explain to each other. Intervene only when no participant has the knowledge
- Leave participants try designs even if you know it is not going to work, let them explore on themselves. Stop them only if they consume too much time
- **Make sure no one is left behind**
- For each challenge, you can ask the least participative members to describe what has been done and why
- Feel free to customize scenarios to match your participants' level: if they are too new to Azure, feel free to remove objectives. If they are too advanced, give them additional ones


## 6. BGP

- Let participants use whatever BGP-able NVA they feel most comfortable with
- If they dont have any preference, recommend them whatever you as coach feel most comfortable with, like the Cisco CSR or a Linux box with Quagga
- At the very minimum participants should be able to configure and explore BGP
- Make sure they understand how BGP route selection works
- Make sure participants understand the difference between eBGP and iBGP
- Optionally, if participants feel comfortable with advanced BGP configuration, you can ask them to modify BGP configuration to introduce AS-path prepending. You can find a config example for Cisco CSR [here](https://community.cisco.com/t5/networking-blogs/bgp-as-path-prepending-configuration/ba-p/3819334)
- The objectives below help to illustrate some of these concepts:
    - Route learning and advertising
    - AS path prepending
    - Filtering based on AS path
    - Filtering based on prefix length
    - BGP communities
    - Connection weights and BGP weight
    - eBGP multipath in the branch devices
    - iBGP between gateway instances

## Challenges

- Challenge 1: **[Lab Setup](01-lab_setup.md)**
   - Deploy the required infrastructure for the exercises
- Challenge 2: **[Enable BGP](02-enable_bpg.md)**
    - Configure BGP in the missing connections
- Challenge 3: **[Influence Routing](03-aspath_prepending.md)**
    - Use AS-path prepending to influence routing
- Challenge 4: **[Route Filtering](04-filtering.md)**
    - Filter incoming routes in the onprem routers
- Challenge 5: **[Prevent Transit Routing](05-transit.md)**
    - Prevent your on-premises network from acting as transit between external AS
- Challenge 6: **[BGP Communities](06-communities.md)**
    - Explore the usage of BGP communities
- Challenge 7: **[iBGP between Virtual Network Gateways](07-vng_ibgp.md)**
    - Troubleshoot a connectivity problem between Virtual Network Gateways

