param Location string = resourceGroup().location
param vm string = '<your-vm-name>'

resource DbDependencyExtension 'Microsoft.Compute/virtualMachines/extensions@2020-12-01' = {
  name: '${vm}/DependencyAgentWindows'
  location: Location
  properties: {
    publisher: 'Microsoft.Azure.Monitoring.DependencyAgent'
    type: 'DependencyAgentWindows'
    typeHandlerVersion: '9.4'
    autoUpgradeMinorVersion: false
    enableAutomaticUpgrade: false
  }
}

resource DbAMA 'Microsoft.Compute/virtualMachines/extensions@2021-11-01' = {
  name: '${vm}/AzureMonitorWindowsAgent'
  location: Location
  properties: {
    publisher: 'Microsoft.Azure.Monitor'
    type: 'AzureMonitorWindowsAgent'
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: true
    enableAutomaticUpgrade: true
  }
  dependsOn: [
    DbDependencyExtension
  ]
}
