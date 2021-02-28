# Challenge 4 - Route Filtering

[< Previous Challenge](./03-aspath_prepending.md) - **[Home](./README.md)** - [Next Challenge >](./05-transit.md)

## Notes and Guidance

Frame this in the context of customer examples:

1. Customers that do not want to get the 0.0.0.0/0 sent from Azure to onprem
1. Customers that do not want too specific prefixes to be sent from Azure to onprem, since this can be seen as a security vulnerability to route poisoning attacks

Since you cannot configure route filters on Azure VPN gateways (or ExpressRoute gateways for that matter), configuring route filters onprem is the only way to protect the customer's network from unwanted prefixes.

## Solution Guide

Solution guide [here](./Solutions/04_Solution.md).
