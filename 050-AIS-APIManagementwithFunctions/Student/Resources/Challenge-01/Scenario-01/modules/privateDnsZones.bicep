@description('The VNET DNS Link name')
param vnet_dns_link_name string = ''

@description('The name of the API Management resource')
param apim_name string = ''

@description('The DNS of the API Management resource')
param apim_dns_name string = ''

@description('The IPv4 address (private) of the API Management resource')
param apimIpv4Address string = ''

@description('The location where the resource would be created')
param vnetId string = ''

@description('The location where the resource would be created')
param location string = 'global'


resource privateDnsZoneResource 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: apim_dns_name
  location: location
  properties: {}

}

resource privateDnsZoneARecordResource 'Microsoft.Network/privateDnsZones/A@2020-06-01' = if (true) {
  parent: privateDnsZoneResource
  name: apim_name
  properties: {
    ttl: 36000
    aRecords: [
      {
        ipv4Address: apimIpv4Address 
      }
    ]
  }
}

resource privateDnsZoneARecord2Resource 'Microsoft.Network/privateDnsZones/A@2020-06-01' = if (true) {
  parent: privateDnsZoneResource
  name: '${apim_name}.developer'
  properties: {
    ttl: 36000
    aRecords: [
      {
        ipv4Address: apimIpv4Address 
      }
    ]
  }
}

resource privateDnsLinkNameResource 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZoneResource
  name: vnet_dns_link_name
  location: location
  properties: {
    registrationEnabled: true
    virtualNetwork: {
      id: vnetId //vnet_name.id
    }
  }
}
