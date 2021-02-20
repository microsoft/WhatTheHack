# Challenge 4 - Route Filtering

[< Previous Challenge](./03-aspath_prepending.md) - **[Home](../README.md)** - [Next Challenge >](./05-transit.md)

## Description

Configure your onprem routers not to accept any prefix longer than a /24. You might use this configuration:

```
router bgp ?
  neighbor ?.?.?.? route-map fromvngs in
route-map fromvngs permit 10
  match ip address prefix-list max24
ip prefix-list max24 permit 0.0.0.0/0 le 24
```

## Success Criteria

- Onprem CSRs do not have any /32 route in their routing table learnt over BGP
- Participants understand the importance of filtering routes onprem