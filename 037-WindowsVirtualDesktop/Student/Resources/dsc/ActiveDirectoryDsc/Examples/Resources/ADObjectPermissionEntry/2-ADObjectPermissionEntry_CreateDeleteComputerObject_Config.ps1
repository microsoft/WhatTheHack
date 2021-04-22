<#PSScriptInfo
.VERSION 1.0
.GUID cb962ab5-6694-43a7-a207-425c23682995
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
        This configuration will add a group permission to create and delete
        (CreateChild,DeleteChild) computer objects in an OU and any sub-OUs that
        may get created.
#>
Configuration ADObjectPermissionEntry_CreateDeleteComputerObject_Config
{
    Import-DscResource -Module ActiveDirectoryDsc

    Node localhost
    {
        ADObjectPermissionEntry 'ADObjectPermissionEntry'
        {
            Ensure                             = 'Present'
            Path                               = 'OU=ContosoComputers,DC=contoso,DC=com'
            IdentityReference                  = 'CONTOSO\ComputerAdminGroup'
            ActiveDirectoryRights              = 'CreateChild', 'DeleteChild'
            AccessControlType                  = 'Allow'
            ObjectType                         = 'bf967a86-0de6-11d0-a285-00aa003049e2' # Computer objects
            ActiveDirectorySecurityInheritance = 'All'
            InheritedObjectType                = '00000000-0000-0000-0000-000000000000'
        }
    }
}
