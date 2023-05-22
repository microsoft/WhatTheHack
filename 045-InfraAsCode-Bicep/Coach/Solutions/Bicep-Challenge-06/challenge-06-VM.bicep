param location string = resourceGroup().location

//Password for the VM
@secure()
param adminPassword string

//Username for the VM
param adminUsername string

//Resource Prefix for all VM Resources
param resourcePrefix string = 'bicepwth'

//The Ubuntu version for the VM. This will pick a fully patched image of this given Ubuntu version.
@allowed([
  '16.04.0-LTS'
  '18.04-LTS'
])
param ubuntuOSVersion string = '18.04-LTS'

// Subnet 
param subnetId string

var nicName = '${resourcePrefix}-VM-NIC'
var vmName = '${resourcePrefix}-VM'
var publicIPAddressName = '${resourcePrefix}-PIP'
var publicIPAddressType = 'Dynamic'
var dnsNameForPublicIP = '${resourcePrefix}${uniqueString(resourceGroup().id)}-pip'
var vmSize = 'Standard_DS2_v2'
var imagePublisher = 'Canonical'
var imageOffer = 'UbuntuServer'

//Start of resource section for creating VM

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: publicIPAddressName
  location: location
  properties: {
    publicIPAllocationMethod: publicIPAddressType
    dnsSettings: {
      domainNameLabel: dnsNameForPublicIP
    }
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2022-07-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddress.id
          }
          subnet: {
            id: subnetId
          }
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2022-11-01' = {
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
          id: nic.id
        }
      ]
    }
  }
}
//End of resource section for creating VM
