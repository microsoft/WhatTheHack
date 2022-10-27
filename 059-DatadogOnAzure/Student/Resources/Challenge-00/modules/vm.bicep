@secure()
param AdminPassword string
param AdminUsername string
param LawId string
param LawKey string
param Location string
param StorageAccountName string
param StorageEndpoint string
param StorageKey string
param SubnetIds array
param VirtualMachines array
param ArtifactsURL string
param ArtifactsStorageID string
param VSServerScriptName string = 'SetupVSServer.ps1'

var SQLServerName = VirtualMachines[0].Name

resource nic 'Microsoft.Network/networkInterfaces@2020-06-01' = [for i in range(0, length(VirtualMachines)): {
  name: VirtualMachines[i].NIC
  location: Location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: SubnetIds[i]
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}]

resource vm 'Microsoft.Compute/virtualMachines@2020-06-01' = [for VirtualMachine in VirtualMachines: {
  name: VirtualMachine.Name
  location: Location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: VirtualMachine.Size
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
      imageReference: {
        publisher: VirtualMachine.ImagePublisher
        offer: VirtualMachine.ImageOffer
        sku: VirtualMachine.ImageVersion
        version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: resourceId('Microsoft.Network/networkInterfaces', VirtualMachine.NIC)
        }
      ]
    }
    osProfile: {
      computerName: VirtualMachine.Name
      adminUsername: AdminUsername
      adminPassword: AdminPassword
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: false
      }
    }
  }
  dependsOn: [
    nic
  ]
}]

//Assign VM's system managed identity "storage blob data reader" role on the Artifacts Storage Account
var VSServerSystemManagedID = vm[1].identity.principalId
output vmprincipalID string = vm[1].identity.principalId

resource StorageBlobDataReaderRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  scope: resourceGroup()
  name: '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1'
}

//Assign the VM's system managed identity Storage Blob Data Reader
resource roleAssignmentSMI 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope: resourceGroup()
  name: guid(ArtifactsStorageID, vm[1].id, StorageBlobDataReaderRole.id)
  properties: {
    roleDefinitionId: StorageBlobDataReaderRole.id
    principalId: VSServerSystemManagedID
    principalType: 'ServicePrincipal'
  }
}

//Custom script extension to run PowerShell script stored in artifacts location (storage account)
// The CSE will use the system-managed identity of the VM to authenticate against the storage account
resource VsCseExtension 'Microsoft.Compute/virtualMachines/extensions@2022-03-01' = {
  name: '${vm[1].name}/CustomScriptExtension'
  location: Location
 dependsOn: [
   roleAssignmentSMI
 ] 
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: false
    enableAutomaticUpgrade: false
    settings: {
      fileUris: [
        '${ArtifactsURL}${VSServerScriptName}'
      ]
    }
    protectedSettings: {
      commandToExecute: 'powershell.exe -ExecutionPolicy Unrestricted -File SetupVSServer.ps1 ${SQLServerName} ${AdminPassword} ${AdminUsername}'
      managedIdentity: {}
    }
  }
}

resource DbIdExtension 'Microsoft.Compute/virtualMachines/extensions@2020-12-01' = {
  name: '${vm[0].name}/ManagedIdentityExtensionForWindows'
  location: Location
  properties: {
    publisher: 'Microsoft.ManagedIdentity'
    type: 'ManagedIdentityExtensionForWindows'
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: false
    enableAutomaticUpgrade: false
    settings: {
      port: 50342
    }
  }
}

