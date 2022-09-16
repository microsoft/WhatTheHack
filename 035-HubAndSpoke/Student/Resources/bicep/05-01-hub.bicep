param location string = 'eastus2'

resource hubvnet 'Microsoft.Network/virtualNetworks@2022-01-01' existing = {
  name: 'wth-vnet-hub01'
  scope: resourceGroup('wth-rg-hub')
}

resource privateDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.database.windows.net'
  location: 'global'
}

resource dnsvnetlink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: 'wth-dnsvnetlink-hub'
  parent: privateDNSZone
  location: 'global' 
  properties: {
    registrationEnabled: true
     virtualNetwork: {
      id: hubvnet.id
     }
  }
}
