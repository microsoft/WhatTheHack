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
        Change the forest functional level to a Windows Server 2012 R2 Forest.
#>
Configuration MSFT_ADForestFunctionalLevel_ChangeForestLevelTo2012R2_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADForestFunctionalLevel 'Integration_Test'
        {
            ForestIdentity = 'contoso.com'
            ForestMode = 'Windows2012R2Forest'
        }
    }
}

<#
    .SYNOPSIS
        Change the forest functional level to a Windows Server 2016 Forest.
#>
Configuration MSFT_ADForestFunctionalLevel_ChangeForestLevelTo2016_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADForestFunctionalLevel 'Integration_Test'
        {
            ForestIdentity = 'contoso.com'
            ForestMode = 'Windows2016Forest'
        }
    }
}