resource DbIaasDiagExtension 'Microsoft.Compute/virtualMachines/extensions@2020-12-01' = {
  name: '${vm[0].name}/IaaSDiagnostics'
  location: Location
  properties: {
    publisher: 'Microsoft.Azure.Diagnostics'
    type: 'IaaSDiagnostics'
    typeHandlerVersion: '1.5'
    autoUpgradeMinorVersion: false
    enableAutomaticUpgrade: false
    settings: {
      WadCfg: {
        DiagnosticMonitorConfiguration: {
          overallQuotaInMB: 4096
          DiagnosticInfrastructureLogs: {
            scheduledTransferLogLevelFilter: 'Error'
          }
          Directories: {
            scheduledTransferPeriod: 'PT1M'
            IISLogs: {
              containerName: 'wad-iis-logfiles'
            }
            FailedRequestLogs: {
              containerName: 'wad-failedrequestlogs'
            }
          }
          PerformanceCounters: {
            scheduledTransferPeriod: 'PT1M'
            sinks: 'AzMonSink'
            PerformanceCounterConfiguration: [
              {
                counterSpecifier: '\\Memory\\Available Bytes'
                sampleRate: 'PT15S'
              }
              {
                counterSpecifier: '\\Memory\\% Committed Bytes In Use'
                sampleRate: 'PT15S'
              }
              {
                counterSpecifier: '\\Memory\\Committed Bytes'
                sampleRate: 'PT15S'
              }
            ]
          }
          WindowsEventLog: {
            scheduledTransferPeriod: 'PT1M'
            DataSource: [
              {
                name: 'Application!*'
              }
            ]
          }
          Logs: {
            scheduledTransferPeriod: 'PT1M'
            scheduledTransferLogLevelFilter: 'Error'
          }
        }
        SinksConfig: {
          Sink: [
            {
              name: 'AzMonSink'
              AzureMonitor: {}
            }
          ]
        }
      }
      StorageAccount: StorageAccountName
    }
    protectedSettings: {
      storageAccountName: StorageAccountName
      storageAccountKey: StorageKey
      storageAccountEndPoint: 'https://${StorageEndpoint}/'
    }
  }
}

resource SqlExtension 'Microsoft.Compute/virtualMachines/extensions@2020-12-01' = {
  name: '${vm[0].name}/SqlIaaSAgent'
  location: Location
  properties: {
    publisher: 'Microsoft.SqlServer.Management'
    type: 'SqlIaaSAgent'
    typeHandlerVersion: '1.2'
    autoUpgradeMinorVersion: false
    enableAutomaticUpgrade: false
    settings: {
      AutoTelemetrySettings: {
        Region: Location
      }
      AutoPatchingSettings: {
        PatchCategory: 'WindowsMandatoryUpdates'
        Enable: false
      }
      KeyVaultCredentialSettings: {
        Enable: false
        CredentialName: ''
      }
      ServerConfigurationsManagementSettings: {
        SQLConnectivityUpdateSettings: {
          ConnectivityType: 'Private'
          Port: 1433
        }
        AdditionalFeaturesServerConfigurations: {
          IsRServicesEnabled: false
        }
      }
    }
    protectedSettings: {
      SQLAuthUpdateUserName: 'sqladmin'
      SQLAuthUpdatePassword: AdminPassword
    }
  }
}

resource DbDependencyExtension 'Microsoft.Compute/virtualMachines/extensions@2020-12-01' = {
  name: '${vm[0].name}/DependencyAgentWindows'
  location: Location
  properties: {
    publisher: 'Microsoft.Azure.Monitoring.DependencyAgent'
    type: 'DependencyAgentWindows'
    typeHandlerVersion: '9.4'
    autoUpgradeMinorVersion: false
    enableAutomaticUpgrade: false
  }
}

resource DbMma 'Microsoft.Compute/virtualMachines/extensions@2020-12-01' = {
  name: '${vm[0].name}/MicrosoftMonitoringAgent'
  location: Location
  properties: {
    publisher: 'Microsoft.EnterpriseCloud.Monitoring'
    type: 'MicrosoftMonitoringAgent'
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: false
    enableAutomaticUpgrade: false
    settings: {
      workspaceId: LawId
    }
    protectedSettings: {
      workspaceKey: LawKey
    }
  }
  dependsOn: [
    DbIdExtension
    DbIaasDiagExtension
    SqlExtension
    DbDependencyExtension
  ]
}
