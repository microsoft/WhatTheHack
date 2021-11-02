param vnetName string = 'vnet-${uniqueString(resourceGroup().id)}'
param vnetLocation string = resourceGroup().location
param addressPrefixes string = '10.0.0.0/16'


resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnetName
  location: vnetLocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefixes
      ]
    }
  }
}
