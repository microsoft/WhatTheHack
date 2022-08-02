# Challenge 02 - Introduce Azure Route Server and peer with a NVA - Coach's Guide 

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Notes & Guidance


Undo/remove static route tabls (UDRs) <br/>
You cant remove branch UDR since its a Azure vNet simulating on-premises (running on Azure SDN) <br/>
Deploy Azure Route Server <br/>
Setup BGP peering with Central NVA <br/>
Test publishing routes/default routes on NVA.<br/>
Validate traffic flows via NVA <br/>
You will notice only spoke to spoke routing via NVA works <br/>
On-premises to Azure routing is possible but it requires static routes on Gateway and NVA Subnet (to prevent the loop)<br/>

Azure to on-prem will not work due to fact that on-premises routes over VPN gateways will always be preferred even if specific routes are advertised via NVA (routing loop will occur and packets will get dropped<br/>
[Using Route server to firewall onprem traffic with an nva](https://blog.cloudtrooper.net/2021/03/29/using-route-server-to-firewall-onprem-traffic-with-an-nva/)

Solution to this problem is to build a 'transit' vnet with another instance of Route Server <br/>
[Different Route Servers to advertise routes to Virtual Network Gateways and to VNets](https://docs.microsoft.com/en-us/azure/route-server/route-injection-in-spokes#different-route-servers-to-advertise-routes-to-virtual-network-gateways-and-to-vnets)



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

