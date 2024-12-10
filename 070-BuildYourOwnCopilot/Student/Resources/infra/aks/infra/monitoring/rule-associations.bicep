param prometheusDcrId string
param containerInsightsDcrId string
param clusterName string

resource aksCluster 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' existing = {
  name: clusterName
}

// Managed prometheus data collection rule association
resource prometheusDcra 'Microsoft.Insights/dataCollectionRuleAssociations@2021-09-01-preview' = {
  name: 'ContainerInsightsMetricsExtension'
  properties: {
    description:'Association of data collection rule. Deleting this association will break the prometheus metrics data collection for this AKS Cluster.'
    dataCollectionRuleId: prometheusDcrId
  }
  scope: aksCluster
}

// Container Insights data collection rule association
resource containerInsightsDcra 'Microsoft.Insights/dataCollectionRuleAssociations@2021-09-01-preview' = {
  name: 'ContainerInsightsExtension'
  properties: {
    description:'Association of data collection rule. Deleting this association will break the data collection for this AKS Cluster.'
    dataCollectionRuleId: containerInsightsDcrId
  }
  scope: aksCluster
}
