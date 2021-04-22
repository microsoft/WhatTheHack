# Import the Helper module
$modulePath = Join-Path -Path (Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent) -ChildPath 'Modules'
Import-Module -Name (Join-Path -Path $modulePath -ChildPath (Join-Path -Path Helper -ChildPath Helper.psm1))

<#

    .SYNOPSIS
        Get desired state

    .PARAMETER IsSingleInstance
        Key for the resource. This value must be set to 'Yes'

#>
function Get-TargetResource
{
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter(Mandatory = $true)]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        [AllowEmptyCollection()]
        $NameServer
    )

    Assert-Module -Name 'DNSServer'

    Write-Verbose 'Getting current root hints.'

    $result = @{
        IsSingleInstance = 'Yes'
        NameServer       = Convert-RootHintsToHashtable -RootHints @(Get-DnsServerRootHint)
    }

    Write-Verbose "Found $($result.Count) root hints"
    $result
}

<#

    .SYNOPSIS
        Set desired state

    .PARAMETER IsSingleInstance
        Key for the resource. This value must be set to 'Yes'

    .PARAMETER NameServer
        A list of names and IP addresses as a hashtable. This may look like this: NameServer = @{ 'rh1.vm.net.' = '20.1.1.1' }

#>
function Set-TargetResource
{
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter(Mandatory = $true)]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        [AllowEmptyCollection()]
        $NameServer
    )

    Write-Verbose -Message 'Removing all root hints.'
    Get-DnsServerRootHint | Remove-DnsServerRootHint -Force

    foreach ($item in $NameServer)
    {
        Write-Verbose "Adding root hint '$($item.Key)'."
        Add-DnsServerRootHint -NameServer $item.Key -IPAddress ($item.value -split ',' | ForEach-Object { $_.Trim() })
    }
}

<#

    .SYNOPSIS
        Test desired state

    .PARAMETER IsSingleInstance
        Key for the resource. This value must be set to 'Yes'

    .PARAMETER NameServer
        A list of names and IP addresses as a hashtable. This may look like this: NameServer = @{ 'rh1.vm.net.' = '20.1.1.1' }

#>
function Test-TargetResource
{
    [OutputType([Bool])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter(Mandatory = $true)]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        [AllowEmptyCollection()]
        $NameServer
    )

    Write-Verbose -Message 'Validating root hints.'
    $currentState = Get-TargetResource @PSBoundParameters
    $desiredState = $PSBoundParameters

    foreach ($entry in $desiredState.NameServer)
    {
        $entry.Value = $entry.Value -replace ' ', ''
    }

    $result = Test-DscParameterState -CurrentValues $currentState -DesiredValues $desiredState -TurnOffTypeChecking -ReverseCheck

    $result
}
