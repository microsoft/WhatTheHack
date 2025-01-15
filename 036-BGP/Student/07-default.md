# Challenge 7: Default Routing

[< Previous Challenge](./06-communities.md) - **[Home](../README.md)** - [Next Challenge >](./08-vng_ibgp.md)

## Description

Inject a default route (`0.0.0.0/0`) over BGP from one of the CSRs. You might use these commands:

```
    router bgp 65100
      neighbor ? default-originate
```

## Success Criteria

- A default route is showing in the effective routes for the VMs in Vnet1 and Vnet2
