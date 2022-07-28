<#
.SYNOPSIS
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Test-MyTestFunction -Verbose
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>
[CmdletBinding()]
param (
    # challenge number to deploy
    [Parameter(Mandatory = $true, HelpMessage = 'Enter the WTH hub and spoke challenge number (1-6)')]
    [ValidateRange(1, 6)]
    [int]
    $challengeNumber,

    # deploy fully configured lab or leave some configuration to be done
    [Parameter(Mandatory = $false, HelpMessage = 'Deploy all challenge resources fully configured or partially configured (for learning!)')]
    [ValidateSet('FullyConfigured', 'PartiallyConfigured')]
    [string]
    $deploymentType = 'FullyConfigured',
    
    # resource deployment Azure region, defaults to 'eastus2'
    [Parameter(Mandatory = $false)]
    [string]
    $location = 'EastUS2',

    # Parameter help description
    [Parameter(Mandatory = $true)]
    [SecureString]
    $vmPassword
)

$ErrorActionPreference = 'Stop'

If (-NOT (Test-Path ./01-resourceGroups.bicep)) {

    Write-Warning "This script need to be executed from the directory containing the bicep files. Attempting to set location to script location."

    try {
        $scriptPath = ($MyInvocation.MyCommand.Path | Split-Path -Parent -ErrorAction Stop)
        Push-Location -Path $scriptPath -ErrorAction Stop
    }
    catch {
        Write-Error "Failed to set path to bicep file location. Use the 'cd' command to change the current directory to the same location as the WTH bicep files before executing this script."
    }
}

If ( -NOT ($azContext = Get-AzContext)) {
    Write-Error "Run 'Connect-AzAccount' before executing this script!"
}
Else {
    do { $response = (Read-Host "Resources will be created in subscription '$($azContext.Subscription.Name)'. Proceed? (y/n)") }
    until ($response -match '[nNYy]')

    If ($response -match 'nN') { exit }
}

switch ($challengeNumber) {
    1 {
        Write-Host "Deploying resources for Challenge 1: Hub-and-spoke Basics"

        Write-Host "`tDeploying resource groups..."
        New-AzDeployment -Location $location -TemplateFile ./01-00-resourceGroups.bicep

        Write-Host "`tDeploying base resources (this will take up to 60 minutes for the VNET Gateway)..."
        $baseInfraJobs = @{}
        $baseInfraJobs += @{'wth-rg-spoke1' = (New-AzResourceGroupDeployment -ResourceGroupName 'wth-rg-spoke1' -TemplateFile ./01-01-spoke1.bicep -TemplateParameterObject @{vmPassword = $vmPassword } -AsJob)}
        $baseInfraJobs += @{'wth-rg-spoke2' = (New-AzResourceGroupDeployment -ResourceGroupName 'wth-rg-spoke2' -TemplateFile ./01-01-spoke2.bicep -TemplateParameterObject @{vmPassword = $vmPassword } -AsJob)}
        $baseInfraJobs += @{'wth-rg-hub' = (New-AzResourceGroupDeployment -ResourceGroupName 'wth-rg-hub' -TemplateFile ./01-01-hub.bicep -TemplateParameterObject @{vmPassword = $vmPassword } -AsJob)}

        Write-Host "`tWaiting up to 60 minutes for resources to deploy..." 
        $baseInfraJobs.GetEnumerator().ForEach({$_.Value}) | Wait-Job -Timeout 3600

        $gw1pip = $baseInfraJobs.'wth-rg-hub'.Output.Outputs.pipgw1.Value
        $gw2pip = $baseInfraJobs.'wth-rg-hub'.Output.Outputs.pipgw2.Value
        $gwasn = $baseInfraJobs.'wth-rg-hub'.Output.Outputs.wthhubvnetgwasn.Value
        $gw1privateip = $baseInfraJobs.'wth-rg-hub'.Output.Outputs.wthhubvnetgwprivateip1.Value
        $gw2privateip = $baseInfraJobs.'wth-rg-hub'.Output.Outputs.wthhubvnetgwprivateip2.Value

        Write-Host "`tDeploying VNET Peering..."
        $peeringJobs = @()
        $peeringJobs += New-AzResourceGroupDeployment -ResourceGroupName 'wth-rg-hub' -TemplateFile ./01-02-vnetpeeringhub.bicep -AsJob
        $peeringJobs += New-AzResourceGroupDeployment -ResourceGroupName 'wth-rg-spoke1' -TemplateFile ./01-02-vnetpeeringspoke1.bicep -AsJob
        $peeringJobs += New-AzResourceGroupDeployment -ResourceGroupName 'wth-rg-spoke2' -TemplateFile ./01-02-vnetpeeringspoke2.bicep -AsJob

        $peeringJobs | Wait-Job -Timeout 300

        Write-Host "Deploying 'onprem' infra"

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
        $onPremJob = New-AzResourceGroupDeployment -ResourceGroupName 'wth-rg-onprem' -TemplateFile ./01-03-onprem.bicep -TemplateParameterObject @{vmPassword = $vmPassword } -AsJob

        $onPremJob | Wait-Job

        Write-Host "`tConfiguring VPN resources..."

        $vpnJobs = @()
        $vpnJobs += New-AzResourceGroupDeployment -ResourceGroupName 'wth-rg-hub' -TemplateFile ./01-04-hubvpnconfig.bicep -AsJob

        $vpnJobs | Wait-Job -Timeout 600
    }
    2 {}
    3 {}
    4 {}
    5 {}
    6 {}
}

Pop-Location