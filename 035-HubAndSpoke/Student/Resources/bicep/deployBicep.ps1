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
    [Parameter(Mandatory=$true, HelpMessage='Enter the WTH hub and spoke challenge number (1-6)')]
    [ValidateRange(1,6)]
    [int]
    $challengeNumber,

    # deploy fully configured lab or leave some configuration to be done
    [Parameter(Mandatory=$false, HelpMessage='Deploy all challenge resources fully configured or partially configured (for learning!)')]
    [ValidateSet('FullyConfigured','PartiallyConfigured')]
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

If (-NOT (Test-Path ./01-resourceGroups.bicep)) {
    $scriptPath = ($MyInvocation.MyCommand.Path | Split-Path -Parent)
    Write-Warning "This script need to be executed from the directory containing the bicep files. Attempting to set location to '$scriptPath'"

    Push-Location -Path $scriptPath -ErrorAction Stop
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
        New-AzDeployment -Location $location -TemplateFile ./01-resourceGroups.bicep

        Write-Host "`tDeploying base resources (this will take up to 60 minutes for the VNET Gateway)..."
        $baseInfraJobs = @()
        $baseInfraJobs += New-AzResourceGroupDeployment -ResourceGroupName 'wth-rg-spoke1' -TemplateFile ./01-spoke1.bicep -TemplateParameterObject @{vmPassword = $vmPassword} -AsJob
        $baseInfraJobs +=New-AzResourceGroupDeployment -ResourceGroupName 'wth-rg-spoke2' -TemplateFile ./01-spoke2.bicep -TemplateParameterObject @{vmPassword = $vmPassword} -AsJob
        $baseInfraJobs +=New-AzResourceGroupDeployment -ResourceGroupName 'wth-rg-hub' -TemplateFile ./01-hub.bicep -TemplateParameterObject @{vmPassword = $vmPassword} -AsJob
        $baseInfraJobs +=New-AzResourceGroupDeployment -ResourceGroupName 'wth-rg-onprem' -TemplateFile ./01-onprem.bicep -TemplateParameterObject @{vmPassword = $vmPassword} -AsJob

        Write-Host "`tWaiting up to 60 minutes for resources to deploy..." 
        $baseInfraJobs | Wait-Job -Timeout 3600

        Write-Host "`tDeploying VNET Peering..."
        $peeringJobs = @()
        $peeringJobs += New-AzResourceGroupDeployment -ResourceGroupName 'wth-rg-hub' -TemplateFile ./01-vnetpeeringhub.bicep -AsJob
        $peeringJobs += New-AzResourceGroupDeployment -ResourceGroupName 'wth-rg-spoke1' -TemplateFile ./01-vnetpeeringspoke1.bicep -AsJob
        $peeringJobs += New-AzResourceGroupDeployment -ResourceGroupName 'wth-rg-spoke2' -TemplateFile ./01-vnetpeeringspoke2.bicep -AsJob

        $peeringJobs | Wait-Job -Timeout 300
    }
    2 {}
    3 {}
    4 {}
    5 {}
    6 {}
}

Pop-Location