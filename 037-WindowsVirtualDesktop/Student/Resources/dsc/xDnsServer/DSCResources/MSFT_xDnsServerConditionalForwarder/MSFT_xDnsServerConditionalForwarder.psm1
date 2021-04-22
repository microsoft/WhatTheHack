<#
    .SYNOPSIS
        Get the state of a conditional forwarder.

    .DESCRIPTION
        xDnsServerConditionalForwarder can be used to manage the state of a single conditional forwarder.

    .PARAMETER Ensure
        Ensure whether the zone is absent or present.

    .PARAMETER Name
        The name of the zone to manage.

    .PARAMETER MasterServers
        The IP addresses the forwarder should use. Mandatory if Ensure is present.

    .PARAMETER ReplicationScope
        Whether the conditional forwarder should be replicated in AD, and the scope of that replication.

        Valid values are:

            * None: (file based / not replicated)
            * Custom: A user defined directory partition. DirectoryPartitionName is mandatory if Custom is set.
            * Domain: DomainDnsZones
            * Forest: ForestDnsZones
            * Legacy: The domain partition (defaultNamingContext).

    .PARAMETER DirectoryPartitionName
        The name of the directory partition to use when the ReplicationScope is Custom. This value is ignored for all other replication scopes.

#>
function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Name
    )

    $targetResource = @{
        Ensure                 = 'Absent'
        Name                   = $Name
        MasterServers          = $null
        ReplicationScope       = $null
        DirectoryPartitionName = $null
        ZoneType               = $null
    }

    $zone = Get-DnsServerZone -Name $Name -ErrorAction SilentlyContinue
    if ($zone)
    {
        Write-Verbose ($localizedData.FoundZone -f @(
            $zone.ZoneType
            $Name
        ))

        $targetResource.ZoneType = $zone.ZoneType
    }
    if ($zone -and $zone.ZoneType -eq 'Forwarder')
    {
        $targetResource.Ensure = 'Present'
        $targetResource.MasterServers = $zone.MasterServers

        if ($zone.IsDsIntegrated)
        {
            $targetResource.ReplicationScope = $zone.ReplicationScope
            $targetResource.DirectoryPartitionName = $zone.DirectoryPartitionName
        }
        else
        {
            $targetResource.ReplicationScope = 'None'
        }
    }
    else
    {
        Write-Verbose ($localizedData.CouldNotFindZone -f $Name)
    }

    $targetResource
}

<#
    .SYNOPSIS
        Set the state of a conditional forwarder.

    .DESCRIPTION
        xDnsServerConditionalForwarder can be used to manage the state of a single conditional forwarder.

    .PARAMETER Ensure
        Ensure whether the zone is absent or present.

    .PARAMETER Name
        The name of the zone to manage.

    .PARAMETER MasterServers
        The IP addresses the forwarder should use. Mandatory if Ensure is present.

    .PARAMETER ReplicationScope
        Whether the conditional forwarder should be replicated in AD, and the scope of that replication.

        Valid values are:

            * None: (file based / not replicated)
            * Custom: A user defined directory partition. DirectoryPartitionName is mandatory if Custom is set.
            * Domain: DomainDnsZones
            * Forest: ForestDnsZones
            * Legacy: The domain partition (defaultNamingContext).

    .PARAMETER DirectoryPartitionName
        The name of the directory partition to use when the ReplicationScope is Custom. This value is ignored for all other replication scopes.

