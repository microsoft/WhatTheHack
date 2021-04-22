<#PSScriptInfo
.VERSION 1.0
.GUID 3bf5100b-238e-435a-8a98-67d756c5cdeb
.AUTHOR Microsoft Corporation
.COMPANYNAME Microsoft Corporation
.COPYRIGHT (c) Microsoft Corporation. All rights reserved.
.TAGS DSCConfiguration
.LICENSEURI https://github.com/PowerShell/ActiveDirectoryDsc/blob/master/LICENSE
.PROJECTURI https://github.com/PowerShell/ActiveDirectoryDsc
.ICONURI
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES
.PRIVATEDATA
#>

#Requires -module ActiveDirectoryDsc

<#
    .DESCRIPTION
        This configuration will create a user with a password and then ignore
        when the password has changed. This might be used with a traditional
        user account where a managed password is not desired.
#>
Configuration ADUser_CreateUserAndIgnorePasswordChanges_Config
{
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        $Password
    )

    Import-DscResource -Module ActiveDirectoryDsc

    Node localhost
    {
        ADUser 'Contoso\ExampleUser'
        {
            Ensure              = 'Present'
            UserName            = 'ExampleUser'
            Password            = $Password
            PasswordNeverResets = $true
            DomainName          = 'contoso.com'
            Path                = 'CN=Users,DC=contoso,DC=com'
        }
    }
}
