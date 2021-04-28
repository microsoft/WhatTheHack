# Challenge 2. VPN - Coach's Guide

## Notes and Guidance

## Solution Guide

<details><summary>Code</summary>

```bash
# Create VPN gateways
az network vpn-gateway create -n hubvpn1 -g $rg -l $location1 --vhub hub1 --asn 65515
az network vpn-gateway create -n hubvpn2 -g $rg -l $location2 --vhub hub2 --asn 65515
```

</details>
<br>

<details><summary>Code</summary>

```bash
# Create CSR to simulate branch1
az vm create -n branch1-nva -g $rg -l $location1 --image ${publisher}:${offer}:${sku}:${version} --admin-username "$username" --generate-ssh-keys --public-ip-address branch1-pip --public-ip-address-allocation static --vnet-name branch1 --vnet-address-prefix $branch1_prefix --subnet nva --subnet-address-prefix $branch1_subnet --private-ip-address $branch1_bgp_ip
branch1_ip=$(az network public-ip show -n branch1-pip -g $rg --query ipAddress -o tsv)
az network vpn-site create -n branch1 -g $rg -l $location1 --virtual-wan $vwan \
    --asn $branch1_asn --bgp-peering-address $branch1_bgp_ip --ip-address $branch1_ip --address-prefixes ${branch1_ip}/32 --device-vendor cisco --device-model csr --link-speed 100
az network vpn-gateway connection create -n branch1 --gateway-name hubvpn1 -g $rg --remote-vpn-site branch1 \
    --enable-bgp true --protocol-type IKEv2 --shared-key "$password" --connection-bandwidth 100 --routing-weight 10 \
    --associated-route-table $hub1_default_rt_id --propagated-route-tables $hub1_default_rt_id --labels default --internet-security true

# Create CSR to simulate branch2
az vm create -n branch2-nva -g $rg -l $location2 --image ${publisher}:${offer}:${sku}:${version} --admin-username "$username" --generate-ssh-keys --public-ip-address branch2-pip --public-ip-address-allocation static --vnet-name branch2 --vnet-address-prefix $branch2_prefix --subnet nva --subnet-address-prefix $branch2_subnet --private-ip-address $branch2_bgp_ip
branch2_ip=$(az network public-ip show -n branch2-pip -g $rg --query ipAddress -o tsv)
az network vpn-site create -n branch2 -g $rg -l $location2 --virtual-wan $vwan \
    --asn $branch2_asn --bgp-peering-address $branch2_bgp_ip --ip-address $branch2_ip --address-prefixes ${branch2_ip}/32
az network vpn-gateway connection create -n branch2 --gateway-name hubvpn2 -g $rg --remote-vpn-site branch2 \
    --enable-bgp true --protocol-type IKEv2 --shared-key "$password" --connection-bandwidth 100 --routing-weight 10 \
    --associated-route-table $hub2_default_rt_id --propagated-route-tables $hub2_default_rt_id  --labels default --internet-security true
```

</details>
<br>

**Scenario1.3**: Configure CSRs

<details><summary>Code</summary>

