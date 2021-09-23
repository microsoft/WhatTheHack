# Challenge 2: Discovery and Assessment - Coach's Guide

[< Previous Challenge](./01-design.md) - **[Home](./README.md)** - [Next Challenge >](./03-prepare.md)

## Notes and Guidance


## Solution Guide

- For the cost calculation, make sure participants don't forget about other costs like bandwidth, load balancers, etc (even if they just do a rough estimation)
- Create "LZ" in Azure
    - There's merit in making them think about IP addressing in the context of a migration; for example do we retain IPs vs use new
    - Potentially you can provide instructions for deploying the VNet & subnets - but make them complete some of the blanks (e.g. a subset of IP addresses)
- Create Azure Migrate project
    - Q: any issues with permissions required to do this - does it still need a service account etc?
- Deploy & configure the Azure Migrate appliance in on-premises environment
    - Q: is the VHD already on the Hyper-V server or do we make them download it
		- Think it's on there, but is probably not up-to-date
    - Q: I remember deploying that to the right VNet etc being fiddly and not adding much value - maybe we deploy that in advance and do the Hyper-V config - just leave it turned off?
- Begin discovery
    - Q: will take some time here - could use this to discuss & demo VMware / physical differences and talk about underlying architecture?
    - Q: use this time to discuss real world wave planning and estate rationalisation
		- Show example of an assessment with more nuance
- Dependency analysis
    - Q: question the merit of this - uses agent based approach for hyper-v
		- Sounds like agentless hyper-v scenario is coming ~October 2021?
- Create assessment
    - Group VMs
    - Review options when creating an assessment: as-on-prem vs perf-based etc
    - View output including suitability to migrate, sizing recommendations (inc disks!), and projected costs