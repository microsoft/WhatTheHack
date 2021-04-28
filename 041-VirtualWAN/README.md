# What The Hack - Virtual WAN

## Introduction

In this Hack you will learn the most important concepts of Azure Virtual WAN. You will start with a basic any-to-any configuration, which will evolve towards a more complex design including Secure Virtual Hubs with Azure Firewall and Network Virtual Appliances.

## Learning Objectives

The Hack challenges cover the following aspects of Virtual WAN

- Basic any-to-any connectivity with Virtual WAN
- Branch connectivity
- Custom routing in Virtual WAN, route tables, static routes
- Secured Virtual Hub with Azure Firewall, Azure Firewall Manager
- Routing traffic through Network Virtual Appliances in connected VNets

## Challenges

- Challenge 1: **[Any to any connectivity](./Student/01-any_to_any.md)**
   - Deploy a basic Virtual WAN to interconnect virtual networks
- Challenge 2: **[Branches](./Student/02-vpn.md)**
   - Bring branch connections to your Virtual WAN with Site-to-Site VPN
- Challenge 3: **[Isolated VNets](./Student/03-isolated_vnet.md)**
   - Use custom routing to isolate a virtual network
- Challenge 4: **[Secured Virtual Hubs](./Student/04-secured_hub.md)**
   - Deploy Azure Firewall to secure your virtual hub
- Challenge 5: **[Network Virtual Appliance](./Student/05-nva.md)**
   - Use a Network Virtual Appliance with the indirect spoke model

## Prerequisites

- Basic knowledge about Azure: tenants, subscriptions, portal
- An understanding of Azure networking concepts such as Virtual Networks, peerings and User-Defined Routes

## Contributors

- Thomas Vuylsteke
- Jose Moreno
