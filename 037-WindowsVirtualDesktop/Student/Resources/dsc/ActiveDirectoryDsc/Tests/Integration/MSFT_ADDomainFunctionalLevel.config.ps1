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
        Change the forest functional level to a Windows Server 2012 R2 Forest
        to be able to test lowering the domain functional level.
#>
Configuration MSFT_ADDomainFunctionalLevel_ChangeForestLevelTo2012R2_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADForestFunctionalLevel 'ChangeForestLevelTo2012R2'
        {
            ForestIdentity = 'contoso.com'
            ForestMode = 'Windows2012R2Forest'
        }
    }
}

<#
    .SYNOPSIS
        Change the domain functional level to a Windows Server 2012 R2 Domain.
#>
Configuration MSFT_ADDomainFunctionalLevel_ChangeDomainLevelTo2012R2_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADDomainFunctionalLevel 'Integration_Test'
        {
            DomainIdentity = 'contoso.com'
            DomainMode = 'Windows2012R2Domain'
        }
    }
}

<#
    .SYNOPSIS
        Change the domain functional level to a Windows Server 2016 Domain.
#>
Configuration MSFT_ADDomainFunctionalLevel_ChangeDomainLevelTo2016_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADDomainFunctionalLevel 'Integration_Test'
        {
            DomainIdentity = 'contoso.com'
            DomainMode = 'Windows2016Domain'
        }
    }
}

<#
    .SYNOPSIS
        Revert the forest functional level to a Windows Server 2016 Forest after
        the domain functional level has been set back to Windows Server 2016 Domain.
#>
Configuration MSFT_ADDomainFunctionalLevel_ChangeForestLevelTo2016_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADForestFunctionalLevel 'ChangeForestLevelTo2016'
        {
            ForestIdentity = 'contoso.com'
            ForestMode = 'Windows2016Forest'
        }
    }
}
