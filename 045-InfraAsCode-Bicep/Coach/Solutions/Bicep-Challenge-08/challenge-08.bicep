@description('Globally Unique Prefix')
param prefix string = 'ch08'

@description('Number of VM instances (100 or less).')
@maxValue(100)
param vmssInstanceCount int = 2 

@description('User name for the Virtual Machine.')
param adminUsername string 

@description('Password for the Virtual Machine.')
@secure()
param adminPassword string

@description('The Ubuntu version for the VM. This will pick a fully patched image of this given Ubuntu version. Allowed values: 12.04.5-LTS, 14.04.2-LTS, 15.10.')
@allowed([
  '12.04.5-LTS'
  '14.04.2-LTS'
  '15.10'
  '16.04-LTS'
  '18.04-LTS'
])
param ubuntuOSVersion string = '18.04-LTS'

param vnetPrefix string ='10.0.0.0/16'

param subnetName string = 'ch08-subnet'

param subnetPrefix string = '10.0.0.0/24'

// For Bicep modules, we don't need to provide an artifacts location - the modules get injected into our main ARM template as a nested deployment instead of a linked template.

// Deploy the VNet.
module vnet '../modules/deploy-vnet.bicep' = {
  name: 'vnet-deployment'
  params: {
    resourcePrefix: prefix
    vnetPrefix: vnetPrefix
    subnetName: subnetName
    subnetPrefix: subnetPrefix
  }
}

// Deploy the VMSS.
module vmss '../modules/deploy-vmss.bicep' = {
  name: 'vmss-deployment'
  params: {
    resourcePrefix: prefix
    vmssInstanceCount: vmssInstanceCount
    subnetRef: vnet.outputs.subnetResourceId // This implicitly adds a dependency so that the VNet will be deployed before the VMSS.
    adminUsername: adminUsername
    adminPassword: adminPassword
    ubuntuOSVersion: ubuntuOSVersion
  }
}
