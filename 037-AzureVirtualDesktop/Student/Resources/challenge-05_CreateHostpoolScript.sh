#!/bin/bash

# Create AVD host pool
az desktopvirtualization hostpool create \
    --host-pool-type '' \
    --load-balancer-type '' \
    --personal-desktop-assignment-type '' \
    --location '' \
    --name '' \
    --resource-group '' \
    --custom-rdp-property '' \
    --max-session-limit '' \
    --registration-info expiration-time=$(date -d "2 hours" +'%Y-%m-%dT%H:%M:00:0000000Z') registration-token-operation="Update" \
    --validation-environment true

# Get the resource ID for the AVD host pool
hostPoolResourceId=$(az desktopvirtualization hostpool show --name '' --resource-group '' --query id --output tsv)
hostPoolToken=$(az desktopvirtualization hostpool show --name '' --resource-group '' --query registrationInfo.token --output tsv)

# Create the AVD application group
az desktopvirtualization applicationgroup create \
    --application-group-type '' \
    --host-pool-arm-path '' \
    --location '' \
    --name '' \
    --resource-group ''

# Get the resource ID for the AVD application group
applicationGroupId=$(az desktopvirtualization applicationgroup show --name '' --resource-group '' --query id --output tsv)

# Create the AVD workspace
az desktopvirtualization workspace create \
    --location '' \
    --name '' \
    --resource-group '' \
    --application-group-references ''

# Create the availability set for the AVD session hosts
az vm availability-set create \
    --name '' \
    --resource-group '' \
    --location '' \
    --platform-fault-domain-count 2 \
    --platform-update-domain-count 5

# Get the resource ID for the availability set
availabilitySetResourceId=$(az vm availability-set show --name '' --resource-group '' --query id --output tsv)
  
# Create the AVD session hosts 
az vm create \
    --name '' \
    --resource-group '' \
    --authentication-type 'password' \
    --admin-username '' \
    --availability-set '' \
    --image '' \
    --license-type '' \
    --location '' \
    --nsg '' \
    --public-ip-address '' \
    --size '' \
    --subnet ''

# Install AVD agent using DSC extension
az vm extension set \
    --name 'DSC' \
    --publisher 'Microsoft.Powershell' \
    --version 2.77 \
    --resource-group '' \
    --vm-name '' \
    --settings '{
        "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_7-20-2020.zip",
        "configurationFunction": "Configuration.ps1\\AddSessionHost",
        "properties": {
            "hostPoolName": "",
            "registrationInfoToken": ""
        }
    }'

# Domain join the AVD session host
az vm extension set \
    --name 'JsonADDomainExtension' \
    --publisher 'Microsoft.Compute' \
    --version 1.3 \
    --resource-group '' \
    --vm-name '' \
    --settings '{
        "Name": "",
        "User": "",
        "Restart": "true",
        "Options": "3",
        "OUPath": ""
    }' \
    --protected-settings '{
        "Password": ""
    }'