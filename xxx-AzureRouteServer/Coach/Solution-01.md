# Challenge 01 - Build Hub and Spoke topology with a NVA and VPN Connected Simulated on-premises branch - Coach's Guide.

[< Previous Solution](./Solution-00.md) - **[Home](./README.md)** - [Next Solution >](./Solution-02.md)

## Notes & Guidance

Setup up a basic hub and spoke topology with a Central Network Virtual Appliance.<br/>
Establish connectivity to (simulated) onprem via VPN site-to-site.<br/>
Prepare non overlapping address spaces ranges for virtual networks and various special (Gateway, NVA) and VM Workload subnets.<br/>
Decide what Azure Region, Resource Group(s) to create. Plan for creating VMs in all vnets (Hub, Spokes, Simulated Branch) to test the connectivity. <br/>
Linux VMs are easy to deploy and do basic connectivity (serial console).<br/>
When using AIRS subscription,may face difficulties RDP/SSH into VMs due to security policy enforcement. (There are workarounds available).

## Solution Guide

- Create a Hub Virtual Network (vnet).
- Create two spoke vnets.
- Setup vnet peering between spokes and hub vnet.
- Create a Azure Network Gateway in Hub vnet with SKU supporting Active/Active and BGP.
- Setup Local Network Gateway reprenting simulated on-prem branch. 
- Deploy the provided Cisco CSR template to simulate branch (on-premises). Template also creates a "Branch1" vnet. 
- Setup 2-tunnels to one active/active virtual network gateway created earlier.
- Deploy  provided Cisco CSR template to setup a central NVA (used as a BGP/Security NVA). 
- Create Route Tables (UDRs) to steer traffic via NVAs for,
   - Branch VM subnet, Route to Hub/spoke vnets addres spaces (summarized should work as well) with next hop Branch NVA (CSR applaince).
   (This is required because branch vnet is really Azure vNet (think of SDN)).
   - GW subnet, route to Hub, next hop Central NVA (Outside Interface). 
   - Hub VM subnet, route to Spokes and Branch, next hop Central NVA (Inside Interface).
   - Spoke VM subnet, route to the other spoke and branch, next hop Central NVa (Inside Interface).
