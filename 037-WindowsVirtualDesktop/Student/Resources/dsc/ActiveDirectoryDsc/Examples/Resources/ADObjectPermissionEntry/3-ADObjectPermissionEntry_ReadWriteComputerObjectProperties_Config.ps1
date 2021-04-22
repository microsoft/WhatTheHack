<#PSScriptInfo
.VERSION 1.0
.GUID 2b2ad944-0a4f-457e-b8ad-98e86767d77c
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
        This configuration will add a group permission to allow read and write
        (ReadProperty, WriteProperty) of all properties of computer objects in
        an OU and any sub-OUs that may get created.
#>
Configuration ADObjectPermissionEntry_ReadWriteComputerObjectProperties_Config
{
    Import-DscResource -Module ActiveDirectoryDsc

    Node localhost
    {
        ADObjectPermissionEntry 'ADObjectPermissionEntry'
        {
            Ensure                             = 'Present'
            Path                               = 'OU=ContosoComputers,DC=contoso,DC=com'
            IdentityReference                  = 'CONTOSO\ComputerAdminGroup'
            ActiveDirectoryRights              = 'ReadProperty', 'WriteProperty'
            AccessControlType                  = 'Allow'
            ObjectType                         = '00000000-0000-0000-0000-000000000000'
            ActiveDirectorySecurityInheritance = 'Descendents'
            InheritedObjectType                = 'bf967a86-0de6-11d0-a285-00aa003049e2' # Computer objects
        }
    }
}
