param aksName string
param location string
param logAnalyticsWorkspaceName string
param managedIdentityName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  name: managedIdentityName
}

resource aks 'Microsoft.ContainerService/managedClusters@2022-09-02-preview' = {
  name: aksName
  location: location
  properties: {
    kubernetesVersion: '1.24.6'
    enableRBAC: true //this is required to install Dapr correctly
    dnsPrefix: aksName
    networkProfile: {
      networkPlugin: 'azure'
    }
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
      omsagent: {
        enabled: true
        config: {
          logAnalyticsWorkspaceResourceID: logAnalyticsWorkspace.id
        }
      }
      azureKeyVaultSecretsProvider: {
        enabled: true
        config: {
          enableSecretRotation: 'true'
          rotationPollInterval: '120s'
        }
      }
    }
    podIdentityProfile: {
      enabled: true
      userAssignedIdentities: [
        {
          name: 'pod-identity'
          namespace: 'dapr-trafficcontrol'
          identity: {
            clientId: managedIdentity.properties.clientId
            objectId: managedIdentity.properties.principalId
            resourceId: managedIdentity.id
          }
        }
      ]
    }
    securityProfile: {
      workloadIdentity: {
        enabled: true
      }
    }
    oidcIssuerProfile: {
      enabled: true
    }
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
}

resource dapr 'Microsoft.KubernetesConfiguration/extensions@2022-03-01' = {
  name: 'dapr'
  scope: aks
  properties: {
    extensionType: 'microsoft.dapr'
    scope: {
      cluster: {
        releaseNamespace: 'dapr-system'
      }
    }
    autoUpgradeMinorVersion: true
  }
}

resource federatedIdentityCredential 'Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials@2022-01-31-preview' = {
  name: 'dapr-trafficcontrol-service-account'
  parent: managedIdentity
  properties: {
    audiences: [
      'api://AzureADTokenExchange'
    ]
    issuer: aks.properties.oidcIssuerProfile.issuerURL
    subject: 'system:serviceaccount:dapr-trafficcontrol:dapr-trafficcontrol-service-account'
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
