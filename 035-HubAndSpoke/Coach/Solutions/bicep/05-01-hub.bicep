param location string = 'eastus2'

resource hubvnet 'Microsoft.Network/virtualNetworks@2022-01-01' existing = {
  name: 'wth-vnet-hub01'
}

resource spoke1vnet 'Microsoft.Network/virtualNetworks@2022-01-01' existing = {
  name: 'wth-vnet-spoke101'
  scope: resourceGroup('wth-rg-spoke1')
}

resource spoke2vnet 'Microsoft.Network/virtualNetworks@2022-01-01' existing = {
  name: 'wth-vnet-spoke201'
  scope: resourceGroup('wth-rg-spoke2')
}

resource privateDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink${environment().suffixes.sqlServerHostname}'
  location: 'global'
  properties: {
  }
}

resource privateDnsZoneWeb 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: 'privatelink.azurewebsites.net'
  location: 'global'
}

resource dnsvnetlinkhub 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: 'wth-dnsvnetlink-hub'
  parent: privateDNSZone
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: hubvnet.id
    }
  }
}

resource dnsvnetlinkspoke1 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: 'wth-dnsvnetlink-spoke1'
  parent: privateDNSZone
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: spoke1vnet.id
    }
  }
}

resource dnsvnetlinkspoke2 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: 'wth-dnsvnetlink-spoke2'
  parent: privateDNSZone
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: spoke2vnet.id
    }
  }
}

resource dnsvnetlinkhubweb 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: 'wth-dnsvnetlink-webhub'
  parent: privateDnsZoneWeb
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: hubvnet.id
    }
  }
}

resource dnsvnetlinkwebspoke1 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: 'wth-dnsvnetlink-webspoke1'
  parent: privateDnsZoneWeb
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: spoke1vnet.id
    }
  }
}

resource dnsvnetlinkwebspoke2 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: 'wth-dnsvnetlink-webspoke2'
  parent: privateDnsZoneWeb
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: spoke2vnet.id
    }
  }
}

resource inboundDNSSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  name: 'wth-subnet-inbounddns'
  parent: hubvnet
  properties: {
    addressPrefix: '10.0.17.0/27'
    delegations: [
      {
        name: 'Microsoft.Network/dnsResolvers'
        properties: {
          serviceName: 'Microsoft.Network/dnsResolvers'
        }
      }
    ]
  }
}

resource outboundDNSSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  name: 'wth-subnet-outbounddns'
  dependsOn: [
    inboundDNSSubnet
  ]
  parent: hubvnet
  properties: {
    addressPrefix: '10.0.17.32/27'
    delegations: [
      {
        name: 'Microsoft.Network/dnsResolvers'
        properties: {
          serviceName: 'Microsoft.Network/dnsResolvers'
        }
      }
    ]
  }
}

resource publicIP 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: 'wth-pip-dnsresolver01'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }
}

resource privateDNSResplver 'Microsoft.Network/dnsResolvers@2022-07-01' = {
  name: 'wth-dnsresolver-hub01'
  location: location
  properties: {
    virtualNetwork: {
      id: hubvnet.id
    }
  }
  resource inboundEndpoint 'inboundEndpoints@2022-07-01' = {
    name: 'wth-dnsresolver-inboundendpoint01'
    location: location
    properties: {
      ipConfigurations: [
        {
          //privateIpAddress: '10.0.17.4'
          //privateIpAllocationMethod: 'Static'
          subnet: {
            id: inboundDNSSubnet.id
          }
        }
      ]
    }
  }
  resource outboundEndpoint 'outboundEndpoints@2022-07-01' = {
    name: 'wth-dnsresolver-outboundendpoint01'
    location: location
    properties: {
      subnet: {
        id: outboundDNSSubnet.id
      }
    }
  }
}