```bash
# Get parameters for VPN GW in hub1
vpngw1_config=$(az network vpn-gateway show -n hubvpn1 -g $rg)
site=branch1
vpngw1_gw0_pip=$(echo $vpngw1_config | jq -r '.bgpSettings.bgpPeeringAddresses[0].tunnelIpAddresses[0]')
vpngw1_gw1_pip=$(echo $vpngw1_config | jq -r '.bgpSettings.bgpPeeringAddresses[1].tunnelIpAddresses[0]')
vpngw1_gw0_bgp_ip=$(echo $vpngw1_config | jq -r '.bgpSettings.bgpPeeringAddresses[0].defaultBgpIpAddresses[0]')
vpngw1_gw1_bgp_ip=$(echo $vpngw1_config | jq -r '.bgpSettings.bgpPeeringAddresses[1].defaultBgpIpAddresses[0]')
vpngw1_bgp_asn=$(echo $vpngw1_config | jq -r '.bgpSettings.asn')  # This is today always 65515
echo "Extracted info for hubvpn1: Gateway0 $vpngw1_gw0_pip, $vpngw1_gw0_bgp_ip. Gateway1 $vpngw1_gw1_pip, $vpngw1_gw0_bgp_ip. ASN $vpngw1_bgp_asn"

# Get parameters for VPN GW in hub2
vpngw2_config=$(az network vpn-gateway show -n hubvpn2 -g $rg)
site=branch2
vpngw2_gw0_pip=$(echo $vpngw2_config | jq -r '.bgpSettings.bgpPeeringAddresses[0].tunnelIpAddresses[0]')
vpngw2_gw1_pip=$(echo $vpngw2_config | jq -r '.bgpSettings.bgpPeeringAddresses[1].tunnelIpAddresses[0]')
vpngw2_gw0_bgp_ip=$(echo $vpngw2_config | jq -r '.bgpSettings.bgpPeeringAddresses[0].defaultBgpIpAddresses[0]')
vpngw2_gw1_bgp_ip=$(echo $vpngw2_config | jq -r '.bgpSettings.bgpPeeringAddresses[1].defaultBgpIpAddresses[0]')
vpngw2_bgp_asn=$(echo $vpngw2_config | jq -r '.bgpSettings.asn')  # This is today always 65515
echo "Extracted info for hubvpn2: Gateway0 $vpngw2_gw0_pip, $vpngw2_gw0_bgp_ip. Gateway1 $vpngw2_gw1_pip, $vpngw2_gw0_bgp_ip. ASN $vpngw2_bgp_asn"

# Create CSR config for branch 1
csr_config_url="https://raw.githubusercontent.com/erjosito/azure-wan-lab/master/csr_config_2tunnels_tokenized.txt"
config_file_csr='branch1_csr.cfg'
config_file_local='/tmp/branch1_csr.cfg'
wget $csr_config_url -O $config_file_local
sed -i "s|\*\*PSK\*\*|${password}|g" $config_file_local
sed -i "s|\*\*GW0_Private_IP\*\*|${vpngw1_gw0_bgp_ip}|g" $config_file_local
sed -i "s|\*\*GW1_Private_IP\*\*|${vpngw1_gw1_bgp_ip}|g" $config_file_local
sed -i "s|\*\*GW0_Public_IP\*\*|${vpngw1_gw0_pip}|g" $config_file_local
sed -i "s|\*\*GW1_Public_IP\*\*|${vpngw1_gw1_pip}|g" $config_file_local
sed -i "s|\*\*BGP_ID\*\*|${branch1_asn}|g" $config_file_local
ssh -o BatchMode=yes -o StrictHostKeyChecking=no $branch1_ip <<EOF
  config t
    file prompt quiet
EOF
scp $config_file_local ${branch1_ip}:/${config_file_csr}
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $branch1_ip "copy bootflash:${config_file_csr} running-config"
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $branch1_ip "wr mem"
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $branch1_ip "sh ip int b"
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $branch1_ip "sh ip bgp summary"
myip=$(curl -s4 ifconfig.co)
loopback_ip=10.11.11.11
default_gateway=$branch1_gateway
ssh -o BatchMode=yes -o StrictHostKeyChecking=no $branch1_ip <<EOF
config t
    username $username password 0 $password
    no ip domain lookup
    interface Loopback0
        ip address ${loopback_ip} 255.255.255.255
    router bgp ${branch1_asn}
        redistribute connected
    ip route ${vpngw1_gw0_pip} 255.255.255.255 ${default_gateway}
    ip route ${vpngw1_gw1_pip} 255.255.255.255 ${default_gateway}
    ip route ${myip} 255.255.255.255 ${default_gateway}
    line vty 0 15
        exec-timeout 0 0
end
EOF

# Create CSR config for branch 2
csr_config_url="https://raw.githubusercontent.com/erjosito/azure-wan-lab/master/csr_config_2tunnels_tokenized.txt"
config_file_csr='branch2_csr.cfg'
config_file_local='/tmp/branch2_csr.cfg'
wget $csr_config_url -O $config_file_local
sed -i "s|\*\*PSK\*\*|${password}|g" $config_file_local
sed -i "s|\*\*GW0_Private_IP\*\*|${vpngw2_gw0_bgp_ip}|g" $config_file_local
sed -i "s|\*\*GW1_Private_IP\*\*|${vpngw2_gw1_bgp_ip}|g" $config_file_local
sed -i "s|\*\*GW0_Public_IP\*\*|${vpngw2_gw0_pip}|g" $config_file_local
sed -i "s|\*\*GW1_Public_IP\*\*|${vpngw2_gw1_pip}|g" $config_file_local
sed -i "s|\*\*BGP_ID\*\*|${branch2_asn}|g" $config_file_local
ssh -o BatchMode=yes -o StrictHostKeyChecking=no $branch2_ip <<EOF
  config t
    file prompt quiet
EOF
scp $config_file_local ${branch2_ip}:/${config_file_csr}
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $branch2_ip "copy bootflash:${config_file_csr} running-config"
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $branch2_ip "wr mem"
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $branch2_ip "sh ip int b"
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $branch2_ip "sh ip bgp summary"
myip=$(curl -s4 ifconfig.co)
loopback_ip=10.22.22.22
default_gateway=$branch2_gateway
ssh -o BatchMode=yes -o StrictHostKeyChecking=no $branch2_ip <<EOF
config t
    username $username password 0 $password
    no ip domain lookup
    interface Loopback0
        ip address ${loopback_ip} 255.255.255.255
    router bgp ${branch2_asn}
        redistribute connected
    ip route ${vpngw2_gw0_pip} 255.255.255.255 ${default_gateway}
    ip route ${vpngw2_gw1_pip} 255.255.255.255 ${default_gateway}
    ip route ${myip} 255.255.255.255 ${default_gateway}
    line vty 0 15
        exec-timeout 0 0
end
EOF
```

```bash
# Verify
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $branch1_ip "sh ip int b"
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $branch1_ip "sh ip bgp summary"
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $branch2_ip "sh ip int b"
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $branch2_ip "sh ip bgp summary"
```

</details>
<br>

**Scenario2.1**: Creating VNets 3 and 4 in hubs:

<details><summary>Code</summary>

