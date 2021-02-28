# Challenge 5 - Prevent Transit Routing

[< Previous Challenge](./04-filtering.md) - **[Home](./README.md)** - [Next Challenge >](./06-communities.md)

## Notes and Guidance

This is important for example when customers are connecting a private peering and a Microsoft peering to the same router. They don't want to inject routes from the Microsoft peering back into the private peering. Doing so will at best introduce suboptimal routing, at worst break certain things such as Azure SQL Managed Instance, for example.

## Solution Guide

Solution guide [here](./Solutions/05_Solution.md).
