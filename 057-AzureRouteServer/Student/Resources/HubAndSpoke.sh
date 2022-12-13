#!/bin/bash

# Variables (change location as relevant)
rg=arshack-rg #STUDENT SHOULD REPLACE RGNAME WITH THEIR INITIALS
location=eastus
username=azureuser
adminpassword=<USER MUST PROVIDE VALUE>
vnet_name=hub
vnet_prefix=10.0.0.0/16
vnet_prefix_long='10.0.0.0 255.255.0.0'
hub_vm_subnet_name=vm
hub_vm_subnet_prefix=10.0.10.0/24
gw_subnet_prefix=10.0.0.0/24


# Spoke 1
spoke1_name=spoke1
spoke1_prefix=10.1.0.0/16
spoke1_vm_subnet_name=vm
spoke1_vm_subnet_prefix=10.1.10.0/24

# Spoke 2
spoke2_name=spoke2
spoke2_prefix=10.2.0.0/16
spoke2_vm_subnet_name=vm
spoke2_vm_subnet_prefix=10.2.10.0/24

# Azure VPN GW
vpngw_name=vpngw
vpngw_asn=65515
vpngw_pip1="${vpngw_name}-pip1"
vpngw_pip2="${vpngw_name}-pip2"

# Create Vnet
echo "Creating RG and VNet..."
az group create -n $rg -l $location -o none
az network vnet create -g $rg -n $vnet_name --address-prefix $vnet_prefix --subnet-name $hub_vm_subnet_name --subnet-prefix $hub_vm_subnet_prefix -o none
az network vnet subnet create -n GatewaySubnet --address-prefix $gw_subnet_prefix --vnet-name $vnet_name -g $rg -o none

# Create test VM in hub
az vm create -n hubvm -g $rg -l $location --image ubuntuLTS  \
    --admin-username "$username" \
    --admin-password "$adminpassword" \
    --public-ip-address hubvm-pip --vnet-name $vnet_name --size Standard_B1s --subnet $hub_vm_subnet_name -o none

# hub_vm_ip=$(az network public-ip show -n hubvm-pip --query ipAddress -o tsv -g $rg) && echo $hub_vm_ip
# hub_vm_nic_id=$(az vm show -n hubvm -g "$rg" --query 'networkProfile.networkInterfaces[0].id' -o tsv) && echo $hub_vm_nic_id
# hub_vm_private_ip=$(az network nic show --ids $hub_vm_nic_id --query 'ipConfigurations[0].privateIpAddress' -o tsv) && echo $hub_vm_private_ip

echo "Creating spoke 1..."
az network vnet create -g $rg -n $spoke1_name --address-prefix $spoke1_prefix --subnet-name $spoke1_vm_subnet_name --subnet-prefix $spoke1_vm_subnet_prefix -l $location -o none


# Create test VM in spoke1
az vm create -n spoke1-vm -g $rg -l $location --image ubuntuLTS  \
        --admin-username "$username" \
        --admin-password "$adminpassword" \
        --public-ip-address spoke1-vm-pip --vnet-name $spoke1_name --size Standard_B1s --subnet $spoke1_vm_subnet_name -o none

echo "Creating spoke 2..."
az network vnet create -g $rg -n $spoke2_name --address-prefix $spoke2_prefix --subnet-name $spoke2_vm_subnet_name --subnet-prefix $spoke2_vm_subnet_prefix -l $location -o none


# Create test VM in spoke2
az vm create -n spoke2-vm -g $rg -l $location --image ubuntuLTS  \
        --admin-username "$username" \
        --admin-password "$adminpassword" \
        --public-ip-address spoke2-vm-pip --vnet-name $spoke2_name --size Standard_B1s --subnet $spoke2_vm_subnet_name -o none


# Create VPN Gateway (IP Sec Tunnel to be established with on-prem. CSR Template provided in student guide)

echo "Creating vnet gateway. command will finish running but gw creation takes a while"

az network public-ip create -n $vpngw_pip1 -g $rg --allocation-method Dynamic
az network public-ip create -n $vpngw_pip2 -g $rg --allocation-method Dynamic
az network vnet-gateway create -n $vpngw_name -l eastus --public-ip-addresses $vpngw_pip1 $vpngw_pip2 -g $rg --vnet $vnet_name --gateway-type Vpn --sku VpnGw1 --vpn-type RouteBased --no-wait

#=======================================================
# Check every second for Succeeded
#=======================================================
declare lookfor='"Succeeded"'
declare cmd="az network vnet-gateway list -g arshack-rg | jq '.[0].provisioningState'"
gwStatus=$(eval $cmd)
echo "Gatway provisioning state = $gwStatus"
while [ "$gwStatus" != "$lookfor" ]
do
    sleep 10
    echo "Gatway provisioning state not equal to Succeeded, instead = $gwStatus"
    gwStatus=$(eval $cmd)
    echo "Gateway status = "$gwStatus
done
echo "Gateway Created"

#=======================================================
# Check every second for Succeeded when enabling BGP
#=======================================================
# Enable BGP
az network vnet-gateway update -g $rg -n $vpngw_name --enable-bgp true --no-wait

gwStatus=$(eval $cmd)
echo "Gatway provisioning state = $gwStatus"
while [ "$gwStatus" != "$lookfor" ]
do
    sleep 10
    echo "Gatway provisioning state not equal to Succeeded, instead = $gwStatus"
    gwStatus=$(eval $cmd)
    echo "Gateway status = "$gwStatus
done

echo "BGP enabled"

echo "Creating Hub to Spoke1 Networking Peering"
az network vnet peering create -n hubtospoke1 -g $rg --vnet-name $vnet_name --remote-vnet $spoke1_name --allow-vnet-access --allow-forwarded-traffic --allow-gateway-transit -o none
echo "Creating Spoke1 to Hub Networking Peering"
az network vnet peering create -n spoke1tohub -g $rg --vnet-name $spoke1_name --remote-vnet $vnet_name --allow-vnet-access --allow-forwarded-traffic --use-remote-gateways -o none

echo "Creating Hub to Spoke2 Networking Peering"
az network vnet peering create -n hubtospoke2 -g $rg --vnet-name $vnet_name --remote-vnet $spoke2_name --allow-vnet-access --allow-forwarded-traffic --allow-gateway-transit -o none
echo "Creating Spoke2 to Hub Networking Peering"
az network vnet peering create -n spoke2tohub -g $rg --vnet-name $spoke2_name --remote-vnet $vnet_name --allow-vnet-access --allow-forwarded-traffic --use-remote-gateways -o none
