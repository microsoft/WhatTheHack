# Challenge 2: Firewalling traffic

[< Previous Challenge](./01-HubNSpoke-basic.md) - **[Home](README.md)** - [Next Challenge >](./03-Asymmetric.md)

## Introduction

In this challenging you will be fine-tuning your routing design to send VM traffic through the firewall.

## Description

After challenge 1 you should have the topology described here:

![hubnspoke basic](media/hubnspoke-01.png)

In this challenge you need to make sure that the firewall is inspecting all Internet traffic from the Virtual Machines, as well as traffic going onprem.

Additionally, you should install a web server on each VM (hub-vm, spoke1-vm and spoke2-vm), and make sure that the web server is available from the public Internet.

## Success Criteria

1. The Azure Firewall should inspect traffic from any VM in the hub or the spoke going to the public Internet or to onprem
1. The solution should be independent of network administrators adding, changing or removing prefixes in the on-premises network in the future
1. A web server should be installed on each VM, and it should be reachable from the public Internet
1. You should be able to show Azure Firewall logs, to demonstrate that traffic traverses the firewall
1. You should be able to identify the client source IP as seen by each web server

## Related documentation

* [What is Azure Firewall](https://docs.microsoft.com/azure/firewall/overview)
* Example troubleshooting pages that can easily be deployed on the web platform of your choice:
  * [Inspector Gadget](https://github.com/jelledruyts/InspectorGadget) (.netcore)
  * [whoami](https://github.com/erjosito/whoami/tree/master/api-vm) (python/flask)
  * [KUARD](https://github.com/kubernetes-up-and-running/kuard) (container)
