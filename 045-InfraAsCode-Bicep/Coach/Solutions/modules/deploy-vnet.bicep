
@description('naming prefix')
param resourcePrefix string

@description('Address Prefix')
param vnetPrefix string = '10.0.0.0/16'

@description('Subnet Name')
param subnetName string = 'Default'

@description('Subnet Prefix')
param subnetPrefix string = '10.0.0.0/24'

var prefix = '${resourcePrefix}-${uniqueString(resourceGroup().id)}'
var vnetName = '${prefix}-vnet'
var nsgName = '${subnetName}-nsg'

resource nsg 'Microsoft.Network/networkSecurityGroups@2015-06-15' = {
  name: nsgName
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

resource vnet 'Microsoft.Network/virtualNetworks@2015-06-15' = {
  name: vnetName
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
            id: nsg.id
          }
        }
      }
    ]
  }
}

output subnetResourceId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)
