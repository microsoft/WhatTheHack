# Cheat sheet for using a Cisco CSR to simulate a branch

## Sample deployment script

You can use this script to deploy a Cisco CSR router to a new Vnet:

```bash
# Variables
rg=myrg
location=westeurope
publisher=cisco
offer=cisco-csr-1000v
sku=16_12-byol
branch_name=branch1
branch_prefix=172.16.1.0/24
branch_subnet=172.16.1.0/26
branch_gateway=172.16.1.1
branch_bgp_ip=172.16.1.10
branch_asn=65501
branch_username=labuser
branch_password=BlahBlah123!

# Create CSR
az group create -n $rg -l westeurope
version=$(az vm image list -p $publisher -f $offer -s $sku --all --query '[0].version' -o tsv)
# You only need to accept the image terms once per subscription
az vm image terms accept --urn ${publisher}:${offer}:${sku}:${version}
az vm create -n ${branch_name}-nva -g $rg -l $location \
    --image ${publisher}:${offer}:${sku}:${version} \
    --admin-username "$branch_username" --admin-password $branch_password --authentication-type all --generate-ssh-keys \
    --public-ip-address ${branch_name}-pip --public-ip-address-allocation static \
    --vnet-name ${branch_name} --vnet-address-prefix $branch_prefix \
    --subnet nva --subnet-address-prefix $branch_subnet \
    --private-ip-address $branch_bgp_ip

# Connect to the CSR and run commands (ideally using SSH key authentication)
branch_ip=$(az network public-ip show -n ${branch_name}-pip -g $rg --query ipAddress -o tsv)
# Example 1-line command (the -n flag disables reading from stdin, the StrickHostKeyChecking=no flag automatically accepts the public key)
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no ${branch_username}@${branch_ip} "show ip interface brief"
# Example multi-line command
ssh -o BatchMode=yes -o StrictHostKeyChecking=no ${branch_username}@${branch_ip} <<EOF
  config t
    username ${branch_username} password 0 ${branch_password}
  end
  wr mem
EOF
```

## Useful Cisco IOS commands

This list is by no means comprehensive, but it is conceived to give some of the most useful commands for admins new to the Cisco CLI

* **config t**: enter configuration mode
* **write mem**: save the config to non-volatile storage
* **show ip interface brief**: show a summary of the network interfaces in the system
* **show ip bgp summary**: show the status of configured BGP adjacencies
* **show ip route**: show the system routing table
* **show ip route bgp**: show the BGP routes in the routing table

## IOS config snippets

### 2-tunnels to one active/active VNG

You can use this configuration sample for configuring a CSR to establish 2 VPN tunnels with BGP enabled to an active/active Azure VPN Gateway (make sure to replace the strings for IPs and pre-shared key with the actual values):

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
  peer **GW0_Public_IP**
    address **GW0_Public_IP**
    pre-shared-key **PSK**
    exit
  peer **GW1_Public_IP**
    address **GW1_Public_IP**
    pre-shared-key **PSK**
    exit
  exit
!
crypto ikev2 profile azure-profile
  match address local interface GigabitEthernet1
  match identity remote address **GW0_Public_IP** 255.255.255.255
  match identity remote address **GW1_Public_IP** 255.255.255.255
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
 tunnel destination **GW0_Public_IP**
 tunnel protection ipsec profile azure-vti
exit
!
interface Tunnel1
 ip unnumbered GigabitEthernet1 
 ip tcp adjust-mss 1350
 tunnel source GigabitEthernet1
 tunnel mode ipsec ipv4
 tunnel destination **GW1_Public_IP**
 tunnel protection ipsec profile azure-vti
exit

