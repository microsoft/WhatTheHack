Write-Host "Making sure that the features are registered"
az extension add --upgrade --name aks-preview
az extension add --upgrade --name amg # Azure Managed Grafana
az feature register --namespace Microsoft.ContainerService --name AKS-KedaPreview
az feature register --namespace Microsoft.ContainerService --name AKS-VPAPreview
az feature register --namespace Microsoft.ContainerService --name AKS-PrometheusAddonPreview
az feature register --namespace Microsoft.ContainerService --name EnableWorkloadIdentityPreview
az feature register --namespace Microsoft.ContainerService --name EnableAPIServerVnetIntegrationPreview
az feature register --namespace Microsoft.ContainerService --name NRGLockdownPreview
az provider register --namespace Microsoft.ContainerService
