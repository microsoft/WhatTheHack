//Resource Prefix for all VM Resources
param resourcePrefix string = 'bicepwth'

// VNet Address Prefix
param vnetPrefix string = '10.0.0.0/16'

// Subnet Name
param subnetName string = 'Default'

//Subnet Prefix
param subnetPrefix string = '10.0.0.0/24'

var vnetName_var = '${resourcePrefix}-VNET'
var nsgName_var = '${resourcePrefix}-NSG'



resource nsgName 'Microsoft.Network/networkSecurityGroups@2015-06-15' = {
  name: nsgName_var
  location: resourceGroup().location
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

resource vnetName 'Microsoft.Network/virtualNetworks@2015-06-15' = {
  name: vnetName_var
  location: resourceGroup().location
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
            id: nsgName.id
          }
        }
      }
    ]
  }
}

