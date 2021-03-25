# Challenge 8: iBGP Between VNG Instances - Coach's Guide

[< Previous Challenge](./07-default.md) - **[Home](./README.md)**

## Notes and Guidance

A mistake that is sometimes done in Azure is breaking iBGP between Virtual Network Gateways by having the wrong route in the GatewaySubnet. One relatively common situation when customers do this is when having shared services in the hub VNet. Customers might define a UDR for the whole VNet range pointing to an NVA, and put it on all subnets (including the GatewaySubnet).

## Solution Guide

We will create a route table in the Virtual Network for the GatewaySubnet, and send all traffic to the vnet to the test VM (which will drop it, since it is not configured to forward traffic):

```bash
# Deploy route table to GatewaySubnet in vnet2
vnet_name=vng2
location=$(az network vnet show -n $vnet_name -g $rg --query location -o tsv) && echo $location
vnet_prefix=$(az network vnet show -n $vnet_name -g $rg --query 'addressSpace.addressPrefixes[0]' -o tsv) && echo $vnet_prefix
testvm_private_ip=$(az vm list-ip-addresses -n testvm2 -g $rg --query '[0].virtualMachine.network.privateIpAddresses[0]' -o tsv) && echo $testvm_private_ip
rt_name=gateways
az network route-table create -n $rt_name -g $rg -l $location
az network route-table route create -n hub --route-table-name $rt_name -g $rg \
    --next-hop-type VirtualAppliance --address-prefix "$vnet_prefix" --next-hop-ip-address $testvm_private_ip
rt_id=$(az network route-table show -n $rt_name -g $rg --query id -o tsv)
az network vnet subnet update -g $rg --vnet-name $vnet_name -n GatewaySubnet --route-table $rt_id
```

We can have a look at the neighbors of the gateways, but now some commands might be broken:

```
❯ az network vnet-gateway list-bgp-peer-status -n vng2 -g $rg -o table
Deployment failed. Error occurred in request., RetryError: HTTPSConnectionPool(host='management.azure.com', port=443): Max retries exceeded with url: /subscriptions/e7da9914-9b05-4891-893c-546cb7b0422e/providers/Microsoft.Network/locations/northeurope/operationResults/1c933ae6-c1a1-4a81-b4c6-f567fdab7cbd?api-version=2020-06-01 (Caused by ResponseError('too many 500 error responses',))
```

We can have a look at the effective routes in the NIC, and there you see that only the routes from the first gateway instance pop up. It looks like only the one of the instance is able to inject routes, and it will only inject the routes from the second one if it learns them via iBGP. Since the iBGP session is now broken, only the routes from one of the instances are visible:

```shell
❯ az network nic show-effective-route-table -n testvm2VMNic -g $rg -o table
Source                 State    Address Prefix    Next Hop Type          Next Hop IP
---------------------  -------  ----------------  ---------------------  -------------
Default                Active   10.2.0.0/16       VnetLocal
VirtualNetworkGateway  Active   10.1.0.254/32     VirtualNetworkGateway  10.2.0.5
VirtualNetworkGateway  Active   10.3.0.10/32      VirtualNetworkGateway  10.2.0.5
VirtualNetworkGateway  Active   10.4.0.10/32      VirtualNetworkGateway  10.2.0.5
VirtualNetworkGateway  Active   10.5.0.0/16       VirtualNetworkGateway  10.2.0.5
VirtualNetworkGateway  Active   10.5.0.0/16       VirtualNetworkGateway  10.2.0.5
VirtualNetworkGateway  Active   10.3.0.0/16       VirtualNetworkGateway  10.2.0.5
VirtualNetworkGateway  Active   10.1.0.0/16       VirtualNetworkGateway  10.2.0.5
VirtualNetworkGateway  Active   10.4.0.0/16       VirtualNetworkGateway  10.2.0.5
Default                Active   0.0.0.0/0         Internet
Default                Active   10.0.0.0/8        None
Default                Active   100.64.0.0/10     None
Default                Active   192.168.0.0/16    None
Default                Active   25.33.80.0/20     None
Default                Active   25.41.3.0/25      None
```

The consequence here is that users should be careful when applying UDRs to the GatewaySubnet, to avoid impacting iBGP traffic between gateways.
