# What The Hack Virtual WAN - Coach's Guide

## Notes and Guidance

Before you start, please consider these points:

- Setting expectations: all of the challenges in this Hack would take around 2 days to complete. In a shorter event you should pick up the challenges most relevant for the participants.
- If your team decides to modify the challenge order, that is possible too. For example, you could skip challenge 4 (Secure Virtual Hub) and go straight to challenge 5 (NVAs).
- You might want to split the individual objectives of a challenge across team members (for example one subteam can do each region)
- Note that cross-hub traffic does not work with Secured Virtual Hubs at the time of this writing, and it is slated for H2CY21
- The Cisco CSR VMs do not generate any extra cost other than the Azure VM charges

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
