# Challenge 2: Discovery and Assessment - Coach's Guide

[< Previous Challenge](./01-design.md) - **[Home](./README.md)** - [Next Challenge >](./03-prepare.md)

## Notes and Guidance

- The users should have enough privileges at the subscription level to generate an Azure Migrate key, if the users are provisioned with the script in [Challenge 0](./00-lab_setup.md)
- Internet Explorer does not need to be uninstalled, it is enough if participants open up the migration appliance web page with Chrome, which is preinstalled in the Azure VM host. The link is [https://SmartHotelHost:44368](https://SmartHotelHost:44368)
- When adding a Hyper-V host, you can use `192.168.0.1` with credentials `demouser`/`demo!pass123`
- You can generate application traffic by accessing the application at `http://smarthotelhost-RANDOM.REGION.cloudapp.azure.com` (where RANDOM will be a random string specific to your environment, and REGION your Azure region of deployment)
- Note port 1433 is also exposed in the Host VM, but in order to access it from the Internet, it needs to be allowed by the NSG. If you do that, you can try to connect to the database from outside, for example with `sqlcmd -S smarthotelhost-RANDOM.REGION.cloudapp.azure.com -U sa -P demo!pass123 -Q "SELECT @@VERSION"` (where RANDOM will be a random string specific to your environment, and REGION your Azure region of deployment)
- The template will already have created a RG with the Landing Zone, where the same IP addresses as in onprem are used. This can be interpreted as a "gentle push" to reuse IPs, but still the discussion of whether reusing IPs or not is valid
- In this context, certain customers have deployed solutions to stretch subnets between onprem and Azure, such as [Azure Extended Network](https://docs.microsoft.com/azure/virtual-network/subnet-extension) or LISP (see for example Cisco's [Configure L2 extension for public cloud](https://www.cisco.com/c/en/us/td/docs/routers/csr1000/software/azu/b_csr1000config-azure/configure-lisp-layer-2-extension.html))
- Note that when creating the Azure Migrate project, some permissions are going to be required at the subscription level. The script to create users provided in [Challenge 0: Environment Setup - Coach's Guide](00-lab_setup.md) creates a custom role to cover those permissions.
- For the cost calculation, make sure participants don't forget about other costs like bandwidth, load balancers, etc (even if they just do a rough estimation)

## Solution Guide

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
