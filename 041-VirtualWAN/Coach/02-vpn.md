# Challenge 2. VPN - Coach's Guide

[< Previous Challenge](./01-any_to_any.md) - **[Home](./README.md)** - [Next Challenge >](./03-isolated_vnet.md)

## Notes and Guidance

- Cisco CSRs do not generate any additional cost
- These scripts leverage Cisco CSR as NVA. If preferred, you can use any other NVA to simulate an onprem VPN device, such as Windows Server, Linux StrongSwan or any other

## Solution Guide

### Create VPN Gateways

Note that VPN creation can take some time:

```bash
# Create VPN gateways
az network vpn-gateway create -n hubvpn1 -g $rg -l $location1 --vhub hub1 --asn 65515
az network vpn-gateway create -n hubvpn2 -g $rg -l $location2 --vhub hub2 --asn 65515
```

### Create CSRs

Cisco CSRs will only cost the VM pricing:

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

### Configure CSRs

Configuring the CSRs will add the required IPsec and BGP configuration:

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

You can verify that all tunnels are up, and BGP adjacencies established:

```bash
# Verify
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $branch1_ip "sh ip int b"
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $branch1_ip "sh ip bgp summary"
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $branch2_ip "sh ip int b"
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $branch2_ip "sh ip bgp summary"
```
