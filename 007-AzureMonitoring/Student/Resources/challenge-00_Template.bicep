targetScope = 'subscription'

@secure()
param AdminPassword string
param AdminUsername string
param TimeStamp string = utcNow('yyyyMMddhhmmss')

var AppInsightsName = 'ai-wth-monitor-d-eus'
var LoadBalancerName = 'lb-wth-monitor-web-d-eus'
var Location = 'eastus'
var LogAnalyticsDataSources = [
  {
    name: '${LogAnalyticsWorkspaceName}/LogicalDisk1'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'LogicalDisk'
      instanceName: '*'
      intervalSeconds: 10
      counterName: 'Avg Disk sec/Read'
    }
  }
  {
    name: '${LogAnalyticsWorkspaceName}/LogicalDisk2'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'LogicalDisk'
      instanceName: '*'
      intervalSeconds: 10
      counterName: 'Avg Disk sec/Write'
    }
  }
  {
    name: '${LogAnalyticsWorkspaceName}/LogicalDisk3'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'LogicalDisk'
      instanceName: '*'
      intervalSeconds: 10
      counterName: 'Current Disk Queue Length'
    }
  }
  {
    name: '${LogAnalyticsWorkspaceName}/LogicalDisk4'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'LogicalDisk'
      instanceName: '*'
      intervalSeconds: 10
      counterName: 'Disk Reads/sec'
    }
  }
  {
    name: '${LogAnalyticsWorkspaceName}/LogicalDisk5'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'LogicalDisk'
      instanceName: '*'
      intervalSeconds: 10
      counterName: 'Disk Transfers/sec'
    }
  }
  {
    name: '${LogAnalyticsWorkspaceName}/LogicalDisk6'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'LogicalDisk'
      instanceName: '*'
      intervalSeconds: 10
      counterName: 'Disk Writes/sec'
    }
  }
  {
    name: '${LogAnalyticsWorkspaceName}/LogicalDisk7'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'LogicalDisk'
      instanceName: '*'
      intervalSeconds: 10
      counterName: 'Free Megabytes'
    }
  }
  {
    name: '${LogAnalyticsWorkspaceName}/LogicalDisk8'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'LogicalDisk'
      instanceName: '*'
      intervalSeconds: 10
      counterName: '% Free Space'
    }
  }
  {
    name: '${LogAnalyticsWorkspaceName}/Memory1'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'Memory'
      instanceName: '*'
      intervalSeconds: 10
      counterName: 'Available MBytes'
    }
  }
  {
    name: '${LogAnalyticsWorkspaceName}/Memory2'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'Memory'
      instanceName: '*'
      intervalSeconds: 10
      counterName: '% Committed Bytes In Use'
    }
  }
  {
    name: '${LogAnalyticsWorkspaceName}/Network1'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'Network Adapter'
      instanceName: '*'
      intervalSeconds: 10
      counterName: 'Bytes Received/sec'
    }
  }
  {
    name: '${LogAnalyticsWorkspaceName}/Network2'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'Network Adapter'
      instanceName: '*'
      intervalSeconds: 10
      counterName: 'Bytes Sent/sec'
    }
  }
  {
    name: '${LogAnalyticsWorkspaceName}/Network3'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'Network Adapter'
      instanceName: '*'
      intervalSeconds: 10
      counterName: 'Bytes Total/sec'
    }
  }
  {
    name: '${LogAnalyticsWorkspaceName}/CPU1'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'Processor'
      instanceName: '_Total'
      intervalSeconds: 10
      counterName: '% Processor Time'
    }
  }
  {
    name: '${LogAnalyticsWorkspaceName}/CPU2'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'System'
      instanceName: '*'
      intervalSeconds: 10
      counterName: 'Processor Queue Lenght'
    }
  }
  {
    name: '${LogAnalyticsWorkspaceName}/System'
    kind: 'WindowsEvent'
    properties: {
      eventLogName: 'System'
      eventTypes: [
        {
          eventType: 'Error'
        }
        {
          eventType: 'Warning'
        }
      ]
    }
  }
  {
    name: '${LogAnalyticsWorkspaceName}/Application'
    kind: 'WindowsEvent'
    properties: {
      eventLogName: 'Application'
      eventTypes: [
        {
          eventType: 'Error'
        }
        {
          eventType: 'Warning'
        }
      ]
    }
  }
  {
    name: '${LogAnalyticsWorkspaceName}/Linux'
    kind: 'LinuxPerformanceObject'
    properties: {
      performanceCounters: [
        {
          counterName: '% Used Inodes'
        }
        {
          counterName: 'Free Megabytes'
        }
        {
          counterName: '% Used Space'
        }
        {
          counterName: 'Disk Transfers/sec'
        }
        {
          counterName: 'Disk Reads/sec'
        }
        {
          counterName: 'Disk Writes/sec'
        }
      ]
      objectName: 'Logical Disk'
      instanceName: '*'
      intervalSeconds: 10
    }
  }
  {
    name: '${LogAnalyticsWorkspaceName}/LinuxPerfCollection'
    kind: 'LinuxPerformanceCollection'
    properties: {
      state: 'Enabled'
    }
  }
  {
    name: '${LogAnalyticsWorkspaceName}/IISLog'
    kind: 'IISLogs'
    properties: {
      state: 'OnPremiseEnabled'
    }
  }
  {
    name: '${LogAnalyticsWorkspaceName}/Syslog'
    kind: 'LinuxSyslog'
    properties: {
      syslogName: 'kern'
      syslogSeverities: [
        {
          severity: 'emerg'
        }
        {
          severity: 'alert'
        }
        {
          severity: 'crit'
        }
        {
          severity: 'err'
        }
        {
          severity: 'warning'
        }
      ]
    }
  }
  {
    name: '${LogAnalyticsWorkspaceName}/SyslogCollection'
    kind: 'LinuxSyslogCollection'
    properties: {
      state: 'Enabled'
    }
  }
]
var LogAnalyticsSolutions = [
  {
    name: 'Security(${LogAnalyticsWorkspaceName})'
    marketplaceName: 'Security'
  }
  {
    name: 'AgentHealthAssessment(${LogAnalyticsWorkspaceName})'
    marketplaceName: 'AgentHealthAssessment'
  }
  {
    name: 'ContainerInsights(${LogAnalyticsWorkspaceName})'
    marketplaceName: 'ContainerInsights'
  }
  {
    name: 'AzureSQLAnalytics(${LogAnalyticsWorkspaceName})'
    marketplaceName: 'AzureSQLAnalytics'
  }
  {
    name: 'ChangeTracking(${LogAnalyticsWorkspaceName})'
    marketplaceName: 'ChangeTracking'
  }
  {
    name: 'Updates(${LogAnalyticsWorkspaceName})'
    marketplaceName: 'Updates'
  }
  {
    name: 'AzureActivity(${LogAnalyticsWorkspaceName})'
    marketplaceName: 'AzureActivity'
  }
  {
    name: 'AzureAutomation(${LogAnalyticsWorkspaceName})'
    marketplaceName: 'AzureAutomation'
  }
  {
    name: 'ADAssessment(${LogAnalyticsWorkspaceName})'
    marketplaceName: 'ADAssessment'
  }
  {
    name: 'SQLAssessment(${LogAnalyticsWorkspaceName})'
    marketplaceName: 'SQLAssessment'
  }
  {
    name: 'ServiceMap(${LogAnalyticsWorkspaceName})'
    marketplaceName: 'ServiceMap'
  }
  {
    name: 'InfrastructureInsights(${LogAnalyticsWorkspaceName})'
    marketplaceName: 'InfrastructureInsights'
  }
  {
    name: 'AzureNSGAnalytics(${LogAnalyticsWorkspaceName})'
    marketplaceName: 'AzureNSGAnalytics'
  }
  {
    name: 'KeyVaultAnalytics(${LogAnalyticsWorkspaceName})'
    marketplaceName: 'KeyVaultAnalytics'
  }
]
var LogAnalyticsWorkspaceName = 'law-wth-monitor-d-eus'
var PublicIpAddressName = 'pip-wth-monitor-web-d-eus'
var StorageAccountName = 'storwthmondeus${toLower(substring(uniqueString(subscription().id), 0, 10))}'
var StorageEndpoint = environment().suffixes.storage
var Subnets = [
  {
    Name: 'snet-db-d-eus'
    NSG: 'nsg-wth-monitor-db-d-eus'
    SecurityRules: [
      {
        name: 'Allow_SQL_Mgmt'
        properties: {
          priority: 100
          sourceAddressPrefix: '10.0.0.0/24'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '1433'
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
        }
      }
      {
        name: 'Allow_AKS'
        properties: {
          priority: 101
          sourceAddressPrefix: '10.0.3.0/24'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '1433'
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
        }
      }
      {
        name: 'Allow_RDP'
        properties: {
          priority: 110
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '3389'
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
        }
      }
      {
        name: 'Deny_Web'
        properties: {
          priority: 121
          sourceAddressPrefix: '10.0.0.0/24'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
          protocol: '*'
          access: 'Deny'
          direction: 'Inbound'
        }
      }
    ]
  }
  {
    Name: 'snet-web-d-eus'
    NSG: 'nsg-wth-monitor-web-d-eus'
    SecurityRules: [
      {
        name: 'Allow_HTTP'
        properties: {
          priority: 100
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '80'
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
        }
      }
      {
        name: 'Allow_IIS_Mgmt_Svc'
        properties: {
          priority: 101
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '8172'
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
        }
      }
      {
        name: 'Allow_RDP'
        properties: {
          priority: 110
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '3389'
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
        }
      }
    ]
  }
  {
    Name: 'snet-aks-d-eus'
    NSG: 'nsg-wth-monitor-aks-d-eus'
    SecurityRules: [
      {
        name: 'Allow_RDP'
        properties: {
          priority: 110
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '3389'
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
        }
      }
    ]
  }
]
var VirtualNetworkName = 'vnet-wth-monitor-d-eus'
var VirtualMachines = [
  {
    Name: 'vmwthmvsdeus'
    NIC: 'nic-wth-monitor-vs-d-eus'
    Size: 'Standard_D4s_v3'
    ImageVersion: 'vs-2019-comm-latest-win10-n'
    ImagePublisher: 'MicrosoftVisualStudio'
    ImageOffer: 'VisualStudio2019latest'
  }
  {
    Name: 'vmwthmdbdeus'
    NIC: 'nic-wth-monitor-db-d-eus'
    Size: 'Standard_DS3_v2'
    ImageVersion: 'Standard'
    ImagePublisher: 'MicrosoftSQLServer'
    ImageOffer: 'SQL2016SP1-WS2016'
  }
]
var VirtualMachineScaleSetName = 'vmss-wth-monitor-d-eus'