```bash
# Spoke13 in location1
spoke_id=13
vnet_prefix=10.1.3.0/24
subnet_prefix=10.1.3.0/26
az vm create -n spoke${spoke_id}-vm -g $rg -l $location1 --image ubuntuLTS --admin-username $username --generate-ssh-keys \
    --public-ip-address spoke${spoke_id}-pip --vnet-name spoke${spoke_id}-$location1 \
    --vnet-address-prefix $vnet_prefix --subnet vm --subnet-address-prefix $subnet_prefix
az network vhub connection create -n spoke${spoke_id} -g $rg --vhub-name hub1 --remote-vnet spoke${spoke_id}-$location1 \
    --internet-security true --associated-route-table $hub1_default_rt_id --propagated-route-tables $hub1_default_rt_id
# Spoke14 in location1
spoke_id=14
vnet_prefix=10.1.4.0/24
subnet_prefix=10.1.4.0/26
az vm create -n spoke${spoke_id}-vm -g $rg -l $location1 --image ubuntuLTS --admin-username $username --generate-ssh-keys \
    --public-ip-address spoke${spoke_id}-pip --vnet-name spoke${spoke_id}-$location1 \
    --vnet-address-prefix $vnet_prefix --subnet vm --subnet-address-prefix $subnet_prefix
az network vhub connection create -n spoke${spoke_id} -g $rg --vhub-name hub1 --remote-vnet spoke${spoke_id}-$location1 \
    --internet-security true --associated-route-table $hub1_default_rt_id --propagated-route-tables $hub1_default_rt_id
# Spoke23 in location2
spoke_id=23
vnet_prefix=10.2.3.0/24
subnet_prefix=10.2.3.0/26
az vm create -n spoke${spoke_id}-vm -g $rg -l $location2 --image ubuntuLTS --admin-username $username --generate-ssh-keys \
    --public-ip-address spoke${spoke_id}-pip --vnet-name spoke${spoke_id}-$location2 \
    --vnet-address-prefix $vnet_prefix --subnet vm --subnet-address-prefix $subnet_prefix
az network vhub connection create -n spoke${spoke_id} -g $rg --vhub-name hub2 --remote-vnet spoke${spoke_id}-$location2 \
    --internet-security true --associated-route-table $hub2_default_rt_id --propagated-route-tables $hub2_default_rt_id
# Spoke24 in location2
spoke_id=24
vnet_prefix=10.2.4.0/24
subnet_prefix=10.2.4.0/26
az vm create -n spoke${spoke_id}-vm -g $rg -l $location2 --image ubuntuLTS --admin-username $username --generate-ssh-keys \
    --public-ip-address spoke${spoke_id}-pip --vnet-name spoke${spoke_id}-$location2 \
    --vnet-address-prefix $vnet_prefix --subnet vm --subnet-address-prefix $subnet_prefix
az network vhub connection create -n spoke${spoke_id} -g $rg --vhub-name hub2 --remote-vnet spoke${spoke_id}-$location2 \
    --internet-security true --associated-route-table $hub2_default_rt_id --propagated-route-tables $hub2_default_rt_id

# Backdoor for access from the testing device over the Internet
myip=$(curl -s4 ifconfig.co)
az network route-table create -n spokes-$location1 -g $rg -l $location1
az network route-table route create -n mypc -g $rg --route-table-name spokes-$location1 --address-prefix "${myip}/32" --next-hop-type Internet
az network vnet subnet update -n vm --vnet-name spoke11-$location1 -g $rg --route-table spokes-$location1
az network vnet subnet update -n vm --vnet-name spoke12-$location1 -g $rg --route-table spokes-$location1
az network route-table create -n spokes-$location2 -g $rg -l $location2
az network route-table route create -n mypc -g $rg --route-table-name spokes-$location2 --address-prefix "${myip}/32" --next-hop-type Internet
az network vnet subnet update -n vm --vnet-name spoke21-$location2 -g $rg --route-table spokes-$location2
az network vnet subnet update -n vm --vnet-name spoke22-$location2 -g $rg --route-table spokes-$location2
```

</details>
<br>

**Scenario2.2**: Modifying custom routing to achieve VNet isolation:

<details><summary>Code</summary>

