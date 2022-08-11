**Create SDWAN1 Cisco CSR 1000V VNET and subnets**

```bash
# Variables
rg=<RG>
location=<SDWAN1_Location_1>
vnet_name=<SDWAN1_Vnet_name>

//You may change the name and address space of the subnets if desired or required. 

Vnet_address_prefix=<ipv4 address space CIDR>
Vnet_out_subnet_name=sdwan1outsidesubnet
vnet_out_subnet=<ipv4subnet address space>
Vnet_in_subnet_name=sdwan1insidesidesubnet
vnet_in_subnet=<ipv4subnet address space>

<pre lang="...">
az group create --name $rg --location $location
az network vnet create --name $vnet_name --resource-group $rg --address-prefix $Vnet_address_prefix
az network vnet subnet create --address-prefix $vnet_out_subnet --name $Vnet_out_subnet_name --resource-group $rg --vnet-name $vnet_name
az network vnet subnet create --address-prefix $vnet_in_subnet --name $Vnet_in_subnet_name --resource-group $rg --vnet-name $vnet_name
</pre>

**Create SDWAN Router Site 1**
<pre lang="...">

az network public-ip create --name SDWAN1PublicIP --resource-group $rg --idle-timeout 30 --allocation-method Static
az network nic create --name SDWAN1OutsideInterface --resource-group $rg --subnet $Vnet_out_subnet_name --vnet $vnet_name --public-ip-address SDWAN1PublicIP --ip-forwarding true
az network nic create --name SDWAN1nsideInterface --resource-group $rg --subnet $Vnet_in_subnet_name --vnet $vnet_name --ip-forwarding true
az vm image accept-terms --urn cisco:cisco-csr-1000v:16_12-byol:latest
az vm create --resource-group $rg --location $location --name SDWAN1Router --size Standard_D2_v2 --nics SDWAN1OutsideInterface SDWAN1nsideInterface  --image cisco:cisco-csr-1000v:16_12-byol:latest --admin-username azureuser --admin-password Msft123Msft123 --no-wait


**Create NSG for CSR1**
<pre lang="...">
az network nsg create --resource-group CSR --name Azure-CSR-NSG --location westus
az network nsg rule create --resource-group CSR --nsg-name Azure-CSR-NSG --name CSR-IPSEC1 --access Allow --protocol Udp --direction Inbound --priority 100 --source-address-prefix "*" --source-port-range "*" --destination-address-prefix "*" --destination-port-range 500
az network nsg rule create --resource-group CSR --nsg-name Azure-CSR-NSG --name CSR-IPSEC2 --access Allow --protocol Udp --direction Inbound --priority 110 --source-address-prefix "*" --source-port-range "*" --destination-address-prefix "*" --destination-port-range 4500
az network nsg rule create --resource-group CSR --nsg-name Azure-CSR-NSG --name Allow-SSH-All --access Allow --protocol Tcp --direction Inbound --priority 120 --source-address-prefix Internet --source-port-range "*" --destination-address-prefix "*" --destination-port-range 22
az network nsg rule create --resource-group CSR --nsg-name Azure-CSR-NSG --name Allow-Tens --access Allow --protocol "*" --direction Inbound --priority 130 --source-address-prefix 10.0.0.0/8 --source-port-range "*" --destination-address-prefix "*" --destination-port-range "*"
az network nsg rule create --resource-group CSR --nsg-name Azure-CSR-NSG --name Allow-Out --access Allow --protocol "*" --direction Outbound --priority 140 --source-address-prefix "*" --source-port-range "*" --destination-address-prefix "*" --destination-port-range "*"
</pre>