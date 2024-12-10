#! /usr/bin/pwsh

Param (
    [parameter(Mandatory=$false)][string][ValidateSet('prod','staging','none','custom', IgnoreCase=$false)]$sslSupport = "none",
    [parameter(Mandatory=$false)][string]$name = "ms-openai-cosmosdb",
    [parameter(Mandatory=$false)][string]$aksName,
    [parameter(Mandatory=$false)][string]$resourceGroup,
    [parameter(Mandatory=$false)][string]$tlsCertFile="",
    [parameter(Mandatory=$false)][string]$tlsKeyFile="",
    [parameter(Mandatory=$false)][string]$domain="",
    [parameter(Mandatory=$false)][string]$tlsSecretName="tls-prod",
    [parameter(Mandatory=$false)][string]$ingressClass="addon-http-application-routing"
)

function validate {
    $valid = $true

    if ([string]::IsNullOrEmpty($aksName)) {
        Write-Host "No AKS name. Use -aksName to specify name" -ForegroundColor Red
        $valid=$false
    }
    if ([string]::IsNullOrEmpty($resourceGroup))  {
        Write-Host "No resource group. Use -resourceGroup to specify resource group." -ForegroundColor Red
        $valid=$false
    }

    if ($sslSupport -eq "custom")  {
        if ([string]::IsNullOrEmpty($domain)) {
            Write-Host "If sslSupport is 'custom' the domain parameter is mandatory." -ForegroundColor Red
            $valid=$false
        }
        if ([String]::IsNullOrEmpty($tlsCertFile)) {
            Write-Host "If sslSupport is 'custom' then need to pass the certificate file in tlsCertFile parameter" -ForegroundColor Red
            $valid=$false
        }
        if ([String]::IsNullOrEmpty($tlsKeyFile)) {
            Write-Host "If sslSupport is 'custom' then need to pass the certificate key file in tlsKeyFile parameter" -ForegroundColor Red
            $valid=$false
        }
        if ([String]::IsNullOrEmpty($tlsSecretName)) {
            Write-Host "If sslSupport is 'custom' then need to pass the Kubernetes secret name in tlsSecretName parameter" -ForegroundColor Red
            $valid=$false
        }        
    }
    
    if ($sslSupport -eq "none")  {
        Write-Host "sslSupport set to none. Nothing will be done. Use staging or prod to setup SSL/TLS" -ForegroundColor Yellow
        $valid=$false
    }

    if ($valid -eq $false) {
        exit 1
    }
}

validate

Write-Host "--------------------------------------------------------" -ForegroundColor Yellow
Write-Host " Enabling SSL/TLS support on cluster $aksName in RG $resourceGroup"  -ForegroundColor Yellow
Write-Host " --------------------------------------------------------" -ForegroundColor Yellow

if ([String]::IsNullOrEmpty($domain)) {
    $domain = $(az aks show -n $aksName -g $resourceGroup -o json --query addonProfiles.httpApplicationRouting.config.HTTPApplicationRoutingZoneName | ConvertFrom-Json)
    if (-not $domain) {
        $domain = $(az aks show -n $aksName -g $resourceGroup -o json --query addonProfiles.httpapplicationrouting.config.HTTPApplicationRoutingZoneName | ConvertFrom-Json)
    }
}

if ([String]::IsNullOrEmpty($domain)) {
    Write-Host "Error: domain not passed and can't be inferred from AKS $aksName" -ForegroundColor Red
    exit 1
}

Write-Host "TLS/SSL will be bound to domain $domain"
Join-Path .. helm | Push-Location

if ($sslSupport -eq "staging") {
    Write-Host "Adding TLS/SSL support using Let's Encrypt Staging environment" -ForegroundColor Yellow
    $command = "helm upgrade --install $name-ssl-staging tls-support -f $(Join-Path tls-support values-staging.yaml) --set domain=$domain --set ingressClass=$ingressClass"
    Invoke-Expression "$command"
}
if ($sslSupport -eq "prod") {
    Write-Host "Adding TLS/SSL support using Let's Encrypt PRODUCTION environment" -ForegroundColor Yellow
    Write-Host "helm upgrade --install $name-ssl-prod tls-support -f $(Join-Path tls-support values-prod.yaml) --set domain=$domain --set ingressClass=$ingressClass"
    $command = "helm upgrade --install $name-ssl-prod tls-support -f $(Join-Path tls-support values-prod.yaml) --set domain=$domain --set ingressClass=$ingressClass"
    Invoke-Expression "$command"
}
if ($sslSupport -eq "custom") {
    Write-Host "TLS support is custom bound to domain $domain" -ForegroundColor Yellow
    Write-Host "Creating secret $tlsSecretName with TLS certificate from file $tlsCertFile and key from $tlsKeyFile"
    $command = "kubectl create secret tls $tlsSecretName --key $tlsKeyFile --cert $tlsCertFile"
    Invoke-Expression "$command"
}

Pop-Location