```bash
# Create separate RTs in hub1
az network vhub route-table create -n hub1DEV --vhub-name hub1 -g $rg --labels dev
az network vhub route-table create -n hub1PROD --vhub-name hub1 -g $rg --labels prod
az network vhub route-table create -n hub1CS --vhub-name hub1 -g $rg --labels cs
hub1_dev_rt_id=$(az network vhub route-table show --vhub-name hub1 -g $rg -n hub1DEV --query id -o tsv)
hub1_prod_rt_id=$(az network vhub route-table show --vhub-name hub1 -g $rg -n hub1PROD --query id -o tsv)
hub1_cs_rt_id=$(az network vhub route-table show --vhub-name hub1 -g $rg -n hub1CS --query id -o tsv)
# Create separate RTs in hub2
az network vhub route-table create -n hub2DEV --vhub-name hub2 -g $rg --labels dev
az network vhub route-table create -n hub2PROD --vhub-name hub2 -g $rg --labels prod
az network vhub route-table create -n hub2CS --vhub-name hub2 -g $rg --labels cs
hub2_dev_rt_id=$(az network vhub route-table show --vhub-name hub2 -g $rg -n hub2DEV --query id -o tsv)
hub2_prod_rt_id=$(az network vhub route-table show --vhub-name hub2 -g $rg -n hub2PROD --query id -o tsv)
hub2_cs_rt_id=$(az network vhub route-table show --vhub-name hub2 -g $rg -n hub2CS --query id -o tsv)
# Setup:
# * Spoke11/21: DEV
# * Spoke12/13/22/23: PROD
# * Spoke14/24: CS
# Modify VNet connections in hub1:
az network vhub connection create -n spoke11 -g $rg --vhub-name hub1 --remote-vnet spoke11-$location1 --internet-security true \
    --associated-route-table $hub1_dev_rt_id --propagated-route-tables $hub1_dev_rt_id --labels dev cs default
az network vhub connection create -n spoke12 -g $rg --vhub-name hub1 --remote-vnet spoke12-$location1 --internet-security true \
    --associated-route-table $hub1_prod_rt_id --propagated-route-tables $hub1_prod_rt_id --labels prod cs default
az network vhub connection create -n spoke13 -g $rg --vhub-name hub1 --remote-vnet spoke13-$location1 --internet-security true \
    --associated-route-table $hub1_prod_rt_id --propagated-route-tables $hub1_prod_rt_id --labels prod cs default
az network vhub connection create -n spoke14 -g $rg --vhub-name hub1 --remote-vnet spoke14-$location1 --internet-security true \
    --associated-route-table $hub1_cs_rt_id --propagated-route-tables $hub1_cs_rt_id --labels dev prod cs default
# Modify VNet connections in hub2:
az network vhub connection create -n spoke21 -g $rg --vhub-name hub2 --remote-vnet spoke21-$location2 --internet-security true \
    --associated-route-table $hub2_dev_rt_id --propagated-route-tables $hub2_dev_rt_id --labels dev cs default
az network vhub connection create -n spoke22 -g $rg --vhub-name hub2 --remote-vnet spoke22-$location2 --internet-security true \
    --associated-route-table $hub2_prod_rt_id --propagated-route-tables $hub2_prod_rt_id --labels prod cs default
az network vhub connection create -n spoke23 -g $rg --vhub-name hub2 --remote-vnet spoke23-$location2 --internet-security true \
    --associated-route-table $hub2_prod_rt_id --propagated-route-tables $hub2_prod_rt_id --labels prod cs default
az network vhub connection create -n spoke24 -g $rg --vhub-name hub2 --remote-vnet spoke24-$location2 --internet-security true \
    --associated-route-table $hub2_cs_rt_id --propagated-route-tables $hub2_cs_rt_id --labels dev prod cs default
# Modify VPN connections
az network vpn-gateway connection create -n branch1 --gateway-name hubvpn1 -g $rg --remote-vpn-site branch1 \
    --enable-bgp true --protocol-type IKEv2 --shared-key "$password" --connection-bandwidth 100 --routing-weight 10 --internet-security true \
    --associated-route-table $hub1_default_rt_id --propagated-route-tables $hub1_default_rt_id --labels default dev prod cs
az network vpn-gateway connection create -n branch2 --gateway-name hubvpn2 -g $rg --remote-vpn-site branch2 \
    --enable-bgp true --protocol-type IKEv2 --shared-key "$password" --connection-bandwidth 100 --routing-weight 10 --internet-security true \
    --associated-route-table $hub2_default_rt_id --propagated-route-tables $hub2_default_rt_id --labels default dev prod cs
```

</details>
<br>

**Scenario3.1**: Convert VM in CS VNet to NVA

<details><summary>Code</summary>

```bash
# NVA in hub1
spoke_id=14
vm_name=spoke${spoke_id}-vm
echo "Configuring IP forwarding in NIC of VM ${vm_name}..."
vm_nic_id=$(az vm show -n $vm_name -g $rg --query 'networkProfile.networkInterfaces[0].id' -o tsv)
az network nic update --ids $vm_nic_id --ip-forwarding
# Configure IP forwarding in OS
echo "Configuring IP forwarding over SSH..."
vm_pip=$(az network public-ip show -n spoke${spoke_id}-pip -g $rg --query ipAddress -o tsv)
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $vm_pip "sudo sysctl -w net.ipv4.ip_forward=1"
# Route table for future spokes
vm_ip=$(az vm list-ip-addresses -n $vm_name -g $rg --query '[0].virtualMachine.network.privateIpAddresses[0]' -o tsv)
rt_name=indirectspokes${spoke_id}
echo "Creating route table ${rt_name} for indirect spokes..."
az network route-table create -n $rt_name -g $rg -l $location1 --disable-bgp-route-propagation
az network route-table route create -n default -g $rg --route-table-name $rt_name \
    --address-prefix 0.0.0.0/0 --next-hop-type VirtualAppliance --next-hop-ip-address $vm_ip
mypip=$(curl -s4 ifconfig.co) && echo $mypip
az network route-table route create -n mypc -g $rg --route-table-name $rt_name --address-prefix "${mypip}/32" --next-hop-type Internet
```

```bash
# NVA in hub2
spoke_id=24
vm_name=spoke${spoke_id}-vm
echo "Configuring IP forwarding in NIC of VM ${vm_name}..."
vm_nic_id=$(az vm show -n $vm_name -g $rg --query 'networkProfile.networkInterfaces[0].id' -o tsv)
az network nic update --ids $vm_nic_id --ip-forwarding
# Configure IP forwarding in OS
echo "Configuring IP forwarding over SSH..."
vm_pip=$(az network public-ip show -n spoke${spoke_id}-pip -g $rg --query ipAddress -o tsv)
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $vm_pip "sudo sysctl -w net.ipv4.ip_forward=1"
# Route table for future spokes
vm_ip=$(az vm list-ip-addresses -n $vm_name -g $rg --query '[0].virtualMachine.network.privateIpAddresses[0]' -o tsv)
rt_name=indirectspokes${spoke_id}
echo "Creating route table ${rt_name} for indirect spokes..."
az network route-table create -n $rt_name -g $rg -l $location2 --disable-bgp-route-propagation
az network route-table route create -n default -g $rg --route-table-name $rt_name \
    --address-prefix 0.0.0.0/0 --next-hop-type VirtualAppliance --next-hop-ip-address $vm_ip
mypip=$(curl -s4 ifconfig.co) && echo $mypip
az network route-table route create -n mypc -g $rg --route-table-name $rt_name --address-prefix "${mypip}/32" --next-hop-type Internet
```

