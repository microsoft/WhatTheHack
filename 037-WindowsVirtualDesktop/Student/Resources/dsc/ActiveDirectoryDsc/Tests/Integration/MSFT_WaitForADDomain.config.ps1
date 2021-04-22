#region HEADER
# Integration Test Config Template Version: 1.2.0
#endregion

<#
    .NOTES
        To run this integration test there are prerequisites that need to
        be setup.

        Integration tests is assumed to be ran on a existing domain controller.

        1. One Domain Controller as source (e.g. forest contoso.com).
        2. Credentials that have access to the domain controller in the domain.
        3. If no certificate path is set to the environment variable
           `$env:DscPublicCertificatePath` then `PSDscAllowPlainTextPassword = $true`
           must be added to the ConfigurationData-block.
#>

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
    $netBiosDomainName = $currentDomain.NetBIOSName

    $currentDomainController = Get-ADDomainController
    $domainName = $currentDomainController.Domain
    $siteName = $currentDomainController.Site

    $ConfigurationData = @{
        AllNodes = @(
            @{
                NodeName        = 'localhost'
                CertificateFile = $env:DscPublicCertificatePath

                DomainName      = $domainName
                SiteName        = $siteName

                AdministratorUserName   = ('{0}\Administrator' -f $netBiosDomainName)
                AdministratorPassword   = 'P@ssw0rd1'
            }
        )
    }
}

<#
    .SYNOPSIS
        Waits for an domain controller and uses the current credentials
        (NT AUTHORITY\SYSTEM when run in the integration test).

    .NOTES
        Using NT AUTHORITY\SYSTEM does only work when evaluating the domain on
        the current node, for example on a node that should be a domain controller.
#>
Configuration MSFT_WaitForADDomain_WaitDomainControllerCurrentUser_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        WaitForADDomain 'Integration_Test'
        {
            DomainName = $Node.DomainName
        }
    }
}

<#
    .SYNOPSIS
        Waits for an domain controller and uses the parameter Credential to pass
        the credentials to impersonate.
#>
Configuration MSFT_WaitForADDomain_WaitDomainControllerUsingCredential_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        WaitForADDomain 'Integration_Test'
        {
            DomainName = $Node.DomainName

            Credential = New-Object `
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
        Waits for an domain controller and uses the parameter PsDscRunAsCredential
        to pass the credentials to impersonate.
#>
Configuration MSFT_WaitForADDomain_WaitDomainControllerUsingPsDscRunAsCredential_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        WaitForADDomain 'Integration_Test'
        {
            DomainName           = $Node.DomainName

            PsDscRunAsCredential = New-Object `
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
        Waits for an domain controller in a specific site, and uses the parameter
        PsDscRunAsCredential to pass the credentials to impersonate.
#>
Configuration MSFT_WaitForADDomain_WaitDomainControllerInSite_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        WaitForADDomain 'Integration_Test'
        {
            DomainName           = $Node.DomainName
            SiteName             = $Node.SiteName

            PsDscRunAsCredential = New-Object `
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
        A domain controller in the domain fails to respond within the timeout
        period.
#>
Configuration MSFT_WaitForADDomain_FailedWaitDomainController_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        WaitForADDomain 'Integration_Test'
        {
            DomainName           = 'unknown.local'
            WaitTimeout           = 3

            PsDscRunAsCredential = New-Object `
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
        A domain controller in the specified site in the domain fails to respond
        within the timeout period.
#>
Configuration MSFT_WaitForADDomain_FailedWaitDomainControllerInSite_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        WaitForADDomain 'Integration_Test'
        {
            DomainName           = 'unknown.local'
            SiteName             = 'Europe'
            WaitTimeout           = 3

            PsDscRunAsCredential = New-Object `
                -TypeName System.Management.Automation.PSCredential `
                -ArgumentList @(
                    $Node.AdministratorUserName,
                    (ConvertTo-SecureString -String $Node.AdministratorPassword -AsPlainText -Force)
                )
        }
    }
}
