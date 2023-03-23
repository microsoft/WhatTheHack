#!/bin/bash

############################################################
# Create a BGP lab in Azure using VNGs and/or Cisco CSR NVAs
# Syntax:
#    bgp.sh <router_list> <connection_list> <resource_group_name> <azure_region> <IKE pre-shared key>
#  - <router_list> is a comma-separated list of devices to deploy. Each device takes the form "id:type:asn"
#       "id" is a unique integer to identify the device
#       "type" is either vng, vng1 (active/passive vng) or csr
#       "asn" is the BGP ASN to be configured on that device
#  - <connection_list> is a comma-separated list of the devices to connect to each other. Each
#       connection takes the form "device1_id:device2_id".
#       Alternatively you can specify connections in the form "device1_id:device2_id:protocol", where protocol
#       can be "bgp", "ospf", "bgpospf" or "none". If you dont specify a protocol, "bgp" is taken per default.
#  - <resource_group_name>: all devices will be created in this resource group in the active Azure subscription
#  - <azure_region>: all devices will be created in this Azure region
#  - <pre-shared key>: this key will be used as pre-shared key for the IPsec connections, as well as for the
#       password of usernames in CSR (additionally to SSH key auth)
#
# Examples:
#
# Basic example with 1 VNG connected to one CSR:
#     bgp.sh "1:vng:65501,2:csr:65502" "1:2" mylab northeurope mypresharedkey
# 4 CSRs connected in full mesh:
#     bgp.sh "1:csr:65501,2:csr:65502,3:csr:65503,4:csr:65504" "1:2,1:3,2:4,3:4,1:4,2:3" mylab northeurope mypresharedkey
# 2 VNGs and 2 CSRs connected in full mesh:
#     bgp.sh "1:vng:65001,2:vng:65002,3:csr:65100,4:csr:65100" "1:2,1:3,1:4,2:4,2:3,3:4" mylab northeurope mypresharedkey
# 2 VNGs and 2 CSRs connected in full mesh, with a 5th router connected via OSPF to CSR3 and CSR4 in triangle:
#     bgp.sh "1:vng1:65001,2:vng:65002,3:csr:65100,4:csr:65100,5:csr:65100" "1:2,1:3,1:4,2:4,2:3,3:4:bgpospf,3:5:ospf,4:5:ospf" mylab northeurope mypresharedkey
# Environment simulating 2 ExpressRoute locations (note you cannot use the 12076 ASN in Local Gateways):
#     bgp.sh "1:vng:65515,2:vng:65515,3:csr:22076,4:csr:22076,5:csr:65001,6:csr:65002" "1:3,1:4,2:3,2:4,3:5,4:6,5:6" mylab northeurope mypresharedkey
#
# bash and zsh tested
#
# Jose Moreno, August 2020
############################################################

# Waits until a resource finishes provisioning
# Example: wait_until_finished <resource_id> 
function wait_until_finished () {
     wait_interval=60
     resource_id=$1
     resource_name=$(echo "$resource_id" | cut -d/ -f 9)
     echo "Waiting for resource $resource_name to finish provisioning..."
     start_time=$(date +%s)
     state=$(az resource show --id "$resource_id" --query properties.provisioningState -o tsv 2>/dev/null)
     until [[ "$state" == "Succeeded" ]] || [[ "$state" == "Failed" ]] || [[ -z "$state" ]]
     do
        sleep $wait_interval
        state=$(az resource show --id "$resource_id" --query properties.provisioningState -o tsv)
     done
     if [[ -z "$state" ]]
     then
        echo "Something really bad happened..."
     else
        run_time=$(("$(date +%s)" - "$start_time"))
        ((minutes=run_time/60))
        ((seconds=run_time%60))
        echo "Resource $resource_name provisioning state is $state, wait time $minutes minutes and $seconds seconds"
     fi
}

# Remove special characters and empty lines from string
# Used in case the SSH session to IOS returns invalid characters (like CR aka 0x0d), but that doesnt seem to be the case,
#  so left to remove empty strings for the time being
function clean_string () {
    output=$1
    # output=$(echo $output | tr '\r' '\n')                   # Replace \r with \n
    output=$(echo "$output" | tr -d '\r')                   # Delete \r
    # output=$(echo $output | tr -dc '[:alnum:]\ \.\,\n')     # Remove special characters
    output=$(echo "$output" | awk NF)                       # Remove empty lines
    echo "$output"
}

# Wait until a public IP address answers via SSH
# The only thing CSR-specific is the command sent
function wait_until_csr_available () {
    wait_interval=15
    csr_id=$1
    csr_ip=$(az network public-ip show -n "csr${csr_id}-pip" -g "$rg" --query ipAddress -o tsv)
    echo "Waiting for CSR${csr_id} with IP address $csr_ip to answer over SSH..."
    start_time=$(date +%s)
    ssh_command="show version | include uptime"  # 'show version' contains VM name and uptime
    ssh_output=$(ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group14-sha1 -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa "$csr_ip" "$ssh_command" 2>/dev/null)
    until [[ -n "$ssh_output" ]]
    do
        sleep $wait_interval
        ssh_output=$(ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group14-sha1 -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa "$csr_ip" "$ssh_command" 2>/dev/null)
    done
    run_time=$(("$(date +%s)" - "$start_time"))
    ((minutes=run_time/60))
    ((seconds=run_time%60))
    echo "IP address $csr_ip is available (wait time $minutes minutes and $seconds seconds). Answer to SSH command \"$ssh_command\":"
    clean_string "$ssh_output"
}

# Wait until all VNGs in the router list finish provisioning
function wait_for_csrs_finished () {
    for router in "${routers[@]}"
    do
        type=$(get_router_type  "$router")
        id=$(get_router_id  "$router")
        if [[ "$type" == "csr" ]]
        then
            wait_until_csr_available "$id"
        fi
    done
}

# Add required rules to an NSG to allow traffic between the vnets (RFC1918)
function fix_nsg () {
    nsg_name=$1
    echo "Adding RFC1918 prefixes to NSG ${nsg_name}..."
    az network nsg rule create --nsg-name "$nsg_name" -g "$rg" -n Allow_Inbound_RFC1918 --priority 2000 \
        --access Allow --protocol '*' --source-address-prefixes '10.0.0.0/8' '172.16.0.0/12' '192.168.0.0/16' --direction Inbound \
        --destination-address-prefixes '10.0.0.0/8' '172.16.0.0/12' '192.168.0.0/16' --destination-port-ranges '*' >/dev/null
    az network nsg rule create --nsg-name "$nsg_name" -g "$rg" -n Allow_Outbound_RFC1918 --priority 2000 \
        --access Allow --protocol '*' --source-address-prefixes '10.0.0.0/8' '172.16.0.0/12' '192.168.0.0/16' --direction Outbound \
        --destination-address-prefixes '10.0.0.0/8' '172.16.0.0/12' '192.168.0.0/16' --destination-port-ranges '*' >/dev/null
}

