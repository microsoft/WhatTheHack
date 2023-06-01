<#
.SYNOPSIS
.DESCRIPTION
    Deploys or configures WTH Networking challenge resources. 
.EXAMPLE
    ./deploy.ps1 -challengeNumber 1 
    Deploy all resource groups and resources for Challenge 1. Script will prompt for a password, which will be used across all VMs. 
#>
[CmdletBinding()]
param (
    # challenge number to deploy
    [Parameter(Mandatory = $true, HelpMessage = 'Enter the WTH hub and spoke challenge number (1-6)')]
    [ValidateRange(1, 6)]
    [int]
    $challengeNumber,

    <#
    # TODO: deploy fully configured lab or leave some configuration to be done
    [Parameter(Mandatory = $false, HelpMessage = 'Deploy all challenge resources fully configured or partially configured (for learning!)')]
    [ValidateSet('FullyConfigured', 'PartiallyConfigured')]
    [string]
    $deploymentType = 'FullyConfigured',
    #>
    
    # resource deployment Azure region, defaults to 'eastus2'
    [Parameter(Mandatory = $false)]
    [string]
    $location = 'EastUS2',

    # Parameter help description
    [Parameter(Mandatory = $false)]
    [SecureString]
    $vmPassword,

    # include to correct intentionally misconfigured resources (deployed as part of the challenge)
    [Parameter(Mandatory = $false)]
    [switch]
    $correctedConfiguration,

    # confirm subscription and resource types
    [Parameter(Mandatory=$false)]
    [System.Boolean]
    $confirm = $true,

    # challenge parameters
    [parameter(Mandatory = $false)]
    [hashtable]
    $challengeParameters = @{}
)

$ErrorActionPreference = 'Stop'

If (-NOT (Test-Path ./01-resourceGroups.bicep)) {

    Write-Warning "This script need to be executed from the directory containing the bicep files. Attempting to set location to script location."

    try {
        $scriptPath = ($MyInvocation.MyCommand.Path | Split-Path -Parent -ErrorAction Stop)
        Push-Location -Path $scriptPath -ErrorAction Stop
    }
    catch {
        throw "Failed to set path to bicep file location. Use the 'cd' command to change the current directory to the same location as the WTH bicep files before executing this script."
    }
}

If ( -NOT ($azContext = Get-AzContext)) {
    throw "Run 'Connect-AzAccount' before executing this script!"
}
ElseIf ($confirm) {
    do { $response = (Read-Host "Resources will be created in subscription '$($azContext.Subscription.Name)' in region '$location'. If this is not the correct subscription, use 'Select-AzSubscription' before running this script and specify an alternate location with the -Location parameter. Proceed? (y/n)") }
    until ($response -match '[nNYy]')

    If ($response -match 'nN') { exit }
}