</details>
<br>


**Scenario3.2**: Create indirect spokes

<details><summary>Code</summary>

```bash
# Create indirect spokes in hub1
nvaspoke_id=14
spoke_id=141
vnet_prefix=10.1.41.0/24
subnet_prefix=10.1.41.0/26
rt_name=indirectspokes${nvaspoke_id}
az vm create -n spoke${spoke_id}-vm -g $rg -l $location1 --image ubuntuLTS --admin-username $username --generate-ssh-keys \
    --public-ip-address spoke${spoke_id}-pip --vnet-name spoke${spoke_id}-$location1 \
    --vnet-address-prefix $vnet_prefix --subnet vm --subnet-address-prefix $subnet_prefix
az network vnet peering create -n spoke${spoke_id}to${nvaspoke_id} -g $rg \
    --vnet-name spoke${spoke_id}-${location1} --remote-vnet spoke${nvaspoke_id}-${location1} --allow-vnet-access --allow-forwarded-traffic
az network vnet peering create -n spoke${nvaspoke_id}to${spoke_id} -g $rg \
    --vnet-name spoke${nvaspoke_id}-${location1} --remote-vnet spoke${spoke_id}-${location1} --allow-vnet-access --allow-forwarded-traffic
az network vnet subnet update -n vm --vnet-name spoke${spoke_id}-${location1} -g $rg --route-table $rt_name
spoke_id=142
vnet_prefix=10.1.42.0/24
subnet_prefix=10.1.42.0/26
az vm create -n spoke${spoke_id}-vm -g $rg -l $location1 --image ubuntuLTS --admin-username $username --generate-ssh-keys \
    --public-ip-address spoke${spoke_id}-pip --vnet-name spoke${spoke_id}-$location1 \
    --vnet-address-prefix $vnet_prefix --subnet vm --subnet-address-prefix $subnet_prefix
az network vnet peering create -n spoke${spoke_id}to${nvaspoke_id} -g $rg \
    --vnet-name spoke${spoke_id}-${location1} --remote-vnet spoke${nvaspoke_id}-${location1} --allow-vnet-access --allow-forwarded-traffic
az network vnet peering create -n spoke${nvaspoke_id}to${spoke_id} -g $rg \
    --vnet-name spoke${nvaspoke_id}-${location1} --remote-vnet spoke${spoke_id}-${location1} --allow-vnet-access --allow-forwarded-traffic
az network vnet subnet update -n vm --vnet-name spoke${spoke_id}-${location1} -g $rg --route-table $rt_name
```

```bash
# Create indirect spokes in hub2
nvaspoke_id=24
spoke_id=241
vnet_prefix=10.2.41.0/24
subnet_prefix=10.2.41.0/26
rt_name=indirectspokes${nvaspoke_id}
az vm create -n spoke${spoke_id}-vm -g $rg -l $location2 --image ubuntuLTS --admin-username $username --generate-ssh-keys \
    --public-ip-address spoke${spoke_id}-pip --vnet-name spoke${spoke_id}-$location2 \
    --vnet-address-prefix $vnet_prefix --subnet vm --subnet-address-prefix $subnet_prefix
az network vnet peering create -n spoke${spoke_id}to${nvaspoke_id} -g $rg \
    --vnet-name spoke${spoke_id}-${location2} --remote-vnet spoke${nvaspoke_id}-${location2} --allow-vnet-access --allow-forwarded-traffic
az network vnet peering create -n spoke${nvaspoke_id}to${spoke_id} -g $rg \
    --vnet-name spoke${nvaspoke_id}-${location2} --remote-vnet spoke${spoke_id}-${location2} --allow-vnet-access --allow-forwarded-traffic
az network vnet subnet update -n vm --vnet-name spoke${spoke_id}-${location2} -g $rg --route-table $rt_name
spoke_id=242
vnet_prefix=10.2.42.0/24
subnet_prefix=10.2.42.0/26
az vm create -n spoke${spoke_id}-vm -g $rg -l $location2 --image ubuntuLTS --admin-username $username --generate-ssh-keys \
    --public-ip-address spoke${spoke_id}-pip --vnet-name spoke${spoke_id}-$location2 \
    --vnet-address-prefix $vnet_prefix --subnet vm --subnet-address-prefix $subnet_prefix
az network vnet peering create -n spoke${spoke_id}to${nvaspoke_id} -g $rg \
    --vnet-name spoke${spoke_id}-${location2} --remote-vnet spoke${nvaspoke_id}-${location2} --allow-vnet-access --allow-forwarded-traffic
az network vnet peering create -n spoke${nvaspoke_id}to${spoke_id} -g $rg \
    --vnet-name spoke${nvaspoke_id}-${location2} --remote-vnet spoke${spoke_id}-${location2} --allow-vnet-access --allow-forwarded-traffic
az network vnet subnet update -n vm --vnet-name spoke${spoke_id}-${location2} -g $rg --route-table $rt_name
```

</details>
<br>

**Scenario3.3**: Inject routes for indirect spokes

<details><summary>Code</summary>

