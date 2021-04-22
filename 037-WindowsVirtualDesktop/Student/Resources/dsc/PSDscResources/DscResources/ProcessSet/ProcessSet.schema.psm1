$errorActionPreference = 'Stop'
Set-StrictMode -Version 'Latest'

# Import ResourceSetHelper for New-ResourceSetConfigurationScriptBlock
$script:dscResourcesFolderFilePath = Split-Path -Path $PSScriptRoot -Parent
$script:resourceSetHelperFilePath = Join-Path -Path $script:dscResourcesFolderFilePath -ChildPath 'ResourceSetHelper.psm1'
Import-Module -Name $script:resourceSetHelperFilePath

<#
    .SYNOPSIS
        A composite DSC resource to configure a set of similar WindowsProcess resources.
        No arguments can be passed into these WindowsProcess resources.

    .DESCRIPTION
        A composite DSC resource to configure a set of similar WindowsProcess resources.

    .PARAMETER Path
        The file paths to the executables of the processes to start or stop. Only the names of the
        files may be specified if they are all accessible through the environment path. Relative
        paths are not supported.

    .PARAMETER Ensure
        Specifies whether or not the processes should exist.

        To start processes, set this property to Present.
        To stop processes, set this property to Absent.

    .PARAMETER Credential
        The credential of the user account to start the processes under.

    .PARAMETER StandardOutputPath
        The file path to write the standard output to. Any existing file at this path
        will be overwritten.This property cannot be specified at the same time as Credential
        when running the processes as a local user.

    .PARAMETER StandardErrorPath
        The file path to write the standard error output to. Any existing file at this path
        will be overwritten.

    .PARAMETER StandardInputPath
        The file path to get standard input from. This property cannot be specified at the
        same time as Credential when running the processes as a local user.

    .PARAMETER WorkingDirectory
        The file path to use as the working directory for the processes. Any existing file
        at this path will be overwritten. This property cannot be specified at the same time
        as Credential when running the processes as a local user.
#>
Configuration ProcessSet
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String[]]
        $Path,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $StandardOutputPath,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $StandardErrorPath,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $StandardInputPath,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $WorkingDirectory
    )

    $newResourceSetConfigurationParams = @{
        ResourceName = 'WindowsProcess'
        ModuleName = 'PSDscResources'
        KeyParameterName = 'Path'
        Parameters = $PSBoundParameters
    }

    # Arguments is a key parameter in WindowsProcess resource. Adding it as a common parameter with an empty value string
    $newResourceSetConfigurationParams['Parameters']['Arguments'] = ''

    $configurationScriptBlock = New-ResourceSetConfigurationScriptBlock @newResourceSetConfigurationParams

    # This script block must be run directly in this configuration in order to resolve variables
    . $configurationScriptBlock
}
