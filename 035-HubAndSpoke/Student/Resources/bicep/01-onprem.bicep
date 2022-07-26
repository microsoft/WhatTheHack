param location string = 'eastus2'
param onpremVMUsername string = 'admin-wth'
@secure()
param vmPassword string

targetScope = 'resourceGroup'
//onprem resources

resource wthonpremvnet 'Microsoft.Network/virtualNetworks@2021-08-01' = {
  name: 'wth-vnet-onprem01'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '172.16.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'subnet-vpn'
        properties: {
          addressPrefix: '172.16.0.0/24'
        }
      }
      {
        name: 'subnet-onpremvms'
        properties: {
          addressPrefix: '172.16.10.0/24'
          networkSecurityGroup: {
            id: nsgonpremvms.id
          }
          routeTable: { 
            id: rtonpremvms.id 
          }
        }
      }
    ]
  }
}

resource wthonpremvmpip01 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  name: 'wth-pip-onpremvm01'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource wthonpremvmnic 'Microsoft.Network/networkInterfaces@2022-01-01' = {
  name: 'wth-nic-onpremvm01'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: '${wthonpremvnet.id}/subnets/subnet-onpremvms'
          }
          privateIPAddress: '172.16.10.4'
          publicIPAddress: {
            id: wthonpremvmpip01.id
          }
        }
      }
    ]
  }
}

resource wthonpremvm01 'Microsoft.Compute/virtualMachines@2022-03-01' = {
  name: 'wth-vm-onprem01'
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
        name: 'wth-disk-vmonpremos01'
        createOption: 'FromImage'
        caching: 'ReadWrite'
      }
    }
    osProfile: {
      computerName: 'vm-onprem01'
      adminUsername: onpremVMUsername
      adminPassword: vmPassword
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: wthonpremvmnic.id
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

resource changerdpport 'Microsoft.Compute/virtualMachines/extensions@2022-03-01' = {
  name: '${wthonpremvm01.name}/wth-vmextn-changerdpport33899'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    settings: {
      commandToExecute: 'powershell.exe -ep bypass -encodedcommand UwBlAHQALQBJAHQAZQBtAFAAcgBvAHAAZQByAHQAeQAgAC0AUABhAHQAaAAgACIASABLAEwATQA6AFwAUwB5AHMAdABlAG0AXABDAHUAcgByAGUAbgB0AEMAbwBuAHQAcgBvAGwAUwBlAHQAXABDAG8AbgB0AHIAbwBsAFwAVABlAHIAbQBpAG4AYQBsACAAUwBlAHIAdgBlAHIAXABXAGkAbgBTAHQAYQB0AGkAbwBuAHMAXABSAEQAUAAtAFQAYwBwAFwAIgAgAC0ATgBhAG0AZQAgAFAAbwByAHQATgB1AG0AYgBlAHIAIAAtAFYAYQBsAHUAZQAgADMAMwA4ADkAOQAKAE4AZQB3AC0ATgBlAHQARgBpAHIAZQB3AGEAbABsAFIAdQBsAGUAIAAtAEQAaQBzAHAAbABhAHkATgBhAG0AZQAgACIAUgBEAFAAIAAzADMAOAA5ADkAIABUAEMAUAAiACAALQBEAGkAcgBlAGMAdABpAG8AbgAgAEkAbgBiAG8AdQBuAGQAIAAtAEwAbwBjAGEAbABQAG8AcgB0ACAAMwAzADgAOQA5ACAALQBQAHIAbwB0AG8AYwBvAGwAIABUAEMAUAAgAC0AQQBjAHQAaQBvAG4AIABBAGwAbABvAHcACgBOAGUAdwAtAE4AZQB0AEYAaQByAGUAdwBhAGwAbABSAHUAbABlACAALQBEAGkAcwBwAGwAYQB5AE4AYQBtAGUAIAAiAFIARABQACAAMwAzADgAOQA5ACAAVQBEAFAAIgAgAC0ARABpAHIAZQBjAHQAaQBvAG4AIABJAG4AYgBvAHUAbgBkACAALQBMAG8AYwBhAGwAUABvAHIAdAAgADMAMwA4ADkAOQAgAC0AUAByAG8AdABvAGMAbwBsACAAVQBEAFAAIAAtAEEAYwB0AGkAbwBuACAAQQBsAGwAbwB3AAoAUgBlAHMAdABhAHIAdAAtAFMAZQByAHYAaQBjAGUAIAAtAE4AYQBtAGUAIABUAGUAcgBtAFMAZQByAHYAaQBjAGUAIAAtAEYAbwByAGMAZQA='
    }
  }
}

resource rtonpremvms 'Microsoft.Network/routeTables@2022-01-01' = {
  name: 'wth-rt-onpremvmssubnet'
  location: location
  properties: {
    routes: []
    disableBgpRoutePropagation: false
  }
}

resource nsgonpremvms 'Microsoft.Network/networkSecurityGroups@2022-01-01' = {
  name: 'wth-nsg-onpremvmssubnet'
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
          destinationAddressPrefix: '172.16.10.0/24'
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
          destinationAddressPrefix: '172.16.10.0/24'
        }
      }
    ]
  }
}

resource wthonpremcsrpip01 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  name: 'wth-pip-csr01'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource wthonpremcsrnic 'Microsoft.Network/networkInterfaces@2022-01-01' = {
  name: 'wth-nic-csr01'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: '${wthonpremvnet.id}/subnets/subnet-vpn'
          }
          privateIPAddress: '172.16.0.4'
          publicIPAddress: {
            id: wthonpremcsrpip01.id
          }
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
          id: wthonpremcsrnic.id
        }
      ]
    }
    osProfile: {
      adminUsername: onpremVMUsername
      adminPassword: vmPassword
      computerName: 'csr'
    }
  }
}