# Add RFC1918 to all nsgs in the RG
function fix_all_nsgs () {
    nsg_list=$(az network nsg list -g "$rg" --query '[].name' -o tsv 2>/dev/null)
    echo "$nsg_list" | while read nsg
    do
        fix_nsg "$nsg"
    done
}

# Creates BGP-enabled VNG
# ASN as parameter is optional
function create_vng () {
    id=$1
    asn=$2
    if [[ -n "$2" ]]
    then
        asn=$2
    else
        asn=$(get_router_asn_from_id "${id}")
    fi
    vnet_name=vng${id}
    vnet_prefix=10.${id}.0.0/16
    subnet_prefix=10.${id}.0.0/24
    test_vm_name=testvm${id}
    test_vm_size=Standard_B1s
    test_vm_subnet_prefix=10.${id}.1.0/24
    type=$(get_router_type_from_id "$id")
    # Create vnet
    echo "Creating vnet $vnet_name..."
    az network vnet create -g "$rg" -n "$vnet_name" --address-prefix "$vnet_prefix" --subnet-name GatewaySubnet --subnet-prefix "$subnet_prefix" >/dev/null
    # Create test VM (to be able to see effective routes)
    # Not possible to create a test VM while a gateway is Updating, therefore starting the VM creation before the gateway
    test_vm_id=$(az vm show -n "$test_vm_name" -g "$rg" --query id -o tsv 2>/dev/null)
    if [[ -z "$test_vm_id" ]]
    then
        echo "Creating test virtual machine $test_vm_name in vnet $vnet_name in new subnet $test_vm_subnet_prefix..."
        az network vnet subnet create --vnet-name "$vnet_name" -g "$rg" -n testvm --address-prefixes "$test_vm_subnet_prefix" >/dev/null
        # Not using $psk as password because it might not fulfill the password requirements for Azure VMs
        az vm create -n "$test_vm_name" -g "$rg" -l "$location" --image UbuntuLTS --size "$test_vm_size" \
            --generate-ssh-keys --authentication-type all --admin-username "$default_username" --admin-password "$psk" \
            --public-ip-address "${test_vm_name}-pip" --public-ip-address-allocation static \
            --vnet-name "$vnet_name" --subnet testvm --no-wait 2>/dev/null
    else
        echo "Virtual machine $test_vm_name already exists"
    fi
    # Create PIPs for gateway (this gives time as well for the test VM NICs to be created and attached to the subnet)
    echo "Creating public IP addresses for gateway vng${id}..."
    az network public-ip create -g "$rg" -n "vng${id}a" >/dev/null
    az network public-ip create -g "$rg" -n "vng${id}b" >/dev/null
    # Create VNG
    vng_id=$(az network vnet-gateway show -n "vng${id}" -g "$rg" --query id -o tsv 2>/dev/null)
    if [[ -z "${vng_id}" ]]
    then
        if [[ "$type" ==  "vng" ]] || [[ "$type" ==  "vng2" ]]
        then
            echo "Creating VNG vng${id} in active/active mode..."
            az network vnet-gateway create -g "$rg" --sku VpnGw1 --gateway-type Vpn --vpn-type RouteBased \
            --vnet "$vnet_name" -n "vng${id}" --asn "$asn" --public-ip-address "vng${id}a" "vng${id}b" --no-wait
        elif [[ "$type" ==  "vng1" ]]
        then
            echo "Creating VNG vng${id} in active/passive mode..."
            az network vnet-gateway create -g "$rg" --sku VpnGw1 --gateway-type Vpn --vpn-type RouteBased \
            --vnet "$vnet_name" -n "vng${id}" --asn "$asn" --public-ip-address "vng${id}a" --no-wait
        else
            echo "Sorry, I do not understand the VNG type $type"
        fi
    else
        echo "VNG vng${id} already exists"
    fi
}

