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

## Prerequisites

No specific prerequisites are needed, but familiarity with Azure Networking is a plus.

## Contributors

- Thomas Vuylsteke
- Jose Moreno

## Getting started

Start this WhatTheHack with the [student guide](Student/README.md)

- Challenge 0: **[Pre-requisites](Student/00-prereqs.md)**
   - Prepare your workstation to work with Azure
- Challenge 1: **[Hub and spoke](Student/01-HubNSpoke-basic.md)**
    - Configure a basic hub and spoke design with hybrid connectivity
- Challenge 2: **[Azure Firewall](Student/02-AzFW.md)**
    - Fine tune your routing to send additional traffic flows through the firewall
- Challenge 3: **[Routing Troubleshooting](Student/03-Asymmetric)**
    - Troubleshoot a routing problem introduced by a different admin
- Challenge 4: **[Application Gateway](Student/04-AppGW.MD)**
    - Add an Application Gateway to the mix
- Challenge 5: **[PaaS Networking](Student/05-Paas.md)**
    - Integrate Azure Web Apps and Azure SQL Databases with your hub and spoke design
