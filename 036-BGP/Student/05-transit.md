# Challenge 5 - Prevent Transit Routing

[< Previous Challenge](./04-filtering.md) - **[Home](../README.md)** - [Next Challenge >](./06-communities.md)

## Description

Prevent that your branches act as transit between the Azure Vnets, even in the case of a failure in the tunnels between VNG1 and VNG2. You might use this configuration

```
ip as-path access-list 1 permit ^$
route-map ? permit 20
  match as-path 1
route-map ? deny 30
```

How can this configuration be useful for an onprem router connected to both ExpressRoute private and Microsoft peerings?

## Success Criterial

- VNGs do not learn each other's prefixes via the onprem routers
- Participants understand the importance of this configuration in a ExpressRoute scenario with private and Microsoft peerings.