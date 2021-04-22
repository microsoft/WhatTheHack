<#PSScriptInfo
.VERSION 1.0
.GUID c096de91-61ee-41e9-917a-069c62b34d50
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
        This configuration will add full control (GenericAll) permissions to
        the virtual computer object (VCO) ROLE01 for a cluster name object (CNO)
        CONTOSO\CLUSTER01$. This is used so that the Windows Failover Cluster
        can control the roles AD objects.
#>
Configuration ADObjectPermissionEntry_DelegateFullControl_Config
{
    Import-DscResource -Module ActiveDirectoryDsc

    Node localhost
    {
        ADObjectPermissionEntry 'ADObjectPermissionEntry'
        {
            Ensure                             = 'Present'
            Path                               = 'CN=ROLE01,CN=Computers,DC=contoso,DC=com'
            IdentityReference                  = 'CONTOSO\CLUSTER01$'
            ActiveDirectoryRights              = 'GenericAll'
            AccessControlType                  = 'Allow'
            ObjectType                         = '00000000-0000-0000-0000-000000000000'
            ActiveDirectorySecurityInheritance = 'None'
            InheritedObjectType                = '00000000-0000-0000-0000-000000000000'
        }
    }
}
