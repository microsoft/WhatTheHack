$script:resourceModulePath = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
$script:modulesFolderPath = Join-Path -Path $script:resourceModulePath -ChildPath 'Modules'

$script:localizationModulePath = Join-Path -Path $script:modulesFolderPath -ChildPath 'ActiveDirectoryDsc.Common'
Import-Module -Name (Join-Path -Path $script:localizationModulePath -ChildPath 'ActiveDirectoryDsc.Common.psm1')

$script:localizedData = Get-LocalizedData -ResourceName 'MSFT_ADDomainControllerProperties'

<#
    .SYNOPSIS
        Returns the current state of the properties of the domain controller.

    .PARAMETER IsSingleInstance
        Specifies the resource is a single instance, the value must be 'Yes'.
#>
function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance
    )

    Write-Verbose -Message (
        $script:localizedData.RetrievingProperties -f $env:COMPUTERNAME
    )

    $getTargetResourceReturnValue = @{
        IsSingleInstance = $IsSingleInstance
        ContentFreshness = 0
    }

    $getCimInstanceParameters = @{
        Namespace = 'ROOT/MicrosoftDfs'
        Query = 'select MaxOfflineTimeInDays from DfsrMachineConfig'
    }

    $getTargetResourceReturnValue['ContentFreshness'] = (Get-CimInstance @getCimInstanceParameters).MaxOfflineTimeInDays

    return $getTargetResourceReturnValue
}

<#
    .SYNOPSIS
        Determines if the properties are in the desired state.

    .PARAMETER IsSingleInstance
        Specifies the resource is a single instance, the value must be 'Yes'.

    .PARAMETER ContentFreshness
        Specifies the Distributed File System Replication (DFSR) server threshold
        after the number of days its content is considered stale (MaxOfflineTimeInDays)
        Once the content is considered stale, the Distributed File System Replication
        (DFSR) server will no longer be able to replicate.
#>
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.UInt32]
        $ContentFreshness
    )

    Write-Verbose -Message (
        $script:localizedData.TestConfiguration -f $env:COMPUTERNAME
    )

    $compareTargetResourceStateResult = Compare-TargetResourceState @PSBoundParameters

    if ($false -in $compareTargetResourceStateResult.InDesiredState)
    {
        Write-Verbose -Message $script:localizedData.DomainControllerNotInDesiredState

        $testTargetResourceReturnValue = $false
    }
    else
    {
        Write-Verbose -Message $script:localizedData.DomainControllerInDesiredState

        $testTargetResourceReturnValue = $true
    }

    return $testTargetResourceReturnValue
}

<#
    .SYNOPSIS
        Sets the properties on the Active Directory domain controller.

    .PARAMETER IsSingleInstance
        Specifies the resource is a single instance, the value must be 'Yes'.

    .PARAMETER ContentFreshness
        Specifies the Distributed File System Replication (DFSR) server threshold
        after the number of days its content is considered stale (MaxOfflineTimeInDays)
        Once the content is considered stale, the Distributed File System Replication
        (DFSR) server will no longer be able to replicate.
#>
function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.UInt32]
        $ContentFreshness
    )

    $compareTargetResourceStateResult = Compare-TargetResourceState @PSBoundParameters

    # Get all properties that are not in desired state.
    $propertiesNotInDesiredState = $compareTargetResourceStateResult | Where-Object -FilterScript {
        -not $_.InDesiredState
    }

    if ($propertiesNotInDesiredState.Where( { $_.ParameterName -eq 'ContentFreshness' }))
    {
        Write-Verbose -Message (
            $script:localizedData.ContentFreshnessUpdated -f $ContentFreshness
        )

        $setCimInstanceParameters = @{
            Namespace = 'ROOT/MicrosoftDfs'
            Query = 'select MaxOfflineTimeInDays from DfsrMachineConfig'
            Property = @{
                MaxOfflineTimeInDays = $ContentFreshness
            }

        }

        $null = Set-CimInstance @setCimInstanceParameters
    }
}

<#
    .SYNOPSIS
        Compares the properties in the current state with the properties of the
        desired state and returns a hashtable with the comparison result.

    .PARAMETER IsSingleInstance
        Specifies the resource is a single instance, the value must be 'Yes'.

    .PARAMETER ContentFreshness
        Specifies the Distributed File System Replication (DFSR) server threshold
        after the number of days its content is considered stale (MaxOfflineTimeInDays)
        Once the content is considered stale, the Distributed File System Replication
        (DFSR) server will no longer be able to replicate.
#>
function Compare-TargetResourceState
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.UInt32]
        $ContentFreshness
    )

    $getTargetResourceParameters = @{
        IsSingleInstance = $IsSingleInstance
    }

    $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters

    $compareTargetResourceStateParameters = @{
        CurrentValues = $getTargetResourceResult
        DesiredValues = $PSBoundParameters
        Properties    = @('ContentFreshness')
    }

    return Compare-ResourcePropertyState @compareTargetResourceStateParameters
}