```bash
spoke14_cx_id=$(az network vhub connection show -n spoke14 -g $rg --vhub hub1 --query id -o tsv)
spoke24_cx_id=$(az network vhub connection show -n spoke24 -g $rg --vhub hub2 --query id -o tsv)
# Routes in the Common Services RT
az network vhub route-table route add -n hub1CS --vhub-name hub1 -g $rg \
    --route-name spokes14x --destination-type CIDR --destinations "10.1.41.0/24" "10.1.42.0/24" \
    --next-hop-type ResourceId --next-hop $spoke14_cx_id
az network vhub route-table route add -n hub1CS --vhub-name hub1 -g $rg \
    --route-name spokes24x --destination-type CIDR --destinations "10.2.41.0/24" "10.2.42.0/24" \
    --next-hop-type ResourceId --next-hop $spoke24_cx_id
az network vhub route-table route add -n hub2CS --vhub-name hub2 -g $rg \
    --route-name spokes14x --destination-type CIDR --destinations "10.1.41.0/24" "10.1.42.0/24" \
    --next-hop-type ResourceId --next-hop $spoke14_cx_id
az network vhub route-table route add -n hub2CS --vhub-name hub2 -g $rg \
    --route-name spokes24x --destination-type CIDR --destinations "10.2.41.0/24" "10.2.42.0/24" \
    --next-hop-type ResourceId --next-hop $spoke24_cx_id
# Routes in the Prod RT
az network vhub route-table route add -n hub1Prod --vhub-name hub1 -g $rg \
    --route-name spokes14x --destination-type CIDR --destinations "10.1.41.0/24" "10.1.42.0/24" \
    --next-hop-type ResourceId --next-hop $spoke14_cx_id
az network vhub route-table route add -n hub1Prod --vhub-name hub1 -g $rg \
    --route-name spokes24x --destination-type CIDR --destinations "10.2.41.0/24" "10.2.42.0/24" \
    --next-hop-type ResourceId --next-hop $spoke24_cx_id
az network vhub route-table route add -n hub2Prod --vhub-name hub2 -g $rg \
    --route-name spokes14x --destination-type CIDR --destinations "10.1.41.0/24" "10.1.42.0/24" \
    --next-hop-type ResourceId --next-hop $spoke14_cx_id
az network vhub route-table route add -n hub2Prod --vhub-name hub2 -g $rg \
    --route-name spokes24x --destination-type CIDR --destinations "10.2.41.0/24" "10.2.42.0/24" \
    --next-hop-type ResourceId --next-hop $spoke24_cx_id
# Routes in the connections
vm_ip=$(az vm list-ip-addresses -n spoke14-vm -g $rg --query '[0].virtualMachine.network.privateIpAddresses[0]' -o tsv)
az network vhub connection create -n spoke14 -g $rg --vhub-name hub1 \
    --remote-vnet spoke14-$location1 --internet-security true \
    --associated-route-table $hub1_cs_rt_id --propagated-route-tables $hub1_cs_rt_id \
    --labels dev prod cs default \
    --route-name spokes --next-hop $vm_ip --address-prefixes 10.1.41.0/24 10.1.42.0/24
vm_ip=$(az vm list-ip-addresses -n spoke24-vm -g $rg --query '[0].virtualMachine.network.privateIpAddresses[0]' -o tsv)
az network vhub connection create -n spoke24 -g $rg --vhub-name hub2 \
    --remote-vnet spoke24-$location2 --internet-security true \
    --associated-route-table $hub2_cs_rt_id --propagated-route-tables $hub2_cs_rt_id \
    --labels dev prod cs default \
    --route-name spokes --next-hop $vm_ip --address-prefixes 10.2.41.0/24 10.2.42.0/24
```

</details>
<br>


**Scenario3.4**: Connectivity tests

<details><summary>Code</summary>

```bash
# 141 -> 142
from_pip_name=spoke141-pip
from_pip=$(az network public-ip show -n $from_pip_name -g $rg --query ipAddress -o tsv)
to_ip=$(az vm list-ip-addresses -n spoke142-vm -g $rg --query '[0].virtualMachine.network.privateIpAddresses[0]' -o tsv)
echo "Testing from $from_pip to $to_ip..."
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $username@$from_pip "ping $to_ip -c 3"
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $username@$from_pip "nc -vz $to_ip 22"
ssh -J $username@$from_pip $username@$to_pip
```

```bash
# 241 -> 242
from_pip_name=spoke241-pip
from_pip=$(az network public-ip show -n $from_pip_name -g $rg --query ipAddress -o tsv)
to_ip=$(az vm list-ip-addresses -n spoke242-vm -g $rg --query '[0].virtualMachine.network.privateIpAddresses[0]' -o tsv)
echo "Testing from $from_pip to $to_ip..."
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $username@$from_pip "ip a"
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $username@$from_pip "ping $to_ip -c 3"
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $username@$from_pip "nc -vz $to_ip 22"
ssh -J $username@$from_pip $username@$to_ip
```

```bash
# 14 -> 24
from_pip_name=spoke14-pip
from_pip=$(az network public-ip show -n $from_pip_name -g $rg --query ipAddress -o tsv)
to_ip=$(az vm list-ip-addresses -n spoke24-vm -g $rg --query '[0].virtualMachine.network.privateIpAddresses[0]' -o tsv)
echo "Testing from $from_pip to $to_ip..."
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $username@$from_pip "ping $to_ip -c 3"
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $username@$from_pip "nc -vz $to_ip 22"
```

