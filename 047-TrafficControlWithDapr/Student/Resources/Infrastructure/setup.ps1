param (
  [CmdletBinding()]
  [Parameter(Mandatory = $true)]
  [string]$TenantId,
  [Parameter(Mandatory = $true)]
  [string]$SubscriptionId,
  [Parameter(Mandatory = $true)]
  [string]$Location
)

$InformationPreference = 'Continue'
$DEFAULT_AKS_NODE_POOL_SKU = 'Standard_DS2_v2'
$CPU_LOCALNAME = 'Standard DSv2 Family vCPUs'
$NUMBER_OF_CPUS_NEEDED = 6
$DOTNET_VERSION = "6.0"

function Confirm-DotNet6 {
  Write-Debug "Checking if .NET 6 is installed..."

  $dotnetVersion = (dotnet --version)

  if ($dotnetVersion -lt $DOTNET_VERSION) {
    Write-Error ".NET 6 is not installed"
    Write-Error "Installed version of .NET version is: $dotnetVersion"
    return
  }

  Write-Information ".NET 6 installed"
}

function Confirm-AzureCli {
  Write-Debug "Checking if Azure CLI is installed..."

  Get-Command az | Out-Null

  if (!$?) {
    Write-Error "Azure CLI is not installed"
    return
  }

  Write-Information "Azure CLI installed"
}

function Install-AzureCliAksPreview {
  az extension add --name aks-preview
  az extension update --name aks-preview
}

function Install-AksWorkloadIdentityPreview {
  $isWorkloadIdentityPreviewRegistered = (az feature list -o table --query "[?contains(name, 'Microsoft.ContainerService/EnableWorkloadIdentityPreview')].properties.state" -otsv) -eq "Registered"
  if (!$isWorkloadIdentityPreviewRegistered) {
    az feature register --namespace "Microsoft.ContainerService" --name "EnableWorkloadIdentityPreview"
    while (!$isWorkloadIdentityPreviewRegistered) {
      $isWorkloadIdentityPreviewRegistered = (az feature list -o table --query "[?contains(name, 'Microsoft.ContainerService/EnableWorkloadIdentityPreview')].properties.state" -otsv) -eq "Registered"
      if (!$isWorkloadIdentityPreviewRegistered) {
        Write-Warning "Waiting for Microsoft.ContainerService/EnableWorkloadIdentityPreview to be registered..."
        Start-Sleep -Seconds 10
      }
    }
    az provider register --namespace Microsoft.ContainerService
  }
}

function Confirm-Bicep {
  Write-Debug "Checking to see if Bicep is installed..."

  az bicep version

  if (!$?) {
    Write-Error "Bicep is not installed"
    return
  }

  Write-Information "Bicep installed"
}

function Confirm-Docker {
  Write-Debug "Checking to see if Docker is installed..."

  Get-Command docker | Out-Null

  if (!$?) {
    Write-Error "Docker is not installed"
    return
  }

  Write-Information "Docker installed"
}

function Confirm-DockerRunning {
  Write-Debug "Checking to see if Docker is running..."

  docker info | Out-Null

  if (!$?) {
    Write-Error "Docker is not running"
    return
  }

  Write-Information "Docker running"
}

function Confirm-Dapr {
  Write-Debug "Checking to see if Dapr is installed..."

  Get-Command dapr | Out-Null

  if (!$?) {
    Write-Error "Dapr is not installed"
    return
  }

  Write-Information "Dapr installed"
}

function Enable-AzureResourceProviders {
  Write-Debug "Checking Azure resource providers..."

  $requiredProviders = @(
    'Microsoft.Cache'
    'Microsoft.ContainerService'
    'Microsoft.ContainerRegistry'
    'Microsoft.Devices'
    'Microsoft.EventHub'
    'Microsoft.Insights'
    'Microsoft.KeyVault'
    'Microsoft.KubernetesConfiguration'
    'Microsoft.Logic'
    'Microsoft.OperationalInsights'
    'Microsoft.OperationsManagement'
    'Microsoft.ServiceBus'
    'Microsoft.Storage'
    'Microsoft.Web'
  )

  $registeredProviders = (az provider list --query "[?registrationState == 'Registered'].namespace" --output tsv | Sort-Object)

  $areAllProvidersRegistered = $true

  foreach ($requiredProvider in $requiredProviders) {
    if ($registeredProviders -inotcontains $requiredProvider) {
      Write-Warning "Provider '$requiredProvider' is not registered for this subscription"
      Write-Warning "Registering resource provider $requiredProvider ..."
      az provider register --namespace $requiredProvider --subscription $SubscriptionId
      $areAllProvidersRegistered = $false
    }
  }

  if ($areAllProvidersRegistered) {
    Write-Information "All required providers are registered"
  }
}

function Confirm-AksSkuAvailablility {
  Write-Debug "Checking to see if the AKS node pool SKU $DEFAULT_AKS_NODE_POOL_SKU is available in this region..."

  $skuExists = (az vm list-skus --location $Location --size $DEFAULT_AKS_NODE_POOL_SKU --output table)

  if ([string]::IsNullOrWhiteSpace($skuExists)) {
    Write-Error "The default AKS node pool SKU $DEFAULT_AKS_NODE_POOL_SKU is not available in this region"
  }
  else {
    Write-Information "The default AKS node pool SKU $DEFAULT_AKS_NODE_POOL_SKU is available in this region"
  }
}

function Confirm-CpuQuota {
  Write-Debug "Checking to see if the CPU quota will be exceeded for this subscription..."

  $cpuCounts = (az vm list-usage --location southcentralus --query "[?contains(localName, '$CPU_LOCALNAME')]. { CurrentValue:currentValue, Limit:limit }" | ConvertFrom-Json)
  if ($cpuCounts.CurrentValue + $NUMBER_OF_CPUS_NEEDED -gt $cpuCounts.Limit) {
    Write-Error "You will exceeded the CPU quota $($cpuCounts.Limit) for this subscription"
  }
  else {
    Write-Information "You will not exceeded the CPU quota for this subscription"
  }
}

Write-Progress -Activity "Checking all prerequisites..." -Status "0% Complete:" -PercentComplete 0

az login --tenant $TenantId | Out-Null

az account set --subscription $SubscriptionId | Out-Null

$checks = @(
  (Get-Item function:Confirm-AzureCli)
  (Get-Item function:Install-AzureCliAksPreview)
  (Get-Item function:Install-AksWorkloadIdentityPreview)
  (Get-Item function:Confirm-Bicep)
  (Get-Item function:Confirm-Docker)
  (Get-Item function:Confirm-DockerRunning)
  (Get-Item function:Confirm-Dapr)
  (Get-Item function:Confirm-DotNet6)
  (Get-Item function:Enable-AzureResourceProviders)
  (Get-Item function:Confirm-AksSkuAvailablility)
  (Get-Item function:Confirm-CpuQuota)
)

$i = 0

foreach ($check in $checks) {
  & $check
  
  $i++

  $percentComplete = [math]::Round(($i / $checks.Count) * 100)

  Write-Progress -Activity "Completed $($check.Name)" -Status "$percentComplete% Complete:" -PercentComplete $percentComplete
}
  
Write-Progress -Activity "Completed $($check.Name)" -Status "100% Complete:" -PercentComplete 100
