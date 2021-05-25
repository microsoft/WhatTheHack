# Sample to create VNets and VMs with the Azure CLI

You can use this code to quickly deploy multiple Virtual Networks, each with one Virtual Machine (the script has been validated to run in bash):

```bash
# Variables
rg=yourresourcegroup
vm_size=Standard_B1s
nva_size=Standard_B2ms
publisher=cisco
offer=cisco-csr-1000v
sku=16_12-byol
version=$(az vm image list -p $publisher -f $offer -s $sku --all --query '[0].version' -o tsv)
az vm image terms accept --urn ${publisher}:${offer}:${sku}:${version}

admin_username=vmuser
admin_password=your_super_secret_password

# Create a list of Vnets and a VM in each
# If the Vnet_id begins with "1", it is created in $location1
# If the Vnet_id begins with "2", it is created in $location2

function create_vm_vnet {    
    location=$1
    vnet_id=$2
    vnet_prefix=$3
    subnet_prefix=$4

    echo "Location: $location"
    echo "VNET name: vnet-${vnet_id}-$location"
    echo "VNET prefix: $vnet_prefix and subnet prefix: $subnet_prefix"
    echo "VM name: vnet${vnet_id}-vm"
    
    az vm create -n "vnet${vnet_id}-vm" -g "$rg" -l "$location" --image "ubuntuLTS" --size $vm_size \
            --authentication-type Password --admin-username "$admin_username" --admin-password "$admin_password" \
            --public-ip-address "vnet${vnet_id}-pip" --vnet-name "vnet${vnet_id}-$location" \
            --vnet-address-prefix "$vnet_prefix" --subnet vm --subnet-address-prefix "$subnet_prefix" \
            --no-wait
}

function create_branch_csr_vnet {    
    location=$1
    vnet_id=$2
    vnet_prefix=$3
    subnet_prefix=$4

    echo "Location: $location"
    echo "VNET name: vnet-${vnet_id}-$location"
    echo "VNET prefix: $vnet_prefix and subnet prefix: $subnet_prefix"
    echo "CSR name: ${vnet_id}-nva"

    az vm create -n ${vnet_id}-nva -g $rg -l $location --image ${publisher}:${offer}:${sku}:${version} --size $nva_size \
            --authentication-type Password --admin-username "$admin_username" --admin-password "$admin_password" \
            --public-ip-address ${vnet_id}-pip --public-ip-address-allocation static \
            --vnet-name "${vnet_id}-$location" --vnet-address-prefix $vnet_prefix --subnet nva --subnet-address-prefix $subnet_prefix \
            --no-wait
}

#create rg if it doesn't exist
az group create -n $rg -l $location

#example creating a VNET with a single VM in westeurope to test connectivity
create_vm_vnet westeurope prod11 10.1.1.0/24 10.1.1.0/26

#example creating a VNET with a single CSR to act as a branch office
create_branch_csr_vnet westeurope branch1 10.1.101.0/24 10.1.101.0/26
```