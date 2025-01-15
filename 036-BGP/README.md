# What The Hack - Using BGP for Hybrid Connectivity

## Introduction

In this Hack exercise students will explore how to use BGP in a complex environment between an on-premises network and two Azure regions. Both active/passive and active/active Azure VPN Gateways will be used in Azure, and Cisco CSR 8000V will be used to simulate onprem devices.

The challenges will show real-world scenarios that have been observed in customers deploying their applications to Azure

The estimated duration time for this hack is 1.5-2 days.

The only cost for this Hack is Azure infrastructure, there are no licensing costs associated to the Cisco NVAs.

## Learning Objectives

After completing this Hack, participants will be familiar with these concepts, amongst others:

- BGP
- Differences between eBGP and iBGP
- Understanding Autonomous Systems
- Using AS-path prepending to influence routing
- Explore BGP route manipulation capabilities
- BGP communities

## Before you start

Please read these instructions carefully:

- Since this Hack is not about deploying VNets or NVAs, you can use a script to deploy the infrastructure that you will be working on. You will find a script called `bgp.sh` in the file resources supplied for this Hack, which you can run to deploy the environment. The script has been tested to run in Azure Cloud Shell. Note that the script takes around 1 hour to complete, and it requires certain dependencies to exist. Therefore, it is recommended to deploy the environment the day before the Hack:
- While this hack was designed with enough content to support a 2-day event, students will still get value if they complete only some of the challenges in a shorter event.
- It is recommended going one challenge after the other, without skipping any. However, if your team decides to modify the challenge order, that is possible too. Please consult with your coach to verify that the challenge order you wish to follow is doable, and there are no dependencies on the challenges you skip
- **Think** before rushing to configuration. One minute of planning might save you hours of work
- Look for the **relevant information** section in each challenge, they might contain useful information and tools
- You might want to split the individual objectives of a challenge across team members, but please consider that all of the team members need to understand every part of a challenge, so run a retrospective after each subteam has finished and share lessons learnt

These are your challenges, it is recommended to start with the first one and proceed to the next one when your coach confirms that you have completed each challenge successfully:

## Challenges

- Challenge 0: **[Environment Setup](Student/00-lab_setup.md)**
   - Deploy the required infrastructure for the exercises
- Challenge 1: **[Exploration](Student/01-lab_exploration.md)**
   - Get familiar with the deployed topology
- Challenge 2: **[Enable BGP](Student/02-enable_bgp.md)**
    - Configure BGP in the missing connections
- Challenge 3: **[Influence Routing](Student/03-aspath_prepending.md)**
    - Use AS-path prepending to influence routing
- Challenge 4: **[Route Filtering](Student/04-filtering.md)**
    - Filter incoming routes in the onprem routers
- Challenge 5: **[Prevent Transit Routing](Student/05-transit.md)**
    - Prevent your on-premises network from acting as transit between external AS
- Challenge 6: **[BGP Communities](Student/06-communities.md)**
    - Explore the usage of BGP communities
- Challenge 7: **[Default Routing](Student/07-default.md)**
    - Advertise a default route over BGP
- Challenge 8: **[iBGP between Virtual Network Gateways](Student/08-vng_ibgp.md)**
    - Troubleshoot a connectivity problem between Virtual Network Gateways

## Prerequisites

- This challenge does not have any technical prerequisite. Azure networking knowledge and basic understanding of IP routing is required though
- Configuring BGP in a non-Azure Network Appliance is part of the exercise. However, the goal is not becoming a Cisco expert, so your coach will assist you during the process

## Contributors

- Thomas Vuylsteke
- Jose Moreno
