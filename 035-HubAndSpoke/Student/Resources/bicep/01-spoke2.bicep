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
  properties: {
    publicIPAllocationMethod: 'Static'
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
          publicIPAddress: {
            id: wthspoke2vmpip01.id
          }
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

resource changerdpport 'Microsoft.Compute/virtualMachines/runCommands@2022-03-01' = {
  name: '${wthspoke2vm01.name}/wth-vmextn-changerdpport'
  location: location
  properties: {
    source: {
      script: 'U2V0LUl0ZW1Qcm9wZXJ0eSAtUGF0aCAiSEtMTTpcU3lzdGVtXEN1cnJlbnRDb250cm9sU2V0XENvbnRyb2xcVGVybWluYWwgU2VydmVyXFdpblN0YXRpb25zXFJEUC1UY3BcIiAtTmFtZSBQb3J0TnVtYmVyIC1WYWx1ZSAzMzg5OQpOZXctTmV0RmlyZXdhbGxSdWxlIC1EaXNwbGF5TmFtZSAiUkRQIDMzODk5IFRDUCIgLURpcmVjdGlvbiBJbmJvdW5kIC1Mb2NhbFBvcnQgNTAxMDIgLVByb3RvY29sIFRDUCAtQWN0aW9uIEFsbG93Ck5ldy1OZXRGaXJld2FsbFJ1bGUgLURpc3BsYXlOYW1lICJSRFAgMzM4OTkgVURQIiAtRGlyZWN0aW9uIEluYm91bmQgLUxvY2FsUG9ydCA1MDEwMiAtUHJvdG9jb2wgVURQIC1BY3Rpb24gQWxsb3cKUmVzdGFydC1TZXJ2aWNlIC1OYW1lIFRlcm1TZXJ2aWNlIC1Gb3JjZQ=='
    }
  }
}

resource rtspoke2vms 'Microsoft.Network/routeTables@2022-01-01' = {
  name: 'wth-rt-spoke2vmssubnet'
  location: location
  properties: {
    routes: []
    disableBgpRoutePropagation: false
  }
}

resource nsgspoke1vms 'Microsoft.Network/networkSecurityGroups@2022-01-01' = {
  name: 'wth-nsg-spoke2vmssubnet'
  location: location
  properties: {
    securityRules: [
      {
        name: 'allow-altrdp-to-vmssubnet-from-any'
        properties: {
          priority: 1000
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
          priority: 1001
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
