# Challenge 3: Isolated Virtual Networks - Coach's Guide

[< Previous Challenge](./02-vpn.md) - **[Home](./README.md)** - [Next Challenge >](./04-secured_hub.md)

## Notes and Guidance

- Here again, you might want to create the VNets before the actual event

## Solution Guide

### Creating VNets 3 and 4 in hubs

Creates two additional VNets:

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

### Modifying custom routing to achieve VNet isolation

Creates new route tables and changes association/propagation settings:

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
