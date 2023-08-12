targetScope = 'subscription'

@secure()
param AdminPassword string
var AdminUsername = 'wthadmin'
var SqlUsername = 'sqladmin'
param Location string = deployment().location
param TimeStamp string = utcNow('yyyyMMddhhmmss')

var LocationShort = {
  australiacentral: 'ac'
  australiacentral2: 'ac2'
  australiaeast:	'ae'
  australiasoutheast:	'as'
  brazilsouth: 'bs2'
  brazilsoutheast: 'bs'
  canadacentral: 'cc'
  canadaeast: 'ce'
  centralindia:	'ci'
  centralus: 'cu'
  chinaeast: 'ce'
  chinaeast2: 'ce2'
  chinanorth: 'cn'
  chinanorth2: 'cn2'
  eastasia:	'ea'
  eastus:	'eu'
  eastus2: 'eu2'
  francecentral: 'fc'
  francesouth: 'fs'
  germanynorth: 'gn'
  germanywestcentral: 'gwc'
  japaneast: 'je'
  japanwest: 'jw'
  jioindiawest: 'jiw'
  koreacentral:	'kc'
  koreasouth:	'ks'
  northcentralus:	'ncu'
  northeurope: 'ne2'
  norwayeast:	'ne'
  norwaywest:	'nw'
  southafricanorth:	'san'
  southafricawest: 'saw'
  southcentralus:	'scu'
  southindia:	'si'
  southeastasia: 'sa'
  switzerlandnorth: 'sn'
  switzerlandwest: 'sw'
  uaecentral:	'uc'
  uaenorth: 'un'
  uksouth: 'us'
  ukwest: 'uw'
  usdodcentral:	'uc'
  usdodeast: 'ue'
  usgovarizona: 'ua'
  usgoviowa: 'ui'
  usgovtexas: 'ut'
  usgovvirginia: 'uv'
  westcentralus: 'wcu'
  westeurope: 'we'
  westindia: 'wi'
  westus: 'wu'
  westus2: 'wu2'
  westus3: 'wu3'
}
var NameSuffix = '${LocationShort[Location]}'
var AksName ='aks-wth-monitor-d-${NameSuffix}'
var AppInsightsName = 'ai-wth-monitor-d-${NameSuffix}'
var BastionName = 'bastion-wth-monitor-d-${NameSuffix}'
var ComputerNamePrefix  = 'vmwthd${NameSuffix}'
var LoadBalancerName = 'lb-wth-monitor-web-d-${NameSuffix}'
var sqlServerName = 'vmwthdbd${NameSuffix}'
var vsServerName =  'vmwthvsd${NameSuffix}'

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
var LogAnalyticsWorkspaceName = 'law-wth-monitor-d-${NameSuffix}'
var PublicIpAddresses = [
  {
    Name: 'pip-wth-monitor-web-d-${NameSuffix}'
    Sku: 'Basic'
  }
  {
    Name: 'pip-wth-monitor-bastion-d-${NameSuffix}'
    Sku: 'Standard'
  } 
]
var StorageAccountName = 'storwthmond${NameSuffix}${toLower(substring(uniqueString(deployment().name), 0, 10))}'
var StorageEndpoint = environment().suffixes.storage
var Subnets = [
  {
    Name: 'snet-db-d-${NameSuffix}'
    Prefix: '10.0.0.0/24'
    NSG: 'nsg-wth-monitor-db-d-${NameSuffix}'
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
          sourceAddressPrefix: '10.0.2.0/24'
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
    Name: 'snet-web-d-${NameSuffix}'
    Prefix: '10.0.1.0/24'
    NSG: 'nsg-wth-monitor-web-d-${NameSuffix}'
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
    Name: 'snet-aks-d-${NameSuffix}'
    Prefix: '10.0.2.0/24'
    NSG: 'nsg-wth-monitor-aks-d-${NameSuffix}'
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
    Name: 'AzureBastionSubnet'
    Prefix: '10.0.3.0/26'
    NSG: 'nsg-wth-monitor-bastion-d-${NameSuffix}'
    SecurityRules: [
      {
        name: 'AllowBastionClients'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: '100'
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowGatewayManager'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: 'GatewayManager'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: '200'
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowAzureLoadBalancer'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: 'AzureLoadBalancer'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: '300'
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowBastionHostCommunication'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: '400'
          direction: 'Inbound'
          destinationPortRanges: [
            '8080'
            '5701'
          ]
        }
      }
      {
        name: 'AllowSshRdp'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: '100'
          direction: 'Outbound'
          destinationPortRanges: [
            '22'
            '3389'
          ]
        }
      }
      {
        name: 'AllowAzureCloud'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'AzureCloud'
          access: 'Allow'
          priority: '200'
          direction: 'Outbound'
        }
      }
      {
        name: 'AllowBastionCommunication'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: '300'
          direction: 'Outbound'
          destinationPortRanges: [
            '8080'
            '5701'
          ]
        }
      }
      {
        name: 'AllowGetSessionInformation'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'Internet'
          access: 'Allow'
          priority: '400'
          direction: 'Outbound'
        }
      }
      {
        name: 'DenyAllInbound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: '4096'
          direction: 'Inbound'
        }
      }
      {
        name: 'DenyAllOutbound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: '4096'
          direction: 'Outbound'
        }
      }
    ]
  }
]
var VirtualNetworkName = 'vnet-wth-monitor-d-${NameSuffix}'
var VirtualMachines = [
  {
    Name: sqlServerName
    NIC: 'nic-wth-monitor-db-d-${NameSuffix}'
    Size: 'Standard_DS3_v2'
    ImageVersion: 'Standard'
    ImagePublisher: 'MicrosoftSQLServer'
    ImageOffer: 'SQL2016SP1-WS2016'
  }
  {
    Name: vsServerName
    NIC: 'nic-wth-monitor-vs-d-${NameSuffix}'
    Size: 'Standard_D4s_v3'
    ImageVersion: 'vs-2022-comm-latest-ws2022'
    ImagePublisher: 'MicrosoftVisualStudio'
    ImageOffer: 'visualstudio2022'
  }
]
var VirtualMachineScaleSetName = 'vmss-wth-monitor-d-${NameSuffix}'
var VmssNicName = 'nic-wth-monitor-vmss-d-${NameSuffix}'

