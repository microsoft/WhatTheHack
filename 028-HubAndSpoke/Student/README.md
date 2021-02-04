# What the Hack - Azure Networking Hub and Spoke

## Overview

Before you start, please read these instructions carefully:

* Setting expectations: all of the challenges in this FastHack would take around 2 days to complete. Please do not expect to finish all of the exercises in a shorter event
* It is recommended going one challenge after the other, without skipping any. However, if your team decides to modify the challenge order, that is possible too. Please consult with your coach to verify that the challenge order you wish to follow is doable, and there are no dependencies on the challenges you skip
* **Think** before rushing to configuration. One minute of planning might save you hours of work
* Look at the **relevant information** in each challenge, they might contain useful information and tools
* You might want to split the individual objectives of a challenge across team members, but please consider that all of the team members need to understand every part of a challenge

These are your challenges, it is recommended to start with the first one and proceed to the next one when your coach confirms that you have completed each challenge successfully:

## Challenges

Please make sure that your deployment meets these objectives:

- Challenge 0: **[Pre-requisites](00-Prereqs.md)**
   - Prepare your workstation to work with Azure
- Challenge 1: **[Hub and spoke](01-HubNSpoke-basic.md)**
    - Configure a basic hub and spoke design with hybrid connectivity
- Challenge 2: **[Azure Firewall](02-AzFW.md)**
    - Fine tune your routing to send additional traffic flows through the firewall
- Challenge 3: **[Routing Troubleshooting](03-Asymmetric)**
    - Troubleshoot a routing problem introduced by a different admin
- Challenge 4: **[Application Gateway](04-AppGW.MD)**
    - Add an Application Gateway to the mix
- Challenge 5: **[PaaS Networking](05-Paas.md)**
    - Integrate Azure Web Apps and Azure SQL Databases with your hub and spoke design

## Relevant links

* [Virtual Network peering](https://docs.microsoft.com/azure/virtual-network/virtual-network-peering-overview)
* [Hub and Spoke topology in Azure](https://docs.microsoft.com/azure/architecture/reference-architectures/hybrid-networking/hub-spoke)
* [What is Azure Firewall](https://docs.microsoft.com/azure/firewall/overview)
* [What is VPN Gateway](https://docs.microsoft.com/azure/vpn-gateway/vpn-gateway-about-vpngateways)
* [Create a Site-to-Site connection in the Azure portal](https://docs.microsoft.com/azure/vpn-gateway/vpn-gateway-howto-site-to-site-resource-manager-portal)
* Example troubleshooting pages that can easily be deployed on the web platform of your choice:
  * [Inspector Gadget](https://github.com/jelledruyts/InspectorGadget) (.netcore)
  * [whoami](https://github.com/erjosito/whoami/tree/master/api-vm) (python/flask)
  * [KUARD](https://github.com/kubernetes-up-and-running/kuard) (container)
