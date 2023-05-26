param location string = resourceGroup().location
param vmssName string = 'vmss-wth-monitor-d-XX'
param lawResourceName string = 'law-wth-monitor-d-XX'

resource vm 'Microsoft.Compute/virtualMachineScaleSets@2021-11-01' existing = {
  name: vmssName
}

resource lawResource 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: lawResourceName
}

resource dependencyExtension 'Microsoft.Compute/virtualMachineScaleSets/extensions@2020-12-01' = {
  parent: vm
  name: 'DependencyAgentWindows'
  properties: {
    publisher: 'Microsoft.Azure.Monitoring.DependencyAgent'
    type: 'DependencyAgentWindows'
    typeHandlerVersion: '9.4'
    autoUpgradeMinorVersion: false
    enableAutomaticUpgrade: false
  }
}

resource ama 'Microsoft.Compute/virtualMachineScaleSets/extensions@2021-11-01' = {
  parent: vm
  name: 'AzureMonitorWindowsAgent'
  properties: {
    publisher: 'Microsoft.Azure.Monitor'
    type: 'AzureMonitorWindowsAgent'
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: true
    enableAutomaticUpgrade: true
  }
  dependsOn: [
    dependencyExtension
  ]
}

resource dcrEventLogs 'Microsoft.Insights/dataCollectionRules@2021-09-01-preview' = {
  name: 'DCR-Win-Event-Logs-to-LAW'
  location: location
  kind: 'Windows'
  properties: {
    dataFlows: [
      {
        destinations: [
          'law-wth-monitor-d-xx'
        ]
        streams: [
          'Microsoft-Event'
        ]
      }
    ]
    dataSources: {
      windowsEventLogs: [
        { streams: [ 
          'Microsoft-Event' 
        ]
          xPathQueries: [
            'Application!*[System[(Level=1 or Level=2 or Level=3 or or Level=0) ]]'
            'Security!*[System[(band(Keywords,13510798882111488))]]'
            'System!*[System[(Level=1 or Level=2 or Level=3 or or Level=0)]]'
            ]
          name: 'eventLogsDataSource'
        }
    ]
    }
    description: 'Collect Windows Event Logs and send to Azure Monitor Logs'
    destinations: {
      logAnalytics: [
        {
          name: 'law-wth-monitor-d-xx'
          workspaceResourceId: lawResource.id
        }
      ]
    }
  }
  dependsOn: [
    ama
  ]
}

resource dcrPerfLaw 'Microsoft.Insights/dataCollectionRules@2021-09-01-preview' = {
  name: 'DCR-Win-Perf-to-LAW'
  location: location
  kind: 'Windows'
  properties: {
    dataFlows: [
      {
        destinations: [
          'law-wth-monitor-d-xx'
        ]
        streams: [
          'Microsoft-Perf'
        ]
      }
    ]
    dataSources: {
      performanceCounters: [
        {
          counterSpecifiers: [
            '\\Processor Information(_Total)\\% Processor Time'
            '\\Processor Information(_Total)\\% Privileged Time'
            '\\Processor Information(_Total)\\% User Time'
            '\\Processor Information(_Total)\\Processor Frequency'
            '\\System\\Processes'
            '\\Process(_Total)\\Thread Count'
            '\\Process(_Total)\\Handle Count'
            '\\System\\System Up Time'
            '\\System\\Context Switches/sec'
            '\\System\\Processor Queue Length'
            '\\Memory\\% Committed Bytes In Use'
            '\\Memory\\Available Bytes'
            '\\Memory\\Committed Bytes'
            '\\Memory\\Cache Bytes'
            '\\Memory\\Pool Paged Bytes'
            '\\Memory\\Pool Nonpaged Bytes'
            '\\Memory\\Pages/sec'
            '\\Memory\\Page Faults/sec'
            '\\Process(_Total)\\Working Set'
            '\\Process(_Total)\\Working Set - Private'
            '\\LogicalDisk(_Total)\\% Disk Time'
            '\\LogicalDisk(_Total)\\% Disk Read Time'
            '\\LogicalDisk(_Total)\\% Disk Write Time'
            '\\LogicalDisk(_Total)\\% Idle Time'
            '\\LogicalDisk(_Total)\\Disk Bytes/sec'
            '\\LogicalDisk(_Total)\\Disk Read Bytes/sec'
            '\\LogicalDisk(_Total)\\Disk Write Bytes/sec'
            '\\LogicalDisk(_Total)\\Disk Transfers/sec'
            '\\LogicalDisk(_Total)\\Disk Reads/sec'
            '\\LogicalDisk(_Total)\\Disk Writes/sec'
            '\\LogicalDisk(_Total)\\Avg. Disk sec/Transfer'
            '\\LogicalDisk(_Total)\\Avg. Disk sec/Read'
            '\\LogicalDisk(_Total)\\Avg. Disk sec/Write'
            '\\LogicalDisk(_Total)\\Avg. Disk Queue Length'
            '\\LogicalDisk(_Total)\\Avg. Disk Read Queue Length'
            '\\LogicalDisk(_Total)\\Avg. Disk Write Queue Length'
            '\\LogicalDisk(_Total)\\% Free Space'
            '\\LogicalDisk(_Total)\\Free Megabytes'
            '\\Network Interface(*)\\Bytes Total/sec'
            '\\Network Interface(*)\\Bytes Sent/sec'
            '\\Network Interface(*)\\Bytes Received/sec'
            '\\Network Interface(*)\\Packets/sec'
            '\\Network Interface(*)\\Packets Sent/sec'
            '\\Network Interface(*)\\Packets Received/sec'
            '\\Network Interface(*)\\Packets Outbound Errors'
            '\\Network Interface(*)\\Packets Received Errors'
          ]
          name: 'perfCounterDataSource60'
          samplingFrequencyInSeconds: 60
          streams: [
            'Microsoft-Perf'
          ]
        }
      ]
    }
    description: 'Collect Perf Counters and send to Azure Monitor Logs'
    destinations: {
      logAnalytics: [
        {
          name: 'law-wth-monitor-d-xx'
          workspaceResourceId: lawResource.id
        }
      ]
    }
  }
  dependsOn: [
    ama
  ]
}

resource dcrEventLogsAssociation 'Microsoft.Insights/dataCollectionRuleAssociations@2021-09-01-preview' = {
  name: 'DCRA-VMSS-WEL-LAW'
  scope: vm
  properties: {
    description: 'Association of data collection rule. Deleting this association will break the data collection for this virtual machine scale set.'
    dataCollectionRuleId: dcrEventLogs.id
  }
}

resource dcrPerfLawAssociation 'Microsoft.Insights/dataCollectionRuleAssociations@2021-09-01-preview' = {
  name: 'DCRA-VMSS-PC-LAW'
  scope: vm
  properties: {
    description: 'Association of data collection rule. Deleting this association will break the data collection for this virtual machine scale set.'
    dataCollectionRuleId: dcrPerfLaw.id
  }
}