switch ($challengeNumber) {
    1 {
        Write-Host "Deploying resources for Challenge 1: Hub-and-spoke Basics"

        If (-NOT ($vmPassword)) {
            $vmPassword = Read-Host "Enter (and make note of) a complex password which will be used for all deployed VMs (username will be 'admin-wth')" -AsSecureString
        }

        Write-Host "`tDeploying resource groups..."
        New-AzDeployment -Location $location -Name "01-00-resourceGroups_$location" -TemplateFile ./01-00-resourceGroups.bicep | Out-Null

        Write-Host "`tDeploying base resources (this will take up to 60 minutes for the VNET Gateway)..."
        $baseInfraJobs = @{}
        $baseInfraJobs += @{'wth-rg-spoke1' = (New-AzResourceGroupDeployment -ResourceGroupName 'wth-rg-spoke1' -TemplateFile ./01-01-spoke1.bicep -TemplateParameterObject @{vmPassword = $vmPassword; location = $location } -AsJob)}
        $baseInfraJobs += @{'wth-rg-spoke2' = (New-AzResourceGroupDeployment -ResourceGroupName 'wth-rg-spoke2' -TemplateFile ./01-01-spoke2.bicep -TemplateParameterObject @{vmPassword = $vmPassword; location = $location } -AsJob)}
        $baseInfraJobs += @{'wth-rg-hub' = (New-AzResourceGroupDeployment -ResourceGroupName 'wth-rg-hub' -TemplateFile ./01-01-hub.bicep -TemplateParameterObject @{vmPassword = $vmPassword; location = $location } -AsJob)}

        Write-Host "`tWaiting up to 60 minutes for resources to deploy..." 
        $baseInfraJobs.GetEnumerator().ForEach({$_.Value}) | Wait-Job -Timeout 3600 | Out-Null

        # check for deployment errors
        $baseInfraJobs.GetEnumerator().ForEach({$_.Value}) | Foreach-Object {
            $job = $_ | Get-Job
            If ($job.Error) {
                Write-Error "A deployment experienced an error: $($job.error)"
            }
        }

        $gw1pip = $baseInfraJobs.'wth-rg-hub'.Output.Outputs.pipgw1.Value
        $gw2pip = $baseInfraJobs.'wth-rg-hub'.Output.Outputs.pipgw2.Value
        $gwasn = $baseInfraJobs.'wth-rg-hub'.Output.Outputs.wthhubvnetgwasn.Value
        $gw1privateip = $baseInfraJobs.'wth-rg-hub'.Output.Outputs.wthhubvnetgwprivateip1.Value
        $gw2privateip = $baseInfraJobs.'wth-rg-hub'.Output.Outputs.wthhubvnetgwprivateip2.Value

        Write-Host "`tDeploying VNET Peering..."
        $peeringJobs = @()
        $peeringJobs += New-AzResourceGroupDeployment -ResourceGroupName 'wth-rg-hub' -TemplateFile ./01-02-vnetpeeringhub.bicep -TemplateParameterObject @{} -AsJob
        $peeringJobs += New-AzResourceGroupDeployment -ResourceGroupName 'wth-rg-spoke1' -TemplateFile ./01-02-vnetpeeringspoke1.bicep -TemplateParameterObject @{}  -AsJob
        $peeringJobs += New-AzResourceGroupDeployment -ResourceGroupName 'wth-rg-spoke2' -TemplateFile ./01-02-vnetpeeringspoke2.bicep -TemplateParameterObject @{}  -AsJob

        $peeringJobs | Wait-Job -Timeout 300 | Out-Null

        # check for deployment errors
        $peeringJobs | Foreach-Object {
            $job = $_
            If ($job.Error) {
                Write-Error "A VNET peering deployment experienced an error: $($job.error)"
            }
        }

        Write-Host "`tDeploying 'onprem' infra"

        #accept csr marketplace terms
        try {
            If (-Not (Get-AzMarketplaceTerms -Publisher 'cisco' -Product 'cisco-csr-1000v' -Name '16_12-byol').Accepted) {
                Write-Host "`t`tAccepting Cisco CSR marketplace terms for this subscription..."
                Set-AzMarketplaceTerms -Publisher 'cisco' -Product 'cisco-csr-1000v' -Name '16_12-byol' -Accept | Out-Null
            }
        }
        catch {
            throw "An error occured while attempting to accept the markeplace terms for the Cisco CSR deployment. Try running `Set-AzMarketplaceTerms -Publisher 'cisco' -Product 'cisco-csr-1000v' -Name '16_12-byol' -Accept` in Cloud Shell for the target subscription. Error: $_"
        }
        #update csr bootstrap file
        $csrConfigContent = Get-Content -Path .\csrScript.txt
        $updatedCsrConfigContent = $csrConfigContent
        $updatedCsrConfigContent = $updatedCsrConfigContent.Replace('**GW0_Public_IP**',$gw1pip)
        $updatedCsrConfigContent = $updatedCsrConfigContent.Replace('**GW1_Public_IP**',$gw2pip)
        $updatedCsrConfigContent = $updatedCsrConfigContent.Replace('**VNETGWASN**',$gwasn)
        $updatedCsrConfigContent = $updatedCsrConfigContent.Replace('**GW0_Private_IP**',$gw1privateip)
        $updatedCsrConfigContent = $updatedCsrConfigContent.Replace('**GW1_Private_IP**',$gw2privateip)

        Set-Content -Path .\csrScript.txt.tmp -Value $updatedCsrConfigContent -Force

        #deploy resources
        $onPremJob = New-AzResourceGroupDeployment -ResourceGroupName 'wth-rg-onprem' -TemplateFile ./01-03-onprem.bicep -TemplateParameterObject @{vmPassword = $vmPassword; location = $location } -AsJob

        $onPremJob | Wait-Job | Out-Null

        # check for deployment errors
        If ($onPremJob.Error) {
            Write-Error "A on-prem infrastructure deployment experienced an error: $($onPremJob.error)"
        }

        Write-Host "`tConfiguring VPN resources..."

        $vpnJobs = @()
        $vpnJobs += New-AzResourceGroupDeployment -ResourceGroupName 'wth-rg-hub' -TemplateFile ./01-04-hubvpnconfig.bicep -TemplateParameterObject @{location = $location } -AsJob

        $vpnJobs | Wait-Job -Timeout 600 | Out-Null

        # check for deployment errors
        If ($vpnJobs.Error) {
            Write-Error "A VPN resource/configuration deployment experienced an error: $($vpnJobs.error)"
        }

        Write-Host "`tConfiguring Cisco Hub CSR NVA resources..."

        $csrJobs = @()
        $csrJobs += New-AzResourceGroupDeployment -ResourceGroupName 'wth-rg-hub' -TemplateFile ./01-05-csrnva.bicep -TemplateParameterObject @{vmPassword = $vmPassword;location = $location } -AsJob

        $csrJobs | Wait-Job -Timeout 600 | Out-Null

        # check for deployment errors
        If ($csrJobs.Error) {
            Write-Error "The Cisco CSR NVA resource/configuration deployment experienced an error: $($csrJobs.error)"
        }
    }
    default {
        Write-Error "Deployment of this challenge is not implemented"
    }
}

Pop-Location