# Connect 2 VPN gateways to each other
function connect_gws () {
    gw1_id=$1
    gw2_id=$2
    cx_type=$3
    gw1_type=$(get_router_type_from_id "$gw1_id")
    gw2_type=$(get_router_type_from_id "$gw2_id")
    echo "Connecting vng${gw1_id} and vng${gw2_id}. Finding out information about the gateways..." 

    # Using Vnet-to-Vnet connections (no BGP supported)
    # az network vpn-connection create -g $rg -n ${gw1_id}to${gw2_id} \
    #   --enable-bgp --shared-key $psk \
    #   --vnet-gateway1 vng${gw1_id} --vnet-gateway2 vng${gw2_id}

    # Using local gws
    # Create Local Gateways for vpngw1
    vpngw1_name=vng${gw1_id}
    vpngw1_bgp_json=$(az network vnet-gateway show -n "$vpngw1_name" -g "$rg" --query 'bgpSettings' -o json 2>/dev/null)
    vpngw1_asn=$(echo "$vpngw1_bgp_json" | jq -r '.asn')
    vpngw1_gw0_pip=$(echo "$vpngw1_bgp_json" | jq -r '.bgpPeeringAddresses[0].tunnelIpAddresses[0]')
    vpngw1_gw0_bgp_ip=$(echo "$vpngw1_bgp_json" | jq -r '.bgpPeeringAddresses[0].defaultBgpIpAddresses[0]')
    if [[ ${gw1_type} == "vng" ]] || [[ ${gw1_type} == "vng2" ]]
    then
        vpngw1_gw1_pip=$(echo "$vpngw1_bgp_json" | jq -r '.bgpPeeringAddresses[1].tunnelIpAddresses[0]')
        vpngw1_gw1_bgp_ip=$(echo "$vpngw1_bgp_json" | jq -r '.bgpPeeringAddresses[1].defaultBgpIpAddresses[0]')    
        echo "Extracted info for vpngw1: ASN $vpngw1_asn, GW0 $vpngw1_gw0_pip, $vpngw1_gw0_bgp_ip. GW1 $vpngw1_gw1_pip, $vpngw1_gw1_bgp_ip."
    elif [[ "$gw1_type" ==  "vng1" ]]
    then
        echo "Extracted info for vpngw1: ASN $vpngw1_asn, $vpngw1_gw0_pip, $vpngw1_gw0_bgp_ip."
    else
        echo "Sorry, I do not understand the VNG type $gw1_type"
    fi

    echo "Creating local network gateways for vng${gw1_id}..."
    local_gw_id=$(az network local-gateway show -g "$rg" -n "${vpngw1_name}a" --query id -o tsv 2>/dev/null)
    if [[ -z "$local_gw_id" ]]
    then
        az network local-gateway create -g "$rg" -n "${vpngw1_name}a" --gateway-ip-address "$vpngw1_gw0_pip" \
            --local-address-prefixes "${vpngw1_gw0_bgp_ip}/32" --asn "$vpngw1_asn" --bgp-peering-address "$vpngw1_gw0_bgp_ip" --peer-weight 0 >/dev/null 2>&1
    else
        echo "Local gateway ${vpngw1_name}a already exists"
    fi
    # Create second local gateway only if the type is "vng" (default) or "vng2"
    if [[ ${gw1_type} == "vng" ]] || [[ ${gw1_type} == "vng2" ]]
    then
        local_gw_id=$(az network local-gateway show -g "$rg" -n "${vpngw1_name}b" --query id -o tsv 2>/dev/null)
        if [[ -z "$local_gw_id" ]]
        then
            az network local-gateway create -g "$rg" -n "${vpngw1_name}b" --gateway-ip-address "$vpngw1_gw1_pip" \
                --local-address-prefixes "${vpngw1_gw1_bgp_ip}/32" --asn "$vpngw1_asn" --bgp-peering-address "$vpngw1_gw1_bgp_ip" --peer-weight 0 >/dev/null 2>&1
        else
            echo "Local gateway ${vpngw1_name}b already exists"
        fi
    fi
    # Create Local Gateways for vpngw2
    vpngw2_name=vng${gw2_id}
    vpngw2_bgp_json=$(az network vnet-gateway show -n "$vpngw2_name" -g "$rg" -o json --query 'bgpSettings')
    vpngw2_asn=$(echo "$vpngw2_bgp_json" | jq -r '.asn')
    vpngw2_gw0_pip=$(echo "$vpngw2_bgp_json" | jq -r '.bgpPeeringAddresses[0].tunnelIpAddresses[0]')
    vpngw2_gw0_bgp_ip=$(echo "$vpngw2_bgp_json" | jq -r '.bgpPeeringAddresses[0].defaultBgpIpAddresses[0]')
    echo "Creating local network gateways for vng${gw2_id}..."
    local_gw_id=$(az network local-gateway show -g "$rg" -n "${vpngw2_name}a" --query id -o tsv 2>/dev/null)
    if [[ ${gw2_type} == "vng" ]] || [[ ${gw2_type} == "vng2" ]]
    then
        vpngw2_gw1_pip=$(echo "$vpngw2_bgp_json" | jq -r '.bgpPeeringAddresses[1].tunnelIpAddresses[0]')
        vpngw2_gw1_bgp_ip=$(echo "$vpngw2_bgp_json" | jq -r '.bgpPeeringAddresses[1].defaultBgpIpAddresses[0]')
        echo "Extracted info for vpngw2: ASN $vpngw2_asn GW0 $vpngw2_gw0_pip, $vpngw2_gw0_bgp_ip. GW1 $vpngw2_gw1_pip, $vpngw2_gw1_bgp_ip."
    elif [[ "$gw2_type" ==  "vng1" ]]
    then
        echo "Extracted info for vpngw1: ASN $vpngw2_asn, $vpngw2_gw0_pip, $vpngw2_gw0_bgp_ip."
    else
        echo "Sorry, I do not understand the VNG type $gw2_type"
    fi
    if [[ -z "$local_gw_id" ]]
    then
        az network local-gateway create -g "$rg" -n "${vpngw2_name}a" --gateway-ip-address "$vpngw2_gw0_pip" \
            --local-address-prefixes "${vpngw2_gw0_bgp_ip}/32" --asn "$vpngw2_asn" --bgp-peering-address "$vpngw2_gw0_bgp_ip" --peer-weight 0 >/dev/null 2>&1
    else
        echo "Local gateway ${vpngw2_name}a already exists"
    fi
    # Create second local gateway only if the type is "vng" (default) or "vng2"
    if [[ ${gw2_type} == "vng" ]] || [[ ${gw2_type} == "vng2" ]]
    then
        local_gw_id=$(az network local-gateway show -g "$rg" -n "${vpngw2_name}b" --query id -o tsv 2>/dev/null)
        if [[ -z "$local_gw_id" ]]
        then
            az network local-gateway create -g "$rg" -n "${vpngw2_name}b" --gateway-ip-address "$vpngw2_gw1_pip" \
                --local-address-prefixes "${vpngw2_gw1_bgp_ip}/32" --asn "$vpngw2_asn" --bgp-peering-address "$vpngw2_gw1_bgp_ip" --peer-weight 0 >/dev/null 2>&1
        else
            echo "Local gateway ${vpngw2_name}b already exists"
        fi
    fi
    # Create connections
    echo "Connecting vng${gw1_id} to local gateways for vng${gw2_id}..."
    if [[ "$cx_type" == "nobgp" ]]
    then
        bgp_option=""
    else
        bgp_option="--enable-bgp"
    fi
    # 1->2A
    az network vpn-connection create -n "vng${gw1_id}tovng${gw2_id}a" -g "$rg" --vnet-gateway1 "vng${gw1_id}" \
        --shared-key "$psk" --local-gateway2 "${vpngw2_name}a" $bgp_option >/dev/null
    # 1->2B
    if [[ ${gw2_type} == "vng" ]] || [[ ${gw2_type} == "vng2" ]]
    then
        az network vpn-connection create -n "vng${gw1_id}tovng${gw2_id}b" -g "$rg" --vnet-gateway1 "vng${gw1_id}" \
            --shared-key "$psk" --local-gateway2 "${vpngw2_name}b" $bgp_option >/dev/null
    fi
    echo "Connecting vng${gw2_id} to local gateways for vng${gw1_id}..."
    # 2->1A
    az network vpn-connection create -n "vng${gw2_id}tovng${gw1_id}a" -g "$rg" --vnet-gateway1 "vng${gw2_id}" \
        --shared-key "$psk" --local-gateway2 "${vpngw1_name}a" $bgp_option >/dev/null
    # 2->1B
    if [[ ${gw1_type} == "vng" ]] || [[ ${gw1_type} == "vng2" ]]
    then
        az network vpn-connection create -n "vng${gw2_id}tovng${gw1_id}b" -g "$rg" --vnet-gateway1 "vng${gw2_id}" \
            --shared-key "$psk" --local-gateway2 "${vpngw1_name}b" $bgp_option >/dev/null
    fi
}