#>
function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [ValidateSet('Absent', 'Present')]
        [String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [String]
        $Name,

        [Parameter()]
        [String[]]
        $MasterServers,

        [Parameter()]
        [ValidateSet('None', 'Custom', 'Domain', 'Forest', 'Legacy')]
        [String]
        $ReplicationScope = 'None',

        [Parameter()]
        [String]
        $DirectoryPartitionName
    )

    Test-DscDnsServerConditionalForwarderParameter

    $zone = Get-DnsServerZone -Name $Name -ErrorAction SilentlyContinue
    if ($Ensure -eq 'Present')
    {
        $params = @{
            Name          = $Name
            MasterServers = $MasterServers
        }

        if ($zone)
        {
            # File <--> DsIntegrated requires create and destroy
            if ($zone.ZoneType -ne 'Forwarder' -or
                ($zone.IsDsIntegrated -and $ReplicationScope -eq 'None') -or
                (-not $zone.IsDsIntegrated -and $ReplicationScope -ne 'None'))
            {
                Remove-DnsServerZone -Name $Name

                Write-Verbose ($localizedData.RecreateZone -f @(
                    $zone.ZoneType
                    $Name
                ))

                $zone = $null
            }
            else
            {
                if ("$($zone.MasterServers)" -ne "$MasterServers")
                {
                    Write-Verbose ($localizedData.UpdatingMasterServers -f @(
                        $Name
                        ($MasterServers -join ', ')
                    ))

                    $null = Set-DnsServerConditionalForwarderZone @params
                }
            }
        }

        $params = @{
            Name = $Name
        }
        if ($ReplicationScope -ne 'None')
        {
            $params.ReplicationScope = $ReplicationScope
        }
        if ($ReplicationScope -eq 'Custom' -and
            $DirectoryPartitionName -and
            $zone.DirectoryPartitionName -ne $DirectoryPartitionName)
        {
            $params.ReplicationScope = 'Custom'
            $params.DirectoryPartitionName = $DirectoryPartitionName
        }

        if ($zone)
        {
            if (($params.ReplicationScope -and $params.ReplicationScope -ne $zone.ReplicationScope) -or $params.DirectoryPartitionName)
            {
                Write-Verbose ($localizedData.MoveADZone -f @(
                    $Name
                    $ReplicationScope
                ))

                $null = Set-DnsServerConditionalForwarderZone @params
            }
        }
        else
        {
            Write-Verbose ($localizedData.NewZone -f $Name)

            $params.MasterServers = $MasterServers
            $null = Add-DnsServerConditionalForwarderZone @params
        }
    }
    elseif ($Ensure -eq 'Absent')
    {
        if ($zone -and $zone.ZoneType -eq 'Forwarder')
        {
            Write-Verbose ($localizedData.RemoveZone -f $Name)

            Remove-DnsServerZone -Name $Name
        }
    }
}

<#
    .SYNOPSIS
        Test the state of a conditional forwarder.

    .DESCRIPTION
        xDnsServerConditionalForwarder can be used to manage the state of a single conditional forwarder.

    .PARAMETER Ensure
        Ensure whether the zone is absent or present.

    .PARAMETER Name
        The name of the zone to manage.

    .PARAMETER MasterServers
        The IP addresses the forwarder should use. Mandatory if Ensure is present.

    .PARAMETER ReplicationScope
        Whether the conditional forwarder should be replicated in AD, and the scope of that replication.

        Valid values are:

            * None: (file based / not replicated)
            * Custom: A user defined directory partition. DirectoryPartitionName is mandatory if Custom is set.
            * Domain: DomainDnsZones
            * Forest: ForestDnsZones
            * Legacy: The domain partition (defaultNamingContext).

    .PARAMETER DirectoryPartitionName
        The name of the directory partition to use when the ReplicationScope is Custom. This value is ignored for all other replication scopes.

