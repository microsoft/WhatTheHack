#! /usr/bin/pwsh

Param(
    [parameter(Mandatory=$true)][string]$resourceGroup,
    [parameter(Mandatory=$true)][string]$aksName
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

$webappHostname=$(az aks show -n $aksName -g $resourceGroup -o json --query addonProfiles.httpApplicationRouting.config.HTTPApplicationRoutingZoneName | ConvertFrom-Json)
$apiUrl = "https://$webappHostname/api"
Write-Output "API Url is $apiUrl"

$OldProgressPreference = $ProgressPreference
$ProgressPreference = "SilentlyContinue"

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

Pop-Location
