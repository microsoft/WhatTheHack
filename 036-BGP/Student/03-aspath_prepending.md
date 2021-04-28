# Challenge 3: Influencing Routing

[< Previous Challenge](./02-enable_bgp.md) - **[Home](../README.md)** - [Next Challenge >](./04-filtering.md)

## Description

Make sure that VNG1 prefers CSR3 to send traffic to 10.3.0.0/16, and CSR4 for 10.4.0.0/24. You might use this configuration sample on your Cisco CSR appliances:

```
router bgp ?
  neighbor ?.?.?.? route-map tovngs out
route-map tovngs
  match ip address prefix-list branch4
  set as-path prepend ?
route-map tovngs permit 20
ip prefix-list branch4 permit ?.?.?.?/?
```

Would the solution have been different if CSR3 and CSR4 had different ASNs?

## Success Criteria

- VNG1/VNG2 prefer CSR3 to reach 10.3.0.0/16
- VNG1/VNG2 prefer CSR4 to reach 10.4.0.0/16
- Participants can relate the configuration in this challenge to the scenario with redundant ER connections in two Azure regions

## Learning Resources

- [Optimize ExpressRoute routing](https://docs.microsoft.com/azure/expressroute/expressroute-optimize-routing)
