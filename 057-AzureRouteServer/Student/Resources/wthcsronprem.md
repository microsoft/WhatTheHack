# Cheat sheet for using a Cisco CSR to simulate a branch (on Premises)

[< Back to Challenge 1](../Challenge-01.md) 

## Automated deployment

You can use the [OnPrem.sh script](Onprem.sh?raw=true) to deploy a CSR to simulate an on-premises network and configure it to connect to the Azure VPN gateway via IPsec and BGP.

## Custom deployment

If the [OnPrem.sh script](Onprem.sh?raw=true) didn't work for you, or you want to customize how the branch is created, you can use this code to deploy a Cisco CSR router to a new VNet.

If you are not using bash but Windows, you will have to do some changes, such as:

- Add a `$` symbol to the variable names when they are declared
- Double quote the values

```bash
rg=datacenter-rg
location=<Azure region of your choice>
publisher=cisco
offer=cisco-csr-1000v
sku=16_12-byol
version=latest
site_name=datacenter
site_prefix=172.16.1.0/24
site_subnet=172.16.1.0/26
site_gateway=172.16.1.1
site_bgp_ip=172.16.1.10
site_asn=65501
site_username=azureuser
site_password=<select a password>

# Create CSR
# Replace -l with Azure region of your choice
az group create -n $rg -l $location
version=$(az vm image list -p $publisher -f $offer -s $sku --all --query '[0].version' -o tsv)
# You only need to accept the image terms once per subscription
az vm image terms accept --urn ${publisher}:${offer}:${sku}:${version}
az vm create -n ${site_name}-nva -g $rg -l $location \
    --image ${publisher}:${offer}:${sku}:${version} \
    --admin-username "$site_username" --admin-password $site_password --authentication-type all --generate-ssh-keys \
    --public-ip-address ${site_name}-pip --public-ip-address-allocation static \
    --vnet-name ${site_name} --vnet-address-prefix $site_prefix \
    --subnet nva --subnet-address-prefix $site_subnet \
    --private-ip-address $site_bgp_ip

# Connect to the CSR and run commands (ideally using SSH key authentication)
site_ip=$(az network public-ip show -n ${site_name}-pip -g $rg --query ipAddress -o tsv)
# Example 1-line command (the -n flag disables reading from stdin, the StrickHostKeyChecking=no flag automatically accepts the public key)
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no ${site_username}@${site_ip} "show ip interface brief"

```

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
router bgp **LOCAL_BGP_ASN**
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
## Useful Cisco IOS commands

This list is by no means comprehensive, but it is conceived to give some of the most useful commands for admins new to the Cisco CLI

* `config t`: enter configuration mode
* `write mem`: save the config to non-volatile storage
* `show ip interface brief`: show a summary of the network interfaces in the system

### Check IPSec tunnel

* `show interface tunnel 1` shows the status of the tunnel interface (VTI), should be up/up
* `show crypto session` shows the status of the session. Should be Active
* `show crypto ipsec transform-set` shows the policy applied to the ipsec tunnel
* `show crypto ikev2 proposal` shows the policy applied to phase 1 of the tunnel

### Check BGP sessions

* `show ip bgp summary`: show the status of configured BGP adjacencies
* `show ip route`: show the system routing table
* `show ip route bgp`: show the BGP routes in the routing table
