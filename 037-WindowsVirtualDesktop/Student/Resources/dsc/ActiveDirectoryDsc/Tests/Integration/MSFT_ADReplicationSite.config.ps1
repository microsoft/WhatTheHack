#region HEADER
# Integration Test Config Template Version: 1.2.0
#endregion

$configFile = [System.IO.Path]::ChangeExtension($MyInvocation.MyCommand.Path, 'json')
if (Test-Path -Path $configFile)
{
    <#
        Allows reading the configuration data from a JSON file, for real testing
        scenarios outside of the CI.
    #>
    $ConfigurationData = Get-Content -Path $configFile | ConvertFrom-Json
}
else
{
    $ConfigurationData = @{
        AllNodes = @(
            @{
                NodeName        = 'localhost'
                CertificateFile = $env:DscPublicCertificatePath
            }
        )
    }
}

<#
    .SYNOPSIS
        Creates a brand new Site in AD Sites and Services.
#>
Configuration MSFT_ADReplicationSite_CreateSite_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADReplicationSite 'Integration_Test'
        {
            Name        = 'NewADSite'
            Description = 'New AD site description'
            Ensure      = 'Present'
        }
    }
}

<#
    .SYNOPSIS
        Remove site from AD Sites and Services
#>
Configuration MSFT_ADReplicationSite_RemoveSite_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADReplicationSite 'Integration_Test'
        {
            Name        = 'NewADSite'
            Description = 'New AD site description'
            Ensure      = 'Absent'
        }
    }
}

<#
    .SYNOPSIS
        Rename the Default Site in Active Directory
#>
Configuration MSFT_ADReplicationSite_RenameDefaultSite_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADReplicationSite 'Integration_Test'
        {
            Name                       = 'RenamedDefaultADSite'
            Description                = 'Renaming Default Site'
            Ensure                     = 'Present'
            RenameDefaultFirstSiteName = $true
        }
    }
}

