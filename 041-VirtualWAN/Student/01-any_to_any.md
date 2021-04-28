![](nwfasthack.png)

# Virtual WAN FastHack

Before you start, please read these instructions carefully:

* Setting expectations: all of the challenges in this FastHack would take around 2 days to complete. Please do not expect to finish all of the exercises in a shorter event
* It is recommended going one challenge after the other, without skipping any. However, if your team decides to modify the challenge order, that is possible too. Please consult with your coach to verify that the challenge order you wish to follow is doable, and there are no dependencies on the challenges you skip
* **Think** before rushing to configuration. One minute of planning might save you hours of work
* Look at the **relevant information** in each challenge, they might contain useful information and tools
* You might want to split the individual objectives of a challenge across team members, but please consider that all of the team members need to understand every part of a challenge

## Requirements

- An understanding of Azure networking concepts such as Virtual Networks, peerings and User-Defined Routes

## Objectives

Deploy an Azure Virtual WAN with 2 hubs. Deploy and connect 2 VNets on each hub. Especially for deploying VMs and VNets, it is recommended using the Azure CLI ([az vm create](https://docs.microsoft.com/cli/azure/vm?view=azure-cli-latest#az_vm_create)) or Azure PowerShell ([New-AzVM](https://docs.microsoft.com/powershell/module/az.compute/new-azvm)). For example, in the scripts folder in this repo you can find a script that can create a batch of VNets with predefined prefixes.

Make sure your deployment meets these requirements:

* Confirm connectivity is working between VNets on the same hub and across hubs

Sample topology:

![topology](pictures/vwan01.png)

### Optional objective 1: branch connectivity

Deploy two VNets with a VPN solution (for example Cisco CSR) and connect them as branches to the VWAN hubs. If you choose to use the Cisco CSR, there are some sample configs and deployment commands in [this repo](./csr).

Requirements:

* Confirm connectivity between branches as well as between branches and VNets (same hub and across hubs)

Sample topology:

![topology](pictures/vwan02.png)

### Optional scenario 2: isolated VNets

Deploy 2 more VNets on each hub. Make sure each hub has 4 VNets in total. Those 4 VNets in each hub will have different roles:

* 1 VNet will be used for Development
* 2 VNets will be used for Production
* 1 VNet will be used for Common Services

Requirements:

* The Development VNet should be able to communicate with the other Development VNet in the other hub, and to the other Common Services VNet
* The Production VNets should be able to communicate with the other Production VNets (same hub and across hubs), and to the other Common Services VNet
* The Development VNets should not be able to communicate to the Production VNets
* All VNets should be able to communicate with the VPN branches

Sample topology:

![topology](pictures/vwan03.png)

### Optional scenario 3: NVA/Azure Firewall in connected VNet

Deploy an NVA or an Azure Firewall instance in the Common Services VNet. Create two additional VNets in each region and peer them to the Common Services VNet.

Requirements:

* The indirect spokes in one hub can reach the indirect spokes in the other hub.
* The indirect spokes can reach all branches
* Verify if the indirect spokes can reach the Development and Production VNets

Sample topology:

![topology](pictures/vwan04.png)

### Optional scenario 4: Secured hubs

Convert both of your VWAN hubs to secured hubs. Fulfill these requirements:

* These flows need to go through the Azure Firewall:

* VNet-to-VNet in the same hub (aka VHV)
* VNet-to-Branch in the same hub (aka VHB)
* VNet-to-Internet

Note that Virtual Secure Hub does not support VHHV or VHHB traversing the firewall

Sample topology:

![topology](pictures/vwan05.png)

## Relevant links

* [VWAN any-to-any across hubs](https://docs.microsoft.com/azure/virtual-wan/scenario-any-to-any)
* [VWAN routing through NVA VNet](https://docs.microsoft.com/azure/virtual-wan/scenario-route-through-nva)
* [VWAN isolated Vnets](https://docs.microsoft.com/azure/virtual-wan/scenario-isolate-vnets)
* [VWAN secure virtual hub](https://docs.microsoft.com/azure/virtual-wan/scenario-route-between-vnets-firewall)