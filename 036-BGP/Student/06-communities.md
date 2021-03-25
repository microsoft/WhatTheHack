# Challenge 6: BGP Communities

[< Previous Challenge](./05-transit.md) - **[Home](../README.md)** - [Next Challenge >](./07-default.md)

## Description

Configure CSR3 and CSR4 to tag the routes learnt from VNG1 and VNG2 as belonging to Vnet1 or Vnet2. Verify in CSR5 that the tags are propagated. You might use these commands:

```
    route-map fromvngs permit 5
      match ip address prefix-list Vnet1
      set community 65100:1
    ip prefix-list Vnet1 permit 10.1.0.0/16
    router bgp 65100
      neighbor ? send-community
```

## Success Criteria

- Verify the presence of the tags introduced by CSR3 and CSR4 in CSR5's BGP table
- Participants understand the significance and use cases for communities, and can relate it to the usage of communities in ExpressRoute Microsoft peering
