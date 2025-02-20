#! /usr/bin/pwsh

Param(
    [parameter(Mandatory=$true)][string]$resourceGroup,
    [parameter(Mandatory=$true)][string]$acrName,
    [parameter(Mandatory=$true)][string]$subscription,
    [parameter(Mandatory=$false)][string]$dockerTag="latest"
)

Push-Location $($MyInvocation.InvocationName | Split-Path)
$sourceFolder=$(./Join-Path-Recursively.ps1 -pathParts ..,scripts)


# Write-Host "Login in your account" -ForegroundColor Yellow
az login

# Write-Host "Choosing your subscription" -ForegroundColor Yellow
az account set --subscription $subscription

& ./BuildPush.ps1 -resourceGroup $resourceGroup -acrName $acrName -dockerTag $dockerTag -dockerBuild 1 -dockerPush 1

Pop-Location
