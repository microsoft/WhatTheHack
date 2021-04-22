$errorActionPreference = 'Stop'
Set-StrictMode -Version 'Latest'

# Import CommonResourceHelper for Get-LocalizedData
$script:dscResourcesFolderFilePath = Split-Path $PSScriptRoot -Parent
$script:commonResourceHelperFilePath = Join-Path -Path $script:dscResourcesFolderFilePath -ChildPath 'CommonResourceHelper.psm1'
Import-Module -Name $script:commonResourceHelperFilePath

# Localized messages for verbose and error statements in this resource
$script:localizedData = Get-LocalizedData -ResourceName 'MSFT_ScriptResource'

<#
    .SYNOPSIS
        Runs the given get script.
        Should return a hashtable.

    .PARAMETER GetScript
        The script to retrieve the current state of the resource.

    .PARAMETER SetScript
        Not used in Get-TargetResource.

    .PARAMETER TestScript
        Not used in Get-TargetResource.

    .PARAMETER Credential
        The Credential to run the get script under if needed.
#>
function Get-TargetResource
{
    [OutputType([System.Collections.Hashtable])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $GetScript,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $SetScript,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $TestScript,

        [Parameter()]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )

    Write-Verbose -Message $script:localizedData.GetTargetResourceStartVerboseMessage

    $invokeScriptParameters = @{
        ScriptBlock = [System.Management.Automation.ScriptBlock]::Create($GetScript)
    }

    if ($PSBoundParameters.ContainsKey('Credential'))
    {
        $invokeScriptParameters['Credential'] = $Credential
    }

    $invokeScriptResult = Invoke-Script @invokeScriptParameters

    if ($invokeScriptResult -is [System.Management.Automation.ErrorRecord])
    {
        New-InvalidOperationException -Message $script:localizedData.GetScriptThrewError -ErrorRecord $invokeScriptResult
    }

    $invokeScriptResultAsHashTable = $invokeScriptResult -as [System.Collections.Hashtable]

    if ($null -eq $invokeScriptResultAsHashTable)
    {
        New-InvalidArgumentException -ArgumentName 'TestScript' -Message $script:localizedData.GetScriptDidNotReturnHashtable
    }

    Write-Verbose -Message $script:localizedData.GetTargetResourceEndVerboseMessage

    return $invokeScriptResultAsHashTable
}

<#
    .SYNOPSIS
        Runs the given set script.
        Should not return.

    .PARAMETER GetScript
        Not used in Set-TargetResource.

    .PARAMETER SetScript
        The script to set the resource to the desired state.

    .PARAMETER TestScript
        Not used in Set-TargetResource.

    .PARAMETER Credential
        The Credential to run the set script under if needed.
#>
function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $GetScript,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $SetScript,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $TestScript,

        [Parameter()]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )

    Write-Verbose -Message $script:localizedData.SetTargetResourceStartVerboseMessage

    $invokeScriptParameters = @{
        ScriptBlock = [System.Management.Automation.ScriptBlock]::Create($SetScript)
    }

    if ($PSBoundParameters.ContainsKey('Credential'))
    {
        $invokeScriptParameters['Credential'] = $Credential
    }

    $invokeScriptResult = Invoke-Script @invokeScriptParameters

    if ($invokeScriptResult -is [System.Management.Automation.ErrorRecord])
    {
        New-InvalidOperationException -Message $script:localizedData.SetScriptThrewError -ErrorRecord $invokeScriptResult
    }

    Write-Verbose -Message $script:localizedData.SetTargetResourceEndVerboseMessage
}

<#
    .SYNOPSIS
        Runs the given test script.
        Should return true if the resource is in the desired state and false otherwise.

    .PARAMETER GetScript
        Not used in Test-TargetResource.

    .PARAMETER SetScript
        Not used in Test-TargetResource.

    .PARAMETER TestScript
        The script to validate whether or not the resource is in the desired state.

    .PARAMETER Credential
        The Credential to run the test script under if needed.
#>
function Test-TargetResource
{
    [OutputType([System.Boolean])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $GetScript,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $SetScript,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $TestScript,

        [Parameter()]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )

    Write-Verbose -Message $script:localizedData.TestTargetResourceStartVerboseMessage

    $invokeScriptParameters = @{
        ScriptBlock = [System.Management.Automation.ScriptBlock]::Create($TestScript)
    }

    if ($PSBoundParameters.ContainsKey('Credential'))
    {
        $invokeScriptParameters['Credential'] = $Credential
    }

    $invokeScriptResult = Invoke-Script @invokeScriptParameters

    # If the script is returing multiple objects, then we consider the last object to be the result of the script execution.
    if ($invokeScriptResult -is [System.Object[]] -and $invokeScriptResult.Count -gt 0)
    {
        $invokeScriptResult = $invokeScriptResult[$invokeScriptResult.Count - 1]
    }

    if ($invokeScriptResult -is [System.Management.Automation.ErrorRecord])
    {
        New-InvalidOperationException -Message $script:localizedData.TestScriptThrewError -ErrorRecord $invokeScriptResult
    }

    if ($null -eq $invokeScriptResult -or -not ($invokeScriptResult -is [System.Boolean]))
    {
        New-InvalidArgumentException -ArgumentName 'TestScript' -Message $script:localizedData.TestScriptDidNotReturnBoolean
    }

    Write-Verbose -Message $script:localizedData.TestTargetResourceEndVerboseMessage

    return $invokeScriptResult
}

<#
    .SYNOPSIS
        Invokes the given script block.

        The output of the script will be returned unless the script throws an error.
        If the script throws an error, the ErrorRecord will be returned rather than thrown.

    .PARAMETER ScriptBlock
        The script block to invoke.

    .PARAMETER Credential
        The credential to run the script under if needed.
#>
function Invoke-Script
{
    [OutputType([System.Object])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.ScriptBlock]
        $ScriptBlock,

        [Parameter()]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )

    $scriptResult = $null

    try
    {
        Write-Verbose -Message ($script:localizedData.ExecutingScriptMessage -f $ScriptBlock)

        if ($null -ne $Credential)
        {
            $scriptResult = Invoke-Command -ScriptBlock $ScriptBlock -Credential $Credential -ComputerName .
        }
        else
        {
            $scriptResult = & $ScriptBlock
        }
    }
    catch
    {
        # Surfacing the error thrown by the execution of the script
        $scriptResult = $_
    }

    return $scriptResult
}
