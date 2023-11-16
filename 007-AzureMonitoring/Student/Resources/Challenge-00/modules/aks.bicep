// This template deploys:
//  - an AKS cluster
//  - a user assigned managed identity
//  - a Bicep Deployment script that installs the eShopOnWeb app onto the AKS cluster
//    from a Helm chart & container stored in the What The Hack Docker Hub account.

param Location string
param Name string
param NodeResourceGroup string
param OmsWorkspaceId string
param SubnetId string

resource aks 'Microsoft.ContainerService/managedClusters@2021-02-01' = {
  name: Name
  location: Location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    enableRBAC: true
    dnsPrefix: 'aks'
    addonProfiles:{
      httpApplicationRouting: {
        enabled: true
      }
      omsagent: {
        enabled: true
        config: {
          logAnalyticsWorkspaceResourceID: OmsWorkspaceId
        }
      }
    }
    agentPoolProfiles: [
      {
        name: 'agentpool01'
        count: 1
        mode: 'System'
        vmSize: 'Standard_D2_v3'
        type: 'VirtualMachineScaleSets'
        osType: 'Linux'
        osDiskSizeGB: 0
        enableAutoScaling: false
        vnetSubnetID: SubnetId
        maxPods: 30
      }
    ]
    servicePrincipalProfile: {
      clientId: 'msi'
    }
    nodeResourceGroup: NodeResourceGroup
    networkProfile: {
      networkPlugin: 'kubenet'
      loadBalancerSku: 'standard'
      serviceCidr: '10.240.0.0/16'
      dnsServiceIP: '10.240.0.10'
      dockerBridgeCidr: '172.17.0.1/16'

    }
  }
  sku: {
    name: 'Basic'
    tier: 'Free'
  }
}

output id string = aks.id
output apiServerAddress string = aks.properties.fqdn
output aksName string = aks.name

@description('UTC timestamp used to create distinct deployment scripts for each deployment')
param utcValue string = utcNow()

@description('SQL Server VM name')
param sqlServerName string

@description('SQL Server Admin Name')
param sqlUserName string

@description('SQL Server Password')
@secure()
param sqlPassword string

@description('Name of app insights resource')
param appInsightsName string

//Set Azure contributor role IDs
var bootstrapRoleAssignmentId = guid('${resourceGroup().id}contributor')
var contributorRoleDefinitionId = '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'

// create User Assigned Managed Identity for Deployment Script
resource deploymentManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'deploymentScriptManagedIdentity'
  location: Location
}

// assign the UAID permissions to do what is needed on the AKS cluster??
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: bootstrapRoleAssignmentId
  properties: {
    roleDefinitionId: contributorRoleDefinitionId
    principalId: reference(deploymentManagedIdentity.id, '2018-11-30').principalId
    scope: resourceGroup().id
    principalType: 'ServicePrincipal'
  }
}

resource eshopAKSDeployment 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'eshop-AKSDeployment-${utcValue}'
  location: Location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${deploymentManagedIdentity.id}': {}
    }
  }
  kind: 'AzureCLI'
  properties: {
    azCliVersion: '2.26.1'
    timeout: 'PT5M'
    retentionInterval: 'PT1H'
    environmentVariables: [
      {
        name: 'AKS_CLUSTER_NAME'
        value: aks.name
      }
      {
        name: 'RESOURCE_GROUP'
        value: resourceGroup().name
      }
      {
        name: 'APP_INSIGHTS_NAME'
        value: appInsightsName
      }
      {
        name: 'SQLSERVER_NAME'
        value: sqlServerName
      }
      {
        name: 'SQL_USERNAME'
        value: sqlUserName
      }
      {
        name: 'SQL_PASSWORD'
        value: sqlPassword
      }
    ]
    scriptContent: loadTextContent('../scripts/deployeShopToAKS.sh')
  }
}
