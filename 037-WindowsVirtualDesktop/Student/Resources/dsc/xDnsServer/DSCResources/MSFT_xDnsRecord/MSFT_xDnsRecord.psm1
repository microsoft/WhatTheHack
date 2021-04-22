# Localized messages
data LocalizedData
{
    # culture="en-US"
    ConvertFrom-StringData @'
        GettingDnsRecordMessage   = Getting DNS record '{0}' ({1}) in zone '{2}', from '{3}'.
        CreatingDnsRecordMessage  = Creating DNS record '{0}' for target '{1}' in zone '{2}' on '{3}'.
        RemovingDnsRecordMessage  = Removing DNS record '{0}' for target '{1}' in zone '{2}' on '{3}'.
        NotDesiredPropertyMessage = DNS record property '{0}' is not correct. Expected '{1}', actual '{2}'
        InDesiredStateMessage     = DNS record '{0}' is in the desired state.
        NotInDesiredStateMessage  = DNS record '{0}' is NOT in the desired state.
'@
}

<#
    .SYNOPSIS
        This will return the current state of the resource.

    .PARAMETER Name
        Specifies the name of the DNS server resource record object.

    .PARAMETER Zone
        Specifies the name of a DNS zone.

    .PARAMETER Type
        Specifies the type of DNS record.

    .PARAMETER Target
        Specifies the Target Hostname or IP Address.

    .PARAMETER DnsServer
        Name of the DnsServer to create the record on.

    .PARAMETER Ensure
        Whether the host record should be present or removed.
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
        $Zone,

        [Parameter(Mandatory = $true)]
        [ValidateSet("ARecord", "CName", "Ptr")]
        [System.String]
        $Type,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Target,

        [Parameter()]
        [System.String]
        $DnsServer = "localhost",

        [Parameter()]
        [ValidateSet('Present','Absent')]
        [System.String]
        $Ensure = 'Present'
    )

    Write-Verbose -Message ($LocalizedData.GettingDnsRecordMessage -f $Name, $Type, $Zone, $DnsServer)
    $record = Get-DnsServerResourceRecord -ZoneName $Zone -Name $Name -ComputerName $DnsServer -ErrorAction SilentlyContinue
    
    if ($null -eq $record)
    {
        return @{
            Name = $Name.HostName;
            Zone = $Zone;
            Target = $Target;
            DnsServer = $DnsServer
            Ensure = 'Absent';
        }
    }
    if ($Type -eq "CName") 
    {
        $recordData = ($record.RecordData.hostnamealias).TrimEnd('.')
    }
    if ($Type -eq "ARecord") 
    {
        $recordData = $record.RecordData.IPv4address.IPAddressToString
    }
    if ($Type -eq "PTR") 
    {
        $recordData = ($record.RecordData.PtrDomainName).TrimEnd('.')
    }

    return @{
        Name = $record.HostName;
        Zone = $Zone;
        Target = $recordData;
        DnsServer = $DnsServer
        Ensure = 'Present';
    }
} #end function Get-TargetResource

<#
    .SYNOPSIS
        This will set the resource to the desired state.

    .PARAMETER Name
        Specifies the name of the DNS server resource record object.

    .PARAMETER Zone
        Specifies the name of a DNS zone.

    .PARAMETER Type
        Specifies the type of DNS record.

    .PARAMETER Target
        Specifies the Target Hostname or IP Address.

    .PARAMETER DnsServer
        Name of the DnsServer to create the record on.

    .PARAMETER Ensure
        Whether the host record should be present or removed.
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
        $Zone,

        [Parameter(Mandatory = $true)]
        [ValidateSet("ARecord", "CName", "Ptr")]
        [System.String]
        $Type,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Target,

        [Parameter()]
        [System.String]
        $DnsServer = "localhost",

        [Parameter()]
        [ValidateSet('Present','Absent')]
        [System.String]
        $Ensure = 'Present'
    )

    $DNSParameters = @{ Name = $Name; ZoneName = $Zone; ComputerName = $DnsServer; } 

    if ($Ensure -eq 'Present')
    {
        if ($Type -eq "ARecord")
        {
            $DNSParameters.Add('A',$true)
            $DNSParameters.Add('IPv4Address',$target)
        }
        if ($Type -eq "CName")
        {
            $DNSParameters.Add('CName',$true)
            $DNSParameters.Add('HostNameAlias',$Target)
        }
        if ($Type -eq "PTR")
        {
            $DNSParameters.Add('Ptr',$true)
            $DNSParameters.Add('PtrDomainName',$Target)
        }

        Write-Verbose -Message ($LocalizedData.CreatingDnsRecordMessage -f $Type, $Target, $Zone, $DnsServer)
        Add-DnsServerResourceRecord @DNSParameters
    }
    elseif ($Ensure -eq 'Absent')
    {
        $DNSParameters.Add('Force',$true)

        if ($Type -eq "ARecord")
        {
            $DNSParameters.Add('RRType','A')
        }
        if ($Type -eq "CName")
        {
            $DNSParameters.Add('RRType','CName')
        }
        if ($Type -eq "PTR")
        {
            $DNSParameters.Add('RRType','Ptr')
        }
        Write-Verbose -Message ($LocalizedData.RemovingDnsRecordMessage -f $Type, $Target, $Zone, $DnsServer)
        Remove-DnsServerResourceRecord @DNSParameters
    }
} #end function Set-TargetResource

<#
    .SYNOPSIS
        This will return whether the resource is in desired state.

    .PARAMETER Name
        Specifies the name of the DNS server resource record object.

    .PARAMETER Zone
        Specifies the name of a DNS zone.

    .PARAMETER Type
        Specifies the type of DNS record.

    .PARAMETER Target
        Specifies the Target Hostname or IP Address.

    .PARAMETER DnsServer
        Name of the DnsServer to create the record on.

    .PARAMETER Ensure
        Whether the host record should be present or removed.
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
        $Zone,

        [Parameter(Mandatory = $true)]
        [ValidateSet("ARecord", "CName", "Ptr")]
        [System.String]
        $Type,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Target,

        [Parameter()]
        [System.String]
        $DnsServer = "localhost",

        [Parameter()]
        [ValidateSet('Present','Absent')]
        [System.String]
        $Ensure = 'Present'
    )

    $result = @(Get-TargetResource @PSBoundParameters)
    if ($Ensure -ne $result.Ensure)
    {
        Write-Verbose -Message ($LocalizedData.NotDesiredPropertyMessage -f 'Ensure', $Ensure, $result.Ensure)
        Write-Verbose -Message ($LocalizedData.NotInDesiredStateMessage -f $Name)
        return $false
    }
    elseif ($Ensure -eq 'Present')
    {
        if ($result.Target -notcontains $Target)
        {
            $resultTargetString = $result.Target
            if ($resultTargetString -is [System.Array])
            {
                ## We have an array, create a single string for verbose output
                $resultTargetString = $result.Target -join ','
            }
            Write-Verbose -Message ($LocalizedData.NotDesiredPropertyMessage -f 'Target', $Target, $resultTargetString)
            Write-Verbose -Message ($LocalizedData.NotInDesiredStateMessage -f $Name)
            return $false
        }
    }
    Write-Verbose -Message ($LocalizedData.InDesiredStateMessage -f $Name)
    return $true
} #end function Test-TargetResource

Export-ModuleMember -Function *-TargetResource
