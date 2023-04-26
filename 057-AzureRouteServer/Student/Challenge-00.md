# Challenge 00 - Prerequisites - Ready, Set, GO

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

A smart Azure engineer always has the right tools in their toolbox. In addition, a good grasp on the key fundamental networking concepts. In this case, the Border Gateway Protocol (BGP).

## Description

In this challenge you will be setting up the prerequisite tools you will need to complete the hack's challenges. You will also deploy a baseline Hub and Spoke network topography into Azure which you will use complete the challenges of this hack.

- First, make sure you have an Azure Subscription. 

### Set Up Your Local Workstation

You can complete all of the challenges in this hack in a web browser using the [Azure Portal](https://portal.azure.com) and [Azure Cloud Shell](https://shell.azure.com). However, if you work with Azure and on a regular basis, be a good cloud architect and make sure you have experience installing the required tools on your local workstation:
 
- The PowerShell way (same tooling for Windows, Linux or Mac):
  - [PowerShell core (7.x)](https://docs.microsoft.com/en-us/powershell/scripting/overview)
  - [Azure PowerShell modules](https://docs.microsoft.com/en-us/powershell/azure/new-azureps-module-az)
  - [Visual Studio Code](https://code.visualstudio.com/): the Windows PowerShell ISE might be an option here for Windows users, but VS Code is far, far better
  - [Visual Studio Code PowerShell extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell)
- The Azure CLI way:
  - [Windows Subsystem for Linux](https://docs.microsoft.com/windows/wsl/install-win10), if you are running Windows and want to install the Azure CLI under a Linux shell like bash or zsh
  - [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli)
  - [Visual Studio Code](https://code.visualstudio.com/): the Windows Powershell ISE might be an option here for Windows users, but VS Code is far, far better
  - [VScode Azure CLI extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.azurecli)

### Student Resources

Your coach will provide you with a `Resources.zip` file that contains resource files you will use to setup the initial Hub and Spoke Topology. 

If you have installed all of the tools listed above and plan to work on your local workstation, you should download and unpack the `Resources.zip` file there too.

If you plan to use the Azure Cloud Shell, you should upload the `Resources.zip` file to your cloud shell first and then unpack it there.

### Deploy the Baseline Hub & Spoke Topology to Azure

- From a bash shell on your local workstation, or in the Azure Cloud Shell, navigate to the location you have unpacked the `Resources.zip` file. You should find a script file named `HubAndSpoke.sh`. 
- Open the `HubAndSpoke.sh` script file and set the following values:
  - `rg` - The name of the resource group that will be created in Azure to deploy the baseline hub & spoke topology. If using a shared Azure subscription with other students, you should include your name or initials in the value to make it unique.
  - `adminpassword` - Provide a password value which will be used for the admin account on the VMs that the script deploys.
- Run the script to deploy the baseline Hub & Spoke network in Azure.

 **NOTE:** The script deploys Active/Active VPNs with BGP and the correspondent VNet Peering attributes for transitivity. However, other aspects such as configuring Local Network Gateways, setting up required Route Tables (UDRs) will need to be done manually. Simulated on-premises and Central NVA templates are provided separately throughout the challenge.

 **NOTE:** The deployment process takes aproximately 30 min. In the meantime, your coach will provide an intro lecture or explanation of the challenges.

 **TIP:** You may need to make the script file executable before you can run it.

 ```bash
 # Make the file executable
 chmod +x HubAndSpoke.sh
 # Remove the unix characters
  dos2unix HubAndSpoke.sh
 #run the file
 ./HubAndSpoke.sh
 ```

## Success Criteria

- You have an Azure shell at your disposal (Powershell, WSL(2), Mac, Linux or Azure Cloud Shell)
- Validate that you have deployed the base line Hub and Spoke Topology into your Azure subscription.
- You have reviewed foundational knowledge in Virtual Network Routing, Azure VNG , Azure Route Server, BGP fundamentals.

## Learning Resources

### Border Gateway Protocol

It is of paramount importance that you are aware that 100% of the Azure Route Server functionality revolves around basic to advanced Border Gateway Protocol (BGP) concepts. With that in mind, take as a first priority to grasp the BGP concepts as much as possible. On the other hand, do not feel overwhelmed if the concepts are not very clear at the beginning. After all, there are books dedicated entirely to BGP as a dynamic routing protocol.

- [BGP Fundamentals](https://www.linkedin.com/learning/cisco-ccnp-encor-350-401-cert-prep-1-architecture-virtualization-and-infrastructure/fundamental-bgp-concepts?autoplay=true&u=3322)

- [Great overview of BGP concepts outside configurations](https://www.youtube.com/watch?v=ydE-HprufbA)

 
### Route Server and Azure Route Server

- [Route Server RFC](https://datatracker.ietf.org/doc/html/rfc7947)
- [Azure Route Server](https://docs.microsoft.com/azure/route-server/overview)
- [John Savill Review on Route Server](https://www.youtube.com/watch?v=c1f4rmkrF6M&t=1668s)

### Review of Vnet Routing and BGP on VPN Gateways

- [Virtual Network Routing](https://docs.microsoft.com/azure/virtual-network/virtual-networks-udr-overview)
- [About BGP with Azure VPN Gateway](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-bgp-overview)
