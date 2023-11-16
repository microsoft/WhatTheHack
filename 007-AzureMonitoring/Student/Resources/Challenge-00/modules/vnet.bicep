param AddressPrefixes array
param Location string 
param Subnets array
param VirtualNetworkName string

resource vnet 'Microsoft.Network/virtualNetworks@2020-07-01' = {
  name: VirtualNetworkName
  location: Location
  properties: {
    addressSpace: {
      addressPrefixes: AddressPrefixes
    }
    subnets: [for Subnet in Subnets: {
      name: Subnet.name
      properties: {
        addressPrefix: Subnet.prefix
        networkSecurityGroup: {
          id: Subnet.networkSecurityGroupId
        }
      }
    }]
  }
}

output Id string = vnet.id
output SubnetIds array = [for Subnet in Subnets: '${vnet.id}/subnets/${Subnet.name}']
