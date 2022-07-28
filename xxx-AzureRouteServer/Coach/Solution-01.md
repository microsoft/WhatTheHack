# Challenge 01 - <Title of Challenge> - Coach's Guide.

[< Previous Solution](./Solution-00.md) - **[Home](./README.md)** - [Next Solution >](./Solution-02.md)

## Notes & Guidance

Setup up a basic hub and spoke topology with a Central Network Virtual Appliance.
Establish connectivity to (simulated) onprem via VPN site-to-site.
Prepare non overlapping address spaces ranges for virtual networks and various special (Gateway, NVA) and VM Workload subnets.
Decide what Azure Region, Resource Group(s) to create. 
Plan for creating VMs in all vnets (Hub, Spokes, Simulated Branch) to test the connectivity. 
Linux VMs are easy to deploy and do basic connectivity (serial console).
When using AIRS subscription,may face difficulties RDP/SSH into VMs due to security policy enforcement. (There are workarounds available).


Break things apart with more than one bullet list

- Like this
- One
- Right
- Here
