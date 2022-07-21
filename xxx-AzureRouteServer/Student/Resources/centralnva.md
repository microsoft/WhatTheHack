#### You can use this script to deploy and configure the Central Network Virtual Appliance (Cisco CSR 1000v):

### Azure CLI CSR Creation

```bash
# Variables
$rg=<Resource Group of your Hub Vnet>
$location=<Azure region same as Hub Vnet>
$vnet_name=<Name of your Hub Vnet>
$vnet_prefix=10.0.0.0/16

  # Examples
  # $rg="ARSFastHack"
  # $location="southeastasia"
  # $vnet_name="ARSFastHackHub"
  # $vnet_prefix="10.0.0.0/16"

//You may change the name and address space of the subnets if desired or required. 

$Vnet_out_subnet_name="nvaoutsidesubnet"
$vnet_out_subnet="10.0.2.0/24"
$Vnet_in_subnet_name="nvainsidesidesubnet"
$vnet_in_subnet="10.0.3.0/24"


# Create CSR

az network vnet subnet create --address-prefix $vnet_out_subnet --name $Vnet_out_subnet_name --resource-group $rg --vnet-name $vnet_name
az network vnet subnet create --address-prefix $vnet_in_subnet --name $Vnet_in_subnet_name --resource-group $rg --vnet-name $vnet_name

az network public-ip create --name CSRPublicIP --resource-group $rg --idle-timeout 30 --allocation-method Static
az network nic create --name CSROutsideInterface --resource-group $rg --subnet $Vnet_out_subnet_name --vnet $vnet_name --public-ip-address CSRPublicIP --ip-forwarding true
az network nic create --name CSRInsideInterface --resource-group $rg --subnet $Vnet_in_subnet_name --vnet $vnet_name --ip-forwarding true
az vm image accept-terms --urn cisco:cisco-csr-1000v:16_12-byol:latest
az vm create --resource-group $rg --location $location --name NVAHub --size Standard_D2_v2 --nics CSROutsideInterface CSRInsideInterface  --image cisco:cisco-csr-1000v:16_12-byol:latest --admin-username azureuser --admin-password Msft123Msft123 --no-wait

```


### Cisco IOS Commands

```bash

conf t
## On premises route. DG outside interface
ip route 172.16.0.0 255.255.0.0 10.0.2.1

## Routes to the spokes. DG inside interface
ip route <spoke1 vnet prefix> <spoke1 network mask> 10.0.1.1
ip route <spokeN vnet prefix> <spokeN network mask> 10.0.1.1

```

## Useful Cisco IOS commands

This list is by no means comprehensive, but it is conceived to give some of the most useful commands for admins new to the Cisco CLI

**config t**: enter configuration mode
**write mem**: save the config to non-volatile storage
**show ip interface brief**: show a summary of the network interfaces in the system
**show ip route**: show the system routing table
