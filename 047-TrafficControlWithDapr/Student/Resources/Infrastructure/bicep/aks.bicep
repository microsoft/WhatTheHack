param aksName string
param location string
param logAnalyticsWorkspaceName string
param managedIdentityName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  name: managedIdentityName
}

resource managedIdentityOperatorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: subscription()
  name: 'f1a07417-d97a-45cb-824c-7a7467783830'
}

resource managedIdentityManagedIdentityOperatorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(managedIdentity.id, 'ManagedIdentityOperatorRoleAssignment')
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: managedIdentityOperatorRoleDefinition.id
  }
  scope: managedIdentity
}

resource aks 'Microsoft.ContainerService/managedClusters@2022-09-02-preview' = {
  name: aksName
  location: location
  dependsOn: [
    managedIdentityManagedIdentityOperatorRoleAssignment
  ]
  properties: {
    kubernetesVersion: '1.26.0'
    enableRBAC: true //this is required to install Dapr correctly
    dnsPrefix: aksName
    networkProfile: {
      networkPlugin: 'azure'
    }
    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: 0
        count: 1
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
    securityProfile: {
      workloadIdentity: {
        enabled: true
      }
    }
    oidcIssuerProfile: {
      enabled: true
    }
    identityProfile: {
      kubeletidentity: {
        clientId: managedIdentity.properties.clientId
        objectId: managedIdentity.properties.principalId
        resourceId: managedIdentity.id
      }
    }
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
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
