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
        $Zone,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Target,

        [Parameter()]
        [ValidateSet('Present','Absent')]
        [System.String]
        $Ensure = 'Present'
    )
    Write-Warning -Message "DSC Resource xDnsARecord has been replaced by xDNSRecord, and will be removed in a future version"
    Write-Verbose "Looking up DNS record for $Name in $Zone"
    $record = Get-DnsServerResourceRecord -ZoneName $Zone -Name $Name -ErrorAction SilentlyContinue
    if ($null -eq $record)
    {
        return @{
            Name = $Name;
            Zone = $Zone;
            Target = $Target;
            Ensure = 'Absent';
        }
    }
    else {
        return @{
            Name = $record.HostName;
            Zone = $Zone;
            Target = $record.RecordData.IPv4Address.ToString();
            Ensure = 'Present';
        }
    }
}


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
        $Zone,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Target,

        [Parameter()]
        [ValidateSet('Present','Absent')]
        [System.String]
        $Ensure = 'Present'
    )
    if ($Ensure -eq 'Present')
    {
        Write-Verbose "Creating for DNS $Target in $Zone"
        Add-DnsServerResourceRecordA -IPv4Address $Target -Name $Name -ZoneName $Zone
    }
    elseif ($Ensure -eq 'Absent') {
        Write-Verbose "Removing DNS $Target in $Zone"
        Remove-DnsServerResourceRecord -Name $Name -ZoneName $Zone -RRType A
    }
}


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
        $Zone,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Target,

        [Parameter()]
        [ValidateSet('Present','Absent')]
        [System.String]
        $Ensure = 'Present'
    )

    Write-Verbose "Testing for DNS $Name in $Zone"
    $result = @(Get-TargetResource @PSBoundParameters)
    if ($Ensure -ne $result.Ensure)
    {
        return $false 
    }
    elseif ($Ensure -eq 'Present' -and ($result.Target -ne $Target)) 
    { 
        return $false 
    }
    return $true
}


Export-ModuleMember -Function *-TargetResource
