# Cheat sheet for Simulating two SDWAN Routers

### Create SDWAN1 Cisco CSR 1000V VNET and subnets

```bash
# Variables
rg=<RG>
location=<SDWAN1_Location_1>
vnet_name=<SDWAN1_Vnet_name>

//You may change the name and address space of the subnets if desired or required. 

Vnet_address_prefix=<ipv4 address space CIDR>
Vnet_out_subnet_name=sdwan1outsidesubnet
vnet_out_subnet=<ipv4subnet out address space CIDR>
Vnet_in_subnet_name=sdwan1insidesidesubnet
vnet_in_subnet=<ipv4subnet in address space CIDR>

az group create --name $rg --location $location
az network vnet create --name $vnet_name --resource-group $rg --address-prefix $Vnet_address_prefix
az network vnet subnet create --address-prefix $vnet_out_subnet --name $Vnet_out_subnet_name --resource-group $rg --vnet-name $vnet_name
az network vnet subnet create --address-prefix $vnet_in_subnet --name $Vnet_in_subnet_name --resource-group $rg --vnet-name $vnet_name

```
### Create NSG for SDWAN1 Cisco CSR 1000V**
```bash
az network nsg create --resource-group $rg --name SDWAN1-NSG --location $location
az network nsg rule create --resource-group $rg --nsg-name SDWAN1-NSG --name all --access Allow --protocol "*" --direction Inbound --priority 100 --source-address-prefix "*" --source-port-range "*" --destination-address-prefix "*" --destination-port-range "*"

```

### Create SDWAN Router Site 1

```bash

az network public-ip create --name SDWAN1PublicIP --resource-group $rg --idle-timeout 30 --allocation-method Static
az network nic create --name SDWAN1OutsideInterface --resource-group $rg --subnet $Vnet_out_subnet_name --vnet $vnet_name --public-ip-address SDWAN1PublicIP --ip-forwarding true --network-security-group SDWAN1-NSG
az network nic create --name SDWAN1nsideInterface --resource-group $rg --subnet $Vnet_in_subnet_name --vnet $vnet_name --ip-forwarding true --network-security-group SDWAN1-NSG
az vm image accept-terms --urn cisco:cisco-csr-1000v:16_12-byol:latest
az vm create --resource-group $rg --location $location --name SDWAN1Router --size Standard_D2_v2 --nics SDWAN1OutsideInterface SDWAN1nsideInterface  --image cisco:cisco-csr-1000v:16_12-byol:latest --admin-username azureuser --admin-password Msft123Msft123 --no-wait
```

### Create SDWAN2 Cisco CSR 1000V VNET and subnets

```bash
# Variables
rg=<RG>
location=<SDWAN2_Location_1>
vnet_name=<SDWAN2_Vnet_name>

//You may change the name and address space of the subnets if desired or required. 

Vnet_address_prefix=<ipv4 address space CIDR>
Vnet_out_subnet_name=SDWAN2outsidesubnet
vnet_out_subnet=<ipv4subnet address space CIDR>
Vnet_in_subnet_name=SDWAN2insidesidesubnet
vnet_in_subnet=<ipv4subnet address space CIDR>

az group create --name $rg --location $location
az network vnet create --name $vnet_name --resource-group $rg --address-prefix $Vnet_address_prefix
az network vnet subnet create --address-prefix $vnet_out_subnet --name $Vnet_out_subnet_name --resource-group $rg --vnet-name $vnet_name
az network vnet subnet create --address-prefix $vnet_in_subnet --name $Vnet_in_subnet_name --resource-group $rg --vnet-name $vnet_name

```
### Create NSG for SDWAN2 Cisco CSR 1000V
```bash
az network nsg create --resource-group $rg --name SDWAN2-NSG --location $location
az network nsg rule create --resource-group $rg --nsg-name SDWAN2-NSG --name all --access Allow --protocol "*" --direction Inbound --priority 100 --source-address-prefix "*" --source-port-range "*" --destination-address-prefix "*" --destination-port-range "*"

```

