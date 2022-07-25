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

resource spoke2tohub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-01-01' = {
  name: '${spoke2vnet.name}/wth-peering-spoke1tohub'
  properties: {
    allowGatewayTransit: false
    allowForwardedTraffic: false
    allowVirtualNetworkAccess: true
    useRemoteGateways: true
    remoteVirtualNetwork: {
      id: hubvnet.id
    }
  }
}
