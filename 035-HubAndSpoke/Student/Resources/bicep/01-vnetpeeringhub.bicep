resource hubvnet 'Microsoft.Network/virtualNetworks@2022-01-01' existing = {
  name: 'wth-vnet-hub01'
  scope: resourceGroup('wth-rg-hub')
}

resource spoke1vnet 'Microsoft.Network/virtualNetworks@2022-01-01' existing = {
  name: 'wth-vnet-spoke101'
  scope: resourceGroup('wth-rg-spoke1')
}

resource spoke2vnet 'Microsoft.Network/virtualNetworks@2022-01-01' existing = {
  name: 'wth-vnet-spoke201'
  scope: resourceGroup('wth-rg-spoke2')
}

resource hubtospoke1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-01-01' = {
  name: '${hubvnet.name}/wth-peering-hubtospoke1'
  properties: {
    allowGatewayTransit: true
    allowForwardedTraffic: true
    allowVirtualNetworkAccess: true
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: spoke1vnet.id
    }
  }
}

resource hubtospoke2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-01-01' = {
  name: '${hubvnet.name}/wth-peering-hubtospoke2'
  properties: {
    allowGatewayTransit: true
    allowForwardedTraffic: true
    allowVirtualNetworkAccess: true
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: spoke2vnet.id
    }
  }
}
