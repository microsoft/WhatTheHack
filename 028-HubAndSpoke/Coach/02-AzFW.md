# Challenge 2: Firewalling traffic

[< Previous Challenge](./01-HubNSpoke-basic.md) - **[Home](README.md)** - [Next Challenge >](./03-Asymmetric.md)

## Introduction

In this challenging participants will be fine-tuning their routing design to send VM traffic through the firewall.

## Description

* When participants configure a default route in the VM subnets pointing to the firewall, they will be breaking direct access to the ILPIPs, so they need to configure DNAT in the firewall
* Participants might get confused with the order in which network rules and application rules are applied

## Additional optional challenges

* Include microsegmentation (intra-subnet traffic sent to firewall)
