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
    $netBiosDomainName = $currentDomain.NetBIOSName
    $domainDistinguishedName = $currentDomain.DistinguishedName

    $ConfigurationData = @{
        AllNodes = @(
            @{
                NodeName                = 'localhost'
                CertificateFile         = $env:DscPublicCertificatePath

                DomainDistinguishedName = $domainDistinguishedName
                NetBIOSName             = $netBiosDomainName

                UserName1               = 'DscTestUser1'
                DisplayName1            = 'Dsc Test User 1'

                ThumbnailPhotoBase64 = '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'
                ThumbnailPhotoHash   = 'E3253C13DFF396BE98D6144F0DFA6105'
                ThumbnailPhotoPath   = Join-Path -Path $PSScriptRoot -ChildPath '..\TestHelpers\DSC_Logo_96.jpg'

                Password                = New-Object `
                    -TypeName System.Management.Automation.PSCredential `
                    -ArgumentList @(
                    'AnyName',
                    (ConvertTo-SecureString -String 'P@ssW0rd1' -AsPlainText -Force)
                )

                AdministratorUserName   = ('{0}\Administrator' -f $netBiosDomainName)
                AdministratorPassword   = 'P@ssw0rd1'
            }
        )
    }
}

<#
    .SYNOPSIS
        Removes a user account.
#>
Configuration MSFT_ADUser_CreateUser1_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADUser 'Integration_Test'
        {
            # Using distinguished name for DomainName - Regression test for issue #451.
            DomainName           = $Node.DomainDistinguishedName
            UserName             = $Node.UserName1
            UserPrincipalName    = $Node.UserName1
            DisplayName          = $Node.DisplayName1
            PasswordNeverExpires = $true
            Password             = $Node.Password

            Credential           = New-Object `
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
        Updates the thumbnail photo on a user account from a Base64-encoded jpeg
        image.
#>
Configuration MSFT_ADUser_UpdateThumbnailPhotoUsingBase64_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADUser 'Integration_Test'
        {
            DomainName     = $Node.DomainDistinguishedName
            UserName       = $Node.UserName1
            ThumbnailPhoto = $Node.ThumbnailPhotoBase64

            Credential     = New-Object `
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
        Updates the thumbnail photo on a user account from a Base64-encoded jpeg
        image.
#>
Configuration MSFT_ADUser_RemoveThumbnailPhoto_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADUser 'Integration_Test'
        {
            DomainName     = $Node.DomainDistinguishedName
            UserName       = $Node.UserName1
            ThumbnailPhoto = ''

            Credential     = New-Object `
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
        Updates the thumbnail photo on a user account from a Base64-encoded jpeg
        file.
#>
Configuration MSFT_ADUser_UpdateThumbnailPhotoFromFile_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADUser 'Integration_Test'
        {
            DomainName     = $Node.DomainDistinguishedName
            UserName       = $Node.UserName1
            ThumbnailPhoto = $Node.ThumbnailPhotoPath

            Credential     = New-Object `
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
        Creates a user account with a password that never expires.
#>
Configuration MSFT_ADUser_RemoveUser1_Config
{
    Import-DscResource -ModuleName 'ActiveDirectoryDsc'

    node $AllNodes.NodeName
    {
        ADUser 'Integration_Test'
        {
            Ensure     = 'Absent'
            DomainName = $Node.DomainDistinguishedName
            UserName   = $Node.UserName1

            Credential           = New-Object `
                -TypeName System.Management.Automation.PSCredential `
                -ArgumentList @(
                $Node.AdministratorUserName,
                (ConvertTo-SecureString -String $Node.AdministratorPassword -AsPlainText -Force)
            )
        }
    }
}
