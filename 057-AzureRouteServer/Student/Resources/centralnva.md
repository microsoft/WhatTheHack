[< Back to Challenge 1](../Challenge-01.md) 

# Deploying an NVA in the hub VNet

You can use this code to deploy and configure the Central Network Virtual Appliance (Cisco CSR 1000v):

### Azure CLI CSR Creation

(If you are not using bash, add $ symbol to the variable and double quote the values).

```bash
# Variables
echo -n "Please enter the resource group name where the VPN VNG is located: "
read RGNAME
echo -n "Please enter a password to be used for the new NVA: "
read ADMIN_PASSWORD
echo ""
rg="$RGNAME"
username=azureuser
# You may change the name and address space of the subnets if desired or required. 
nva_subnet_name=nva
nva_subnet_prefix='10.0.1.0/24'


# Try to find a VNG in the RG
echo "Searching for a VPN gateway in the resource group $rg..."
vpngw_name=$(az network vnet-gateway list -g "$rg" --query '[0].name' -o tsv)
location=$(az network vnet-gateway show -n "$vpngw_name" -g "$rg" --query location -o tsv)
vnet_name=$(az network vnet-gateway show -n "$vpngw_name" -g "$rg" --query 'ipConfigurations[0].subnet.id' -o tsv | cut -d/ -f 9)
# Create NVA
nva_name="${vnet_name}-nva1"
nva_pip_name="${vnet_name}-nva1-pip"
version=$(az vm image list -p $publisher -f $offer -s $sku --all --query '[0].version' -o tsv)
echo "Creating NVA $nva_name in VNet $vnet_name in location $location from ${publisher}:${offer}:${sku}:${version}, in resource group $rg..."
az vm create -n "$nva_name" -g "$rg" -l "$location" \
    --image "${publisher}:${offer}:${sku}:${version}" \
    --admin-username "$username" --admin-password "$ADMIN_PASSWORD" --authentication-type all --generate-ssh-keys \
    --public-ip-address "$nva_pip_name" --public-ip-address-allocation static \
    --vnet-name "$vnet_name" --subnet "$nva_subnet_name" --subnet-address-prefix "$nva_subnet_prefix" -o none --only-show-errors
# Configuring the NIC for IP forwarding
nva_nic_id=$(az vm show -n $nva_name -g $rg --query 'networkProfile.networkInterfaces[0].id' -o tsv)
az network nic update --ids $nva_nic_id --ip-forwarding -o none --only-show-errors
```

## Useful Cisco IOS commands

This list is by no means comprehensive, but it is conceived to give some of the most useful commands for admins new to the Cisco CLI

- `config t`: enter configuration mode
- `write mem`: save the config to non-volatile storage
- `show ip interface brief`: show a summary of the network interfaces in the system
- `show ip route`: show the system routing table
