@secure()
param AdminPassword string
param AdminUsername string
param ComputerNamePrefix string
@secure()
param LBBackendAddressPools string
param LBInboundNatPools string
param Location string
param Name string
param NicName string
param SqlServer string
param StorageAccount string
@secure()
param StorageAccountKey string
param StorageEndpoint string
param Subnet string

// This module will pull a PowerShell script from an artifacts location in Azure Blob Storage
// It will use a user managed identity to authenticate with Azure Storage
// That user managed identity needs to be assigned to the VMSS.

param ArtifactsURL string //blob storage URL where the artifacts (PowerShell script) is located
param WebServersScriptName string = 'SetupWebServers.ps1' //name of the PowerShell script

//Get the role id for Storage Blob Data Reader
resource StorageBlobDataReaderRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  scope: resourceGroup()
  name: '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1'
}

//Create a new user managed identity which will be used by the VMSS
var userManagedIdentityName = 'ArtifactsManagedIdentity'
resource userManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' = {
  name: userManagedIdentityName
  location: Location
}

//Assign the UMI the Storage Blob Data Reader role
resource roleAssignmentUMI 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, userManagedIdentity.id, StorageBlobDataReaderRole.id)
  scope: resourceGroup()
  properties: {
    roleDefinitionId: StorageBlobDataReaderRole.id
    principalId: userManagedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

// Define the VMSS and ensure it uses the User Managed Identity.
resource vmss 'Microsoft.Compute/virtualMachineScaleSets@2022-03-01' = {
  name: Name
  location: Location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: { '${userManagedIdentity.id}': {} } 
  }
  sku: {
    name: 'Standard_DS3_v2'
    tier: 'Standard'
    capacity: 2
  }
  properties: {
    overprovision: true
    upgradePolicy: {
      mode: 'Manual'
    }
    singlePlacementGroup: true
    virtualMachineProfile: {
      storageProfile: {
        osDisk: {
          createOption: 'FromImage'
          caching: 'ReadWrite'
        }
        imageReference: {
          publisher: 'MicrosoftWindowsServer'
          offer: 'WindowsServer'
          sku: '2016-datacenter'
          version: 'latest'
        }
      }
      osProfile: {
        computerNamePrefix: ComputerNamePrefix
        adminUsername: AdminUsername
        adminPassword: AdminPassword
      }
      networkProfile: {
        networkInterfaceConfigurations: [
          {
            name: NicName
            properties: {
              primary: true
              ipConfigurations: [
                {
                  name: 'IpConfig'
                  properties: {
                    subnet: {
                      id: Subnet
                    }
                    loadBalancerBackendAddressPools: [
                      {
                        id: LBBackendAddressPools
                      }
                    ]
                    loadBalancerInboundNatPools: [
                      {
                        id: LBInboundNatPools
                      }
                    ]
                  }
                }
              ]
            }
          }
        ]
      }
      extensionProfile: {
        extensions: [
          {
            name: 'CustomScriptExtension'
            properties: {
              publisher: 'Microsoft.Compute'
              type: 'CustomScriptExtension'
              typeHandlerVersion: '1.10'
              autoUpgradeMinorVersion: true
              settings: {
              }
              protectedSettings:{
                fileUris: [
                  '${ArtifactsURL}${WebServersScriptName}'
                ]
                commandToExecute: 'powershell.exe -ExecutionPolicy Unrestricted -File SetupWebServers.ps1 ${SqlServer} ${AdminUsername} ${AdminPassword}'
                managedIdentity: { clientId: userManagedIdentity.properties.clientId }
              }
            }
          }
          {
            name: 'VMSSWADextension'
            properties: {
              publisher: 'Microsoft.ManagedIdentity'
              type: 'ManagedIdentityExtensionForWindows'
              typeHandlerVersion: '1.0'
              autoUpgradeMinorVersion: true
              settings: {
                port: 50342
              }
              protectedSettings: {}
            }
          }
        ]
      }
    }
  }
}

resource autoscale 'microsoft.insights/autoscalesettings@2015-04-01' = {
  name: 'cpuautoscale${ComputerNamePrefix}'
  location: Location
  properties: {
    name: 'cpuautoscale${ComputerNamePrefix}'
    targetResourceUri: vmss.id
    enabled: true
    profiles: [
      {
        name: 'Profile1'
        capacity: {
          minimum: '2'
          maximum: '4'
          default: '2'
        }
        rules: [
          {
            metricTrigger: {
              metricName: 'Percentage CPU'
              metricNamespace: ''
              metricResourceUri: vmss.id
              timeGrain: 'PT1M'
              statistic: 'Average'
              timeWindow: 'PT5M'
              timeAggregation: 'Average'
              operator: 'GreaterThan'
              threshold: 75
            }
            scaleAction: {
              direction: 'Increase'
              type: 'ChangeCount'
              value: '1'
              cooldown: 'PT1M'
            }
          }
          {
            metricTrigger: {
              metricName: 'Percentage CPU'
              metricNamespace: ''
              metricResourceUri: vmss.id
              timeGrain: 'PT1M'
              statistic: 'Average'
              timeWindow: 'PT5M'
              timeAggregation: 'Average'
              operator: 'LessThan'
              threshold: 25
            }
            scaleAction: {
              direction: 'Decrease'
              type: 'ChangeCount'
              value: '1'
              cooldown: 'PT1M'
            }
          }
        ]
      }
    ]
  }
}
