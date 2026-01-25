param location string = 'eastus2'

resource onpremcsrpip 'Microsoft.Network/publicIPAddresses@2022-01-01' existing = {
  name: 'wth-pip-csr01'
  scope: resourceGroup('wth-rg-onprem')
}

resource onpremcsrnic 'Microsoft.Network/networkInterfaces@2022-01-01' existing = {
  name: 'wth-nic-csr01'
  scope: resourceGroup('wth-rg-onprem')
}

resource wthhubvnetgw 'Microsoft.Network/virtualNetworkGateways@2022-01-01' existing = {
  name: 'wth-vngw-hub01'
  scope: resourceGroup('wth-rg-hub')
}

resource wthhublocalgw 'Microsoft.Network/localNetworkGateways@2022-01-01' = {
  name: 'wth-lgw-onprem01'
  location: location
  properties: {
    gatewayIpAddress: onpremcsrpip.properties.ipAddress
    localNetworkAddressSpace: {
      addressPrefixes: []
    }
    bgpSettings: {
      bgpPeeringAddress: onpremcsrnic.properties.ipConfigurations[0].properties.privateIPAddress
      asn: 65510
    }
  }
}

resource wthhubconnection 'Microsoft.Network/connections@2022-01-01' = {
  name: 'wth-cxn-vpn01'
  location: location
  properties: {
    sharedKey: '123mysecretkey'
    connectionType: 'IPsec'
    connectionMode: 'Default'
    enableBgp: true
    localNetworkGateway2: {
      id: wthhublocalgw.id
    }
    virtualNetworkGateway1: {
      id: wthhubvnetgw.id
    }
  }
}