# Deploy a VM in CSR's vnet, and configure CSR to route traffic
function create_vm_in_csr_vnet () {
    csr_id=$1
    csr_name=csr${csr_id}
    vnet_name=${csr_name}
    csr_vnet_prefix="10.${csr_id}.0.0/16"
    csr_subnet_prefix="10.${csr_id}.0.0/24"
    csr_bgp_ip="10.${csr_id}.0.10"
    vm_subnet_prefix="10.${csr_id}.1.0/24"
    vm_subnet_name=testvm
    vm_name=testvm${csr_id}
    vm_size=Standard_B1s
    rt_name="${vm_name}-rt"
    # Create VM
    test_vm_id=$(az vm show -n "$vm_name" -g "$rg" --query id -o tsv 2>/dev/null)
    if [[ -z "$test_vm_id" ]]
    then
        echo "Creating VM $vm_name in vnet $vnet_name..."
        az vm create -n "$vm_name" -g "$rg" -l "$location" --image ubuntuLTS --size $vm_size \
            --generate-ssh-keys --authentication-type all --admin-username "$default_username" --admin-password "$psk" \
            --public-ip-address "${vm_name}-pip" --vnet-name "$vnet_name" --public-ip-address-allocation static \
            --subnet "$vm_subnet_name" --subnet-address-prefix "$vm_subnet_prefix" --no-wait 2>/dev/null
        az network route-table create -n "$rt_name" -g "$rg" -l "$location" >/dev/null
        az network route-table route create -n localrange -g "$rg" --route-table-name "$rt_name" \
            --address-prefix "10.0.0.0/8" --next-hop-type VirtualAppliance --next-hop-ip-address "$csr_bgp_ip" >/dev/null
        az network vnet subnet update -n "$vm_subnet_name" --vnet-name "$vnet_name" -g "$rg" --route-table "$rt_name" >/dev/null
    else
        echo "Virtual machine $vm_name already exists"
    fi
    # Setting IP Forwarding for CSR
    echo "Enabling IP forwarding for $csr_name..."
    csr_nic_id=$(az vm show -n "$csr_name-nva" -g "$rg" --query 'networkProfile.networkInterfaces[0].id' -o tsv)
    az network nic update --ids $csr_nic_id --ip-forwarding >/dev/null
}

function accept_csr_terms () {
    publisher=cisco
    offer=cisco-csr-1000v
    sku=16_12-byol
    # sku=17_3_4a-byol  # Newest version available
    version=$(az vm image list -p $publisher -f $offer -s $sku --all --query '[0].version' -o tsv 2>/dev/null)
    # Accept terms
    echo "Accepting image terms for ${publisher}:${offer}:${sku}:${version}..."
    az vm image terms accept --urn "${publisher}:${offer}:${sku}:${version}" >/dev/null
    # Verify
    status=$(az vm image terms show --urn "${publisher}:${offer}:${sku}:${version}" --query accepted -o tsv 2>/dev/null)
    if [[ "$status" != "true" ]]
    then
        echo "Marketplace image terms for ${publisher}:${offer}:${sku}:${version} could not be accepted, do you have access at the subscription level?"
        exit
    fi
}

# Creates a CSR NVA
# Example: create_csr 1
function create_csr () {
    csr_id=$1
    csr_name=csr${csr_id}
    csr_vnet_prefix="10.${csr_id}.0.0/16"
    csr_subnet_prefix="10.${csr_id}.0.0/24"
    csr_bgp_ip="10.${csr_id}.0.10"
    publisher=cisco
    offer=cisco-csr-1000v
    sku=16_12-byol
    # sku=17_3_4a-byol  # Newest version available
    version=$(az vm image list -p $publisher -f $offer -s $sku --all --query '[0].version' -o tsv 2>/dev/null)
    nva_size=Standard_B2ms
    # Create CSR
    echo "Creating VM csr${csr_id}-nva in Vnet $csr_vnet_prefix..."
    vm_id=$(az vm show -n "csr${csr_id}-nva" -g "$rg" --query id -o tsv 2>/dev/null)
    if [[ -z "$vm_id" ]]
    then
        az vm create -n "csr${csr_id}-nva" -g "$rg" -l "$location" --image "${publisher}:${offer}:${sku}:${version}" --size "$nva_size" \
            --generate-ssh-keys --public-ip-address "csr${csr_id}-pip" --public-ip-address-allocation static \
            --vnet-name "$csr_name" --vnet-address-prefix "$csr_vnet_prefix" --subnet nva --subnet-address-prefix "$csr_subnet_prefix" \
            --private-ip-address "$csr_bgp_ip" --no-wait 2>/dev/null
        sleep 30 # Wait 30 seconds for the creation of the PIP
    else
        echo "VM csr${csr_id}-nva already exists"
    fi
    # Adding UDP ports 500 and 4500 to NSG
    nsg_name=csr${csr_id}-nvaNSG
    az network nsg rule create --nsg-name "$nsg_name" -g "$rg" -n ike --priority 1010 \
      --source-address-prefixes Internet --destination-port-ranges 500 4500 --access Allow --protocol Udp \
      --description "UDP ports for IKE"  >/dev/null
    # Get public IP
    csr_ip=$(az network public-ip show -n "csr${csr_id}-pip" -g "$rg" --query ipAddress -o tsv)
    # Create Local Network Gateway
    echo "CSR created with IP address $csr_ip. Creating Local Network Gateway now..."
    asn=$(get_router_asn_from_id "$csr_id")
    local_gw_id=$(az network local-gateway show -g "$rg" -n "${csr_name}" --query id -o tsv 2>/dev/null)
    if [[ -z "$local_gw_id" ]]
    then
        az network local-gateway create -g "$rg" -n "$csr_name" --gateway-ip-address "$csr_ip" \
            --local-address-prefixes "${csr_bgp_ip}/32" --asn "$asn" --bgp-peering-address "$csr_bgp_ip" --peer-weight 0 >/dev/null 2>&1
    else
        echo "Local gateway ${csr_name} already exists"
    fi
}

# Connects a CSR to one VNG
function connect_csr () {
    csr_id=$1
    gw_id=$2
    cx_type=$3
    gw_type=$(get_router_type_from_id "$gw_id")
    # csr_asn=$(get_router_asn_from_id $csr_id)  # Not used

    vpngw_name=vng${gw_id}
    vpngw_bgp_json=$(az network vnet-gateway show -n "$vpngw_name" -g "$rg" --query 'bgpSettings' -o json 2>/dev/null)
    vpngw_asn=$(echo "$vpngw_bgp_json" | jq -r '.asn')
    vpngw_gw0_pip=$(echo "$vpngw_bgp_json" | jq -r '.bgpPeeringAddresses[0].tunnelIpAddresses[0]')
    vpngw_gw0_bgp_ip=$(echo "$vpngw_bgp_json" | jq -r '.bgpPeeringAddresses[0].defaultBgpIpAddresses[0]')
    if [[ ${gw_type} == "vng" ]] || [[ ${gw_type} == "vng2" ]]
    then
        vpngw_gw1_pip=$(echo "$vpngw_bgp_json" | jq -r '.bgpPeeringAddresses[1].tunnelIpAddresses[0]')
        vpngw_gw1_bgp_ip=$(echo "$vpngw_bgp_json" | jq -r '.bgpPeeringAddresses[1].defaultBgpIpAddresses[0]')    
        echo "Extracted info for vpngw: ASN $vpngw_asn, GW0 $vpngw_gw0_pip, $vpngw_gw0_bgp_ip. GW1 $vpngw_gw1_pip, $vpngw_gw1_bgp_ip."
    elif [[ "$gw_type" ==  "vng1" ]]
    then
        echo "Extracted info for vpngw: ASN $vpngw_asn, $vpngw_gw0_pip, $vpngw_gw0_bgp_ip."
    else
        echo "Sorry, I do not understand the VNG type $gw_type"
    fi

    # Tunnels for vpngw (IKEv2)
    echo "Configuring tunnels between CSR $csr_id and VPN GW $gw_id"
    config_csr_tunnel "$csr_id" "${csr_id}${gw_id}0" "$vpngw_gw0_pip" "$vpngw_gw0_bgp_ip" "$(get_router_asn_from_id "$gw_id")" ikev2 "$cx_type"
    if [[ ${gw_type} == "vng" ]] || [[ ${gw_type} == "vng2" ]]
    then
        config_csr_tunnel "$csr_id" "${csr_id}${gw_id}1" "$vpngw_gw1_pip" "$vpngw_gw1_bgp_ip" "$(get_router_asn_from_id "$gw_id")" ikev2 "$cx_type"
    fi

    # Connect Local GWs to VNGs
    echo "Creating VPN connections in Azure..."
    if [[ "$cx_type" == "nobgp" ]]
    then
        bgp_option=""
    else
        bgp_option="--enablebgp"
    fi
    az network vpn-connection create -n "vng${gw_id}tocsr${csr_id}" -g "$rg" --vnet-gateway1 "vng${gw_id}" \
        --shared-key "$psk" --local-gateway2 "csr${csr_id}" $bgp_option >/dev/null 2>&1
    if [[ -n "$gw2_id" ]]
    then
        az network vpn-connection create -n "vng${gw2_id}tocsr${csr_id}" -g "$rg" --vnet-gateway1 "vng${gw2_id}" \
            --shared-key "$psk" --local-gateway2 "csr${csr_id}" $bgp_option >/dev/null 2>&1
    fi
}

