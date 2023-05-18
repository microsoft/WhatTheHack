#!/bin/bash

# This script will deploy an onprem CSR to a dedicated Azure VNet, and connect it
#   to an existing VPN gateway via IPsec+BGP.

# Collect input parameters from the user
echo -n "Please enter the resource group name where the VPN VPG is located: "
read RGNAME
echo -n "Please enter an Azure region to deploy the resources to simulate onprem (i.e. \"eastus\", \"westus\"): "
read LOCATION
echo -n "Please enter a password to be used for your CSR and the VPN pre-shared key: "
read ADMIN_PASSWORD
echo ""

# Variables
rg=$RGNAME
location=$LOCATION
username=azureuser
adminpassword=$ADMIN_PASSWORD
vpn_psk="$ADMIN_PASSWORD"
publisher=cisco
offer=cisco-csr-1000v
sku=16_12-byol
site_name=datacenter
site_prefix=172.16.1.0/24
site_subnet=172.16.1.0/26
site_gateway=172.16.1.1
site_bgp_ip=172.16.1.10
site_asn=65501

# Verify that the RG exists
rg_id=$(az group show -n $rg --query id -o tsv)
if [[ -z "$rg_id" ]]; then
    echo "Resource group $rg does not exist. Please create it and try again."
    exit 1
fi

# Create CSR
echo "Creating CSR VM..."
version=$(az vm image list -p $publisher -f $offer -s $sku --all --query '[0].version' -o tsv)
az vm image terms accept --urn ${publisher}:${offer}:${sku}:${version} --only-show-errors -o none
az vm create -n ${site_name}-nva -g $rg -l $location \
    --image ${publisher}:${offer}:${sku}:${version} \
    --admin-username "$username" --admin-password $adminpassword --authentication-type all --generate-ssh-keys \
    --public-ip-address ${site_name}-pip --public-ip-address-allocation static \
    --vnet-name ${site_name} --vnet-address-prefix $site_prefix \
    --subnet nva --subnet-address-prefix $site_subnet \
    --private-ip-address $site_bgp_ip -o none --only-show-errors
site_ip=$(az network public-ip show -n ${site_name}-pip -g $rg --query ipAddress -o tsv) && echo "CSR deployed with public IP $site_ip"

# Add rules to NSG for IPsec
nva_nic_id=$(az vm show -n ${site_name}-nva -g $rg --query 'networkProfile.networkInterfaces[0].id' -o tsv)
nva_nsg_id=$(az network nic show --ids $nva_nic_id --query 'networkSecurityGroup.id' -o tsv)
nva_nsg_name=$(echo $nva_nsg_id | cut -d/ -f 9)
echo "Adding rules to NSG $nva_nsg_name for IPsec..."
az network nsg rule create --nsg-name "$nva_nsg_name" -g "$rg" -n Allow_Inbound_IPsec --priority 1020 \
    --access Allow --protocol Udp --source-address-prefixes 'Internet' --direction Inbound \
    --destination-address-prefixes '*' --destination-port-ranges 500 4500 -o none --only-show-errors

# Create LNG and VPN connection in Azure
echo "Searching for a VPN gateway in the resource group $rg..."
vpngw_name=$(az network vnet-gateway list -g $rg --query '[0].name' -o tsv)
vpngw_location=$(az network vnet-gateway show -n $vpngw_name -g $rg --query location -o tsv)
if [[ -z "$vpngw_name" ]]; then
    echo "No VPN gateway found in resource group $rg. Exiting..."
    exit 1
fi
echo "VPN gateway $vpngw_name found in resource group $rg, located in $vpngw_location. Creating LNG and VPN connection in Azure..."
az network local-gateway create -g $rg -l $vpngw_location -n $site_name --gateway-ip-address $site_ip --asn $site_asn --bgp-peering-address $site_bgp_ip -o none --only-show-errors
az network vpn-connection create -g $rg -l $vpngw_location --shared-key $vpn_psk --enable-bgp -n $site_name --vnet-gateway1 $vpngw_name --local-gateway2 $site_name -o none --only-show-errors

# Get information from the VNG
vpngw_bgp_asn=$(az network vnet-gateway show -n $vpngw_name -g $rg --query 'bgpSettings.asn' -o tsv)
vpngw_gw0_pip=$(az network vnet-gateway show -n $vpngw_name -g $rg --query 'bgpSettings.bgpPeeringAddresses[0].tunnelIpAddresses[0]' -o tsv)
vpngw_gw0_bgp_ip=$(az network vnet-gateway show -n $vpngw_name -g $rg --query 'bgpSettings.bgpPeeringAddresses[0].defaultBgpIpAddresses[0]' -o tsv)
vpngw_gw1_pip=$(az network vnet-gateway show -n $vpngw_name -g $rg --query 'bgpSettings.bgpPeeringAddresses[1].tunnelIpAddresses[0]' -o tsv)
vpngw_gw1_bgp_ip=$(az network vnet-gateway show -n $vpngw_name -g $rg --query 'bgpSettings.bgpPeeringAddresses[1].defaultBgpIpAddresses[0]' -o tsv)
echo "Extracted info for VPN gateway $vpngw_name: Gateway0 $vpngw_gw0_pip, $vpngw_gw0_bgp_ip. Gateway1 $vpngw_gw1_pip, $vpngw_gw0_bgp_ip. ASN $vpngw_bgp_asn"

# Create CSR config in a local file and copy it to the NVA
csr_config_url="https://raw.githubusercontent.com/erjosito/azure-nvas/master/csr/csr_config_2tunnels_tokenized.txt"
config_file_csr='csr.cfg'
config_file_local='/tmp/csr.cfg'
wget $csr_config_url -O $config_file_local
sed -i "s|\*\*PSK\*\*|${vpn_psk}|g" $config_file_local
sed -i "s|\*\*GW0_Private_IP\*\*|${vpngw_gw0_bgp_ip}|g" $config_file_local
sed -i "s|\*\*GW1_Private_IP\*\*|${vpngw_gw1_bgp_ip}|g" $config_file_local
sed -i "s|\*\*GW0_Public_IP\*\*|${vpngw_gw0_pip}|g" $config_file_local
sed -i "s|\*\*GW1_Public_IP\*\*|${vpngw_gw1_pip}|g" $config_file_local
sed -i "s|\*\*BGP_ID\*\*|${site_asn}|g" $config_file_local
ssh -o BatchMode=yes -o StrictHostKeyChecking=no "${username}@${site_ip}" <<EOF
config t
    file prompt quiet
EOF
scp -o KexAlgorithms=+diffie-hellman-group14-sha1 -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa $config_file_local "${username}@${site_ip}:/${config_file_csr}"
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group14-sha1 -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa "${username}@${site_ip}" "copy bootflash:${config_file_csr} running-config"
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group14-sha1 -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa "${username}@${site_ip}" "wr mem"

# Connect to the CSR and run commands (ideally using SSH key authentication)
# Example 1-line command (the -n flag disables reading from stdin, the StrickHostKeyChecking=no flag automatically accepts the public key)
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no "${username}@${site_ip}" -o KexAlgorithms=+diffie-hellman-group14-sha1 -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa "show ip interface brief"
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no "${username}@${site_ip}" -o KexAlgorithms=+diffie-hellman-group14-sha1 -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa "show ip bgp summary"
# Example multi-line command, to create a user for password authentication
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group14-sha1 -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa "${username}@${site_ip}" <<EOF
  config t
    username ${username} password 0 ${adminpassword}
    username ${username} privilege 15
  end
  wr mem
EOF
