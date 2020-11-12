# Challenge 0: Coach's Guide

**[Home](README.md)** - [Next Challenge >](./01-containers.md)

## Notes & Guidance

Links to install the tooling for this hack:

- [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
- [Visual Studio Code](https://code.visualstudio.com/)
- *Optional:* [Azure Storage Explorer](http://storageexplorer.com)

If attendees will be using a shared Azure subscription, you should be aware of the following:
- In addition to the “Contributor” role, all attendees should have the  “Azure account administrator” role on the Azure subscription in order to authenticate their AKS clusters against their Azure Container Registries.  For more info: <https://docs.microsoft.com/en-us/azure/aks/cluster-container-registry-integration>
- CPU and Public IP quotas will need to be raised for the subscription.  Default quota is 10 for each.  Each student will be spinning up:
	- 3 x 2core VMs for the AKS cluster + 2 PIPs. 1 for AKS cluster, 1 for content-web
	- 1 x 2core VM for the Docker Build machine + one PIP
	- Total: 8 cores + 3 PiPs per attendee
- **NOTE:** Quotas are set per region.  If you increase the quota in a single region, you need to ensure that all students deploy to the same region.  Or else, they will bump up against the quota limits in the region they deploy to.
- **NOTE:** If there is no access to an administrator who can request quota increases, have the students deploy to different regions to stay within the quota limit of each region.
- **NOTE:** If the students will deploy AKS across Availability Zones, coaches should ensure they pick a region where Availability Zones are supported. 
<https://docs.microsoft.com/en-us/azure/availability-zones/az-region>

