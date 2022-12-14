# Challenge 01 - Build Hub and Spoke topology with a NVA and VPN Connected Simulated on-premises branch - Coach's Guide.

[< Previous Solution](./Solution-00.md) - **[Home](./README.md)** - [Next Solution >](./Solution-02.md)

## Notes & Guidance

- Setup up a basic hub and spoke topology with a Central Network Virtual Appliance.<br/>
- Establish connectivity to (simulated) on-prem via VPN site-to-site.<br/>
- Prepare non-overlapping address spaces ranges for virtual networks and various special (Gateway, NVA) and VM Workload subnets.<br/>
- Decide what Azure Region, Resource Group(s) to create. Plan for creating VMs in all VNets (Hub, Spokes, Simulated Branch) to test the connectivity. <br/>
- Linux VMs are easy to deploy and do basic connectivity checks(using serial console).<br/>
- When using AIRS subscription, may face difficulties RDP/SSH into VMs due to security policy enforcement. (There are workarounds available).

## Solution Guide

- Create a Hub Virtual Network (VNet).
- Create two spoke VNets.
- Create a Azure Network Gateway in Hub VNet with SKU supporting Active/Active and BGP.
- Setup VNet peering between spokes and hub VNet.
- Setup Local Network Gateway reprenting simulated on-prem branch. 
- Deploy the Cisco CSR template (provided in the challange section) to simulate a branch office (on-premises). The said template also creates a "datacenter" VNet. 
- Setup 2-tunnels to one active/active virtual network gateway created earlier.
- Deploy Cisco CSR template (provided in the challange section) to setup a central NVA (used as a BGP/Security NVA). 
- Deploy VMs in all VNets (including Branch).
- Create Route Tables (UDRs) to steer traffic via NVAs for,
   - Branch VM subnet, Route to Hub/spoke VNets addres spaces (summarized should work as well) with next hop Branch NVA (CSR applaince).
   (This is required because branch VNet is really Azure vNet (think of SDN)).
   - GW subnet, route to Hub, next hop Central NVA (Outside Interface). 
   - Hub VM subnet, route to Spokes and Branch, next hop Central NVA (Inside Interface).
   - Spoke VM subnet, route to the other spoke and branch, next hop Central NVA (Inside Interface).
- Verify all traffic is going through the Central Network Virtual Appliance:
   - spoke-to-spoke
   - spokes-to-onprem
   - onprem-to-hub
   - onprem-to-spokes

## Sample deployment script

You can use this script to deploy a Hub and Spoke VNet, Test VMs, Azure VPN Gateway. Other aspects such as configuring Active/Active VPN Gateway, BGP, setting up required Route Tables (UDRs) will need to be done manually. (Simulated on-premises and Central NVA templates are provided separately in the challange) <br/>
(If you are not using Bash, add $ symbol to the variable and double quote the values).