!
router bgp **BGP_ID**
 bgp router-id interface GigabitEthernet1
 bgp log-neighbor-changes
 redistribute connected
 neighbor **GW0_Private_IP** remote-as 65515
 neighbor **GW0_Private_IP** ebgp-multihop 5
 neighbor **GW0_Private_IP** update-source GigabitEthernet1
 neighbor **GW1_Private_IP** remote-as 65515
 neighbor **GW1_Private_IP** ebgp-multihop 5
 neighbor **GW1_Private_IP** update-source GigabitEthernet1
 maximum-paths eibgp 4
!
ip route **GW0_Private_IP** 255.255.255.255 Tunnel0
ip route **GW1_Private_IP** 255.255.255.255 Tunnel1
!
end
!
wr mem
```

### 4-tunnels to two active/active VNGs

You can use this configuration sample for configuring a CSR to establish 4 VPN tunnels with BGP enabled, each pair to an active/active Azure VPN Gateway (make sure to replace the strings for IPs and pre-shared key with the actual values):

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
  peer **GW0_Public_IP**
    address **GW0_Public_IP**
    pre-shared-key **PSK**
    exit
  peer **GW1_Public_IP**
    address **GW1_Public_IP**
    pre-shared-key **PSK**
    exit
  peer **GW2_Public_IP**
    address **GW2_Public_IP**
    pre-shared-key **PSK**
    exit
  peer **GW3_Public_IP**
    address **GW3_Public_IP**
    pre-shared-key **PSK**
    exit
  exit
!
crypto ikev2 profile azure-profile
  match address local interface GigabitEthernet1
  match identity remote address **GW0_Public_IP** 255.255.255.255
  match identity remote address **GW1_Public_IP** 255.255.255.255
  match identity remote address **GW2_Public_IP** 255.255.255.255
  match identity remote address **GW3_Public_IP** 255.255.255.255
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
 tunnel destination **GW0_Public_IP**
 tunnel protection ipsec profile azure-vti
exit
!
interface Tunnel1
 ip unnumbered GigabitEthernet1 
 ip tcp adjust-mss 1350
 tunnel source GigabitEthernet1
 tunnel mode ipsec ipv4
 tunnel destination **GW1_Public_IP**
 tunnel protection ipsec profile azure-vti
exit
!
interface Tunnel2
 ip unnumbered GigabitEthernet1 
 ip tcp adjust-mss 1350
 tunnel source GigabitEthernet1
 tunnel mode ipsec ipv4
 tunnel destination **GW2_Public_IP**
 tunnel protection ipsec profile azure-vti
exit
!
interface Tunnel3
 ip unnumbered GigabitEthernet1 
 ip tcp adjust-mss 1350
 tunnel source GigabitEthernet1
 tunnel mode ipsec ipv4
 tunnel destination **GW3_Public_IP**
 tunnel protection ipsec profile azure-vti
exit

!
router bgp **BGP_ID**
 bgp router-id interface GigabitEthernet1
 bgp log-neighbor-changes
 redistribute connected
 neighbor **GW0_Private_IP** remote-as 65515
 neighbor **GW0_Private_IP** ebgp-multihop 5
 neighbor **GW0_Private_IP** update-source GigabitEthernet1
 neighbor **GW1_Private_IP** remote-as 65515
 neighbor **GW1_Private_IP** ebgp-multihop 5
 neighbor **GW1_Private_IP** update-source GigabitEthernet1
 neighbor **GW2_Private_IP** remote-as 65515
 neighbor **GW2_Private_IP** ebgp-multihop 5
 neighbor **GW2_Private_IP** update-source GigabitEthernet1
 neighbor **GW3_Private_IP** remote-as 65515
 neighbor **GW3_Private_IP** ebgp-multihop 5
 neighbor **GW3_Private_IP** update-source GigabitEthernet1
 maximum-paths eibgp 4
!
ip route **GW0_Private_IP** 255.255.255.255 Tunnel0
ip route **GW1_Private_IP** 255.255.255.255 Tunnel1
ip route **GW2_Private_IP** 255.255.255.255 Tunnel2
ip route **GW3_Private_IP** 255.255.255.255 Tunnel3
!
end
!
wr mem
```