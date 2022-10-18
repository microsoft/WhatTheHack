param aksName string
param location string
param logAnalyticsWorkspaceName string

resource aksAzurePolicy 'Microsoft.Authorization/policyAssignments@2019-09-01' = {
  name: 'aksAzurePolicy'
  scope: resourceGroup()
  properties: {
    #disable-next-line use-resource-id-functions
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/c26596ff-4d70-4e6a-9a30-c2506bd2f80c'
  }
}

resource aks 'Microsoft.ContainerService/managedClusters@2021-03-01' = {
  name: aksName
  location: location
  dependsOn: [
    aksAzurePolicy
  ]
  properties: {
    kubernetesVersion: '1.24.6'
    dnsPrefix: aksName
    enableRBAC: true
    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: 0
        count: 3
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
        mode: 'System'
      }
    ]
    addonProfiles: {
      httpApplicationRouting: {
        enabled: true
      }
      omsagent: {
        enabled: true
        config: {
          logAnalyticsWorkspaceResourceID: logAnalyticsWorkspace.id
        }
      }
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = {
  name: 'Logging'
  scope: aks
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'kube-apiserver'
        enabled: true
      }
      {
        category: 'kube-audit'
        enabled: true
      }
      {
        category: 'kube-audit-admin'
        enabled: true
      }
      {
        category: 'kube-controller-manager'
        enabled: true
      }
      {
        category: 'kube-scheduler'
        enabled: true
      }
      {
        category: 'cluster-autoscaler'
        enabled: true
      }
      {
        category: 'cloud-controller-manager'
        enabled: true
      }
      {
        category: 'guard'
        enabled: true
      }
      {
        category: 'csi-azuredisk-controller'
        enabled: true
      }
      {
        category: 'csi-azurefile-controller'
        enabled: true
      }
      {
        category: 'csi-snapshot-controller'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

output aksName string = aks.name
output aksfqdn string = aks.properties.fqdn
output aksazurePortalFQDN string = aks.properties.azurePortalFQDN
output aksNodeResourceGroupName string = aks.properties.nodeResourceGroup
