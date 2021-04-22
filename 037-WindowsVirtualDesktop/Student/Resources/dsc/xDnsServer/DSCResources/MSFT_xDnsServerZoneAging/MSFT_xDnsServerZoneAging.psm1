<#
    .SYNOPSIS
        Get the DNS zone aging settings.

    .PARAMETER Name
        Name of the DNS forward or reverse loookup zone.

    .PARAMETER Enabled
        Option to enable scavenge stale resource records on the zone.
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
        [System.Boolean]
        $Enabled
    )

    Write-Verbose -Message "Getting the DNS zone aging for $Name."

    # Get the current zone aging from the local DNS server
    $zoneAging = Get-DnsServerZoneAging -Name $Name

    return @{
        Name              = $Name
        Enabled           = $zoneAging.AgingEnabled
        RefreshInterval   = $zoneAging.RefreshInterval.TotalHours
        NoRefreshInterval = $zoneAging.NoRefreshInterval.TotalHours
    }
}

<#
    .SYNOPSIS
        Set the DNS zone aging settings.

    .PARAMETER Name
        Name of the DNS forward or reverse loookup zone.

    .PARAMETER Enabled
        Option to enable scavenge stale resource records on the zone.

    .PARAMETER RefreshInterval
        Refresh interval for record scavencing in hours. Default value is 7 days.

    .PARAMETER NoRefreshInterval
        No-refresh interval for record scavencing in hours. Default value is 7 days.
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
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.UInt32]
        $RefreshInterval = 168,

        [Parameter()]
        [System.UInt32]
        $NoRefreshInterval = 168
    )

    $currentConfiguration = Get-TargetResource -Name $Name -Enabled $Enabled

    # Enable or disable zone aging
    if ($currentConfiguration.Enabled -ne $Enabled)
    {
        if ($Enabled)
        {
            Write-Verbose -Message "Enable DNS zone aging on $Name."
        }
        else
        {
            Write-Verbose -Message "Disable DNS zone aging on $Name."
        }

        Set-DnsServerZoneAging -Name $Name -Aging $Enabled -WarningAction 'SilentlyContinue'
    }

    # Update the refresh interval
    if ($PSBoundParameters.ContainsKey('RefreshInterval'))
    {
        if ($currentConfiguration.RefreshInterval -ne $RefreshInterval)
        {
            Write-Verbose -Message "Set DNS zone refresh interval to $RefreshInterval hours."

            $refreshIntervalTimespan = [System.TimeSpan]::FromHours($RefreshInterval)

            <#
                Hide the following warning if aging is not enabled: Specified
                parameters related to aging of records have been set. However,
                aging was not enabled and hence the settings are ineffective.
            #>
            Set-DnsServerZoneAging -Name $Name -RefreshInterval $refreshIntervalTimespan -WarningAction 'SilentlyContinue'
        }
    }

    # Update the no refresh interval
    if ($PSBoundParameters.ContainsKey('NoRefreshInterval'))
    {
        if ($currentConfiguration.NoRefreshInterval -ne $NoRefreshInterval)
        {
            Write-Verbose -Message "Set DNS zone no refresh interval to $NoRefreshInterval hours."

            $noRefreshIntervalTimespan = [System.TimeSpan]::FromHours($NoRefreshInterval)

            <#
                Hide the following warning if aging is not enabled: Specified
                parameters related to aging of records have been set. However,
                aging was not enabled and hence the settings are ineffective.
            #>
            Set-DnsServerZoneAging -Name $Name -NoRefreshInterval $noRefreshIntervalTimespan -WarningAction 'SilentlyContinue'
        }
    }
}

<#
    .SYNOPSIS
        Test the DNS zone aging settings.

    .PARAMETER Name
        Name of the DNS forward or reverse loookup zone.

    .PARAMETER Enabled
        Option to enable scavenge stale resource records on the zone.

    .PARAMETER RefreshInterval
        Refresh interval for record scavencing in hours. Default value is 7 days.

    .PARAMETER NoRefreshInterval
        No-refresh interval for record scavencing in hours. Default value is 7 days.
#>
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.UInt32]
        $RefreshInterval = 168,

        [Parameter()]
        [System.UInt32]
        $NoRefreshInterval = 168
    )

    Write-Verbose -Message "Testing the DNS zone aging for $Name."

    $currentConfiguration = Get-TargetResource -Name $Name -Enabled $Enabled

    $isDesiredState = $currentConfiguration.Enabled -eq $Enabled

    if ($PSBoundParameters.ContainsKey('RefreshInterval'))
    {
        $isDesiredState = $isDesiredState -and $currentConfiguration.RefreshInterval -eq $RefreshInterval
    }

    if ($PSBoundParameters.ContainsKey('NoRefreshInterval'))
    {
        $isDesiredState = $isDesiredState -and $currentConfiguration.NoRefreshInterval -eq $NoRefreshInterval
    }

    return $isDesiredState
}
