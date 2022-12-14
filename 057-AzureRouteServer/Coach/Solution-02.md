# Challenge 02 - Introduce Azure Route Server and peer with a NVA - Coach's Guide 

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Notes & Guidance

- Undo/remove static route tabls (UDRs) <br/>
- You can't remove branch UDR since it's an Azure VNet simulating on-premises (running on Azure SDN) <br/>
- Deploy Azure Route Server <br/>
- Setup BGP peering with Central NVA <br/>
- Test publishing routes/default routes on NVA<br/>
- Validate traffic flows via NVA <br/>
- You will notice only spoke to spoke routing via NVA works <br/>
- For spoke to spoke traffic, advertise supernet since equal and more specific routes will be dropped by Azure Route Server.<br/>
- Also, because of the limitation in the Azure virtual network gateway type VPN it's not possible to advertise a 0.0.0.0/0 route through to the VPN Gateway. Student can try the approach of splitting advertisements like 0/1 and 128/1, but still routes learned through VPN Gateway will be more specific. (There might be some differences with ExR but same principle applies)<br/>


- Azure to on-premises traffic is not possible in this design since advertising a more specific on-prem prefix from the NVA will result in a routing loop with the SDN fabric. 
- On-premises to Azure routing is possible but it requires static routes on Gateway and NVA Subnet (to prevent the loop)<br/>

Few plausible solutions to solve these challanges.
- [Create an overlay with Vxlan + eBGP](https://blog.cloudtrooper.net/2021/03/29/using-route-server-to-firewall-onprem-traffic-with-an-nva/) <br/>
- [Split ARS design](https://docs.microsoft.com/en-us/azure/route-server/route-injection-in-spokes#different-route-servers-to-advertise-routes-to-virtual-network-gateways-and-to-vnets)<br/>

## Sample deployment script
You can use this script to deploy Azure Route Server. Setting up via portal is recommended if you are new to Azure Route Server. 

```bash

# Create Azure Route Server

echo "Creating Azure Route Server"
az network vnet subnet create --name RouteServerSubnet --resource-group $rg --vnet-name $vnet_name --address-prefix 10.0.3.0/24


subnet_id=$(az network vnet subnet show --name RouteServerSubnet --resource-group $rg --vnet-name $vnet_name --query id -o tsv) 
echo $subnet_id

az network public-ip create --name RouteServerIP --resource-group $rg --version IPv4 --sku Standard

az network routeserver create --name ARSHack --resource-group $rg --hosted-subnet $subnet_id --public-ip-address RouteServerIP

# Enable Branch to Branch flag.
az network routeserver update --name ARSHack --resource-group $rg --allow-b2b-traffic true