```bash

# Variables (change location as relevant)
rg=arshack-rg
location=eastus
vnet_name=hub
vnet_prefix=10.0.0.0/16
vnet_prefix_long='10.0.0.0 255.255.0.0'
hub_vm_subnet_name=vm
hub_vm_subnet_prefix=10.0.4.0/24
gw_subnet_prefix=10.0.0.0/24
username=azureuser

# Spoke 1
spoke1_name=spoke1
spoke1_prefix=10.1.0.0/16
spoke1_vm_subnet_name=vm
spoke1_vm_subnet_prefix=10.1.4.0/24

# Spoke 2
spoke2_name=spoke2
spoke2_prefix=10.2.0.0/16
spoke2_vm_subnet_name=vm
spoke2_vm_subnet_prefix=10.2.4.0/24

# Azure VPN GW
vpngw_name=vpngw
vpngw_asn=65515
vpngw_pip="${vpngw_name}-pip"

# Create Vnet
echo "Creating RG and VNet..."
az group create -n $rg -l $location -o none
az network vnet create -g $rg -n $vnet_name --address-prefix $vnet_prefix --subnet-name $hub_vm_subnet_name --subnet-prefix $hub_vm_subnet_prefix -o none
az network vnet subnet create -n GatewaySubnet --address-prefix $gw_subnet_prefix --vnet-name $vnet_name -g $rg -o none

# Create test VM in hub
az vm create -n hubvm -g $rg -l $location --image ubuntuLTS --generate-ssh-keys \
    --admin-username "$username" \
    --public-ip-address hubvm-pip --vnet-name $vnet_name --size Standard_B1s --subnet $hub_vm_subnet_name -o none

# hub_vm_ip=$(az network public-ip show -n hubvm-pip --query ipAddress -o tsv -g $rg) && echo $hub_vm_ip
# hub_vm_nic_id=$(az vm show -n hubvm -g "$rg" --query 'networkProfile.networkInterfaces[0].id' -o tsv) && echo $hub_vm_nic_id
# hub_vm_private_ip=$(az network nic show --ids $hub_vm_nic_id --query 'ipConfigurations[0].privateIpAddress' -o tsv) && echo $hub_vm_private_ip

echo "Creating spoke 1..."
az network vnet create -g $rg -n $spoke1_name --address-prefix $spoke1_prefix --subnet-name $spoke1_vm_subnet_name --subnet-prefix $spoke1_vm_subnet_prefix -l $location -o none


# Create test VM in spoke1
az vm create -n spoke1-vm -g $rg -l $location --image ubuntuLTS --generate-ssh-keys \
        --admin-username "$username" \
        --public-ip-address spoke1-vm-pip --vnet-name $spoke1_name --size Standard_B1s --subnet $spoke1_vm_subnet_name -o none

echo "Creating spoke 2..."
az network vnet create -g $rg -n $spoke2_name --address-prefix $spoke2_prefix --subnet-name $spoke2_vm_subnet_name --subnet-prefix $spoke2_vm_subnet_prefix -l $location -o none


# Create test VM in spoke2
az vm create -n spoke2-vm -g $rg -l $location --image ubuntuLTS --generate-ssh-keys \
        --admin-username "$username" \
        --public-ip-address spoke2-vm-pip --vnet-name $spoke2_name --size Standard_B1s --subnet $spoke2_vm_subnet_name -o none


# Create VPN Gateway (IP Sec Tunnel to be established with on-prem. CSR Template provided in student guide)

echo "Creating vnet gateway. command will finish running but gw creation takes a while"

az network public-ip create -n $vpngw_pip -g $rg --allocation-method Dynamic
az network vnet-gateway create -n $vpngw_name -l eastus --public-ip-address $vpngw_pip -g $rg --vnet $vnet_name --gateway-type Vpn --sku VpnGw1 --vpn-type RouteBased --no-wait

# Create Local Network Gateway representing simulated on-prem. Replace the actual Public IP of the CSR IPSec NVA from the simulated on-prem. 
az network local-gateway create --gateway-ip-address 23.99.221.164 --name datacenter -g $rg --local-address-prefixes 172.16.1.0/24

echo "Creating Hub to Spoke1 Networking Peering"
az network vnet peering create -n hubtospoke1 -g $rg --vnet-name $vnet_name --remote-vnet $spoke1_name --allow-vnet-access --allow-forwarded-traffic --allow-gateway-transit -o none
echo "Creating Spoke1 to Hub Networking Peering"
az network vnet peering create -n spoke1tohub -g $rg --vnet-name $spoke1_name --remote-vnet $vnet_name --allow-vnet-access --allow-forwarded-traffic --use-remote-gateways -o none

echo "Creating Hub to Spoke2 Networking Peering"
az network vnet peering create -n hubtospoke2 -g $rg --vnet-name $vnet_name --remote-vnet $spoke2_name --allow-vnet-access --allow-forwarded-traffic --allow-gateway-transit -o none
echo "Creating Spoke2 to Hub Networking Peering"
az network vnet peering create -n spoke2tohub -g $rg --vnet-name $spoke2_name --remote-vnet $vnet_name --allow-vnet-access --allow-forwarded-traffic --use-remote-gateways -o none
