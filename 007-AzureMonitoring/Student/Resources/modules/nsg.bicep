param Location string
param Subnets array

resource nsg 'Microsoft.Network/networkSecurityGroups@2020-06-01' = [for Subnet in Subnets: {
  name: Subnet.NSG
  location: Location
  properties: {
    securityRules: [for SecurityRule in Subnet.SecurityRules: {
      name: SecurityRule.name
      properties: {
        priority: SecurityRule.properties.priority
        sourceAddressPrefix: SecurityRule.properties.sourceAddressPrefix
        sourcePortRange: SecurityRule.properties.sourcePortRange
        access: SecurityRule.properties.access
        protocol: SecurityRule.properties.protocol
        destinationPortRange: SecurityRule.properties.destinationPortRange
        direction: SecurityRule.properties.direction
        destinationAddressPrefix: SecurityRule.properties.destinationAddressPrefix
      }
    }]
  }
}]

output Names array = [for Subnet in Subnets: '${Subnet.NSG}']
output Ids array = [for Subnet in Subnets: '${resourceId('Microsoft.Network/networkSecurityGroups', Subnet.NSG)}']
