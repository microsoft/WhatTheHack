@description('Location in which Public IP resource will be created')
param location string = resourceGroup().location

@description('Public IP SKU')
param public_ip_sku object = {
  name: 'Standard'
  tier: 'Regional'
}

@description('The name of the Public IP resource')
param public_ip_name string

@description('The DNS label of the Public IP resource')
param public_ip_dns_label string

resource publicIpResource 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: public_ip_name
  location: location
  sku: public_ip_sku
  properties: {
    publicIPAllocationMethod: 'Static'
    dnsSettings: {
      domainNameLabel: public_ip_dns_label
    }
  }
}

output publicEndpointFqdn string = publicIpResource.properties.dnsSettings.fqdn
output publicEndpointId string = publicIpResource.id
