<#PSScriptInfo
.VERSION 1.0
.GUID 697115a8-3004-4eca-b400-f861c6914279
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
        This configuration will update a user with a thumbnail photo using
        a jpeg image encoded as a Base64 string.
#>
Configuration ADUser_UpdateThumbnailPhotoAsBase64_Config
{
    Import-DscResource -Module ActiveDirectoryDsc

    Node localhost
    {
        ADUser 'Contoso\ExampleUser'
        {
            UserName       = 'ExampleUser'
            DomainName     = 'contoso.com'
            ThumbnailPhoto = '/9j/4AAQSkZJRgABAQEAYABgAAD/4QB .... STRING TRUNCATED FOR LENGTH'
        }
    }
}