```bash
# 141 -> 242
from_pip_name=spoke141-pip
from_pip=$(az network public-ip show -n $from_pip_name -g $rg --query ipAddress -o tsv)
to_ip=$(az vm list-ip-addresses -n spoke242-vm -g $rg --query '[0].virtualMachine.network.privateIpAddresses[0]' -o tsv)
echo "Testing from $from_pip to $to_ip..."
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $username@$from_pip "ping $to_ip -c 3"
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $username@$from_pip "nc -vz $to_ip 22"
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $username@$from_pip "ip a"
az network nic show-effective-route-table -n spoke14-vmVMNic -g $rg -o table
az network nic show-effective-route-table -n spoke24-vmVMNic -g $rg -o table
cx_id=$(az network vhub connection show -n spoke14 -g $rg --vhub hub1 --query id -o tsv)
az network vhub get-effective-routes --resource-type HubVirtualNetworkConnection --resource-id $cx_id -n hub1 -g $rg --query 'value[].addressPrefixes[]' -o tsv
cx_id=$(az network vhub connection show -n spoke24 -g $rg --vhub hub2 --query id -o tsv)
az network vhub get-effective-routes --resource-type HubVirtualNetworkConnection --resource-id $cx_id -n hub1 -g $rg --query 'value[].addressPrefixes[]' -o tsv
```

```bash
# 12 -> 141
from_pip_name=spoke12-pip
from_pip=$(az network public-ip show -n $from_pip_name -g $rg --query ipAddress -o tsv)
to_ip=$(az vm list-ip-addresses -n spoke141-vm -g $rg --query '[0].virtualMachine.network.privateIpAddresses[0]' -o tsv)
echo "Testing from $from_pip to $to_ip..."
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $username@$from_pip "ping $to_ip -c 3"
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $username@$from_pip "nc -vz $to_ip 22"
az network nic show-effective-route-table -n spoke12-vmVMNic -g $rg -o table
```

```bash
# 22 -> 241
from_pip_name=spoke22-pip
from_pip=$(az network public-ip show -n $from_pip_name -g $rg --query ipAddress -o tsv)
to_ip=$(az vm list-ip-addresses -n spoke241-vm -g $rg --query '[0].virtualMachine.network.privateIpAddresses[0]' -o tsv)
echo "Testing from $from_pip to $to_ip..."
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $username@$from_pip "ip a"
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $username@$from_pip "ping $to_ip -c 3"
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $username@$from_pip "nc -vz $to_ip 22"
ssh -J $username@$from_pip $username@$to_ip
az network nic show-effective-route-table -n spoke12-vmVMNic -g $rg -o table
```

```bash
# 12 -> 241
from_pip_name=spoke12-pip
from_pip=$(az network public-ip show -n $from_pip_name -g $rg --query ipAddress -o tsv)
to_ip=$(az vm list-ip-addresses -n spoke241-vm -g $rg --query '[0].virtualMachine.network.privateIpAddresses[0]' -o tsv)
echo "Testing from $from_pip to $to_ip..."
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $username@$from_pip "ping $to_ip -c 3"
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $username@$from_pip "nc -vz $to_ip 22"
az network nic show-effective-route-table -n spoke12-vmVMNic -g $rg -o table
```

```bash
# 22 -> 141
from_pip_name=spoke22-pip
from_pip=$(az network public-ip show -n $from_pip_name -g $rg --query ipAddress -o tsv)
to_ip=$(az vm list-ip-addresses -n spoke141-vm -g $rg --query '[0].virtualMachine.network.privateIpAddresses[0]' -o tsv)
echo "Testing from $from_pip to $to_ip..."
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $username@$from_pip "ping $to_ip -c 3"
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $username@$from_pip "nc -vz $to_ip 22"
az network nic show-effective-route-table -n spoke12-vmVMNic -g $rg -o table
```

</details>
<br>


**Scenario4.1**: Create Azure Firewalls Policy

<details><summary>Code</summary>

```bash
# Create Azure Firewall policy with sample policies
azfw_policy_name=vwanfwpolicy
az network firewall policy create -n $azfw_policy_name -g $rg
az network firewall policy rule-collection-group create -n ruleset01 --policy-name $azfw_policy_name -g $rg --priority 100
# Allow SSH
echo "Creating rule to allow SSH..."
az network firewall policy rule-collection-group collection add-filter-collection --policy-name $azfw_policy_name --rule-collection-group-name ruleset01 -g $rg \
    --name mgmt --collection-priority 101 --action Allow --rule-name allowSSH --rule-type NetworkRule --description "TCP 22" \
    --destination-addresses 10.0.0.0/8 1.1.1.1/32 2.2.2.2/32 3.3.3.3/32 --source-addresses 10.0.0.0/8 1.1.1.1/32 2.2.2.2/32 3.3.3.3/32 --ip-protocols TCP --destination-ports 22
# Allow ICMP
# echo "Creating rule to allow ICMP..."
# az network firewall policy rule-collection-group collection add-filter-collection --policy-name $azfw_policy_name --rule-collection-group-name ruleset01 -g $rg \
#     --name icmp --collection-priority 102 --action Allow --rule-name allowICMP --rule-type NetworkRule --description "ICMP traffic" \
#     --destination-addresses 10.0.0.0/8 1.1.1.1/32 2.2.2.2/32 3.3.3.3/32 --source-addresses 10.0.0.0/8 1.1.1.1/32 2.2.2.2/32 3.3.3.3/32 --ip-protocols ICMP --destination-ports "1-65535" >/dev/null
# Allow NTP
echo "Creating rule to allow NTP..."
az network firewall policy rule-collection-group collection add-filter-collection --policy-name $azfw_policy_name --rule-collection-group-name ruleset01 -g $rg \
    --name ntp --collection-priority 103 --action Allow --rule-name allowNTP --rule-type NetworkRule --description "Egress NTP traffic" \
    --destination-addresses '*' --source-addresses "10.0.0.0/8" --ip-protocols UDP --destination-ports "123"
# Example application collection with 2 rules (ipconfig.co, api.ipify.org)
echo "Creating rule to allow ifconfig.co and api.ipify.org..."
az network firewall policy rule-collection-group collection add-filter-collection --policy-name $azfw_policy_name --rule-collection-group-name ruleset01 -g $rg \
    --name ifconfig --collection-priority 201 --action Allow --rule-name allowIfconfig --rule-type ApplicationRule --description "ifconfig" \
    --target-fqdns "ifconfig.co" --source-addresses "10.0.0.0/8" --protocols Http=80 Https=443
az network firewall policy rule-collection-group collection rule add -g $rg --policy-name $azfw_policy_name --rule-collection-group-name ruleset01 --collection-name ifconfig \
    --name ipify --target-fqdns "api.ipify.org" --source-addresses "10.0.0.0/8" --protocols Http=80 Https=443 --rule-type ApplicationRule
# Example application collection with wildcards (*.ubuntu.com)
echo "Creating rule to allow *.ubuntu.com..."
az network firewall policy rule-collection-group collection add-filter-collection --policy-name $azfw_policy_name --rule-collection-group-name ruleset01 -g $rg \
    --name ubuntu --collection-priority 202 --action Allow --rule-name repos --rule-type ApplicationRule --description "ubuntucom" \
    --target-fqdns '*.ubuntu.com' --source-addresses "10.0.0.0/8" --protocols Http=80 Https=443
```

