[< Back to Challenge 1](../Challenge-01.md) 

#### You can use this script to deploy and configure the Central Network Virtual Appliance (Cisco CSR 1000v):

### Azure CLI CSR Creation

(If you are not using bash, add $ symbol to the variable and double quote the values).

```bash
# Variables
echo -n "Please enter the resource group name where the VPN VPG is located: "
read RGNAME
echo -n "Please enter an Azure region to deploy the resources to simulate onprem (i.e. \"eastus\", \"westus\"): "
read LOCATION
echo -n "Please enter a password to be used for your CSR and the VPN pre-shared key: "
read ADMIN_PASSWORD
echo ""

rg="$RGNAME"
location="$LOCATION"
vnet_name=hub

//You may change the name and address space of the subnets if desired or required. 

nva_subnet_name=nva
nva_subnet_prefix=10.0.1.0/24


# Create CSR
az network vnet subnet create --address-prefix $nva_subnet_prefix --name $nva_subnet_name --resource-group $rg --vnet-name $vnet_name -o none --only-show-errors

az network public-ip create --name CSRPublicIP --resource-group $rg --idle-timeout 30 --allocation-method Static -o none --only-show-errors
az network nic create --name hub-nva1-nic --resource-group $rg --subnet $nva_subnet_name --vnet $vnet_name --public-ip-address CSRPublicIP --ip-forwarding true -o none --only-show-errors
az vm image accept-terms --urn cisco:cisco-csr-1000v:16_12-byol:latest
az vm create --resource-group $rg --location $location --name hub-nva1 --size Standard_D2_v2 --nics hub-nva1-nic --image cisco:cisco-csr-1000v:16_12-byol:latest --admin-username azureuser --admin-password $ADMIN_PASSWORD -o none --only-show-errors

```

## Useful Cisco IOS commands

This list is by no means comprehensive, but it is conceived to give some of the most useful commands for admins new to the Cisco CLI

**config t**: enter configuration mode
**write mem**: save the config to non-volatile storage
**show ip interface brief**: show a summary of the network interfaces in the system
**show ip route**: show the system routing table
