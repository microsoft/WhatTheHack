<#PSScriptInfo
.VERSION 1.0
.GUID 7282b5a1-93e4-4ec7-8aea-8ec63f5bab2b
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
        a jpeg file.
#>
Configuration ADUser_UpdateThumbnailPhotoFromFile_Config
{
    Import-DscResource -Module ActiveDirectoryDsc

    Node localhost
    {
        ADUser 'Contoso\ExampleUser'
        {
            UserName       = 'ExampleUser'
            DomainName     = 'contoso.com'
            ThumbnailPhoto = 'C:\ThumbnailPhotos\ExampleUser.jpg'
        }
    }
}