# Run "show interface ip brief" on CSR
function sh_csr_int () {
    csr_id=$1
    csr_ip=$(az network public-ip show -n "csr${csr_id}-pip" -g "$rg" -o tsv --query ipAddress 2>/dev/null)
    ssh -n -o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group14-sha1 -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa "$csr_ip" "sh ip int b" 2>/dev/null
}

# Open an interactive SSH session to a CSR
function ssh_csr () {
    csr_id=$1
    csr_ip=$(az network public-ip show -n "csr${csr_id}-pip" -g "$rg" -o tsv --query ipAddress 2>/dev/null)
    ssh "$csr_ip"
}

# Deploy baseline VPN and BGP config to a Cisco CSR
function config_csr_base () {
    csr_id=$1
    csr_ip=$(az network public-ip show -n "csr${csr_id}-pip" -g "$rg" -o tsv --query ipAddress 2>/dev/null)
    asn=$(get_router_asn_from_id "$csr_id")
    myip=$(curl -s4 ifconfig.co)
    # Check we have a valid IP
    until [[ $myip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]
    do
        sleep 5
        myip=$(curl -s4 ifconfig.co)
    done
    echo "Our IP seems to be $myip"
    default_gateway="10.${csr_id}.0.1"
    echo "Configuring CSR ${csr_ip} for VPN and BGP..."
    username=$(whoami)
    password=$psk
    ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group14-sha1 -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa "$csr_ip" >/dev/null 2>&1 <<EOF
    config t
      username ${username} password 0 ${password}
      username ${username} privilege 15
      username ${default_username} password 0 ${password}
      username ${default_username} privilege 15
      no ip domain lookup
      no ip ssh timeout
      crypto ikev2 keyring azure-keyring
      crypto ikev2 proposal azure-proposal
        encryption aes-cbc-256 aes-cbc-128 3des
        integrity sha1
        group 2
      crypto ikev2 policy azure-policy
        proposal azure-proposal
      crypto ikev2 profile azure-profile
        match address local interface GigabitEthernet1
        authentication remote pre-share
        authentication local pre-share
        keyring local azure-keyring
      crypto ipsec transform-set azure-ipsec-proposal-set esp-aes 256 esp-sha-hmac
        mode tunnel
      crypto ipsec profile azure-vti
        set security-association lifetime kilobytes 102400000
        set transform-set azure-ipsec-proposal-set
        set ikev2-profile azure-profile
      crypto isakmp policy 1
        encr aes
        authentication pre-share
        group 14
      crypto ipsec transform-set csr-ts esp-aes esp-sha-hmac
        mode tunnel
      crypto ipsec profile csr-profile
        set transform-set csr-ts
      router bgp $asn
        bgp router-id interface GigabitEthernet1
        network 10.${csr_id}.0.0 mask 255.255.0.0
        bgp log-neighbor-changes
        maximum-paths eibgp 4
      ip route ${myip} 255.255.255.255 ${default_gateway}
      ip route 10.${csr_id}.0.0 255.255.0.0 ${default_gateway}
      line vty 0 15
        exec-timeout 0 0
    end
    wr mem
EOF
}

# Configure a tunnel a BGP neighbor for a specific remote endpoint on a Cisco CSR
# "mode" can be either IKEv2 or ISAKMP. I havent been able to bring up 
#   a CSR-to-CSR connection using IKEv2, hence my workaround is using isakmp.
function config_csr_tunnel () {
    csr_id=$1
    tunnel_id=$2
    public_ip=$3
    private_ip=$4
    remote_asn=$5
    mode=$6
    cx_type=$7  # Can be none, ospf, bgpospf or empty (bgp per default)
    if [[ -z "$mode" ]]
    then
        mode=ikev2
    fi
    if [[ "$mode" == "ikev2" ]]
    then
        ipsec_profile="azure-vti"
    else
        ipsec_profile="csr-profile"
    fi
    asn=$(get_router_asn_from_id "${csr_id}")
    default_gateway="10.${csr_id}.0.1"
    csr_ip=$(az network public-ip show -n "csr${csr_id}-pip" -g "$rg" -o tsv --query ipAddress)
    echo "Configuring tunnel ${tunnel_id} in CSR ${csr_ip}..."
    ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group14-sha1 -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa "$csr_ip" >/dev/null 2>&1 <<EOF
    config t
      crypto ikev2 keyring azure-keyring
        peer ${public_ip}
          address ${public_ip}
          pre-shared-key ${psk}
      crypto ikev2 profile azure-profile
        match identity remote address ${public_ip} 255.255.255.255
      crypto isakmp key ${psk} address ${public_ip}
      interface Tunnel${tunnel_id}
        ip unnumbered GigabitEthernet1
        ip tcp adjust-mss 1350
        tunnel source GigabitEthernet1
        tunnel mode ipsec ipv4
        tunnel destination ${public_ip}
        tunnel protection ipsec profile ${ipsec_profile}
      ip route ${private_ip} 255.255.255.255 Tunnel${tunnel_id}
      ip route ${public_ip} 255.255.255.255 ${default_gateway}
    end
    wr mem
EOF
    if [[ -z "$cx_type" ]] || [[ "$cx_type" == "bgp" ]] || [[ "$cx_type" == "bgpospf" ]]
    then
      echo "Configuring BGP on tunnel ${tunnel_id} in CSR ${csr_ip}..."
      ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group14-sha1 -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa "$csr_ip" >/dev/null 2>&1 <<EOF
        config t
          router bgp ${asn}
            neighbor ${private_ip} remote-as ${remote_asn}
            neighbor ${private_ip} update-source GigabitEthernet1
        end
        wr mem
EOF
      if [[ "$asn" == "$remote_asn" ]]
      then
        # iBGP
        ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group14-sha1 -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa "$csr_ip" >/dev/null 2>&1 <<EOF
            config t
              router bgp ${asn}
                neighbor ${private_ip} next-hop-self
            end
            wr mem
EOF
      else
        # eBGP
        ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group14-sha1 -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa "$csr_ip" >/dev/null 2>&1 <<EOF
            config t
              router bgp ${asn}
                neighbor ${private_ip} ebgp-multihop 5
            end
            wr mem
EOF
      fi
    elif [[ "$cx_type" == "ospf" ]] || [[ "$cx_type" == "bgpospf" ]]
    then
      echo "Configuring OSPF on tunnel ${tunnel_id} in CSR ${csr_ip}..."
      ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group14-sha1 -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa "$csr_ip" >/dev/null 2>&1 <<EOF
        config t
          router ospf 100
            no passive-interface Tunnel${tunnel_id}
            network 10.${csr_id}.0.0 255.255.0.0 area 0
        end
        wr mem
EOF
    elif [[ "$cx_type" == "static" ]]  ## Not used
    then
      echo "Configuring static routes for tunnel ${tunnel_id} in CSR ${csr_ip}..."
      remote_id=$(echo "$tunnel_id" | head -c 2 | tail -c 1) # This only works with a max of 9 routers
      echo "Configuring OSPF on tunnel ${tunnel_id} in CSR ${csr_ip}..."
      ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group14-sha1 -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa "$csr_ip" >/dev/null 2>&1 <<EOF
        config t
          ip route 10.${remote_id}.0.0 255.255.0.0 Tunnel${tunnel_id}
        end
        wr mem
EOF
    else
        echo "No routing protocol configured on ${tunnel_id} in CSR ${csr_ip}..."
    fi
}

# Connect two CSRs to each other over IPsec and BGP
function connect_csrs () {
    csr1_id=$1
    csr2_id=$2
    cx_type=$3
    csr1_ip=$(az network public-ip show -n "csr${csr1_id}-pip" -g "$rg" -o tsv --query ipAddress)
    csr2_ip=$(az network public-ip show -n "csr${csr2_id}-pip" -g "$rg" -o tsv --query ipAddress)
    csr1_asn=$(get_router_asn_from_id "${csr1_id}")
    csr2_asn=$(get_router_asn_from_id "${csr2_id}")
    csr1_bgp_ip="10.${csr1_id}.0.10"
    csr2_bgp_ip="10.${csr2_id}.0.10"
    # Tunnel from csr1 to csr2 (using ISAKMP instead of IKEv2)
    tunnel_id=${csr1_id}${csr2_id}
    config_csr_tunnel "$csr1_id" "$tunnel_id" "$csr2_ip" "$csr2_bgp_ip" "$csr2_asn" isakmp "$cx_type"
    # Tunnel from csr2 to csr1 (using ISAKMP instead of IKEv2)
    tunnel_id=${csr2_id}${csr1_id}
    config_csr_tunnel "$csr2_id" "$tunnel_id" "$csr1_ip" "$csr1_bgp_ip" "$csr1_asn" isakmp "$cx_type"
}

# Configure logging
function init_log () {
    logws_name=$(az monitor log-analytics workspace list -g "$rg" --query '[0].name' -o tsv 2>/dev/null)
    if [[ -z "$logws_name" ]]
    then
        logws_name=log$RANDOM
        echo "Creating LA workspace $logws_name..."
        az monitor log-analytics workspace create -n $logws_name -g "$rg" >/dev/null 2>/dev/null
    else
        echo "Found log analytics workspace $logws_name"
    fi
    logws_id=$(az resource list -g "$rg" -n "$logws_name" --query '[].id' -o tsv)
    logws_customerid=$(az monitor log-analytics workspace show -n "$logws_name" -g "$rg" --query customerId -o tsv)
}

# Configures a certain VNG for logging to a previously created LA workspace
function log_gw () {
  gw_id=$1
  vpngw_id=$(az network vnet-gateway show -n "vng${gw_id}" -g "$rg" --query id -o tsv)
  echo "Configuring diagnostic settings for gateway vng${gw_id}"
  az monitor diagnostic-settings create -n mydiag --resource "$vpngw_id" --workspace "$logws_id" \
      --metrics '[{"category": "AllMetrics", "enabled": true, "retentionPolicy": {"days": 0, "enabled": false }, "timeGrain": null}]' \
      --logs '[{"category": "GatewayDiagnosticLog", "enabled": true, "retentionPolicy": {"days": 0, "enabled": false}}, 
              {"category": "TunnelDiagnosticLog", "enabled": true, "retentionPolicy": {"days": 0, "enabled": false}},
              {"category": "RouteDiagnosticLog", "enabled": true, "retentionPolicy": {"days": 0, "enabled": false}},
              {"category": "IKEDiagnosticLog", "enabled": true, "retentionPolicy": {"days": 0, "enabled": false}}]' >/dev/null
}

