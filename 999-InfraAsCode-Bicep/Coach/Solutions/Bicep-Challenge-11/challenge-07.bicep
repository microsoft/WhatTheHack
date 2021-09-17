targetScope = 'subscription'

param resourceGroupName string = 'myrg01'
param location string

param vnetName string
param addressPrefixes string

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name : resourceGroupName
  location: location
}


module network 'network.bicep' = {
  name: 'vnet'
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    rg
  ]
  params: {
    vnetName: vnetName
    addressPrefixes: addressPrefixes
  }
}
