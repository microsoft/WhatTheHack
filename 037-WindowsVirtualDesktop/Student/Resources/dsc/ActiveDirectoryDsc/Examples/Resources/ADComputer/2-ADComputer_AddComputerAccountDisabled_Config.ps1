<#PSScriptInfo
.VERSION 1.0.0
.GUID 6c3b8deb-2fdb-4d81-b74d-81dbfe86fcd7
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
.RELEASENOTES First version.
.PRIVATEDATA 2016-Datacenter,2016-Datacenter-Server-Core
#>

#Requires -module ActiveDirectoryDsc

<#
    .DESCRIPTION
        This configuration will create an Active Directory computer account
        disabled. The property Enabled will not be enforced.
#>
Configuration ADComputer_AddComputerAccountDisabled_Config
{
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    Import-DscResource -ModuleName ActiveDirectoryDsc

    node localhost
    {
        ADComputer 'CreateDisabled'
        {
            ComputerName      = 'CLU_CNO01'
            EnabledOnCreation = $false

            PsDscRunAsCredential = $Credential
        }
    }
}
