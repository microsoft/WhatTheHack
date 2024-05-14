# What The Hack - Azure Networking with Hub and Spoke

## Introduction

In this WTH exercise students will engage into an increasingly complex Azure Virtual Network setup, finding many of the challenges that often appear in production environments. The Hack starts with a deep dive in hub and spoke networking and user-defined routes during the first day, and goes on by adding components such as the Azure Application Gateway or PaaS networking in the second day.

The estimated duration time for this hack is 2 days.

## Learning Objectives

After completing this WTH, participants will be familiar with these concepts, amongst others:

- VNet peering
- User Defined Routes and hybrid connectivity
- Scenarios with potential asymmetric routing
- Azure Firewall DNAT (Destination Network Address Translation) rules
- Azure Firewall network and application rules
- Designs combining the Azure Firewall and the Application Gateway
- PaaS Networking options such as Vnet service endpoints and Private Link

## Before you start

Please read these instructions carefully:

- Setting expectations: all of the challenges in this FastHack would take around 2 days to complete. Please do not expect to finish all of the exercises in a shorter event
- It is recommended going one challenge after the other, without skipping any. However, if your team decides to modify the challenge order, that is possible too. Please consult with your coach to verify that the challenge order you wish to follow is doable, and there are no dependencies on the challenges you skip
- **Think** before rushing to configuration. One minute of planning might save you hours of work
- Look at the **relevant information** in each challenge, they might contain useful information and tools
- You might want to split the individual objectives of a challenge across team members, but please consider that all of the team members need to understand every part of a challenge, so run a retrospective after each subteam has finished and share lessons learnt

These are your challenges, it is recommended to start with the first one and proceed to the next one when your coach confirms that you have completed each challenge successfully:

## Challenges

- Challenge 0: **[Pre-requisites](Student/00-Prereqs.md)**
   - Prepare your workstation to work with Azure
- Challenge 1: **[Hub and spoke](Student/01-HubNSpoke-basic.md)**
    - Configure a basic hub and spoke design with hybrid connectivity
- Challenge 2: **[Azure Firewall](Student/02-AzFW.md)**
    - Fine tune your routing to send additional traffic flows through the firewall
- Challenge 3: **[Routing Troubleshooting](Student/03-Asymmetric.md)**
    - Troubleshoot a routing problem introduced by a different admin
- Challenge 4: **[Application Gateway](Student/04-AppGW.md)**
    - Add an Application Gateway to the mix
- Challenge 5: **[PaaS Networking](Student/05-PaaS.md)**
    - Integrate Azure Web Apps and Azure SQL Databases with your hub and spoke design

## Prerequisites

No specific prerequisites are needed, but familiarity with Azure Networking is a plus.

## Contributors

- Thomas Vuylsteke
- Jose Moreno