### Create SDWAN Router Site 2

```bash

az network public-ip create --name SDWAN2PublicIP --resource-group $rg --idle-timeout 30 --allocation-method Static
az network nic create --name SDWAN2OutsideInterface --resource-group $rg --subnet $Vnet_out_subnet_name --vnet $vnet_name --public-ip-address SDWAN2PublicIP --ip-forwarding true --network-security-group SDWAN2-NSG
az network nic create --name SDWAN2nsideInterface --resource-group $rg --subnet $Vnet_in_subnet_name --vnet $vnet_name --ip-forwarding true --network-security-group SDWAN2-NSG
az vm image accept-terms --urn cisco:cisco-csr-1000v:16_12-byol:latest
az vm create --resource-group $rg --location $location --name SDWAN2Router --size Standard_D2_v2 --nics SDWAN2OutsideInterface SDWAN2nsideInterface  --image cisco:cisco-csr-1000v:16_12-byol:latest --admin-username azureuser --admin-password Msft123Msft123 --no-wait
```

### Site to Site VPN and BGP from Central NVA to SDWAN Routers
```
crypto ikev2 proposal azure-proposal
  encryption aes-cbc-256 aes-cbc-128 3des
  integrity sha1
  group 2
  exit
!
crypto ikev2 policy azure-policy
  proposal azure-proposal
  exit
!
crypto ikev2 keyring azure-keyring
  peer **sdwan1_Public_IP**
    address **sdwan1_Public_IP**
    pre-shared-key **PSK**
    exit
  peer **sdwan2_Public_IP**
    address **sdwan2_Public_IP**
    pre-shared-key **PSK**
    exit
  exit
!
crypto ikev2 profile azure-profile
  match address local interface GigabitEthernet1
  match identity remote address **sdwan1_Public_IP** 255.255.255.255
  match identity remote address **sdwan2_Public_IP** 255.255.255.255
  authentication remote pre-share
  authentication local pre-share
  keyring local azure-keyring
  exit
!
crypto ipsec transform-set azure-ipsec-proposal-set esp-aes 256 esp-sha-hmac
 mode tunnel
 exit

crypto ipsec profile azure-vti
  set transform-set azure-ipsec-proposal-set
  set ikev2-profile azure-profile
  set security-association lifetime kilobytes 102400000
  set security-association lifetime seconds 3600 
 exit
!
interface Tunnel0
 ip unnumbered GigabitEthernet1 
 ip tcp adjust-mss 1350
 tunnel source GigabitEthernet1
 tunnel mode ipsec ipv4
 tunnel destination **sdwan1_Public_IP**
 tunnel protection ipsec profile azure-vti
exit
!
interface Tunnel1
 ip unnumbered GigabitEthernet1 
 ip tcp adjust-mss 1350
 tunnel source GigabitEthernet1
 tunnel mode ipsec ipv4
 tunnel destination **sdwan2_Public_IP**
 tunnel protection ipsec profile azure-vti
exit

!
router bgp **BGP_ID**
 bgp router-id interface GigabitEthernet1
 bgp log-neighbor-changes
 redistribute connected
 neighbor **sdwan1_Private_IP** remote-as 65515
 neighbor **sdwan1_Private_IP** ebgp-multihop 5
 neighbor **sdwan1_Private_IP** update-source GigabitEthernet1
 neighbor **sdwan2_Private_IP** remote-as 65515
 neighbor **sdwan2_Private_IP** ebgp-multihop 5
 neighbor **sdwan2_Private_IP** update-source GigabitEthernet1
 maximum-paths eibgp 4
!
ip route **sdwan1_Private_IP** 255.255.255.255 Tunnel0
ip route **sdwan2_Private_IP** 255.255.255.255 Tunnel1
!
end
!
wr mem
```
