param location string = 'eastus2'
param spoke2VMUsername string = 'admin-wth'
@secure()
param spoke2VMPassword string

targetScope = 'resourceGroup'
//spoke2 resources

resource wthspoke2vnet 'Microsoft.Network/virtualNetworks@2021-08-01' = {
  name: 'wth-vnet-spoke201'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.2.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'subnet-spoke2vms'
        properties: {
          addressPrefix: '10.2.10.0/24'
        }
      }
    ]
  }
}

resource wthspoke2vmpip01 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  name: 'wth-pip-spoke2vm01'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
}

resource wthspoke2vmnic 'Microsoft.Network/networkInterfaces@2022-01-01' = {
  name: 'wth-nic-spoke2vm01'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: '${wthspoke2vnet.id}/subnets/subnet-spoke2vms'
          }
          privateIPAddress: '10.2.10.4'
        }
      }
    ]
  }
}

resource wthspoke2vm01 'Microsoft.Compute/virtualMachines@2022-03-01' = {
  name: 'wth-vm-spoke201'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: 'wth-disk-vmspoke2os01'
        createOption: 'FromImage'
        caching: 'ReadWrite'
      }
    }
    osProfile: {
      computerName: 'vm-spoke201'
      adminUsername: spoke2VMUsername
      adminPassword: spoke2VMPassword
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: wthspoke2vmnic.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
    licenseType: 'Windows_Server'
  }
}

resource rtspoke2vms 'Microsoft.Network/routeTables@2022-01-01' = {
  name: 'wth-rt-spoke2vmssubnet'
  properties: {
    routes: []
    disableBgpRoutePropagation: false
  }
}

resource nsgspoke1vms 'Microsoft.Network/networkSecurityGroups@2022-01-01' = {
  name: 'wth-nsg-spoke2vmssubnet'
  properties: {
    securityRules: [
      {
        name: 'allow-altrdp-to-vmssubnet-from-any'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '33899-33899'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '10.2.10.0/24'
        }
      }
      {
        name: 'allow-altssh-to-vmssubnet-from-any'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22222-22222'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '10.2.10.0/24'
        }
      }
    ]
  }
}
