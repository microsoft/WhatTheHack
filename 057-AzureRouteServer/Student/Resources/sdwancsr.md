# Cheat sheet for Simulating two SDWAN Routers

[< Back to Challenge 3](../Challenge-03.md) 

### Create SDWAN1 Cisco CSR 1000V VNET and subnets

```bash
# Variables
rg=<RG>
location=<SDWAN1_Location_1>
vnet_name=<SDWAN1_Vnet_name>
```
You may change the name and address space of the subnets if desired or required. 
```
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
az network nic create --name SDWAN1InsideInterface --resource-group $rg --subnet $Vnet_in_subnet_name --vnet $vnet_name --ip-forwarding true --network-security-group SDWAN1-NSG
az vm image accept-terms --urn cisco:cisco-csr-1000v:16_12-byol:latest
az vm create --resource-group $rg --location $location --name SDWAN1Router --size Standard_D2_v2 --nics SDWAN1OutsideInterface SDWAN1InsideInterface  --image cisco:cisco-csr-1000v:16_12-byol:latest --admin-username azureuser --admin-password Msft123Msft123 --no-wait
```

### Create SDWAN2 Cisco CSR 1000V VNET and subnets

```bash
# Variables
rg=<RG>
location=<SDWAN2_Location_1>
vnet_name=<SDWAN2_Vnet_name>
```
You may change the name and address space of the subnets if desired or required. 
```
Vnet_address_prefix=<ipv4 address space CIDR>
Vnet_out_subnet_name=SDWAN2outsidesubnet
vnet_out_subnet=<ipv4subnet address space CIDR>
Vnet_in_subnet_name=SDWAN2insidesubnet
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
az network nic create --name SDWAN2InsideInterface --resource-group $rg --subnet $Vnet_in_subnet_name --vnet $vnet_name --ip-forwarding true --network-security-group SDWAN2-NSG
az vm image accept-terms --urn cisco:cisco-csr-1000v:16_12-byol:latest
az vm create --resource-group $rg --location $location --name SDWAN2Router --size Standard_D2_v2 --nics SDWAN2OutsideInterface SDWAN2InsideInterface  --image cisco:cisco-csr-1000v:16_12-byol:latest --admin-username azureuser --admin-password Msft123Msft123 --no-wait
```

###  Central NVA to SDWAN Routers Cisco CSR 1000 BGP over IPsec Connection
```
crypto ikev2 proposal to-sdwan-proposal
  encryption aes-cbc-256
  integrity sha1
  group 2
  exit

crypto ikev2 policy to-sdwan-policy
  proposal to-sdwan-proposal
  match address local "GigabitEthernet1 IP Address"
  exit
  
crypto ikev2 keyring to-sdwan-keyring
  peer "Insert sdwan1PublicIP"
    address "Insert sdwan1PublicIP"
    pre-shared-key Msft123Msft123
    exit
  exit
  
  peer "Insert sdwan2PublicIP"
    address "Insert sdwan2PublicIP"
    pre-shared-key Msft123Msft123
    exit
  exit

crypto ikev2 profile to-sdwan-profile
  match address local "GigabitEthernet1 IP Address"
  match identity remote address **Sdwan1_privateSNATed_IP** 255.255.255.255
  match identity remote address **Sdwan2_privateSNATed_IP** 255.255.255.255
  authentication remote pre-share
  authentication local  pre-share
  lifetime 3600
  dpd 10 5 on-demand
  keyring local to-sdwan-keyring
  exit

crypto ipsec transform-set to-sdwan-TransformSet esp-gcm 256 
  mode tunnel
  exit

crypto ipsec profile to-sdwan-IPsecProfile
  set transform-set to-sdwan-TransformSet
  set ikev2-profile to-sdwan-profile
  set security-association lifetime seconds 3600
  exit

int tunnel 98
  description to SDWAN1-Router
  ip address 192.168.1.1 255.255.255.255
  tunnel mode ipsec ipv4
  ip tcp adjust-mss 1350
  tunnel source GigabitEthernet1
  tunnel destination "Insert sdwan1PublicIP"
  tunnel protection ipsec profile to-sdwan-IPsecProfile
  exit 
  
 int tunnel 99 
  description to SDWAN2-Router
  ip address 192.168.1.4 255.255.255.255
  tunnel mode ipsec ipv4
  ip tcp adjust-mss 1350
  tunnel source GigabitEthernet1
  tunnel destination "Insert sdwan2PublicIP"
  tunnel protection ipsec profile to-sdwan-IPsecProfile
  exit  

router bgp **Central NVA BGP ID**
  bgp log-neighbor-changes
  neighbor 192.168.1.2 remote-as **sdwan1 NVA BGP ID**
  neighbor 192.168.1.2 ebgp-multihop 255
  neighbor 192.168.1.2 update-source tunnel 98
  !
  neighbor 192.168.1.3 remote-as **sdwan2 NVA BGP ID**
  neighbor 192.168.1.3 ebgp-multihop 255
  neighbor 192.168.1.3 update-source tunnel 99
  

  address-family ipv4
   neighbor 192.168.1.2 activate 
   neighbor 192.168.1.3 activate 
    exit
  exit

!route BGP peer IP over the tunnel
ip route 192.168.1.2 255.255.255.255 Tunnel 98
ip route 192.168.1.3 255.255.255.255 Tunnel 99
```

