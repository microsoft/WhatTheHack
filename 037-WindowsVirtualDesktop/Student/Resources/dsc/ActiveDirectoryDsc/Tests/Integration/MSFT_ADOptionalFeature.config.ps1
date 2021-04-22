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
    $currentDomain = Get-ADDomain
    $ForestFullyQualifiedDomainName = $currentDomain.Forest
    $netBiosDomainName = $currentDomain.NetBIOSName

    $ConfigurationData = @{
        AllNodes = @(
            @{
                NodeName        = 'localhost'
                CertificateFile = $env:DscPublicCertificatePath

                ForestFullyQualifiedDomainName = $ForestFullyQualifiedDomainName

                AdministratorUserName = ('{0}\Administrator' -f $netBiosDomainName)
                AdministratorPassword = 'P@ssw0rd1'
            }
        )
    }
}

<#
    .SYNOPSIS
        Enabled feature Recycle Bin.

    .NOTES
        This is most likely already enabled by default so the Set-TargetResource
        is never run/tested.
#>
Configuration MSFT_ADOptionalFeature_RecycleBinFeature_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADOptionalFeature 'Integration_Test'
        {
            FeatureName                       = 'Recycle Bin Feature'
            ForestFQDN                        = $ForestFullyQualifiedDomainName
            EnterpriseAdministratorCredential = New-Object `
                -TypeName System.Management.Automation.PSCredential `
                -ArgumentList @(
                    $Node.AdministratorUserName,
                    (ConvertTo-SecureString -String $Node.AdministratorPassword -AsPlainText -Force)
                )
        }
    }
}

<#
    .SYNOPSIS
        Enabled feature Privileged Access Management Feature.
#>
Configuration MSFT_ADOptionalFeature_PrivilegedAccessManagementFeature_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADOptionalFeature 'Integration_Test'
        {
            FeatureName                       = 'Privileged Access Management Feature'
            ForestFQDN                        = $ForestFullyQualifiedDomainName
            EnterpriseAdministratorCredential = New-Object `
                -TypeName System.Management.Automation.PSCredential `
                -ArgumentList @(
                    $Node.AdministratorUserName,
                    (ConvertTo-SecureString -String $Node.AdministratorPassword -AsPlainText -Force)
                )
        }
    }
}
