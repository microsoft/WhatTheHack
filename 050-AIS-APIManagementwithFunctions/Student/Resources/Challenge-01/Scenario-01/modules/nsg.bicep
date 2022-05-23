@description('The name of the NSG for API Management')
param apim_nsg_name string

@description('The name of the NSG for Application Gateway')
param agw_nsg_name string

@description('The name of the NSG for VM')
param vm_nsg_name string 

@description('The location where the resource would be created')
param location string

resource apimNSGResource 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: apim_nsg_name
  location: location
  properties: {
    securityRules: [
      {
        name: 'Management_endpoint_for_Azure_portal_and_Powershell'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3443'
          sourceAddressPrefix: 'ApiManagement'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 120
          direction: 'Inbound'
        }
      }
      {
        name: 'Dependency_on_Redis_Cache'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '6381-6383'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 130
          direction: 'Inbound'
        }
      }
      {
        name: 'Dependency_to_sync_Rate_Limit_Inbound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '4290'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 135
          direction: 'Inbound'
        }
      }
      {
        name: 'Dependency_on_Azure_SQL'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '1433'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'Sql'
          access: 'Allow'
          priority: 140
          direction: 'Outbound'
        }
      }
      {
        name: 'Dependency_for_Log_to_event_Hub_policy'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '5671'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'EventHub'
          access: 'Allow'
          priority: 150
          direction: 'Outbound'
        }
      }
      {
        name: 'Dependency_on_Redis_Cache_outbound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '6381-6383'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 160
          direction: 'Outbound'
        }
      }
      {
        name: 'Depenedency_To_sync_RateLimit_Outbound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '4290'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 165
          direction: 'Outbound'
        }
      }
      {
        name: 'Dependency_on_Azure_File_Share_for_GIT'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '445'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'Storage'
          access: 'Allow'
          priority: 170
          direction: 'Outbound'
        }
      }
      {
        name: 'Azure_Infrastructure_Load_Balancer'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '6390'
          sourceAddressPrefix: 'AzureLoadBalancer'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 180
          direction: 'Inbound'
        }
      }
      {
        name: 'Publish_DiagnosticLogs_And_Metrics'
        properties: {
          description: 'APIM Logs and Metrics for consumption by admins and your IT team are all part of the management plane'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'AzureMonitor'
          access: 'Allow'
          priority: 185
          direction: 'Outbound'
          destinationPortRanges: [
            '443'
            '12000'
            '1886'
          ]
        }
      }
      {
        name: 'Connect_To_SMTP_Relay_For_SendingEmails'
        properties: {
          description: 'APIM features the ability to generate email traffic as part of the data plane and the management plane'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'Internet'
          access: 'Allow'
          priority: 190
          direction: 'Outbound'
          destinationPortRanges: [
            '25'
            '587'
            '25028'
          ]
        }
      }
      {
        name: 'Authenticate_To_Azure_Active_Directory'
        properties: {
          description: 'Connect to Azure Active Directory for Developer Portal Authentication or for Oauth2 flow during any Proxy Authentication'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'AzureActiveDirectory'
          access: 'Allow'
          priority: 200
          direction: 'Outbound'
          destinationPortRanges: [
            '80'
            '443'
          ]
        }
      }
      {
        name: 'Dependency_on_Azure_Storage'
        properties: {
          description: 'APIM service dependency on Azure Blob and Azure Table Storage'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'Storage'
          access: 'Allow'
          priority: 100
          direction: 'Outbound'
        }
      }
      {
        name: 'Publish_Monitoring_Logs'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'AzureCloud'
          access: 'Allow'
          priority: 300
          direction: 'Outbound'
        }
      }
      {
        name: 'Access_KeyVault'
        properties: {
          description: 'Allow APIM service control plane access to KeyVault to refresh secrets'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'AzureKeyVault'
          access: 'Allow'
          priority: 350
          direction: 'Outbound'
          destinationPortRanges: [
            '443'
          ]
        }
      }
      {
        name: 'Deny_All_Internet_Outbound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'Internet'
          access: 'Deny'
          priority: 999
          direction: 'Outbound'
        }
      }
    ]
  }
}

resource agwNSGResource 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: agw_nsg_name
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowGatewayManager'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '65200-65535'
          sourceAddressPrefix: 'GatewayManager'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'AllowHTTPS'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'AllowLoadBalancer'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'AzureLoadBalancer'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 120
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource vmNSGResource 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: vm_nsg_name
  location: location
  properties: {
    securityRules: [
      {
        name: 'default-allow-3389'
        properties: {
          priority: 1000
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '3389'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

output apimNSGId string = apimNSGResource.id
output agwNSGId string = agwNSGResource.id
output vmNSGId string = vmNSGResource.id