#>
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([Boolean])]
    param
    (
        [Parameter()]
        [ValidateSet('Absent', 'Present')]
        [String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [String]
        $Name,

        [Parameter()]
        [String[]]
        $MasterServers,

        [Parameter()]
        [ValidateSet('None', 'Custom', 'Domain', 'Forest', 'Legacy')]
        [String]
        $ReplicationScope = 'None',

        [Parameter()]
        [String]
        $DirectoryPartitionName
    )

    Test-DscDnsServerConditionalForwarderParameter

    $zone = Get-DnsServerZone -Name $Name -ErrorAction SilentlyContinue
    if ($Ensure -eq 'Present')
    {
        if (-not $zone)
        {
            Write-Verbose ($localizedData.ZoneDoesNotExist -f $Name)

            return $false
        }

        if ($zone.ZoneType -ne 'Forwarder')
        {
            Write-Verbose ($localizedData.IncorrectZoneType -f @(
                $Name
                $zone.ZoneType
            ))

            return $false
        }

        if ($zone.IsDsIntegrated -and $ReplicationScope -eq 'None')
        {
            Write-Verbose ($localizedData.ZoneIsDsIntegrated -f $Name)

            return $false
        }

        if (-not $zone.IsDsIntegrated -and $ReplicationScope -ne 'None')
        {
            Write-Verbose ($localizedData.ZoneIsFileBased -f $Name)

            return $false
        }

        if ($ReplicationScope -ne 'None' -and $zone.ReplicationScope -ne $ReplicationScope)
        {
            Write-Verbose ($localizedData.ReplicationScopeDoesNotMatch -f @(
                $Name
                $zone.ReplicationScope
                $ReplicationScope
            ))

            return $false
        }

        if ($ReplicationScope -eq 'Custom' -and $zone.DirectoryPartitionName -ne $DirectoryPartitionName)
        {
            Write-Verbose ($localizedData.DirectoryPartitionDoesNotMatch -f @(
                $Name
                $DirectoryPartitionName
            ))

            return $false
        }

        <#
            Compares two joined arrays. Arrays are joined using the output field separator.

            If the elements are not in the same order the configuration is considered to be different.

            Equivalent to Compare-Object -SyncWindow 0 without the need for null checking of reference or difference.

            Element order is considered important as it affects name resolution.

            https://support.microsoft.com/en-us/help/2834250/net-dns-forwarders-and-conditional-forwarders-resolution-timeouts
        #>
        if ("$($zone.MasterServers)" -ne "$MasterServers")
        {
            Write-Verbose ($localizedData.MasterServersDoNotMatch -f @(
                $Name
                ($MasterServers -join ', ')
                ($zone.MasterServers -join ', ')
            ))

            return $false
        }
    }
    elseif ($Ensure -eq 'Absent')
    {
        if ($zone -and $zone.ZoneType -eq 'Forwarder')
        {
            Write-Verbose ($localizedData.ZoneExists -f $Name)

            return $false
        }
    }

    return $true
}

function Test-DscDnsServerConditionalForwarderParameter
{
    <#
    .SYNOPSIS
        Tests the parameter combinations required by this resource.
    .DESCRIPTION
        Tests the parameter combinations required by this resource.
    #>

    [CmdletBinding()]
    param ()

    $invocationInfo = Get-Variable MyInvocation -Scope 1 -ValueOnly

    if (-not $invocationInfo.BoundParameters.ContainsKey('Ensure') -or $invocationInfo.BoundParameters['Ensure'] -eq 'Present')
    {
        if ($null -eq $invocationInfo.BoundParameters['MasterServers'] -or $invocationInfo.BoundParameters['MasterServers'].Count -eq 0)
        {
            $pscmdlet.ThrowTerminatingError((
                New-Object System.Management.Automation.ErrorRecord(
                    (New-Object System.ArgumentException($localizedData.MasterServersIsMandatory)),
                    'MasterServersIsMandatory',
                    'InvalidArgument',
                    $null
                )
            ))
        }

        if ($invocationInfo.BoundParameters['ReplicationScope'] -eq 'Custom' -and -not $invocationInfo.BoundParameters['DirectoryPartitionName'])
        {
            $pscmdlet.ThrowTerminatingError((
                New-Object System.Management.Automation.ErrorRecord(
                    (New-Object System.ArgumentException($localizedData.DirectoryPartitionNameIsMandatory)),
                    'DirectoryPartitionNameIsMandatory',
                    'InvalidArgument',
                    $null
                )
            ))
        }
    }
}

Import-LocalizedData -FileName MSFT_xDnsServerConditionalForwarder -BindingVariable localizedData -ErrorAction SilentlyContinue
