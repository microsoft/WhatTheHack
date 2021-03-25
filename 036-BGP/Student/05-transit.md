# Challenge 5: Prevent Transit Routing

[< Previous Challenge](./04-filtering.md) - **[Home](../README.md)** - [Next Challenge >](./06-communities.md)

## Description

Prevent that your branches act as transit between the Azure Vnets, even in the case of a failure in the tunnels between VNG1 and VNG2. You might use this Cisco configuration sample:

```
ip as-path access-list 1 permit ^$
route-map ? permit 20
  match as-path 1
route-map ? deny 30
```

How can this configuration be useful for an onprem router connected to both ExpressRoute private and Microsoft peerings?

## Success Criteria

- VNGs do not learn each other's prefixes via the onprem routers
- Participants understand the importance of this configuration in a ExpressRoute scenario with private and Microsoft peerings (see the Azure SQL MI link in the relevant information).

## Learning Resources

- [Azure SQL Managed Instance Networking Constraints](https://docs.microsoft.com/azure/azure-sql/managed-instance/connectivity-architecture-overview#networking-constraints)