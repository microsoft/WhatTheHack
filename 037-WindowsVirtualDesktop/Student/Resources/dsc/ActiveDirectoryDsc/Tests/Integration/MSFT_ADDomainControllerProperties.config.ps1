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
        Sets the supported property values.
#>
Configuration MSFT_ADDomainControllerProperties_SetPropertyValues_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADDomainControllerProperties 'Integration_Test'
        {
            IsSingleInstance = 'Yes'
            ContentFreshness = 100
        }
    }
}

<#
    .SYNOPSIS
        Restore domain controller properties to the default values.
#>
Configuration MSFT_ADDomainControllerProperties_RestoreDefaultValues_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADDomainControllerProperties 'Integration_Test'
        {
            IsSingleInstance = 'Yes'
            ContentFreshness = 60
        }
    }
}
