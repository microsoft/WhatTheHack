param location string = 'eastus2'

resource wthafw 'Microsoft.Network/azureFirewalls@2022-01-01' existing = {
  name: 'wth-afw-hub01'
  scope: resourceGroup('wth-rg-hub')
}

resource rtspoke1vms 'Microsoft.Network/routeTables@2022-01-01' = {
  name: 'wth-rt-spoke1vmssubnet'
  location: location
  properties: {
    routes: [
      {
        name: 'route-all-to-afw'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: wthafw.properties.ipConfigurations[0].properties.privateIPAddress

        }
      }
      {
        name: 'route-hubvnet-to-afw'
        properties: {
          addressPrefix: '10.0.0.0/16'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: wthafw.properties.ipConfigurations[0].properties.privateIPAddress

        }
      }
    ]
    disableBgpRoutePropagation: true
  }
}
