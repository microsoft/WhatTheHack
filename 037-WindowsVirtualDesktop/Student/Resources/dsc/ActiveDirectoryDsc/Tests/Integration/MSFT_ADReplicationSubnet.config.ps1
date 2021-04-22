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
        Creates a site as part of prerequisits.
#>
Configuration MSFT_ADReplicationSubnet_CreatePreReq_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADReplicationSite 'Site1'
        {
            Ensure      = 'Present'
            Name        = 'IntegrationTestSite'
        }

        ADReplicationSite 'Site2'
        {
            Ensure      = 'Present'
            Name        = 'IntegrationTestSite2'
        }
    }
}

<#
    .SYNOPSIS
        Creates a site subnet.
#>
Configuration MSFT_ADReplicationSubnet_CreateSubnet_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADReplicationSubnet 'Integration_Test'
        {
            Ensure      = 'Present'
            Name        = '10.0.0.0/24'
            Site        = 'IntegrationTestSite'
        }
    }
}

<#
    .SYNOPSIS
        Changes a site subnet Site to Default.
#>
Configuration MSFT_ADReplicationSubnet_ChangeSubnetSite_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADReplicationSubnet 'Integration_Test'
        {
            Ensure      = 'Present'
            Name        = '10.0.0.0/24'
            Site        = 'IntegrationTestSite2'
        }
    }
}

<#
    .SYNOPSIS
        Changes a Replication Subnet Location.
#>
Configuration MSFT_ADReplicationSubnet_ChangeSubnetLocation_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADReplicationSubnet 'Integration_Test'
        {
            Ensure      = 'Present'
            Name        = '10.0.0.0/24'
            Site        = 'IntegrationTestSite2'
            Location    = 'Office 12'
        }
    }
}

<#
    .SYNOPSIS
        Changes a Replication Subnet Description.
#>
Configuration MSFT_ADReplicationSubnet_ChangeSubnetDescription_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADReplicationSubnet 'Integration_Test'
        {
            Ensure      = 'Present'
            Name        = '10.0.0.0/24'
            Site        = 'IntegrationTestSite2'
            Location    = 'Office 12'
            Description = 'Updated Subnet Description'
        }
    }
}

<#
    .SYNOPSIS
        Removes a site subnet.
#>
Configuration MSFT_ADReplicationSubnet_RemoveSubnet_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADReplicationSubnet 'Integration_Test'
        {
            Ensure   = 'Absent'
            Name     = '10.0.0.0/24'
            Site     = 'IntegrationTestSite2'
            Location = 'Datacenter 3'
        }
    }
}

<#
    .SYNOPSIS
        Removes the sites as part of prerequisits.
#>
Configuration MSFT_ADReplicationSubnet_RemovePreReq_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADReplicationSite 'Site1'
        {
            Ensure      = 'Absent'
            Name        = 'IntegrationTestSite'
        }

        ADReplicationSite 'Site2'
        {
            Ensure      = 'Absent'
            Name        = 'IntegrationTestSite2'
        }
    }
}
