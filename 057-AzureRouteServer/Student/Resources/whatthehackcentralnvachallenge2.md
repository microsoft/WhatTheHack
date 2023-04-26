# Cheat sheet for establishing BGP with ARS

[< Back to Challenge 2](../Challenge-02.md) 

## Sample deployment script

```bash
conf t
router bgp **NVA_ASN**
 bgp log-neighbor-changes
 neighbor 10.0.3.4 remote-as 65515
 neighbor 10.0.3.4 ebgp-multihop 255
 neighbor 10.0.3.4 update-source GigabitEthernet1
 neighbor 10.0.3.5 remote-as 65515
 neighbor 10.0.3.5 ebgp-multihop 255
 neighbor 10.0.3.5 update-source GigabitEthernet1
```

# Cisco IOS useful commands

The following set of commands might be useful when influencing traffic to flow through the NVA. Please stop to think for a minute which is the most adequate. Note that for Cisco CSR 1000v or any router in general, the prefixes to be advertised in BGP, need to exist first in the routing table and be valid!

## Route advertisement

### Advertise a default route with default-originate

> [!IMPORTANT]
> If you inject a 0/0, you will lose connectivity to the CSR from your public IP. You still may access the CSR via different ways:
> - Serial console. 
> - Create a UDR with next hop internet for the CSR subnet. 
> - Create a jumpbox to ssh into the private IP of the CSRs

```bash
conf t
!
router bgp **NVA_ASN**
address-family ipv4
neighbor 10.0.3.4 default-originate
neighbor 10.0.3.5 default-originate
end
``` 

### Advertise a route with a static IP address

This pattern can be used as well for a default route. This can be very useful to advertise the range from the whole onprem environment (172.16.0.0/16)

```bash
conf t
!
ip route 172.16.0.0 255.255.0.0 10.0.1.1
!
router bgp **NVA_ASN**
 network 172.16.0.0 mask 255.255.0.0
end
``` 

### Advertise a route with a loopback interface

This pattern can be used to advertise a route, and offer an IP address that is pingable to other systems. For example, if you want to simulate an SDWAN prefix 172.18.0.0, and Azure VMs should be able to ping the IP address 172.18.0.1:

```bash
conf t
!
interface Loopback0
  ip address 172.18.0.1 255.255.0.0
  no shutdown
!
router bgp **NVA_ASN**
 network 172.18.0.0 mask 255.255.0.0
end
``` 

## Route manipulation

Some times you want to manipulate routes before advertising them to the Azure Route Server. The following sections show two of the scenarios that will be required in this hack.

### Setting a specific next hop

You can configure an outbound route map for the ARS neighbors that sets the next-hop field of the BGP route to a certain IP (typically an Azure Load Balancer in front of the NVAs):

```
conf t
router bgp **NVA_ASN**
  neighbor 10.0.3.4 route-map To-ARS out
  neighbor 10.0.3.5 route-map To-ARS out
route-map To-ARS
  set ip next-hop 10.0.1.200
end
```

### Configuring AS path prepending

AS path prepending is a technique that is frequently used to make certain routes less preferrable. This example shows how to configure all routes advertised from an NVA to ARS with an additional ASN in the path:

```
conf t
router bgp **NVA_ASN**
  neighbor 10.0.3.4 route-map To-ARS out
  neighbor 10.0.3.5 route-map To-ARS out
route-map To-ARS
  set as-path prepend **NVA_ASN**
end
```

## Other commands

This list is by no means comprehensive, but it is conceived to give some of the most useful commands for admins new to the Cisco CLI

* `config t`: enter configuration mode
* `write mem`: save the config to non-volatile storage
* `show ip bgp summary`: show the status of configured BGP adjacencies
* `show ip bgp`: show the prefixes that exist on the control plane of the BGP engine
* `show ip route`: show the system routing table
* `show ip bgp neighbors (neighbor ip) advertised-routes`: show routes advertised to a particular neighbor
* `show ip bgp neighbors (neighbor ip) routes`: show routes received from a particular neighbor
* `show ip route bgp`: show the BGP routes in the routing table
* `show running | section bgp`: shows the running configuration relative to BGP
* `show running | include ip route`: shows the static routes configured in the router
