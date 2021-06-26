#!/bin/bash

# Set Variables
domain=''
domainAdminUsername=''
domainAdminPassword=''
localAdminUsername=''
organizationalUnit=''
subnetResourceId=''

# Static Variables
netBios=$(echo $domain | awk -F'.' '{print $1}')
slashes='\\'
user="${netBios}${slashes}${domainAdminUsername}"
location='uksouth'
resourceGroupName='rg-wth-avd-d-uks'
virtualMachineNames=('vmshduks00' 'vmshduks01')
hostPoolName='hp-wth-avd-d-uks'
applicationGroupName='rag-wth-avd-d-uks'
availabilitySetName='as-wth-avd-d-uks'

# Create AVD host pool
az desktopvirtualization hostpool create \
    --host-pool-type 'Pooled' \
    --load-balancer-type 'BreadthFirst' \
    --personal-desktop-assignment-type 'Automatic' \
    --location $location \
    --name $hostPoolName \
    --resource-group $resourceGroupName \
    --custom-rdp-property 'redirectclipboard:i:0;drivestoredirect:s:;redirectprinters:i:0;camerastoredirect:s:;audiocapturemode:i:0;' \
    --max-session-limit '4' \
    --registration-info expiration-time=$(date -d "2 hours" +'%Y-%m-%dT%H:%M:00:0000000Z') registration-token-operation="Update" \
    --validation-environment true

# Get the resource ID for the AVD host pool
hostPoolResourceId=$(az desktopvirtualization hostpool show --name $hostPoolName --resource-group $resourceGroupName --query id --output tsv)
hostPoolToken=$(az desktopvirtualization hostpool show --name $hostPoolName --resource-group $resourceGroupName --query registrationInfo.token --output tsv)

# Create the AVD application group
az desktopvirtualization applicationgroup create \
    --application-group-type 'RemoteApp' \
    --host-pool-arm-path $hostPoolResourceId \
    --location $location \
    --name $applicationGroupName \
    --resource-group $resourceGroupName

# Get the resource ID for the AVD application group
applicationGroupId=$(az desktopvirtualization applicationgroup show --name $applicationGroupName --resource-group $resourceGroupName --query id --output tsv)

# Create the AVD workspace
az desktopvirtualization workspace create \
    --location $location \
    --name 'ws-wth-avd-d-uks' \
    --resource-group $resourceGroupName \
    --application-group-references $applicationGroupId

# Create the availability set for the AVD session hosts
az vm availability-set create \
    --name $availabilitySetName \
    --resource-group $resourceGroupName \
    --location $location \
    --platform-fault-domain-count 2 \
    --platform-update-domain-count 5

# Get the resource ID for the availability set
availabilitySetResourceId=$(az vm availability-set show --name $availabilitySetName --resource-group $resourceGroupName --query id --output tsv)
  
for vm in ${virtualMachineNames[@]}; do
    # Create the AVD session hosts 
    az vm create \
        --name $vm \
        --resource-group $resourceGroupName \
        --authentication-type 'password' \
        --admin-username $localAdminUsername \
        --availability-set $availabilitySetResourceId \
        --image 'MicrosoftWindowsServer:WindowsServer:2019-Datacenter:latest' \
        --license-type 'Windows_Server' \
        --location $location \
        --nsg '' \
        --public-ip-address '' \
        --size 'Standard_D4s_v3' \
        --subnet $subnetResourceId
done

for vm in ${virtualMachineNames[@]}; do
    # Install AVD agent using DSC extension
    az vm extension set \
        --name 'DSC' \
        --publisher 'Microsoft.Powershell' \
        --version 2.77 \
        --resource-group $resourceGroupName \
        --vm-name $vm \
        --settings "{
            \"modulesUrl\": \"https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_7-20-2020.zip\",
            \"configurationFunction\": \"Configuration.ps1\\AddSessionHost\",
            \"properties\": {
                \"hostPoolName\": \"${hostPoolName}\",
                \"registrationInfoToken\": \"${hostPoolToken}\"
            }
        }"
done

for vm in ${virtualMachineNames[@]}; do
    # Domain join the AVD session host
    az vm extension set \
        --name 'JsonADDomainExtension' \
        --publisher 'Microsoft.Compute' \
        --version 1.3 \
        --resource-group $resourceGroupName \
        --vm-name $vm \
        --settings "{
            \"Name\": \"${domain}\",
            \"User\": \"${user}\",
            \"Restart\": \"true\",
            \"Options\": \"3\",
            \"OUPath\": \"${organizationalUnit}\"
        }" \
        --protected-settings "{
            \"Password\": \"${domainAdminPassword}\"
        }"
done