resource rg 'Microsoft.Resources/resourceGroups@2020-10-01' = {
  name: '${deployment().name}-rg-wth-monitor-d-${LocationShort[Location]}'
  location: Location
}

module artifactsStorage 'modules/sa-artifacts.bicep' = {
  name: 'Artifacts-Storage'
  scope: rg
  params: {
    location: Location
  }
}

//Retrieve the blob storage URL where the artifacts will be stored
var artifactsURL = artifactsStorage.outputs.artifactsURL
//Retrieve ID of storage account used for artifacts
var artifactsStorageID = artifactsStorage.outputs.artifactsStorageID

module law 'modules/loganalytics.bicep' = {
  name: 'LogAnalyticsWorkspace_${TimeStamp}'
  scope: rg
  params: {
    Datasources: LogAnalyticsDataSources
    Location: Location
    Name: LogAnalyticsWorkspaceName
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
    LogAnalyticsWorkspaceName: law.outputs.Name
    StorageAccountName: sa.outputs.Name
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
        prefix: Subnets[0].Prefix
        networkSecurityGroupId: nsg.outputs.Ids[0]
      }
      {
        name: Subnets[1].Name
        prefix: Subnets[1].Prefix
        networkSecurityGroupId: nsg.outputs.Ids[1]
      }
      {
        name: Subnets[2].Name
        prefix: Subnets[2].Prefix
        networkSecurityGroupId: nsg.outputs.Ids[2]
      }
      {
        name: Subnets[3].Name
        prefix: Subnets[3].Prefix
        networkSecurityGroupId: nsg.outputs.Ids[3]
      }
    ]
    VirtualNetworkName: VirtualNetworkName
  }
}

module pip 'modules/pip.bicep' = {
  name: 'PublicIpAddresses_${TimeStamp}'
  scope: rg
  params: {
    LawId: law.outputs.ResourceId
    Location: Location
    PIPs: PublicIpAddresses
  }
}

module vm 'modules/vm.bicep' = {
  name: 'VirtualMachines_${TimeStamp}'
  scope: rg
  params: {
    AdminPassword: AdminPassword
    AdminUsername: AdminUsername
    Location: Location
    StorageAccountName: StorageAccountName
    StorageEndpoint: StorageEndpoint
    StorageKey: sa.outputs.Key
    SubnetIds: vnet.outputs.SubnetIds
    VirtualMachines: VirtualMachines
    ArtifactsURL: artifactsURL
    ArtifactsStorageID: artifactsStorageID
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
    PipId: pip.outputs.Ids[0]
  }
}

module bastion 'modules/bastion.bicep' = {
  name: 'Bastion_${TimeStamp}'
  scope: rg
  params: {
    Location: Location
    Name: BastionName
    PipId: pip.outputs.Ids[1]
    SubnetId: vnet.outputs.SubnetIds[3]
  }
}

module vmss 'modules/vmss.bicep' = {
  name: 'VirtualMachineScaleSet_${TimeStamp}'
  scope: rg
  params: {
    AdminPassword: AdminPassword
    AdminUsername: AdminUsername
    ComputerNamePrefix: ComputerNamePrefix
    LBBackendAddressPools: lb.outputs.BackendAddressPools[0].id
    LBInboundNatPools: lb.outputs.InboundNatPools[0].id
    Location: Location
    Name: VirtualMachineScaleSetName
    NicName: VmssNicName
    SqlServer: VirtualMachines[1].Name
    StorageAccount: StorageAccountName
    StorageAccountKey: sa.outputs.Key
    StorageEndpoint: StorageEndpoint
    Subnet: vnet.outputs.SubnetIds[1]
    ArtifactsURL: artifactsURL
  }
  dependsOn: [
    vm
    artifactsStorage
  ]
}

module aksdeployment 'modules/aks.bicep' = {
  name: 'AKS_${TimeStamp}'
  scope: rg
  params: {
    Location: Location
    Name: AksName
    NodeResourceGroup: '${deployment().name}-rg-wth-monitor-aks-d-${LocationShort[Location]}'
    OmsWorkspaceId: law.outputs.ResourceId
    SubnetId: vnet.outputs.SubnetIds[2]
    sqlServerName: sqlServerName
    sqlUserName: SqlUsername
    sqlPassword: AdminPassword
    appInsightsName: AppInsightsName
  }
}
