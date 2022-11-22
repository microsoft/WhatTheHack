# Challenge 00 - Prerequisites - Ready, Set, GO

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

A smart Azure engineer always has the right tools in their toolbox. In addition, a good grasp on the key fundamental networking concepts. In this case, the Border Gateway Protocol (BGP).

## Description

In this challenge we'll be setting up all the tools we will need to complete our challenges.

- Make sure that you have joined the Teams group for this track. Please ask your coach about the correct Teams channel to join.
- Make sure you have an Azure Subscription. In case you don't, possibly ask your coach to create a Resource Group for you. 
- You can use the Azure Portal and Azure Cloud Shell from the portal or use a dedicated window by accesing [https://shell.azure.com](https://shell.azure.com) to accomplish all the tasks. In case you needed to install the tools on your Desktop, please do the below (optional). 
  - The PowerShell way (same tooling for Windows, Linux or Mac):
    - [PowerShell core (7.x)](https://docs.microsoft.com/en-us/powershell/scripting/overview)
    - [Azure PowerShell modules](https://docs.microsoft.com/en-us/powershell/azure/new-azureps-module-az)
    - [Visual Studio Code](https://code.visualstudio.com/): the Windows Powershell ISE might be an option here for Windows users, but VS Code is far, far better
    - [Visual Studio Code PowerShell extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell)
  - The Azure CLI way:
    - [Windows Subsystem for Linux](https://docs.microsoft.com/windows/wsl/install-win10), if you are running Windows and want to install the Azure CLI under a Linux shell like bash or zsh
    - [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli)
    - [Visual Studio Code](https://code.visualstudio.com/): the Windows Powershell ISE might be an option here for Windows users, but VS Code is far, far better
    - [VScode Azure CLI extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.azurecli)

### Student Resources

Your coach will provide you with a link to a `Resources.zip` file that contains resource files you will use to setup the initial Hub and Spoke Topology.  

**NOTE:** The script deploys Active/Active VPNs with BGP and the correspondent VNet Peering attributes for transitivity. However, other aspects such as configuring Local Network Gateways, setting up required Route Tables (UDRs) will need to be done manually. Simulated on-premises and Central NVA templates are provided separately throughout the challenge.

- Download and unpack this file in your Azure Cloud Shell environment. 
- This process takes aproximately 30 min. In the meantime, your coach will provide an intro lecture or explanation of the challenges. 

```bash
# Upload the Resources.zip file provided by your coach into your Cloud Shell with the upload button on the console
```
```bash
# Unpack the zip file
unzip Resources.zip
# Navigate to the "Resources" folder
cd Resources
# Make the file executable
chmod +x HubAndSpoke.azcli
#run the file
./HubAndSpoke.azcli
```

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

## Success Criteria

- You have an Azure shell at your disposal (Powershell, WSL(2), Mac, Linux or Azure Cloud Shell)
- Implemented the base line Hub and Spoke Topology. 
- You have reviewed foundational knowledge in Virtual Network Routing, Azure VNG , Azure Route Server, BGP fundamentals.
