# Challenge 5: Network Virtual Appliance - Coach's Guide

[< Previous Challenge](./04-secured_hub.md) - **[Home](./README.md)**

## Notes and Guidance

- You might want to create the NVAs previously to the event
- Prod <-> NVA <-> Dev is not going to work
- Prod <-> NVA <-> Internet is working since March 2021

## Solution Guide

### Convert VM in Common Services VNet to an NVA

Enable IP forwarding in Azure and inside the VM for hub1:

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

And the same for hub2:

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

### Create indirect spokes

Create some additional Vnets, and peer them to the NVA Vnet in region 1 (not to Virtual WAN):

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

And region 2:

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

### Inject routes for indirect spokes

Create some static routes in Virtual WAN, so that it knows where to reach the indirect spokes:

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

### Connectivity tests

You can use this code for connectivity tests:

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
