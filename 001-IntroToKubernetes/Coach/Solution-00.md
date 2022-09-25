# Challenge 00 - Prerequisites - Ready, Set, GO! - Coach's Guide 

**[Home](./README.md)** - [Next Solution >](./Solution-01.md)

## Notes & Guidance

Links to install the tooling for this hack:

- [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
- [Visual Studio Code](https://code.visualstudio.com/)
- *Optional:* [Azure Storage Explorer](http://storageexplorer.com)

Coach's should recommend Windows users to install the Azure CLI into the WSL instance on their machine using the installation instructions for the Linux distribution they use in WSL.  If a Windows user installs the Azure CLI on Windows in PowerShell or the Command Prompt, the Azure CLI will work, however they may experience two issues in the future:
1. Many code samples online that use the Azure CLI use Bash shell scripting. These will not work in PowerShell or Windows Command Prompt.
1. WSL's integration with Windows combines the Windows & Linux PATH settings.  If a user installs the Azure CLI on both Windows PowerShell and in the WSL, it will show up in WSL's $PATH environment variable twice. This could result in the Windows' installation of the Azure CLI being used instead of the WSL's installation of the Azure CLI being used when using the Azure CLI in WSL.


If attendees will be using a shared Azure subscription, you should be aware of the following:
- In addition to the “Contributor” role, all attendees should have the  “Azure account administrator” role on the Azure subscription in order to authenticate their AKS clusters against their Azure Container Registries.  For more info: <https://docs.microsoft.com/en-us/azure/aks/cluster-container-registry-integration>
- CPU and Public IP quotas will need to be raised for the subscription.  Default quota is 10 for each.  Each student will be spinning up:
	- 3 x 2 vCPUs VMs for the AKS cluster + 2 PIPs. 1 for AKS cluster, 1 for content-web
	- 1 x 2 vCPUs VM for the Docker Build machine + one PIP
	- Total: 8 vCPUs + 3 PiPs per attendee

- **NOTE:** Quotas are set per region.  If you increase the quota in a single region, you need to ensure that all students deploy to the same region.  Or else, they will bump up against the quota limits in the region they deploy to.
- **NOTE:** If there is no access to an administrator who can request quota increases, have the students deploy to different regions to stay within the quota limit of each region.
- **NOTE:** If the students will deploy AKS across Availability Zones, coaches should ensure they pick a region where Availability Zones are supported. 
<https://docs.microsoft.com/en-us/azure/availability-zones/az-region>

## Pre-Select Your Path For Container Content
Coaches, be sure to read the [Coach Guidance for Challenge 1](./Solution-01.md). You will need to select a proper path based on the learning objectives of the organization (to be decided PRIOR TO the hack!).  Select the proper path after consulting with the organization's stakeholder(s) for the hack.