### SDWAN1 Router to Central NVA Cisco CSR 1000 BGP over IPsec Connection
```
crypto ikev2 proposal to-central-nva-proposal
  encryption aes-cbc-256
  integrity sha1
  group 2
  exit

crypto ikev2 policy to-central-nva-policy
  proposal to-central-nva-proposal
  match address local "GigabitEthernet1 IP Address"
  exit
  
crypto ikev2 keyring to-central-nva-keyring
  peer "Insert nva_Public_IP"
    address "Insert nva_Public_IP"
    pre-shared-key Msft123Msft123
    exit
  exit

crypto ikev2 profile to-central-nva-profile
  match address local "GigabitEthernet1 IP Address"
  match identity remote address **CentralNVA_privateSNATed_IP** 255.255.255.255
  authentication remote pre-share
  authentication local  pre-share
  lifetime 3600
  dpd 10 5 on-demand
  keyring local to-central-nva-keyring
  exit

crypto ipsec transform-set to-central-nva-TransformSet esp-gcm 256 
  mode tunnel
  exit

crypto ipsec profile to-central-nva-IPsecProfile
  set transform-set to-central-nva-TransformSet
  set ikev2-profile to-central-nva-profile
  set security-association lifetime seconds 3600
  exit

int tunnel 98
  ip address 192.168.1.2 255.255.255.255
  tunnel mode ipsec ipv4
  ip tcp adjust-mss 1350
  tunnel source GigabitEthernet1
  tunnel destination "Insert nva_Public_IP"
  tunnel protection ipsec profile to-central-nva-IPsecProfile
  exit

router bgp **BGP ID**
  bgp log-neighbor-changes
  neighbor 192.168.1.1 remote-as **Central NVA BGP ID**
  neighbor 192.168.1.1 ebgp-multihop 255
  neighbor 192.168.1.1 update-source tunnel 98
  
  address-family ipv4
    network "vnet Address space" mask 255.255.0.0
    redistribute connected
    neighbor 192.168.1.1 activate    
    exit
  exit

!route BGP peer IP over the tunnel
ip route 192.168.1.1 255.255.255.255 Tunnel 98
ip route "vnet Address space" 255.255.0.0 Null0
```

### SDWAN2 Router to Central NVA Cisco CSR 1000 BGP over IPsec Connection
```
crypto ikev2 proposal to-central-nva-proposal
  encryption aes-cbc-256
  integrity sha1
  group 2
  exit

crypto ikev2 policy to-central-nva-policy
  proposal to-central-nva-proposal
  match address local "GigabitEthernet1 IP Address"
  exit
  
crypto ikev2 keyring to-central-nva-keyring
  peer "Insert nva_Public_IP"
    address "Insert nva_Public_IP"
    pre-shared-key Msft123Msft123
    exit
  exit

crypto ikev2 profile to-central-nva-profile
  match address local "GigabitEthernet1 IP Address"
  match identity remote address **CentralNVA_privateSNATed_IP** 255.255.255.255
  authentication remote pre-share
  authentication local  pre-share
  lifetime 3600
  dpd 10 5 on-demand
  keyring local to-central-nva-keyring
  exit

crypto ipsec transform-set to-central-nva-TransformSet esp-gcm 256 
  mode tunnel
  exit

crypto ipsec profile to-central-nva-IPsecProfile
  set transform-set to-central-nva-TransformSet
  set ikev2-profile to-central-nva-profile
  set security-association lifetime seconds 3600
  exit

int tunnel 99
  ip address 192.168.1.3 255.255.255.255
  tunnel mode ipsec ipv4
  ip tcp adjust-mss 1350
  tunnel source GigabitEthernet1
  tunnel destination "Insert nva_Public_IP"
  tunnel protection ipsec profile to-central-nva-IPsecProfile
  exit

router bgp **BGP ID**
  bgp log-neighbor-changes
  neighbor 192.168.1.4 remote-as **Central NVA BGP ID**
  neighbor 192.168.1.4 ebgp-multihop 255
  neighbor 192.168.1.4 update-source tunnel 99

  address-family ipv4
    network "vnet Address space" mask 255.255.0.0
    redistribute connected
    neighbor 192.168.1.1 activate    
    exit
  exit

!route BGP peer IP over the tunnel
ip route 192.168.1.4 255.255.255.255 Tunnel 99
ip route "vnet Address space" 255.255.0.0 Null0
```

## Use the network command to advertise your routes from SDWAN Routers

> **Note**
> 
> You may use floating address space via a loopback network to simulate additional prefixes and advertise them through the **network** command

```bash
conf t
!
interface loopback 1
ip address <floating address space> 255.255.255.255
end

!
router bgp **BGP_ID**
 address-family ipv4
 network < n ip prefix> mask <network mask>
end
``` 
Example:
``` 
conf t
!
interface loopback 1
ip address 1.1.1.1 255.255.255.255
end

!
router bgp 65001
 address-family ipv4
 network 1.1.1.0 mask 255.255.255.0
end
```

## Route Manipulation
### Create prefix list
```
ip prefix-list toRS seq 5 permit <prefix in CIDR notation>
```

Example:
```
ip prefix-list toRS seq 5 permit 172.16.1.0/24
```
### Create Route Map
```
route-map toRS permit 10
 match ip address prefix-list toRS
 set as-path prepend <LocalASN> <LocalASN> <LocalASN>
```

Example:
``` 
route-map toRS permit 10
 match ip address prefix-list toRS
 set as-path prepend 65001 65001
```

### Assign to neighbor

```
router bgp <LocalASN>
address-family ipv4
neighbor <RS BGP IP> route-map toRS out
neighbor <RS BGP IP> route-map toRS out
```

Example:
```
router bgp 65001
address-family ipv4
neighbor 10.0.3.4 route-map toRS out
neighbor 10.0.3.5 route-map toRS out
```