# Gets IKE logs from Log Analytics
# Possible improvements:
# - Supply time and max number of msgs as parameters
function get_ike_logs () {
  query='AzureDiagnostics 
  | where ResourceType == "VIRTUALNETWORKGATEWAYS" 
  | where Category == "IKEDiagnosticLog" 
  | where TimeGenerated >= ago(5m) 
  | project Message
  | take 20'
  az monitor log-analytics query -w "$logws_customerid" --analytics-query "$query" -o tsv
}

# Creates a connection between two routers
# The function to call depends on whether they are CSRs or VNGs
function create_connection () {
      # Split router_params, different syntax for BASH and ZSH
      if [ -n "$BASH_VERSION" ]; then
          arr_opt=a
      elif [ -n "$ZSH_VERSION" ]; then
          arr_opt=A
      fi
      IFS=':' read -r"$arr_opt" router_params <<< "$1"
      if [ -n "$BASH_VERSION" ]; then
          router1_id="${router_params[0]}"
          router2_id="${router_params[1]}"
          cx_type="${router_params[2]}"
      elif [ -n "$ZSH_VERSION" ]; then
          router1_id="${router_params[1]}"
          router2_id="${router_params[2]}"
          cx_type="${router_params[3]}"
      else
          echo "Error identifying shell, it looks like neither BASH or ZSH!"
      fi
      router1_type=$(get_router_type_from_id "$router1_id")
      router2_type=$(get_router_type_from_id "$router2_id")
      echo "Creating connection between ${router1_type} ${router1_id} and ${router2_type} ${router2_id}, type \"${cx_type}\"..."
      if [[ "$router1_type" == "vng" ]] || [[ "$router1_type" == "vng1" ]] || [[ "$router1_type" == "vng2" ]]
      then
          # VNG-to-VNG
          if [[ "$router2_type" == "vng" ]] || [[ "$router2_type" == "vng1" ]] || [[ "$router2_type" == "vng2" ]]
          then
              connect_gws "$router1_id" "$router2_id" "$cx_type"
          # VNG-to-CSR
          else
              connect_csr "$router2_id" "$router1_id" "$cx_type"
          fi
      else
          # CSR-to-VNG
          if [[ "$router2_type" == "vng" ]] || [[ "$router2_type" == "vng1" ]] || [[ "$router2_type" == "vng2" ]]
          then
              connect_csr "$router1_id" "$router2_id" "$cx_type"
          # CSR-to-CSR
          else
              connect_csrs "$router1_id" "$router2_id" "$cx_type"
          fi
      fi
}