resource rg 'Microsoft.Resources/resourceGroups@2020-10-01' = {
  name: 'rg-wth-monitor-d-eus'
  location: 'eastus'
}

module law 'modules/loganalytics.bicep' = {
  name: 'LogAnalyticsWorkspace_${TimeStamp}'
  scope: rg
  params: {
    Datasources: LogAnalyticsDataSources
    Location: Location
    Name: LogAnalyticsWorkspaceName
    Solutions: LogAnalyticsSolutions
  }
}

module sa 'modules/sa.bicep' = {
  name: 'StorageAccount_${TimeStamp}'
  scope: rg
  params: {
    Location: Location
    StorageAccountName: StorageAccountName
  }
}

module nsg 'modules/nsg.bicep' = {
  name: 'NetworkSecurityGroups_${TimeStamp}'
  scope: rg
  params: {
    Location: Location
    Subnets: Subnets
  }
}

module nsgDiags 'modules/nsgdiags.bicep' = {
  name: 'NetworkSecurityGroups_DiagnosticSettings_${TimeStamp}'
  scope: rg
  params: {
    Location: Location
    LogAnalyticsWorkspaceName: law.outputs.Name
    StorageAccountName: sa.outputs.Name
    NetworkSecurityGroupNames: nsg.outputs.Names
  }
}

