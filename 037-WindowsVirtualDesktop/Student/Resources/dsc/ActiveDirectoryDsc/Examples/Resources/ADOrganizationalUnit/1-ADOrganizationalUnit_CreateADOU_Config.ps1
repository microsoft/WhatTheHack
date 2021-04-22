<#PSScriptInfo
.VERSION 1.0
.GUID e7ed876c-7a6b-46d7-bb89-8288680c1691
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
        This configuration will add an Active Directory organizational unit to the
        domain.
#>
Configuration ADOrganizationalUnit_CreateADOU_Config
{
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Path,

        [Parameter()]
        [System.Boolean]
        $ProtectedFromAccidentalDeletion = $true,

        [Parameter()]
        [ValidateNotNull()]
        [System.String]
        $Description = ''
    )

    Import-DscResource -Module ActiveDirectoryDsc

    Node localhost
    {
        ADOrganizationalUnit 'ExampleOU'
        {
            Name                            = $Name
            Path                            = $Path
            ProtectedFromAccidentalDeletion = $ProtectedFromAccidentalDeletion
            Description                     = $Description
            Ensure                          = 'Present'
        }
    }
}
