# Localized messages
data LocalizedData
{
    # culture="en-US"
    ConvertFrom-StringData @'
        GettingDnsServerZoneScopeMessage   = Getting DNS Server Zone Scope '{0}' in '{1}'.
        CreatingDnsServerZoneScopeMessage  = Creating DNS Server Zone Scope '{0}' in '{1}'.
        RemovingDnsServerZoneScopeMessage  = Removing DNS Server Zone Scope '{0}' from '{1}'.
        NotDesiredPropertyMessage = DNS Server Zone Scope property '{0}' is not correct. Expected '{1}', actual '{2}'
        InDesiredStateMessage     = DNS Server Zone Scope '{0}' is in the desired state.
        NotInDesiredStateMessage  = DNS Server Zone Scope '{0}' is NOT in the desired state.
'@
}

<#
    .SYNOPSIS
        This will return the current state of the resource.

    .PARAMETER Name
        Specifies the name of the Zone Scope.

    .PARAMETER ZoneName
        Specify the existing DNS Zone to add a scope to.
#>
function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ZoneName

    )

    Write-Verbose -Message ($LocalizedData.GettingDnsServerZoneScopeMessage -f $Name, $ZoneName)
    $record = Get-DnsServerZoneScope -Name $Name -ZoneName $ZoneName -ErrorAction SilentlyContinue

    if ($null -eq $record)
    {
        return @{
            Name     = $Name
            ZoneName = $ZoneName
            Ensure   = 'Absent'
        }
    }

    return @{
        Name     = $record.Name
        ZoneName = $record.ZoneName
        Ensure   = 'Present'
    }
} #end function Get-TargetResource

<#
    .SYNOPSIS
        This will configure the resource.

    .PARAMETER Name
        Specifies the name of the Zone Scope.

    .PARAMETER ZoneName
        Specify the existing DNS Zone to add a scope to.
#>
function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ZoneName,

        [Parameter()]
        [ValidateSet('Present','Absent')]
        [System.String]
        $Ensure = 'Present'
    )

    $clientSubnet = Get-DnsServerZoneScope -Name $Name -ZoneName $ZoneName -ErrorAction SilentlyContinue
    if ($Ensure -eq 'Present')
    {
        if (!$clientSubnet)
        {
            Write-Verbose -Message ($LocalizedData.CreatingDnsServerZoneScopeMessage -f $Name, $ZoneName)
            Add-DnsServerZoneScope -ZoneName $ZoneName -Name $Name
        }
    }
    elseif ($Ensure -eq 'Absent')
    {
        Write-Verbose -Message ($LocalizedData.RemovingDnsServerZoneScopeMessage -f $Name, $ZoneName)
        Remove-DnsServerZoneScope -Name $Name -ZoneName $ZoneName
    }
} #end function Set-TargetResource

<#
    .SYNOPSIS
        This will return whether the resource is in desired state.

    .PARAMETER Name
        Specifies the name of the Zone Scope.

    .PARAMETER ZoneName
        Specify the existing DNS Zone to add a scope to.
#>
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ZoneName,

        [Parameter()]
        [ValidateSet('Present','Absent')]
        [System.String]
        $Ensure = 'Present'
    )

    $result = Get-TargetResource -Name $Name -ZoneName $ZoneName

    if ($Ensure -ne $result.Ensure)
    {
        Write-Verbose -Message ($LocalizedData.NotDesiredPropertyMessage -f 'Ensure', $Ensure, $result.Ensure)
        Write-Verbose -Message ($LocalizedData.NotInDesiredStateMessage -f $Name)
        return $false
    }

    Write-Verbose -Message ($LocalizedData.InDesiredStateMessage -f $Name)
    return $true
} #end function Test-TargetResource

Export-ModuleMember -Function *-TargetResource