module vnet 'modules/vnet.bicep' = {
  name: 'VirtualNetwork_${TimeStamp}'
  scope: rg
  params: {
    AddressPrefixes: [
      '10.0.0.0/16'
    ]
    Location: Location
    Subnets: [
      {
        name: Subnets[0].Name
        prefix: '10.0.0.0/24'
        networkSecurityGroupId: nsg.outputs.Ids[0]
      }
      {
        name: Subnets[1].Name
        prefix: '10.0.1.0/24'
        networkSecurityGroupId: nsg.outputs.Ids[1]
      }
      {
        name: Subnets[2].Name
        prefix: '10.0.2.0/24'
        networkSecurityGroupId: nsg.outputs.Ids[2]
      }
    ]
    VirtualNetworkName: VirtualNetworkName
  }
}

module pip 'modules/pip.bicep' = {
  name: 'PublicIpAddress_${TimeStamp}'
  scope: rg
  params: {
    LawId: law.outputs.ResourceId
    Location: Location
    Name: PublicIpAddressName
  }
}

module vm 'modules/vm.bicep' = {
  name: 'VirtualMachines_${TimeStamp}'
  scope: rg
  params: {
    AdminPassword: AdminPassword
    AdminUsername: AdminUsername
    LawId: law.outputs.CustomerId
    LawKey: law.outputs.Key
    Location: Location
    StorageAccountName: StorageAccountName
    StorageEndpoint: StorageEndpoint
    StorageKey: sa.outputs.Key
    SubnetId: vnet.outputs.SubnetIds[0]
    VirtualMachines: VirtualMachines
  }
}