# Get router type for a specific router ID
function get_router_type_from_id () {
    id=$1
    for router in "${routers[@]}"
    do
        this_id=$(get_router_id "$router")
        if [[ "$id" -eq "$this_id" ]]
        then
            get_router_type "$router"
        fi
    done
}

# Get router ASN for a specific router ID
function get_router_asn_from_id () {
    id=$1
    for router in "${routers[@]}"
    do
        this_id=$(get_router_id  "$router")
        if [[ "$id" -eq "$this_id" ]]
        then
            get_router_asn "$router"
        fi
    done
}

# Verifies a VNG or CSR has been created in Azure
function verify_router () {
    router=$1
    echo "Verifying $router..."
    type=$(get_router_type "$router")
    id=$(get_router_id  "$router")
    if [[ "$type" == "csr" ]]
    then
        vm_status=$(az vm show -n "csr${id}-nva" -g "$rg" --query provisioningState -o tsv)
        ip=$(az network public-ip show -n "csr${id}-pip" -g "$rg" --query ipAddress -o tsv)
        echo "VM csr${id}-nva status is ${vm_status}, public IP is ${ip}"
    else
        gw_status=$(az network vnet-gateway show -n "vng${id}" -g "$rg" --query provisioningState -o tsv)
        # ip_a=$(az network public-ip show -n "vng${id}a" -g "$rg" --query ipAddress -o tsv)
        # ip_b=$(az network public-ip show -n "vng${id}b" -g "$rg" --query ipAddress -o tsv)
        # echo "Gateway vng${id} status is ${gw_status}, public IPs are ${ip_a} and ${ip_b}"
        echo "Gateway vng${id} status is ${gw_status}"
    fi
}

# Showing BGP neighbors for a certain router
function show_bgp_neighbors () {
    router=$1
    echo "Getting BGP neighbors for router $router..."
    type=$(get_router_type "$router")
    id=$(get_router_id  "$router")
    if [[ "$type" == "csr" ]]
    then
        ip=$(az network public-ip show -n "csr${id}-pip" -g "$rg" --query ipAddress -o tsv)
        neighbors=$(ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group14-sha1 -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa "$ip" "show ip bgp summary | begin Neighbor" 2>/dev/null)
        echo "BGP neighbors for csr${id}-nva (${ip}):"
        clean_string "$neighbors"
    else
        neighbors=$(az network vnet-gateway list-bgp-peer-status -n "vng${id}" -g "$rg" -o table 2>/dev/null)
        echo "BGP neighbors for vng${id}:"
        echo "$neighbors"
    fi
}

# Create a VNG or a CSR, configuration given by a colon-separated parameter string (like "1:vng:65515")
function create_router () {
    type=$(get_router_type  "$router")
    id=$(get_router_id  "$router")
    asn=$(get_router_asn  "$router")
    echo "Creating router of type $type, id $id, ASN $asn..."
    case $type in
    "vng"|"vng1"|"vng2")
        create_vng "$id" "$asn"
        ;;
    "csr")
        create_csr "$id"
        ;;
    esac
}

# Gets the type out of a router configuration (like csr in "1:csr:65515")
function get_router_type () {
      # Split router_params, different syntax for BASH and ZSH
      if [ -n "$BASH_VERSION" ]; then
          arr_opt=a
      elif [ -n "$ZSH_VERSION" ]; then
          arr_opt=A
      fi
      IFS=':' read -r"$arr_opt" router_params <<< "$1"
      # In BASH array indexes start with 0, in ZSH with 1
      if [ -n "$BASH_VERSION" ]; then
          echo "${router_params[1]}"
      elif [ -n "$ZSH_VERSION" ]; then
          echo "${router_params[2]}"
      fi
}

# Gets the ID out of a router configuration (like 1 in "1:csr:65515")
function get_router_id () {
      # Split router_params, different syntax for BASH and ZSH
      if [ -n "$BASH_VERSION" ]; then
          arr_opt=a
      elif [ -n "$ZSH_VERSION" ]; then
          arr_opt=A
      fi
      IFS=':' read -r"$arr_opt" router_params <<< "$1"
      # In BASH array indexes start with 0, in ZSH with 1
      if [ -n "$BASH_VERSION" ]; then
          echo "${router_params[0]}"
      elif [ -n "$ZSH_VERSION" ]; then
          echo "${router_params[1]}"
      fi
}

# Gets the ASN out of a router configuration (like 65001 in "1:csr:65001")
function get_router_asn () {
      # Split router_params, different syntax for BASH and ZSH
      if [ -n "$BASH_VERSION" ]; then
          arr_opt=a
      elif [ -n "$ZSH_VERSION" ]; then
          arr_opt=A
      fi
      IFS=':' read -r"$arr_opt" router_params <<< "$1"
      # In BASH array indexes start with 0, in ZSH with 1
      if [ -n "$BASH_VERSION" ]; then
          echo "${router_params[2]}"
      elif [ -n "$ZSH_VERSION" ]; then
          echo "${router_params[3]}"
      fi
}

# Wait until all VNGs in the router list finish provisioning
function wait_for_gws_finished () {
    for router in "${routers[@]}"
    do
        type=$(get_router_type "$router")
        id=$(get_router_id "$router")
        if [[ "$type" == "vng" ]] || [[ "$type" == "vng1" ]] || [[ "$type" == "vng2" ]]
        then
            vng_name=vng${id}
            vpngw_id=$(az network vnet-gateway show -n "$vng_name" -g "$rg" --query id -o tsv 2>/dev/null)
            wait_until_finished "$vpngw_id"
        fi
    done
}

# Configure logging to LA for all gateways
function config_gw_logging () {
    for router in "${routers[@]}"
    do
        type=$(get_router_type "$router")
        id=$(get_router_id "$router")
        if [[ "$type" == "vng" ]] || [[ "$type" == "vng1" ]] || [[ "$type" == "vng2" ]]
        then
            log_gw "$id"
        fi
    done
}

