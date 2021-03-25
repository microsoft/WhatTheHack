
# Networking Hackathon - Info for coaches

## Deploying the environment

Since this Hack is not about deploying VNets or NVAs, you can use a script to deploy the infrastructure that you will be working on. You will find a script called `bgp.sh` in the file resources supplied for this Hack, which you can run to deploy the environment. The script has been tested to run in Azure Cloud Shell. Note that the script takes around 1 hour to complete, and it requires certain dependencies to exist. Therefore, it is recommended to deploy the environment the day before the Hack.

Participants some times struggle with the required dependencies, deploying this in your own subscription in advance might help during the Hack, so you might want to deploy this in your subscription the day before.

Note that there are no licensing costs associated to the Cisco NVAs.

## Before you start

- Try to get participants to use code (PS or CLI)
- Make sure they have a way to share code, ideally via git
- If there is any concept not clear for everybody, try to make participants explain to each other. Intervene only when no participant has the knowledge
- Leave participants try designs even if you know it is not going to work, let them explore on themselves. Stop them only if they consume too much time
- **Make sure no one is left behind**
- For each challenge, you can ask the least participative members to describe what has been done and why
- Feel free to customize scenarios to match your participants' level: if they are too new to Azure, feel free to remove objectives. If they are too advanced, give them additional ones
- A short theoretical introduction to BGP has proven to be useful in previous deliveries of this hack. The method we have used is whiteboarding an analogy of a car trying to find its way to a street in a city, where the roundabouts (the routers) exchange routing information, and the postal codes are the ASNs. Here you can find an example of one of the sessions, but feel free to use your own way of explaining BGP:

![BGP sample whiteboard](./whiteboard.png)

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

## Challenges

- Challenge 1: **[Environment Setup](01-lab_setup.md)**
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
- Challenge 8: **[iBGP between Virtual Network Gateways](07-vng_ibgp.md)**
    - Troubleshoot a connectivity problem between Virtual Network Gateways
