//Password for the VM
@secure()
param adminPassword string

//Username for the VM
param adminUsername string

//Resource Prefix for all VM Resources
param resourcePrefix string = 'bicepwth'

param location string = resourceGroup().location

//The Ubuntu version for the VM. This will pick a fully patched image of this given Ubuntu version. Allowed values: 12.04.5-LTS, 14.04.2-LTS, 15.10.
@allowed([
  '16.04.0-LTS'
  '18.04-LTS'
])
param ubuntuOSVersion string = '18.04-LTS'

// VNet Address Prefix
param vnetPrefix string = '10.0.0.0/16'

// Subnet Name
param subnetName string = 'Default'

//Subnet Prefix
param subnetPrefix string = '10.0.0.0/24'

var vnetName = '${resourcePrefix}-VNET'
var nsgName = '${resourcePrefix}-NSG'
var nicName = '${resourcePrefix}-VM-NIC'
var vmName = '${resourcePrefix}-VM'
var publicIPAddressName = '${resourcePrefix}-PIP'
var publicIPAddressType = 'Dynamic'
var dnsNameForPublicIP = '${resourcePrefix}${uniqueString(resourceGroup().id)}-pip'
var vmSize = 'Standard_DS2_v2'
var imagePublisher = 'Canonical'
var imageOffer = 'UbuntuServer'

//Start of resource section for creating VM

resource thisnsg 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'ssh_rule'
        properties: {
          description: 'Allow SSH'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'web_rule'
        properties: {
          description: 'Allow HTTP'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 101
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource thisvnet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefix
          networkSecurityGroup: {
            id: thisnsg.id
          }
        }
      }
    ]
  }
}

resource thisPip 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: publicIPAddressName
  location: location
  properties: {
    publicIPAllocationMethod: publicIPAddressType
    dnsSettings: {
      domainNameLabel: dnsNameForPublicIP
    }
  }
}

resource thisnic 'Microsoft.Network/networkInterfaces@2022-07-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: thisPip.id
          }
          subnet: {
            id: thisvnet.properties.subnets[0].id
          }
        }
      }
    ]
  }
}

resource thisvm 'Microsoft.Compute/virtualMachines@2022-11-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: imagePublisher
        offer: imageOffer
        sku: ubuntuOSVersion
        version: 'latest'
      }
      osDisk: {
        name: 'osdisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: thisnic.id
        }
      ]
    }
  }
}
//End of resource section for creating VM
