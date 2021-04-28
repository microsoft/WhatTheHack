# What The Hack Virtual WAN - Coach's Guide

## Notes and Guidance

* Participants should start with an easy scenario (any-to-any)
* Note that cross-hub traffic does not work with Secure Virtual Hub at the time of this writing, and it is slated for Q4CY20
* Look at the more complex scenarios as optional, each of them demonstrates a certain aspect of Virtual WAN:
    * Isolated Vnets: route tables association and propagation
    * Secure Virtual Hub: AzFW, static routes in route tables
    * NVA: static routes in connections and route tables

## Coach's Guides

- Challenge 1: **[Any to any connectivity](./01-any_to_any.md)**
   - Deploy a basic Virtual WAN to interconnect virtual networks
- Challenge 2: **[Branches](./02-vpn.md)**
   - Bring branch connections to your Virtual WAN with Site-to-Site VPN
- Challenge 3: **[Isolated VNets](./03-isolated_vnet.md)**
   - Use custom routing to isolate a virtual network
- Challenge 4: **[Secured Virtual Hubs](./04-secured_hub.md)**
   - Deploy Azure Firewall to secure your virtual hub
- Challenge 5: **[Network Virtual Appliance](./05-nva.md)**
   - Use a Network Virtual Appliance with the indirect spoke model

