# Challenge 6 - BGP Communities

[< Previous Challenge](./05-transit.md) - **[Home](./README.md)** - [Next Challenge >](./07-default.md)

## Notes and Guidance

BGP communities are like route tags. There are some well-known communities like `no-export` or `no-advertise` that instruct BGP to do specific things. Outside of those you can use your own custom communities to use them as filters later on in your network.

In this challenge we will mark the routes corresponding to VNet1 with a specific label, and the routes for VNet2 with another one. We will do the marking in the onprem edge (CSR3 and CSR4), and we will verify that CSR5 can see the communities.

## Solution Guide

Solution guide [here](./Solutions/06_Solution.md).
