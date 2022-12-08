# Cheat sheet for establishing BGP with ARS

[< Back to Challenge 2](../Challenge-02.md) 

## Sample deployment script

```bash
conf t
## Remove static routes pertaining to previous excercise
no ip route 172.16.0.0 255.255.0.0 10.0.2.1
no ip route <spoke1 vnet prefix> <spoke1 network mask> 10.0.1.1
no ip route <spokeN vnet prefix> <spokeN network mask> 10.0.1.1

##configure BGP 

router bgp **BGP_ID**
 bgp log-neighbor-changes
 neighbor 10.0.3.4 remote-as 65515
 neighbor 10.0.3.4 ebgp-multihop 255
 neighbor 10.0.3.4 update-source GigabitEthernet2
 neighbor 10.0.3.5 remote-as 65515
 neighbor 10.0.3.5 ebgp-multihop 255
 neighbor 10.0.3.5 update-source GigabitEthernet2
 !
 address-family ipv4
  neighbor 10.0.3.4 activate
  neighbor 10.0.3.5 activate
 exit-address-family
!
ip route 10.0.3.4 255.255.255.255 10.0.1.1
ip route 10.0.3.5 255.255.255.255 10.0.1.1
!
```

# The following set of commands might be useful when influencing traffic to flow through the NVA. Please stop to think for a minute which is the most adequate.
Note that for Cisco CSR 1000v or any Router in general, the prefixes to be advertised in BGP, need to exist first in the routing table and be valid!

## Advertise a default route

> [!IMPORTANT]
> If you inject a 0/0, you will lose connectivity to the CSR from your public IP.
> You may access the CSR through serial console. 
> Create a UDR with next hop internet for the CSR subnet interfaces. 
> Create a jumpbox to ssh into the private IP of the CSRs

```bash
conf t
!
router bgp **BGP_ID**
address-family ipv4
neighbor 10.0.3.4 default-originate
neighbor 10.0.3.5 default-originate
end
``` 

## Advertise additional routes

```bash

conf t
!
ip route < n ip prefix> <network mask> 10.0.1.1
!
router bgp **BGP_ID**
 address-family ipv4
 network < n ip prefix> mask <network mask>
end
``` 

This list is by no means comprehensive, but it is conceived to give some of the most useful commands for admins new to the Cisco CLI

* **config t**: enter configuration mode
* **write mem**: save the config to non-volatile storage
* **show ip bgp summary**: show the status of configured BGP adjacencies
* **show ip bgp**: show the prefixes that exist on the control plane of the BGP engine
* **show ip route**: show the system routing table
* **show ip bgp neighbors (neighbor ip) advertised-routes**: show routes advertised to a particular neighbor
* **show ip bgp neighbors (neighbor ip) routes**: show routes received from a particular neighbor
* **show ip route bgp**: show the BGP routes in the routing table
