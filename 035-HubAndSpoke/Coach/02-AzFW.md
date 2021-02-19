# Challenge 2: Firewalling Traffic

[< Previous Challenge](./01-HubNSpoke-basic.md) - **[Home](README.md)** - [Next Challenge >](./03-Asymmetric.md)

## Notes and Guidance

In this challenge participants will be fine-tuning their routing design to send VM traffic through the firewall.

* When participants configure a default route in the VM subnets pointing to the firewall, they will be breaking direct access to the ILPIPs, so they need to configure DNAT in the firewall
* Participants might get confused with the order in which network rules and application rules are applied