module appinsights 'modules/appinsights.bicep' = {
  name: 'AppInsights_${TimeStamp}'
  scope: rg
  params: {
    AppInsightsName: AppInsightsName
    laWsId: law.outputs.ResourceId
    Location: Location
  }
}

module billing 'modules/billingplan.bicep' = {
  name: 'CurrentBillingFeatures_${TimeStamp}'
  scope: rg
  params: {
    AppInsightsName: appinsights.outputs.Name
    Location: Location
  }
}

module lb 'modules/loadbalancer.bicep' = {
  name: 'LoadBalancer_${TimeStamp}'
  scope: rg
  params: {
    LawId: law.outputs.ResourceId
    Location: Location
    Name: LoadBalancerName
    PipId: pip.outputs.id
  }
}

module vmss 'modules/vmss.bicep' = {
  name: 'VirtualMachineScaleSet_${TimeStamp}'
  scope: rg
  params: {
    AdminPassword: AdminPassword
    AdminUsername: AdminUsername
    LAWId: law.outputs.CustomerId
    LAWKey: law.outputs.Key
    LBBackendAddressPools: lb.outputs.BackendAddressPools[0].id
    LBInboundNatPools: lb.outputs.InboundNatPools[0].id
    Location: Location
    Name: VirtualMachineScaleSetName
    SqlServer: VirtualMachines[1].Name
    StorageAccount: StorageAccountName
    StorageAccountKey: sa.outputs.Key
    StorageEndpoint: StorageEndpoint
    Subnet: vnet.outputs.SubnetIds[0]
  }
  dependsOn: [
    vm
  ]
}

module aksdeployment 'modules/aks.bicep' = {
  name: 'AKS_${TimeStamp}'
  scope: rg
  params: {
    Location: Location
    NodeResourceGroup: 'rg-wth-monitor-aks-d-eus'
    OmsWorkspaceId: law.outputs.ResourceId
    SubnetId: vnet.outputs.SubnetIds[2]
  }
}

