param location string = 'eastus2'
param vmusername string = 'admin-wth'
@secure()
param vmPassword string

resource hubvnet 'Microsoft.Network/virtualNetworks@2022-01-01' existing = {
  name: 'wth-vnet-hub01'
  scope: resourceGroup('wth-rg-hub')
}

resource nvaoutsidesubnet 'Microsoft.Network/virtualNetworks/subnets@2022-01-01' = {
  name: '${hubvnet.name}/nvaoutsidesubnet'
  properties: {
    addressPrefix: '10.0.2.0/24'
  }
}

resource nvainsidesidesubnet 'Microsoft.Network/virtualNetworks/subnets@2022-01-01' = {
  dependsOn: [
    nvaoutsidesubnet
  ]
  name: '${hubvnet.name}/nvainsidesidesubnet'
  properties: {
    addressPrefix: '10.0.1.0/24'
  }
}

resource wthcsrpip01 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
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

resource wthcsroutsidenic 'Microsoft.Network/networkInterfaces@2022-07-01' = {
  name: 'wth-nic-nvaoutside'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfigOutside'
        properties: {
          subnet: {
            id: nvaoutsidesubnet.id
          }
          privateIPAllocationMethod: 'Static'
          privateIPAddress: '10.0.2.4'
          publicIPAddress: {
            id: wthcsrpip01.id
          }
        }
      }
    ]
  }
}

resource wthcsrinsidenic 'Microsoft.Network/networkInterfaces@2022-07-01' = {
  name: 'wth-nic-nvainside'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfigInside'
        properties: {
          subnet: {
            id: nvainsidesidesubnet.id
          }
          privateIPAllocationMethod: 'Static'
          privateIPAddress: '10.0.1.4'
        }
      }
    ]
  }
}

resource ciscocsr 'Microsoft.Compute/virtualMachines@2022-03-01' = {
  name: 'wth-vm-ciscocsr01'
  location: location
  plan: {
    publisher: 'cisco'
    product: 'cisco-csr-1000v'
    name: '16_12-byol'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2ms'
    }
    storageProfile: {
      imageReference: {
        publisher: 'cisco'
        offer: 'cisco-csr-1000v'
        sku: '16_12-byol'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: wthcsroutsidenic.id
          properties: {
            primary: true
          }
        }
        {
          id: wthcsrinsidenic.id
          properties: {
            primary: false
          }
        }
      ]
    }
    osProfile: {
      adminUsername: vmusername
      adminPassword: vmPassword
      computerName: 'wthcsrnva01'
      customData: loadFileAsBase64('./csrScriptNVA.txt')
    }
  }
}

resource rthubvms 'Microsoft.Network/routeTables@2022-01-01' = {
  name: 'wth-rt-hubvmssubnet'
  location: location
  properties: {
    routes: [
      {
        name: 'route-all-to-nva'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: wthcsrinsidenic.properties.ipConfigurations[0].properties.privateIPAddress
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
        name: 'route-spoke1-to-nva'
        properties: {
          addressPrefix: '10.1.0.0/16'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: wthcsrinsidenic.properties.ipConfigurations[0].properties.privateIPAddress
        }
      }
      {
        name: 'route-spoke2-to-nva'
        properties: {
          addressPrefix: '10.2.0.0/16'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: wthcsrinsidenic.properties.ipConfigurations[0].properties.privateIPAddress
        }
      }
      {
        name: 'route-hubvm-to-nva'
        properties: {
          addressPrefix: '10.0.10.0/24'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: wthcsrinsidenic.properties.ipConfigurations[0].properties.privateIPAddress
        }
      }
    ]
    disableBgpRoutePropagation: false
  }
}
