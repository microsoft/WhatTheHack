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
        Creates brand new sites for testing Site Links
#>
Configuration MSFT_ADReplicationSiteLink_CreatePreReqs_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADReplicationSite 'Integration1'
        {
            Name          = 'Integration1'
            Ensure        = 'Present'
        }
        ADReplicationSite 'Integration2'
        {
            Name          = 'Integration2'
            Ensure        = 'Present'
        }
        ADReplicationSite 'Integration3'
        {
            Name          = 'Integration3'
            Ensure        = 'Present'
        }
    }
}

<#
    .SYNOPSIS
        Creates a brand new Site Link in AD Sites and Services.
#>
Configuration MSFT_ADReplicationSiteLink_CreateSiteLink_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADReplicationSiteLink 'Integration_Test'
        {
            Name          = 'Integration1-Integration2'
            SitesIncluded = @('Integration1', 'Integration2')
            Ensure        = 'Present'
        }
    }
}

<#
    .SYNOPSIS
        Change the Members of a SiteLink
#>
Configuration MSFT_ADReplicationSiteLink_AddMembers_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADReplicationSiteLink 'Integration_Test'
        {
            Name          = 'Integration1-Integration2'
            SitesIncluded = @('Integration1','Integration2', 'Integration3')
            Ensure        = 'Present'
        }
    }
}

<#
    .SYNOPSIS
        Remove a Member of a SiteLink using Exclude
#>
Configuration MSFT_ADReplicationSiteLink_ExcludeMembers_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADReplicationSiteLink 'Integration_Test'
        {
            Name          = 'Integration1-Integration2'
            SitesExcluded = @('Integration3')
            Ensure        = 'Present'
        }
    }
}

<#
    .SYNOPSIS
        Change the attributes of a SiteLink
#>
Configuration MSFT_ADReplicationSiteLink_SetAttributes_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADReplicationSiteLink 'Integration_Test'
        {
            Name                          = 'Integration1-Integration2'
            SitesIncluded                 = @('Integration1', 'Integration3')
            Description                   = 'Integration Test Site Link'
            Cost                          = 20
            ReplicationFrequencyInMinutes = 15
            Ensure                        = 'Present'
        }
    }
}

<#
    .SYNOPSIS
        Enable Change Notification
#>
Configuration MSFT_ADReplicationSiteLink_SetChangeNotification_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADReplicationSiteLink 'Integration_Test'
        {
            Name                          = 'Integration1-Integration2'
            SitesIncluded                 = @('Integration1', 'Integration3')
            Description                   = 'Integration Test Site Link'
            Cost                          = 20
            ReplicationFrequencyInMinutes = 15
            OptionChangeNotification      = $true
            Ensure                        = 'Present'
        }
    }
}

<#
    .SYNOPSIS
        Enable TWOWAY_SYNC
        Should also leave Change notification enabled from previous config
#>
Configuration MSFT_ADReplicationSiteLink_SetTwoWaySync_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADReplicationSiteLink 'Integration_Test'
        {
            Name                          = 'Integration1-Integration2'
            SitesIncluded                 = @('Integration1', 'Integration3')
            Description                   = 'Integration Test Site Link'
            Cost                          = 20
            ReplicationFrequencyInMinutes = 15
            OptionTwoWaySync              = $true
            Ensure                        = 'Present'
        }
    }
}

<#
    .SYNOPSIS
        Enable Disabling Compression
        Should also leave Change notification and TwoWay enabled from previous config
#>
Configuration MSFT_ADReplicationSiteLink_SetDisableCompression_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADReplicationSiteLink 'Integration_Test'
        {
            Name                          = 'Integration1-Integration2'
            SitesIncluded                 = @('Integration1', 'Integration3')
            Description                   = 'Integration Test Site Link'
            Cost                          = 20
            ReplicationFrequencyInMinutes = 15
            OptionDisableCompression      = $true
            Ensure                        = 'Present'
        }
    }
}

<#
    .SYNOPSIS
        Clear options when value = 0
#>
Configuration MSFT_ADReplicationSiteLink_ClearOptions_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADReplicationSiteLink 'Integration_Test'
        {
            Name                          = 'Integration1-Integration2'
            SitesIncluded                 = @('Integration1', 'Integration3')
            Description                   = 'Integration Test Site Link'
            Cost                          = 20
            ReplicationFrequencyInMinutes = 15
            OptionChangeNotification      = $false
            OptionTwoWaySync              = $false
            OptionDisableCompression      = $false
            Ensure                        = 'Present'
        }
    }
}

<#
    .SYNOPSIS
        Remove a SiteLink
#>
Configuration MSFT_ADReplicationSiteLink_RemoveSiteLink_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADReplicationSiteLink 'Integration_Test'
        {
            Name   = 'Integration1-Integration2'
            Ensure = 'Absent'
        }
    }
}

<#
    .SYNOPSIS
        Removes brand new sites for testing Site Links
#>
Configuration MSFT_ADReplicationSiteLink_DeletePreReqs_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADReplicationSite 'Integration1'
        {
            Name          = 'Integration1'
            Ensure        = 'Absent'
        }
        ADReplicationSite 'Integration2'
        {
            Name          = 'Integration2'
            Ensure        = 'Absent'
        }
        ADReplicationSite 'Integration3'
        {
            Name          = 'Integration3'
            Ensure        = 'Absent'
        }
    }
}
