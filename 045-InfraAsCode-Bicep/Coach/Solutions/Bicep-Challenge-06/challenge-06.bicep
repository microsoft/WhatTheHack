// Note: a common pattern is for this file to be named main.bicep.
// In the interest of consistency, we continue with the prior naming convention

param location string = resourceGroup().location

//Password for the VM
@secure()
param adminPassword string

//Username for the VM
param adminUsername string

//Resource Prefix for all VM Resources
param resourcePrefix string = 'bicepwth'

//The Ubuntu version for the VM. This will pick a fully patched image of this given Ubuntu version.
@allowed([
  '16.04.0-LTS'
  '18.04-LTS'
])
param ubuntuOSVersion string = '18.04-LTS'

// VNet Address Prefix
param vnetPrefix string = '10.0.0.0/16'

// Subnet Name
param subnetName string = 'Default'

//Subnet Prefix
param subnetPrefix string = '10.0.0.0/24'

module vnet './challenge-06-VNET.bicep' = {
  name: 'VNET_Deployment'
  params: {
    resourcePrefix: resourcePrefix
    subnetName: subnetName
    subnetPrefix: subnetPrefix
    vnetPrefix: vnetPrefix
    location: location
  }
}

module vm './challenge-06-VM.bicep' = {
  name: 'VM_Deployment'
  params: {
    adminPassword: adminPassword
    adminUsername: adminUsername
    ubuntuOSVersion: ubuntuOSVersion
    resourcePrefix: resourcePrefix
    subnetId: vnet.outputs.subnetId
    location: location
  }
}
