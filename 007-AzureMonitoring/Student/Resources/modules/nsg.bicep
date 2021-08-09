param Location string
param Subnets array

resource nsg 'Microsoft.Network/networkSecurityGroups@2020-06-01' = [for Subnet in Subnets: {
  name: Subnet.NSG
  location: Location
  properties: {
    securityRules: [for SecurityRule in Subnet.SecurityRules: {
      name: SecurityRule.name
      properties: SecurityRule.properties
    }]
  }
}]

output Names array = [for Subnet in Subnets: '${Subnet.NSG}']
output Ids array = [for Subnet in Subnets: '${resourceId('Microsoft.Network/networkSecurityGroups', Subnet.NSG)}']
