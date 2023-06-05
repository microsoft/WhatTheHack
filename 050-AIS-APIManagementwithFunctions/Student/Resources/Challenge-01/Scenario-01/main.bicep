@description('Application/Solution name which will be used to derive names for all of your resources')
param base_name string = uniqueString(resourceGroup().id)

@description('Location in which resources will be created')
param location string = resourceGroup().location

@description('The edition of Azure API Management to use. This must be an edition that supports VNET Integration. This selection can have a significant impact on consumption cost and \'Developer\' is recommended for non-production use.')
@allowed([
  'Developer'
  'Premium'
])
param apim_sku string = 'Developer'

@description('The number of Azure API Management capacity units to provision. For Developer edition, this must equal 1.')
param apim_capacity int = 1

@description('The number of Azure Application Gateway capacity units to provision. This setting has a direct impact on consumption cost and is recommended to be left at the default value of 1')
param app_gateway_capacity int = 1

@description('The address space (in CIDR notation) to use for the VNET to be deployed in this solution. If integrating with other networked components, there should be no overlap in address space.')
param vnet_address_prefix string = '10.0.0.0/16'

@description('The address space (in CIDR notation) to use for the subnet to be used by Azure Application Gateway. Must be contained in the VNET address space.')
param app_gateway_subnet_prefix string = '10.0.0.0/24'

@description('The address space (in CIDR notation) to use for the subnet to be used by Azure API Management. Must be contained in the VNET address space.')
param apim_subnet_prefix string = '10.0.1.0/24'

@description('Descriptive name for publisher to be used in the portal')
param apim_publisher_name string = 'Contoso'

@description('Email adddress associated with publisher')
param apim_publisher_email string = 'api@contoso.com'

@description('Public IP SKU')
param public_ip_sku object = {
  name: 'Standard'
  tier: 'Regional'
}

@description('Function app SKU')
param functionSku string = 'EP1'

@description('Storage account name')
param storageAccountName string = toLower('stor${base_name}')

@description('Function runtime')
param functionRuntime string = 'dotnet'

@description('App Service plan name')
param appServicePlanName string = toLower('asp-${base_name}')


@description('Jumphost virtual machine username')
param jumpboxVmUsername string = 'svradmin'

@secure()
@minLength(8)
@description('Jumphost virtual machine password')
param jumpboxVmPassword string 

var laws_name_var = 'laws-${base_name}'
var app_insights_name_var = 'ai-${base_name}'
var vnet_name_var = 'vnet-${base_name}'
var apim_name_var = 'apim-${base_name}'
var public_ip_name_var = 'pip-${base_name}'
var app_gateway_name_var = 'agw-${base_name}'
var vnet_dns_link_name = 'vnet-dns-link-${base_name}'
var apim_dns_name_var = 'azure-api.net'
var apim_nsg_name_var = 'nsg-${apim_name_var}'
var agw_nsg_name_var = 'nsg-${app_gateway_name_var}'
var funcapp_name_var = 'func-${base_name}'
var vm_name_var = 'jumpboxVM'
var vm_nsg_name_var = 'nsg-${vm_name_var}'
var bastion_name_var = 'bastion-${base_name}'
var pip_bastion_name_var = 'pip-bas-${base_name}'

var shutdownTime = '1800'
var shutdownTimeZone = 'AUS Eastern Standard Time'

module logAnalyticsModule 'modules/laws.bicep' = {
  name: laws_name_var
  params: {
    location: location
    app_insights_name: app_insights_name_var
    log_analytics_workspace_name: laws_name_var
  }
}

module publicIpModule 'modules/pip.bicep' = {
  name: public_ip_name_var
  params: {
    location: location
    public_ip_dns_label: public_ip_name_var
    public_ip_name: public_ip_name_var
    public_ip_sku: public_ip_sku
  }
}

module vnetModule 'modules/vnet.bicep' = {
  name: vnet_name_var
  params: {
    location: location
    vnet_name: vnet_name_var
    vnet_address_prefix: vnet_address_prefix
    apim_subnet_prefix: apim_subnet_prefix
    app_gateway_subnet_prefix: app_gateway_subnet_prefix
    agw_nsg_id: nsgModule.outputs.agwNSGId
    apim_nsg_id: nsgModule.outputs.apimNSGId
    vm_nsg_id: nsgModule.outputs.vmNSGId
  }
}

module nsgModule 'modules/nsg.bicep' = {
  name: 'nsgModules'
  params: {
    agw_nsg_name: agw_nsg_name_var
    apim_nsg_name: apim_nsg_name_var
    vm_nsg_name: vm_nsg_name_var
    location: location
  }
}

module apimModule 'modules/apim.bicep' = {
  name: apim_name_var    
  params: {
    location: location
    apim_sku: apim_sku
    apim_capacity: apim_capacity
    apim_publisher_email: apim_publisher_email
    apim_publisher_name: apim_publisher_name
    apim_name: apim_name_var
    subnetResourceId: vnetModule.outputs.apimSubnetResourceId
    appInsightsResourceId: logAnalyticsModule.outputs.appInsightsResourceId
    appInsightsInstrumentationKey: logAnalyticsModule.outputs.appInsightsInstrumentationKey
    log_analytics_workspace_id: logAnalyticsModule.outputs.logAnalyticsWorkspaceId
  }
}

module agwModule 'modules/agw.bicep' = {
  name: app_gateway_name_var
  params: {
    location: location
    pip_name: public_ip_name_var
    apim_name: apimModule.outputs.apimName
    app_gateway_capacity: app_gateway_capacity
    app_gateway_name: app_gateway_name_var
    log_analytics_workspace_id: logAnalyticsModule.outputs.logAnalyticsWorkspaceId
    publicIpId: publicIpModule.outputs.publicEndpointId
    vnet_name: vnet_name_var
  }
}

module privateDnsZoneResource 'modules/privateDnsZones.bicep' = {
  name: apim_dns_name_var
  params: {    
    apim_name: apim_name_var
    apimIpv4Address: apimModule.outputs.apimPrivateIpAddresses
    vnet_dns_link_name: vnet_dns_link_name
    vnetId: vnetModule.outputs.vnetId
    apim_dns_name: apim_dns_name_var
    location: 'global'
  }
}

module functionModule 'modules/functionapp.bicep' = {
  name: funcapp_name_var
  params: {
    location:location
    functionRuntime:functionRuntime
    functionSku:functionSku
    storageAccountName:storageAccountName
    functionAppName:funcapp_name_var
    appServicePlanName:appServicePlanName
    appInsightsInstrumentationKey: logAnalyticsModule.outputs.appInsightsInstrumentationKey    
  }
}

module vmModule 'modules/vm.bicep' = {
  name: vm_name_var
  params: {
    adminPassword: jumpboxVmPassword
    adminUsername: jumpboxVmUsername
    vmName: vm_name_var
    subnetId: vnetModule.outputs.vmSubnetResourceId
    location: location
  }
}

module vmAutoShutdownModule 'modules/devtest.bicep' = {
  name: 'vmAutoShutdownModule'
  params: {
    autoShutdownStatus: 'Enabled'
    autoShutdownTime: shutdownTime
    autoShutdownTimeZone: shutdownTimeZone
    location: location
    virtualMachineName: vm_name_var
    virtualMachineResourceId: vmModule.outputs.vmResourceId
  }
}

module bastionModule 'modules/bastion.bicep' = {
  name: bastion_name_var
  params: {
    location: location
    bastionHostName: bastion_name_var
    publicIpName: pip_bastion_name_var
    bastionSubnetId: vnetModule.outputs.bastionSubnetResourceId
  }
}
