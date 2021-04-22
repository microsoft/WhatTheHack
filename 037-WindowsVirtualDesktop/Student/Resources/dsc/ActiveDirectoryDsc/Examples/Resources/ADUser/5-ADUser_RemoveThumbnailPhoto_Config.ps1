<#PSScriptInfo
.VERSION 1.0
.GUID 3115fbc7-ed1b-4218-a5a5-855b79259c5a
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
        This configuration will remove the thumbnail photo from the user.
#>
Configuration ADUser_RemoveThumbnailPhoto_Config
{
    Import-DscResource -Module ActiveDirectoryDsc

    Node localhost
    {
        ADUser 'Contoso\ExampleUser'
        {
            UserName       = 'ExampleUser'
            DomainName     = 'contoso.com'
            ThumbnailPhoto = ''
        }
    }
}
