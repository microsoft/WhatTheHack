//Password for the VM
@secure()
param adminPassword string

//Username for the VM
param adminUsername string

//Resource Prefix for all VM Resources
param resourcePrefix string = 'bicepwth'

//The Ubuntu version for the VM. This will pick a fully patched image of this given Ubuntu version. Allowed values: 12.04.5-LTS, 14.04.2-LTS, 15.10.
@allowed([
  '12.04.5-LTS'
  '14.04.2-LTS'
  '15.10'
  '16.04-LTS'
])
param ubuntuOSVersion string = '16.04-LTS'

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
  }
}

module vm './challenge-06-VM.bicep' = {
  name: 'VM_Deployment'
  params: {
    adminPassword: adminPassword
    adminUsername: adminUsername
    ubuntuOSVersion: ubuntuOSVersion
    resourcePrefix: resourcePrefix
    subnetName: subnetName
  }
}
