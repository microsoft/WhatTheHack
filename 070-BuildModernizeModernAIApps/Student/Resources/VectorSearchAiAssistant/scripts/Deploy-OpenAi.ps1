#!/usr/bin/pwsh

Param(
    [parameter(Mandatory=$true)][string]$name,
    [parameter(Mandatory=$true)][string]$resourceGroup,
    [parameter(Mandatory=$true)][string]$location,
    [parameter(Mandatory=$true)][string]$completionsDeployment,
    [parameter(Mandatory=$true)][string]$embeddingsDeployment
)

Push-Location $($MyInvocation.InvocationName | Split-Path)

if (-Not (az cognitiveservices account list -g $resourceGroup --query '[].name' -o json | ConvertFrom-Json) -Contains $name) {
    Write-Host("The Azure OpenAI account $($name) was not found, creating it...")
    az cognitiveservices account create -g $resourceGroup -n $name --kind OpenAI --sku S0 --location $location --yes --custom-domain $name
}

$deployments = (az cognitiveservices account deployment list -g $resourceGroup -n $name --query '[].name' -o json | ConvertFrom-Json)
Write-Host "Existing deployments: $($deployments)"
if (-Not ($deployments -Contains $completionsDeployment)) {
    Write-Host("The Azure OpenAI deployment $($completionsDeployment) under account $($name) was not found, creating it...")
    az cognitiveservices account deployment create -g $resourceGroup -n $name --deployment-name $completionsDeployment --model-name 'gpt-35-turbo' --model-version '0301' --model-format OpenAI --sku Standard --sku-capacity 120
}

$deployments = (az cognitiveservices account deployment list -g $resourceGroup -n $name --query '[].name' -o json | ConvertFrom-Json)
Write-Host "Existing deployments: $($deployments)"
if (-Not ($deployments -Contains $embeddingsDeployment)) {
    Write-Host("The Azure OpenAI deployment $($embeddingsDeployment) under account $($name) was not found, creating it...")
    az cognitiveservices account deployment create -g $resourceGroup -n $name --deployment-name $embeddingsDeployment --model-name 'text-embedding-ada-002' --model-version '2' --model-format OpenAI --sku Standard --sku-capacity 120
}

Pop-Location