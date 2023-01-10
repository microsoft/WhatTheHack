param location string = 'eastus2'

resource wthafw 'Microsoft.Network/azureFirewalls@2022-01-01' existing = {
  name: 'wth-afw-hub01'
  scope: resourceGroup('wth-rg-hub')
}

resource rtspoke2vms 'Microsoft.Network/routeTables@2022-01-01' = {
  name: 'wth-rt-spoke2vmssubnet'
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
        name: 'route-hubvnet_vms-to-afw'
        properties: {
          addressPrefix: '10.0.10.0/24'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: wthafw.properties.ipConfigurations[0].properties.privateIPAddress

        }
      }
    ]
    disableBgpRoutePropagation: true
  }
}