# Deploy base config for all CSRs
function config_csrs_base () {
    for router in "${routers[@]}"
    do
        type=$(get_router_type  "$router")
        id=$(get_router_id  "$router")
        if [[ "$type" == "csr" ]]
        then
            config_csr_base "$id"
            create_vm_in_csr_vnet "$id"
        fi
    done
}

# Add an additional users to each test VM
function add_users_to_vms () {
    vm_list=$(az vm list -o tsv -g "$rg" --query "[?contains(name,'testvm')].name")
    while IFS= read -r vm_name; do
        az vm user update -g $rg -u "$default_username" -p "$psk" -n "$vm_name"
    done <<< "$vm_list"
}

# Converts a CSV list to a shell array
function convert_csv_to_array () {
    if [ -n "$BASH_VERSION" ]; then
        arr_opt=a
    elif [ -n "$ZSH_VERSION" ]; then
        arr_opt=A
    fi
    IFS=',' read -r"${arr_opt}" myarray <<< "$1"
    echo "${myarray[@]}"
}

# Checks that the PSK complies with password rules for VMs
# Returns a message if the password is not compliant with pasword rules, returns nothing if it is
function check_password () {
    password_to_check=$1
    password_to_check_len=${#password_to_check}
    # Length
    if [ "$password_to_check_len" -lt 12 ]; then
        echo "$password_to_check is shorter than 12 characters"
    else
        # Special characters
        if [[ -z $(echo "$password_to_check" | tr -d "[:alnum:]") ]]; then
            echo "$password_to_check does not contain non alphanumeric characters"
        else
            # Numbers
            if [[ -z $(echo "$password_to_check" | tr -cd "0-9") ]]; then
                echo "$password_to_check does not contain numbers"
            else
                # Lower case
                if [[ -z $(echo "$password_to_check" | tr -cd "a-z") ]]; then
                    echo "$password_to_check does not contain lower case characters"
                else
                    # Upper case
                    if [[ -z $(echo "$password_to_check" | tr -cd "A-Z") ]]; then
                        echo "$password_to_check does not contain upper case characters"
                    fi
                fi
            fi
        fi
    fi
}

# Verify certain things:
# - Presence of required binaries
# - Presence of requirec az extensions
# - Azure CLI logged in
function perform_system_checks () {
    # Verify software dependencies
    for binary in "ssh" "jq" "az" "awk"
    do
        binary_path=$(which "$binary")
        if [[ -z "$binary_path" ]]
        then
            echo "It seems that $binary is not installed in the system. Please install it before trying this script again"
            exit
        fi
    done
    echo "All dependencies checked successfully"

    # Verify az is logged in
    subscription_name=$(az account show --query name -o tsv 2>/dev/null)
    if [[ -z "$subscription_name" ]]
    then
        echo "It seems you are not logged into Azure with the Azure CLI. Please use \"az login\" before trying this script again"
        exit
    fi

    # Verify required az extensions installed
    for extension_name in "log-analytics"
    do
        extension_version=$(az extension show -n $extension_name --query version -o tsv 2>/dev/null)
        if [[ -z "$extension_version" ]]
        then
            echo "It seems that the Azure CLI extension \"$extension_name\" is not installed. Please install it with \"az extension add -n $extension_name\" before trying this script again"
            exit
        else
            echo "Azure CLI extension \"$extension_name\" found with version $extension_version"
        fi
    done
}

########
# Main #
########

# Variables
default_username=labadmin

# Perform some system checks
perform_system_checks

# Create lab variable from arguments, or use default
if [ -n "$BASH_VERSION" ]; then
    echo "Running on BASH"
elif [ -n "$ZSH_VERSION" ]; then
    echo "Running on ZSH"
fi
if [[ -n "$1" ]]
then
    # echo "Converting CSV string to array: $1"
    routers=($(convert_csv_to_array "$1"))
    # echo ""${#routers[@]}" routers identified"
else
    echo "Using sample values for routers"
    routers=("1:vng:65501" "2:vng:65502" "3:csr:65001" "4:csr:65001")
fi
if [[ -n "$2" ]]
then
    # echo "Converting CSV string to array: $2"
    connections=($(convert_csv_to_array "$2"))
else
    echo "Using sample values for connections"
    connections=("1:2" "1:3" "2:4" "3:4")
fi
if [[ -n "$3" ]]
then
    rg=$3
else
    rg=bgp
    echo "No resource group specified in the command line, using $rg"
fi
if [[ -n "$4" ]]
then
    location=$4
else
    location=westeurope
    echo "No location specified in the command line, using $location"
fi
if [[ -n "$5" ]]
then
    psk=$5
    if [[ -n "$(check_password $psk)" ]]
    then
        echo "$(check_password $psk)"
        exit 1
    fi
else
    psk=Microsoft123!
    echo "No preshared key specified in the command line, using $psk"
fi

# Ask confirmation before starting creating stuff
# [[ $BASH_VERSION ]] && read -rsn1 -p"Press any key to start creating Azure resources into Azure subscription \"$subscription_name\"...";echo
# [[ $ZSH_VERSION ]] && read -krs "?Press any key to start creating Azure resources into Azure subscription \"$subscription_name\"...";echo

# Accept CSR image terms
accept_csr_terms

# Create resource group
echo "Creating resource group \"$rg\" in subscription \"$subscription_name\"..."
az group create -n "$rg" -l "$location" >/dev/null

# Deploy CSRs and VNGs
# echo "Routers array: $routers"
for router in "${routers[@]}"
do
    create_router "$router"
done

# Verify VMs/VNGs exist
for router in "${routers[@]}"
do
    verify_router "$router"
done

# Config BGP routers
wait_for_csrs_finished
config_csrs_base

# Fix NSGs to allow all traffic between RFC1918 addresses
fix_all_nsgs

# Wait for VNGs to finish provisioning and configuring logging
wait_for_gws_finished
init_log
config_gw_logging

# Configure connections
for connection in "${connections[@]}"
do
    create_connection "$connection"
done

# Verify VMs/VNGs exist
for router in "${routers[@]}"
do
    show_bgp_neighbors "$router"
done

# Finish
echo "Your resources should be ready to use in resource group $rg. Username/password for access is ${default_username}/${psk}. Enjoy!"

################################
# Sample diagnostics commands: #
################################
# az network vnet-gateway list -g $rg -o table
# az network local-gateway list -g $rg -o table
# az network vpn-connection list -g $rg -o table
# az network public-ip list -g $rg -o table
# az network vnet-gateway list-bgp-peer-status -n vng1 -g $rg -o table
# az network vnet-gateway list-learned-routes -n vng1 -g $rg -o table
# az network vnet-gateway list-advertised-routes -n vng1 -g $rg -o table
# az network nic show-effective-route-table -n testvm1VMNic -g $rg -o table
# sh_csr_int 4
