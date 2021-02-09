# Challenge 1: Building a basic Hub And Spoke topology 

**[Home](README.md)** - [Next Challenge >](./02-AzFW.md)

## Introduction

In this challenge you will be setting up a basic hub and spoke topology with connectivity to onprem via VPN site-to-site.

## Description

Gotchas:

* There are multiple technologies that participants can use to simulate an onprem VPN site:
  * Azure VPN Gateways: make sure that they do not get confused with the VNet gateways and Local Network Gateways. Make sure they use local network gateways (instead of vnet-to-vnet connections), so that they understand the process involved in configuring S2S tunnels
  * Windows Server: good enough for all scenarios, if the participants are familiar with Windows
  * Linux and StrongSwan: good enough for all scenarios, if the participants are familiar with StrongSwan
  * Cisco CSR: the student resources bring an example of how to deploy and configure a Cisco CSR 1000v to simulate an onprem site. You can opt to deploy it in parallel so that they only see Azure.
* Using another VNG to simulate onprem might be confusing, using Windows RRAS to simulate onprem might be more intuitive. However that might be hard to swallow for participants  without Windows Server experience
* You might inject additional prefixes from the S2S tunnel, so that they are hinted to use the `Disable BGP Propagation` route table checkbox, and their solution is actually surviving a change in the onprem prefix
