param location string = 'eastus2'
param afwSku string = 'basic'

resource hubvnet 'Microsoft.Network/virtualNetworks@2022-01-01' existing = {
  name: 'wth-vnet-hub01'
  scope: resourceGroup('wth-rg-hub')
}

resource afwsubnet 'Microsoft.Network/virtualNetworks/subnets@2022-01-01' = {
  name: '${hubvnet.name}/AzureFirewallSubnet'
  properties: {
    addressPrefix: '10.0.1.0/24'
  }
}

resource afwmgmtsubnet 'Microsoft.Network/virtualNetworks/subnets@2022-01-01' = {
  name: '${hubvnet.name}/AzureFirewallManagementSubnet'
  properties: {
    addressPrefix: '10.0.2.0/24'
  }
}

resource wthafwpip01 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  name: 'wth-pip-afw01'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource wthafwmgmtpip01 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  name: 'wth-pip-afwmgmt01'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource wthafwpolicy 'Microsoft.Network/firewallPolicies@2022-01-01' = {
  name: 'wth-fwp-policy01'
  location: location
  properties: {
    sku: {
      tier: afwSku
    }
  }
}

resource wthafw 'Microsoft.Network/azureFirewalls@2022-01-01' = {
  name: 'wth-afw-hub01'
  location: location
  properties: {
    sku: {
      name: 'AZFW_VNet'
      tier: afwSku
    }
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: afwsubnet.id
          }
          publicIPAddress: {
            id: wthafwpip01.id
          }
        }
      }
    ]
    managementIpConfiguration: {
        name: 'ipconfigMgmt1'
        properties: {
          publicIPAddress: {
            id: wthafwmgmtpip01.id
          }
          subnet: {
            id: afwmgmtsubnet.id
          }
        }
      }
    
    firewallPolicy: {
      id: wthafwpolicy.id
    }
  }
}

resource wthlaw 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: 'wth-law-default01'
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}

resource wthafwdiagsettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diagSettingsAFW'
  scope: wthafw
  properties: {
    workspaceId: wthlaw.id
    logs: [
      {
        enabled: true
        categoryGroup: 'allLogs'
        retentionPolicy: {
          enabled: true
          days: 14
        }
      }
    ]
    logAnalyticsDestinationType: 'Dedicated'
  }
}

resource rthubvms 'Microsoft.Network/routeTables@2022-01-01' = {
  name: 'wth-rt-hubvmssubnet'
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
    ]
    disableBgpRoutePropagation: false
  }
}

resource rtvnetgw 'Microsoft.Network/routeTables@2022-01-01' = {
  name: 'wth-rt-hubgwsubnet'
  location: location
  properties: {
    routes: [
      {
        name: 'route-spoke1-to-afw'
        properties: {
          addressPrefix: '10.1.0.0/16'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: wthafw.properties.ipConfigurations[0].properties.privateIPAddress
        }
      }
      {
        name: 'route-spoke2-to-afw'
        properties: {
          addressPrefix: '10.2.0.0/16'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: wthafw.properties.ipConfigurations[0].properties.privateIPAddress
        }
      }
      {
        name: 'route-hubvm-to-afw'
        properties: {
          addressPrefix: '10.0.10.0/24'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: wthafw.properties.ipConfigurations[0].properties.privateIPAddress
        }
      }
    ]
    disableBgpRoutePropagation: false
  }
}
