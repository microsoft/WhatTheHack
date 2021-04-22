<#PSScriptInfo
.VERSION 1.0
.GUID b293f599-2660-424d-8200-61d399e44257
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
        This configuration will create a user with a managed password.
        This might be used to manage the lifecycle of a service account.
#>
Configuration ADUser_CreateUserAndManagePassword_Config
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
            Ensure     = 'Present'
            UserName   = 'ExampleUser'
            Password   = $Password
            DomainName = 'contoso.com'
            Path       = 'CN=Users,DC=contoso,DC=com'
        }
    }
}