</details>
<br>

**Scenario4.2**: Create Azure Firewalls

<details><summary>Code</summary>

```bash
# Create Azure Firewalls in the virtual hubs
az network firewall create -n azfw1 -g $rg --vhub hub1 --policy $azfw_policy_name -l $location1 --sku AZFW_Hub --public-ip-count 1
az network firewall create -n azfw2 -g $rg --vhub hub2 --policy $azfw_policy_name -l $location2 --sku AZFW_Hub --public-ip-count 1
# Configure static routes to firewall
azfw1_id=$(az network firewall show -n azfw1 -g $rg --query id -o tsv)
azfw2_id=$(az network firewall show -n azfw2 -g $rg --query id -o tsv)
az network vhub route-table route add -n defaultRouteTable --vhub-name hub1 -g $rg \
    --route-name default --destination-type CIDR --destinations "0.0.0.0/0" "10.0.0.0/8" "172.16.0.0/12" \
    --next-hop-type ResourceId --next-hop $azfw1_id
az network vhub route-table route add -n defaultRouteTable --vhub-name hub2 -g $rg \
    --route-name default --destination-type CIDR --destinations "0.0.0.0/0" "10.0.0.0/8" "172.16.0.0/12" \
    --next-hop-type ResourceId --next-hop $azfw2_id
```

</details>
<br>

**Scenario4.3**: Configure logging (optional)

<details><summary>Code</summary>

```bash
logws_name=$(az monitor log-analytics workspace list -g $rg --query '[0].name' -o tsv)
if [[ -z "$logws_name" ]]
then
    logws_name=vwanlogs$RANDOM
    echo "Creating log analytics workspace $logws_name..."
    az monitor log-analytics workspace create -n $logws_name -g $rg -l $location1
fi
logws_id=$(az resource list -g $rg -n $logws_name --query '[].id' -o tsv)
logws_customerid=$(az monitor log-analytics workspace show -n $logws_name -g $rg --query customerId -o tsv)
# VPN gateways
echo "Configuring VPN gateways..."
gw_id_list=$(az network vpn-gateway list -g $rg --query '[].id' -o tsv)
while IFS= read -r gw_id; do
    az monitor diagnostic-settings create -n mydiag --resource $gw_id --workspace $logws_id \
        --metrics '[{"category": "AllMetrics", "enabled": true, "retentionPolicy": {"days": 0, "enabled": false }, "timeGrain": null}]' \
        --logs '[{"category": "GatewayDiagnosticLog", "enabled": true, "retentionPolicy": {"days": 0, "enabled": false}}, 
                {"category": "TunnelDiagnosticLog", "enabled": true, "retentionPolicy": {"days": 0, "enabled": false}},
                {"category": "RouteDiagnosticLog", "enabled": true, "retentionPolicy": {"days": 0, "enabled": false}},
                {"category": "IKEDiagnosticLog", "enabled": true, "retentionPolicy": {"days": 0, "enabled": false}}]' >/dev/null
done <<< "$gw_id_list"
# Azure Firewalls
echo "Configuring Azure Firewalls..."
fw_id_list=$(az network firewall list -g $rg --query '[].id' -o tsv)
while IFS= read -r fw_id; do
    az monitor diagnostic-settings create -n mydiag --resource $fw_id --workspace $logws_id \
        --metrics '[{"category": "AllMetrics", "enabled": true, "retentionPolicy": {"days": 0, "enabled": false }, "timeGrain": null}]' \
        --logs '[{"category": "AzureFirewallApplicationRule", "enabled": true, "retentionPolicy": {"days": 0, "enabled": false}}, 
                {"category": "AzureFirewallNetworkRule", "enabled": true, "retentionPolicy": {"days": 0, "enabled": false}}]' >/dev/null
done <<< "$fw_id_list"
```
</details>
<br>
