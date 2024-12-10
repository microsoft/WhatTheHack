#! /usr/bin/pwsh

Param(
    [parameter(Mandatory=$false)][string]$cosmosDbAccountName=$env:AZURE_COSMOS_DB_NAME,
    [parameter(Mandatory=$false)][string]$resourceGroup=$env:AZURE_RESOURCE_GROUP,
    [parameter(Mandatory=$false)][string]$apiUrl=$env:SERVICE_API_ENDPOINT_URL
)

Push-Location $($MyInvocation.InvocationName | Split-Path)

$blobUri = "https://cosmosdbcosmicworks.blob.core.windows.net/cosmic-works-small/product.json"
$result = Invoke-WebRequest -Uri $blobUri
$products = $result.Content | ConvertFrom-Json
Write-Output "Imported $($products.Length) products"

$blobUri = "https://cosmosdbcosmicworks.blob.core.windows.net/cosmic-works-small/customer.json"
$result = Invoke-WebRequest -Uri $blobUri
# The customers file has a BOM which needs to be ignored
$customers = $result.Content.Substring(1, $result.Content.Length - 1) | ConvertFrom-Json
Write-Output "Imported $($customers.Length) customers"

$OldProgressPreference = $ProgressPreference
$ProgressPreference = "SilentlyContinue"

#Write-Host "Bumping up the throughput on the customer container to avoid a known DMT issue..."
#az cosmosdb sql container throughput update --account-name $cosmosDbAccountName --database-name vsai-database --name customer --resource-group $resourceGroup --max-throughput 2000

$currentIndex = 0
foreach($product in $products)
{
    Invoke-RestMethod -Uri $apiUrl/products -Method PUT -Body ($product | ConvertTo-Json) -ContentType 'application/json'

    $currentIndex += 1
    Write-Output "Imported product $currentIndex of $($products.Length)"
}

$currentIndex = 0
foreach($customer in $customers)
{
    if ($customer.type -eq "customer") {
        Invoke-RestMethod -Uri $apiUrl/customers -Method PUT -Body ($customer | ConvertTo-Json) -ContentType 'application/json'
    } elseif ($customer.type -eq "salesOrder") {
        Invoke-RestMethod -Uri $apiUrl/salesorders -Method PUT -Body ($customer | ConvertTo-Json) -ContentType 'application/json'
    }

    $currentIndex += 1
    Write-Output "Imported customer/sales order $currentIndex of $($customers.Length)"
}

$ProgressPreference = $OldProgressPreference

#Write-Host "Restoring the throughput on the customer container..."
#az cosmosdb sql container throughput update --account-name $cosmosDbAccountName --database-name vsai-database --name customer --resource-group $resourceGroup --max-throughput 1000

Pop-Location
