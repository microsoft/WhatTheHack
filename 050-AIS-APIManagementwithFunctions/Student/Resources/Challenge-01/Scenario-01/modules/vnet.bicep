@description('The name of the virtual network resource')
param vnet_name string

@description('The address space (in CIDR notation) to use for the VNET to be deployed in this solution. If integrating with other networked components, there should be no overlap in address space.')
param vnet_address_prefix string = '10.0.0.0/16'

@description('The address space (in CIDR notation) to use for the subnet to be used by Azure Application Gateway. Must be contained in the VNET address space.')
param app_gateway_subnet_prefix string = '10.0.0.0/24'

@description('The address space (in CIDR notation) to use for the subnet to be used by Azure API Management. Must be contained in the VNET address space.')
param apim_subnet_prefix string = '10.0.1.0/24'

@description('The address space (in CIDR notation) to use for the subnet to be used by Virtual Machines. Must be contained in the VNET address space.')
param vm_subnet_prefix string = '10.0.2.0/24'

@description('The address space (in CIDR notation) to use for the subnet to be used by Azure Bastion. Must be contained in the VNET address space.')
param bastion_subnet_prefix string = '10.0.3.0/26'

@description('Location in which resources will be created')
param location string 

@description('The reference to the NSG for API Management')
param apim_nsg_id string

@description('The reference to the NSG for Application Gateway')
param agw_nsg_id string

@description('The reference to the NSG for Application Gateway')
param vm_nsg_id string

resource vnetResource 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnet_name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet_address_prefix
      ]
    }
    subnets: [
      {
        type: 'subnets'
        name: 'appGatewaySubnet'
        properties: {
          addressPrefix: app_gateway_subnet_prefix
          serviceEndpoints: [
            {
              service: 'Microsoft.KeyVault'
              locations: [
                '*'
              ]
            }
          ]
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        type: 'subnets'
        name: 'apimSubnet'
        properties: {
          addressPrefix: apim_subnet_prefix
          serviceEndpoints: [
            {
              service: 'Microsoft.KeyVault'
              locations: [
                '*'
              ]
            }
          ]
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        type: 'subnets'
        name: 'vmSubnet'        
        properties: {
          addressPrefix: vm_subnet_prefix           
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          networkSecurityGroup: {
            id: vm_nsg_id
          }
        }
      }      
      {
        type: 'subnets'
        name: 'AzureBastionSubnet'        
        properties: {
          addressPrefix: bastion_subnet_prefix           
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Disabled'

        }
      }
    ]
  }
}



output apimSubnetResourceId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnet_name, 'apimSubnet')
output appGatewaySubnetResourceId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnet_name, 'appGatewaySubnet')
output vmSubnetResourceId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnet_name, 'vmSubnet')
output bastionSubnetResourceId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnet_name, 'AzureBastionSubnet')
output vnetId string = vnetResource.id
