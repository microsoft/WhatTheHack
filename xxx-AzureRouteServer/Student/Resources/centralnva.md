```bash
# Variables
rg=<Resource Group of your Hub Vnet>
location=<Resource Group of your Hub Vnet>
vnet_name=<Name of your Hub Vnet>
vnet_prefix=10.0.0.0/16

//You may change the name of the subnets if desired

Vnet_out_subnet_name=nvaoutsidesubnet
vnet_out_subnet=10.0.1.0/24
Vnet_in_subnet_name=nvainsidesidesubnet
vnet_in_subnet=10.0.2.0/24


# Create CSR

az network vnet subnet create --address-prefix $vnet_out_subnet --name $Vnet_out_subnet_name --resource-group $rg --vnet-name $vnet_name
az network vnet subnet create --address-prefix $vnet_in_subnet --name $Vnet_in_subnet_name --resource-group $rg --vnet-name $vnet_name

az network public-ip create --name CSRPublicIP --resource-group $rg --idle-timeout 30 --allocation-method Static
az network nic create --name CSROutsideInterface --resource-group $rg --subnet $Vnet_out_subnet_name --vnet $vnet_name --public-ip-address CSRPublicIP --ip-forwarding true
az network nic create --name CSRInsideInterface --resource-group $rg --subnet $Vnet_in_subnet_name --vnet $vnet_name --ip-forwarding true
az vm create --resource-group $rg --location $location --name NVAHub --size Standard_D2_v2 --nics CSROutsideInterface CSRInsideInterface  --image cisco:cisco-csr-1000v:16_12-byol:latest --admin-username azureuser --admin-password Msft123Msft123 --no-wait
```