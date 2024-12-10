#!/usr/bin/pwsh

Param(
    [parameter(Mandatory=$true)][string]$resourceGroup,
    [parameter(Mandatory=$true)][string]$location
)

Push-Location $($MyInvocation.InvocationName | Split-Path)
Push-Location ..

$storageAccount = $(az storage account list -g $resourceGroup -o json | ConvertFrom-Json).name
az storage container create --account-name $storageAccount --name "system-prompt" --only-show-errors
az storage azcopy blob upload -c system-prompt --account-name $storageAccount -s "./SystemPrompts/*" --recursive --only-show-errors

az storage container create --account-name $storageAccount --name "memory-source" --only-show-errors
az storage azcopy blob upload -c memory-source --account-name $storageAccount -s "./MemorySources/*.json" --recursive --only-show-errors

az storage container create --account-name $storageAccount --name "product-policy" --only-show-errors
az storage azcopy blob upload -c product-policy --account-name $storageAccount -s "./MemorySources/*.txt" --recursive --only-show-errors

Pop-Location
Pop-Location
