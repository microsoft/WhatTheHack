# Challenge 4: Route Filtering

[< Previous Challenge](./03-aspath_prepending.md) - **[Home](../README.md)** - [Next Challenge >](./05-transit.md)

## Description

Configure your onprem routers not to accept any prefix longer than a /24 (for example, /32 routes). You might use this Cisco configuration sample:

```
router bgp ?
  neighbor ?.?.?.? route-map fromvngs in
route-map fromvngs permit 10
  match ip address prefix-list max24
ip prefix-list max24 permit 0.0.0.0/0 le 24
```

Is a similar filtering possible in the Virtual Network Gateway?

## Success Criteria

- Onprem CSRs do not have any /32 route in their routing table learnt over BGP
- Participants understand the importance of filtering routes in the on-prem device
