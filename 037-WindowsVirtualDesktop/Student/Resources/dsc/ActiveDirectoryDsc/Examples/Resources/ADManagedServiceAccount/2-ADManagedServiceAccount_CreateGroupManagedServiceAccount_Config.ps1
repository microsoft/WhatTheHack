<#PSScriptInfo
.VERSION 1.0
.GUID 9736d8e5-f4e6-4ae9-9e3f-41267f4026a5
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
        This configuration will create a group managed service account.
#>
Configuration ADManagedServiceAccount_CreateGroupManagedServiceAccount_Config
{
    Import-DscResource -Module ActiveDirectoryDsc

    Node localhost
    {
        ADManagedServiceAccount 'ExampleGroupMSA'
        {
            Ensure             = 'Present'
            ServiceAccountName = 'Service01'
            AccountType        = 'Group'
            Path               = 'OU=ServiceAccounts,DC=contoso,DC=com'
        }
    }
}
