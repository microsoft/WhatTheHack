# Name: DnsServer
# Version: 2.0.0.0
# CreatedOn: 2017-11-16 11:18:28Z

function Export-DnsServerTrustAnchor {
    <#
    .SYNOPSIS
        Exports DS and DNSKEY information for a DNSSEC-signed zone.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER ZoneName
        Specifies the name of the primary zone for which the cmdlet exports the signing keys.
    .PARAMETER Path
        Specifies the absolute path that the cmdlet uses to place the keyset file. The cmdlet automatically names the file according to the zone name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER UnAuthenticated
        Indicates that an unauthenticated user is running this cmdlet. The provider DNS server queries for the DS or DNSKEY information and exports the required data even if you do not have permissions to run the cmdlet on the remote DNS server.
    .PARAMETER Force
        Exports the signing key without prompting you for confirmation. By default, the cmdlet prompts you for confirmation before it proceeds.
    .PARAMETER NoClobber
        Specifies that the export operation does not overwrite an existing export file that has the same name.
    .PARAMETER DigestType
        Specifies an array of algorithms that the zone signing key uses to create the DS record. The acceptable values for this parameter are:
        -- Sha1
        -- Sha256
        -- Sha384
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='DnsKey', SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    param (
        [Parameter(ParameterSetName='DS')]
        [Parameter(ParameterSetName='DnsKey')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='DS', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='DnsKey', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('TrustPointName','TrustAnchorName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='DS', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='DnsKey', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Path},

        [Parameter(ParameterSetName='DS')]
        [Parameter(ParameterSetName='DnsKey')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='DS')]
        [Parameter(ParameterSetName='DnsKey')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${UnAuthenticated},

        [Parameter(ParameterSetName='DS')]
        [Parameter(ParameterSetName='DnsKey')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='DS')]
        [Parameter(ParameterSetName='DnsKey')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${NoClobber},

        [Parameter(ParameterSetName='DS', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('Sha1','Sha256','Sha384')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string[]]
        ${DigestType},

        [Parameter(ParameterSetName='DS')]
        [Parameter(ParameterSetName='DnsKey')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='DS')]
        [Parameter(ParameterSetName='DnsKey')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='DS')]
        [Parameter(ParameterSetName='DnsKey')]
        [switch]
        ${AsJob}
    )
}

function Get-DnsServerRRL {
    <#
    .SYNOPSIS
        Displays the RRL settings on a DNS server.
    .PARAMETER ComputerName
        Specifies a remote DNS server on which to run the command. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NetBIOS name.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResponseRateLimiting')]
    param (
        [Parameter(ParameterSetName='Get0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Get0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Get0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Get0')]
        [switch]
        ${AsJob}
    )
}

function Set-DnsServerRRL {
    <#
    .SYNOPSIS
        Enables RRL on a DNS server.
    .PARAMETER ResponsesPerSec
        Specifies the maximum number of times that the server sends a client the same response within a one-second interval.
    .PARAMETER ErrorsPerSec
        Specifies the maximum number of times that the server can send an error response to a client within a one-second interval. The error responses include: REFUSED, FORMERR and SERVFAIL
    .PARAMETER WindowInSec
        Specifies the period (in seconds) over which rates are measured and averaged for RRL. RRL is applied if queries from same subnet, resulting in same response, occur more frequently than expected in a specified time window. The default value is 5.
    .PARAMETER IPv4PrefixLength
        Specifies the IPv4 prefix length, which indicates the size of the subnet in which the incoming queries are grouped. The server applies RRL if queries resulting in the same response occur more frequently than expected in a specified time window. The default value of this parameter is 24.
    .PARAMETER IPv6PrefixLength
        Specifies the IPv6 prefix length, which indicates the size of the IPv6 subnet in which the incoming queries are grouped. The server applies RRL if queries resulting in the same response occur more frequently than expected in a specified time window. The default value of this parameter is 56.
    .PARAMETER LeakRate
        Specifies the rate at which the server responds to dropped queries. For queries that meet criteria to be dropped due to RRL, the DNS server still responds once per LeakRate queries. For example, if LeakRate is 3, the server responds to one in every 3 queries. The allowed range for LeakRate is 2 to 10. If LeakRate is set to zero, then no responses are 'leaked' by RRL. LeakRate leaves a chance for the victims in the same subnet as the forged IP address to get responses to their valid queries. The default value for LeakRate is 3.
    .PARAMETER ResetToDefault
        Indicates that this cmdlet sets all the RRL settings to their default values.
    .PARAMETER TruncateRate
        Specifies the rate at which the server responds with truncated responses. For queries that meet the criteria to be dropped due to RRL, the DNS server still responds with truncated responses once per TruncateRate queries. For example, if TruncateRate is 2, one in every 2 queries receives a truncated response. The TruncateRate parameter provides the valid clients a way to reconnect using TCP. The allowed range for TruncateRate is 2 to 10. If it is set to 0, then this behaviour is disabled. The default value is 2.
    .PARAMETER Mode
        Specifies the state of RRL on the DNS server. The acceptable values for this parameter are: Enable, or Disable, or LogOnly. If the mode is set to LogOnly the DNS server performs all the RRL calculations but instead of taking the preventive actions (dropping or truncating responses), it only logs the potential actions as if RRL were enabled and continues with the normal responses. The default value is Enable.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NetBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER Force
        Forces the command to run without asking for user confirmation.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResponseRateLimiting')]
    param (
        [Parameter(ParameterSetName='SetDnsServerRRL1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${ResponsesPerSec},

        [Parameter(ParameterSetName='SetDnsServerRRL1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${ErrorsPerSec},

        [Parameter(ParameterSetName='SetDnsServerRRL1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${WindowInSec},

        [Parameter(ParameterSetName='SetDnsServerRRL1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${IPv4PrefixLength},

        [Parameter(ParameterSetName='SetDnsServerRRL1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${IPv6PrefixLength},

        [Parameter(ParameterSetName='SetDnsServerRRL1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${LeakRate},

        [Parameter(ParameterSetName='SetDnsServerRRL1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${ResetToDefault},

        [Parameter(ParameterSetName='SetDnsServerRRL1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${TruncateRate},

        [Parameter(ParameterSetName='SetDnsServerRRL1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${MaximumResponsesPerWindow},

        [Parameter(ParameterSetName='SetDnsServerRRL1', ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('LogOnly','Enable','Disable')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Mode},

        [Parameter(ParameterSetName='SetDnsServerRRL1')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='SetDnsServerRRL1')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='SetDnsServerRRL1')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='SetDnsServerRRL1')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='SetDnsServerRRL1')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='SetDnsServerRRL1')]
        [switch]
        ${AsJob}
    )
}

function Add-DnsServerClientSubnet {
    <#
    .SYNOPSIS
        Adds a client subnet to a DNS server.
    .PARAMETER Name
        Species the name of the new client subnet.
    .PARAMETER IPv4Subnet
        Specifies an array of IPv4 subnet addresses in Classless Interdomain Routing (CIDR) notation.
    .PARAMETER IPv6Subnet
        Specifies an array of IPv6 subnet addresses in CIDR notation.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerClientSubnet')]
    param (
        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Add0', Position=2, ValueFromPipelineByPropertyName=$true)]
        [string[]]
        ${IPv4Subnet},

        [Parameter(ParameterSetName='Add0', Position=3, ValueFromPipelineByPropertyName=$true)]
        [string[]]
        ${IPv6Subnet},

        [Parameter(ParameterSetName='Add0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Add0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Add0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Add0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Add0')]
        [switch]
        ${AsJob}
    )
}

function Add-DnsServerConditionalForwarderZone {
    <#
    .SYNOPSIS
        Adds a conditional forwarder to a DNS server.
    .PARAMETER LoadExisting
        Indicates that the server loads existing data for the forwarder from the registry. Conditional forwarders are internally stored as zones. This parameter is not valid for Active Directory-integrated zones.
    .PARAMETER MasterServers
        Specifies an array of IP addresses of the master servers of the zone. DNS queries for a forwarded zone are sent to master servers. You can use both IPv4 and IPv6 addresses. You must specify at least one master server.
    .PARAMETER ComputerName
        Specifies the DNS server. The cmdlet adds the forwarder to this server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER UseRecursion
        Specifies whether a DNS server attempts to resolve a query after the forwarder fails to resolve it. A value of $False prevents a DNS server from attempting resolution using other DNS servers. This parameter overrides the Use Recursion setting for a DNS server.
    .PARAMETER ForwarderTimeout
        Specifies a length of time, in seconds, that a DNS server waits for a master server to resolve a query. If a server does not resolve the request, the next server in the list is queried until all master servers are queried. After this period, the DNS server can attempt to resolve the query itself. This parameter applies only to the forwarder zone. The minimum value is 0. The maximum value is 15.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER DirectoryPartitionName
        Specifies a directory partition on which to store the forwarder. Conditional forwarders are internally stored as zones. Use this parameter when the ReplicationScope parameter has a value of Custom.
    .PARAMETER ReplicationScope
        Specifies the replication scope for the conditional forwarder. Conditional forwarders are stored internally as zones. The acceptable values for this parameter are:
        -- Custom. Replicate the conditional forwarder to all DNS servers running on domain controllers enlisted in a custom directory partition.
        -- Domain. Replicate the conditional forwarder to all DNS servers that run on domain controllers in the domain.
        -- Forest. Replicate the conditional forwarder to all DNS servers that run on domain controllers in the forest.
        -- Legacy. Replicate the conditional forwarder to all domain controllers in the domain.
    .PARAMETER Name
        Specifies the name of a zone. The cmdlet adds a conditional forwarder for this zone.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='FileForwardLookupZone', SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerConditionalForwarderZone')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerConditionalForwarderZone')]
    param (
        [Parameter(ParameterSetName='FileForwardLookupZone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ADForwardLookupZone', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${LoadExisting},

        [Parameter(ParameterSetName='FileForwardLookupZone', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ADForwardLookupZone', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ipaddress[]]
        ${MasterServers},

        [Parameter(ParameterSetName='FileForwardLookupZone')]
        [Parameter(ParameterSetName='ADForwardLookupZone')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='FileForwardLookupZone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ADForwardLookupZone', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${UseRecursion},

        [Parameter(ParameterSetName='FileForwardLookupZone', Position=3, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ADForwardLookupZone', Position=3, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${ForwarderTimeout},

        [Parameter(ParameterSetName='FileForwardLookupZone')]
        [Parameter(ParameterSetName='ADForwardLookupZone')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='ADForwardLookupZone', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${DirectoryPartitionName},

        [Parameter(ParameterSetName='ADForwardLookupZone', ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('Forest','Domain','Legacy','Custom')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ReplicationScope},

        [Parameter(ParameterSetName='FileForwardLookupZone', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ADForwardLookupZone', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('ZoneName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='FileForwardLookupZone')]
        [Parameter(ParameterSetName='ADForwardLookupZone')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='FileForwardLookupZone')]
        [Parameter(ParameterSetName='ADForwardLookupZone')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='FileForwardLookupZone')]
        [Parameter(ParameterSetName='ADForwardLookupZone')]
        [switch]
        ${AsJob}
    )
}

function Add-DnsServerDirectoryPartition {
    <#
    .SYNOPSIS
        Creates a DNS application directory partition.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER Type
        Specifies a type of DNS application directory partition. The acceptable values for this parameter are:
        -- /Domain
        -- /Forest
        -- /AllDomains

        To create a default domain-wide DNS application directory partition for the Active Directory domain where the specified DNS server is located, specify /Domain.

        To create a default forest-wide DNS application directory partition for the Active Directory forest where the specified DNS server is located, specify /Forest.

        The ComputerName parameter is ignored for an /AllDomains DNS application directory partition. The computer from where you run this command must be joined to a domain in the forest where you want to create all of the default domain-wide application directory partitions.
    .PARAMETER Name
        Specifies a name for the new DNS application directory partition.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='Name', SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerDirectoryPartition')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerDirectoryPartition')]
    param (
        [Parameter(ParameterSetName='Name')]
        [Parameter(ParameterSetName='BuiltIn')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Name')]
        [Parameter(ParameterSetName='BuiltIn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='BuiltIn', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('Forest','Domain')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Type},

        [Parameter(ParameterSetName='Name', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('DirectoryPartitionName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Name')]
        [Parameter(ParameterSetName='BuiltIn')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Name')]
        [Parameter(ParameterSetName='BuiltIn')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Name')]
        [Parameter(ParameterSetName='BuiltIn')]
        [switch]
        ${AsJob}
    )
}

function Add-DnsServerForwarder {
    <#
    .SYNOPSIS
        Adds server level forwarders to a DNS server.
    .PARAMETER IPAddress
        Specifies an array of IP addresses of DNS servers where queries are forwarded. If you prefer one of the forwarders, put that forwarder first in the series of forwarder IP addresses.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerForwarder')]
    param (
        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ipaddress[]]
        ${IPAddress},

        [Parameter(ParameterSetName='Add0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Add0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Add0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Add0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Add0')]
        [switch]
        ${AsJob}
    )
}

function Add-DnsServerPrimaryZone {
    <#
    .SYNOPSIS
        Adds a primary zone to a DNS server.
    .PARAMETER ResponsiblePerson
        Specifies a person responsible for the zone.
    .PARAMETER DynamicUpdate
        Specifies how a zone accepts dynamic updates. The acceptable values for this parameter are:
        -- None
        -- Secure
        -- NonsecureAndSecure

        Secure DNS updates are available only for Active Directory-integrated zones.
    .PARAMETER LoadExisting
        Indicates that the server loads an existing file for the zone. Otherwise, the cmdlet creates default zone records automatically. This switch is relevant only for file-backed zones.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER Name
        Specifies a name for the zone the cmdlet creates.
    .PARAMETER ReplicationScope
        Specifies a partition on which to store an Active Directory-integrated zone. The acceptable values for this parameter are:
        -- Custom. Any custom directory partition that a user creates. Specify a custom directory partition by using the DirectoryPartitionName parameter.
        -- Domain. The domain directory partition.
        -- Forest. The ForestDnsZone directory partition.
        -- Legacy. A legacy directory partition.
    .PARAMETER DirectoryPartitionName
        Specifies a directory partition on which to store the zone. Use this parameter when the ReplicationScope parameter has a value of Custom.
    .PARAMETER NetworkId
        Specifies a network ID and prefix length for a reverse lookup zone. Use the format A.B.C.D/prefix for IPv4 or 1111:2222:3333:4444::/prefix for IPv6.

        For IPv4, the cmdlet creates only class A, B, C, or D reverse lookup zones. If you specify a prefix that is between classes, the cmdlet uses the longer prefix that is divisible by 8. For example, a value of 10.2.10.0/23 adds the 10.2.10.0/24 reverse lookup zone, and the 10.2.11.0/24 reverse lookup zone is not created. If you enter an IPv4 prefix longer than /24, the cmdlet creates a /32 reverse lookup zone.

        For IPv6, the cmdlet creates ip6.arpa zones for prefixes from /16 to /128 that are divisible by 4. If you specify a prefix that is between values, the cmdlet uses the longer prefix that is divisible by 4. For example, entering a value of AAAA::/58 adds the AAAA::/60  ip6.arpa zone. If you do not enter a prefix, the cmdlet uses a default prefix value of /128.
    .PARAMETER ZoneFile
        Specifies a name of the zone file. This parameter is only relevant for file-backed DNS.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='ADForwardLookupZone', SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerPrimaryZone')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerPrimaryZone')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerPrimaryZone')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerPrimaryZone')]
    param (
        [Parameter(ParameterSetName='FileReverseLookupZone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='FileForwardLookupZone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ADReverseLookupZone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ADForwardLookupZone', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ResponsiblePerson},

        [Parameter(ParameterSetName='FileReverseLookupZone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='FileForwardLookupZone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ADReverseLookupZone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ADForwardLookupZone', ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('None','Secure','NonsecureAndSecure')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${DynamicUpdate},

        [Parameter(ParameterSetName='FileReverseLookupZone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='FileForwardLookupZone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ADReverseLookupZone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ADForwardLookupZone', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${LoadExisting},

        [Parameter(ParameterSetName='FileReverseLookupZone')]
        [Parameter(ParameterSetName='FileForwardLookupZone')]
        [Parameter(ParameterSetName='ADReverseLookupZone')]
        [Parameter(ParameterSetName='ADForwardLookupZone')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='FileReverseLookupZone')]
        [Parameter(ParameterSetName='FileForwardLookupZone')]
        [Parameter(ParameterSetName='ADReverseLookupZone')]
        [Parameter(ParameterSetName='ADForwardLookupZone')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='FileForwardLookupZone', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ADForwardLookupZone', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('ZoneName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='ADReverseLookupZone', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ADForwardLookupZone', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('Forest','Domain','Legacy','Custom')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ReplicationScope},

        [Parameter(ParameterSetName='ADReverseLookupZone', Position=3)]
        [Parameter(ParameterSetName='ADForwardLookupZone', Position=3, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${DirectoryPartitionName},

        [Parameter(ParameterSetName='FileReverseLookupZone', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ADReverseLookupZone', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${NetworkId},

        [Parameter(ParameterSetName='FileReverseLookupZone', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='FileForwardLookupZone', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneFile},

        [Parameter(ParameterSetName='FileReverseLookupZone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='FileForwardLookupZone', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${VirtualizationInstance},

        [Parameter(ParameterSetName='FileReverseLookupZone')]
        [Parameter(ParameterSetName='FileForwardLookupZone')]
        [Parameter(ParameterSetName='ADReverseLookupZone')]
        [Parameter(ParameterSetName='ADForwardLookupZone')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='FileReverseLookupZone')]
        [Parameter(ParameterSetName='FileForwardLookupZone')]
        [Parameter(ParameterSetName='ADReverseLookupZone')]
        [Parameter(ParameterSetName='ADForwardLookupZone')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='FileReverseLookupZone')]
        [Parameter(ParameterSetName='FileForwardLookupZone')]
        [Parameter(ParameterSetName='ADReverseLookupZone')]
        [Parameter(ParameterSetName='ADForwardLookupZone')]
        [switch]
        ${AsJob}
    )
}

function Add-DnsServerQueryResolutionPolicy {
    <#
    .SYNOPSIS
        Adds a policy for query resolution to a DNS server.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as an FQDN, host name, or NETBIOS name.
    .PARAMETER ZoneName
        Specifies the name of a DNS zone on which this cmdlet creates a zone level policy. The zone must exist on the DNS server.
    .PARAMETER Name
        Specifies a name for the new policy.
    .PARAMETER Fqdn
        Specifies the FQDN criterion. This is the FQDN of record in the query. Specify a criterion in the following format:
        operator, value01, value02, . . . , operator, value03, value04, . . .
        The operator is either EQ or NE. You can specify no more than one of each operator a criterion.

        The policy treats values that follow the EQ operator as multiple assertions which are logically combined (OR'd). The policy treats values that follow the NE operator as multiple assertions which are logically differenced (AND'd). The criterion is satisfied if the FQDN of the request matches one of the EQ values and does not match any of the NE values. You can include the asterisk (*) as the wildcard character. For example, EQ,*.contoso.com,NE,*.fabricam.com.
    .PARAMETER ClientSubnet
        Specifies the client subnet criterion. This is a client subnet from which the query was sent. For more information, see Add-DnsServerClientSubnet. Specify a criterion in the following format:
        operator, value01, value02, . . . , operator, value03, value04, . . .
        The operator is either EQ or NE. You can specify no more than one of each operator in a criterion.

        The policy treats values that follow the EQ operator as multiple assertions which are logically combined (OR'd). The policy treats values that follow the NE operator as multiple assertions which are logically differenced (AND'd). The criterion is satisfied if the subnet of the request matches one of the EQ values and does not match any of the NE values.

        Example criterion: "EQ,NorthAmerica,Asia,NE,Europe"
    .PARAMETER TimeOfDay
        Specifies the time of day criterion. This is when the server receives the query. Specify a criterion in the following format:
        operator, value01, value02, . . . , operator, value03, value04, . . .
        The operator is either EQ or NE. You can specify no more than one of each operator in the criterion.

        The policy treats values the follow the EQ operator as multiple assertions which are logically combined (OR'd). The policy treats values that follow the NE operator as multiple assertions which are logically differenced (AND'd). The criterion is satisfied if the time of day of the request matches one of the EQ values and does not match any of the NE values.

        Example criterion: "EQ,10:00-12:00,22:00-23:00"
    .PARAMETER TransportProtocol
        Specifies the transport protocol criterion. This is the transport protocol of the query. Valid values are: TCP and UDP. Specify a criterion in the following format:
        operator, value01, value02, . . . , operator, value03, value04, . . .
        The operator is either EQ or NE. You can specify no more than one of each operator in the string.

        The policy treats values the follow the EQ operator as multiple assertions which are logically combined (OR'd). The policy treats values that follow the NE operator as multiple assertions which are logically differenced (AND'd). The criterion is satisfied if the transport protocol of the request matches one of the EQ values and does not match any of the NE values.

        Example criteria: "EQ,TCP" and "NE,UDP"
    .PARAMETER InternetProtocol
        Specifies the Internet Protocol criterion. This is the IP version of the query. Valid values are: IPv4 and IPv6. Specify a criterion in the following format:
        operator, value01, value02, . . . , operator, value03, value04, . . .
        The operator is either EQ or NE. You can specify no more than one of each operator in a criterion.

        The policy treats values that follow the EQ operator as multiple assertions which are logically combined (OR'd). The policy treats values that follow the NE operator as multiple assertions which are logically differenced (AND'd). The criterion is satisfied if the IP address of the request matches one of the EQ values and does not match any of the NE values.

        Example criteria: "EQ,IPv4" and "EQ,IPv6"
    .PARAMETER Action
        Specifies the action to take if a query matches this policy. The acceptable values for this parameter are:
        -- ALLOW.
        -- DENY. Respond with SERV_FAIL.
        -- IGNORE. Do not respond.
    .PARAMETER ApplyOnRecursion
        Indicates that this policy is a server level recursion policy.

        Recursion policies are special class of server level policies that control how the DNS server performs recursion for a query. Recursion policies apply only when query processing reaches the recursion path.
    .PARAMETER ServerInterfaceIP
        Specifies the IP address of the server interface on which the DNS server listens. Specify a criterion in the following format:
        operator, value01, value02, . . . , operator, value03, value04, . . .
        The operator is either EQ or NE. You can specify no more than one of each operator in the criterion.

        The policy treats values the follow the EQ operator as multiple assertions which are logically combined (OR'd). The policy treats values that follow the NE operator as multiple assertions which are logically differenced (AND'd). The criterion is satisfied if the IP address of the interface matches one of the EQ values and does not match any of the NE values.

        Example criteria: "EQ,10.0.0.1" and "NE,192.168.1.1"
    .PARAMETER QType
        Specifies the query type criterion. This is the type of record that is being queried. Specify a criterion in the following format:
        operator, value01, value02, . . . , operator, value03, value04, . . .
        The operator is either EQ or NE. You can specify no more than one of each operator in a criterion.

        The policy treats values the follow the EQ operator as multiple assertions which are logically combined (OR'd). The policy treats values that follow the NE operator as multiple assertions which are logically differenced (AND'd). The criterion is satisfied if the type of query of the request matches one of the EQ values and does not match any of the NE values.

        Example criterion: "EQ,TXT,SRV,NE,MX"
    .PARAMETER ProcessingOrder
        Specifies the precedence of the policy. Higher integer values have lower precedence. By default, this cmdlet adds a new policy as the lowest precedence.
    .PARAMETER Condition
        Specifies how the policy treats multiple criteria. The acceptable values for this parameter are:
        -- OR. The policy evaluates criteria as multiple assertions which are logically combined (OR'd).
        -- AND. The policy evaluates criteria as multiple assertions which are logically differenced (AND'd).
        The default value is AND.
    .PARAMETER RecursionScope
        Specifies the scope of recursion. If the policy is a recursion policy, and if a query matches it, the DNS server uses settings from this scope to perform recursion for the query.
    .PARAMETER Disable
        Indicates that this cmdlet disables the policy. If you do not specify this parameter, the cmdlet creates the policy and enables it.
    .PARAMETER ZoneScope
        Specifies a list of scopes and weights for the zone. Specify the value as a string in this format:
        Scope01, Weight01; Scope02, Weight02;
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='Server', SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerPolicy')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerPolicy')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerPolicy')]
    param (
        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [Parameter(ParameterSetName='InputObject')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [Parameter(ParameterSetName='InputObject')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='InputObject', Mandatory=$true, Position=1, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [PSTypeName('Microsoft.Management.Infrastructure.CimInstance#DnsServerPolicy')]
        [ciminstance]
        ${InputObject},

        [Parameter(ParameterSetName='Zone', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='InputObject')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Zone', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Fqdn},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ClientSubnet},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${TimeOfDay},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${TransportProtocol},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${InternetProtocol},

        [Parameter(ParameterSetName='Zone', Position=3, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', Position=3, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('ALLOW','DENY','IGNORE')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Action},

        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${ApplyOnRecursion},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ServerInterfaceIP},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${QType},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${ProcessingOrder},

        [Parameter(ParameterSetName='Zone', Position=4, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', Position=4, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('AND','OR')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Condition},

        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${RecursionScope},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Disable},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneScope},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [Parameter(ParameterSetName='InputObject')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [Parameter(ParameterSetName='InputObject')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [Parameter(ParameterSetName='InputObject')]
        [switch]
        ${AsJob}
    )
}

function Add-DnsServerRecursionScope {
    <#
    .SYNOPSIS
        Adds a recursion scope on a DNS server.
    .PARAMETER Name
        Specifies a name for the recursion scope.
    .PARAMETER Forwarder
        Specifies an array IP addresses of forwarders for this recursion scope.
    .PARAMETER EnableRecursion
        Indicates whether to enable recursion.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerRecursionScope')]
    param (
        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Add0', Position=2, ValueFromPipelineByPropertyName=$true)]
        [ipaddress[]]
        ${Forwarder},

        [Parameter(ParameterSetName='Add0', Position=3, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${EnableRecursion},

        [Parameter(ParameterSetName='Add0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Add0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Add0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Add0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Add0')]
        [switch]
        ${AsJob}
    )
}

function Add-DnsServerResourceRecord {
    <#
    .SYNOPSIS
        Adds a resource record of a specified type to a specified DNS zone.
    .PARAMETER ZoneName
        Specifies the name of a DNS zone.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER ZoneScope
        Specifies the name of a zone scope.
    .PARAMETER CreatePtr
        Indicates that the DNS server automatically creates an associated pointer (PTR) resource record for an A or AAAA record. A PTR resource record maps an IP address to a host name.
    .PARAMETER IPv4Address
        Specifies the IPv4 address of a host.
    .PARAMETER Name
        Specifies the name of a DNS server resource record object.
    .PARAMETER TimeToLive
        Specifies the Time to Live (TTL) value, in seconds, for a resource record. Other DNS servers use this length of time to determine how long to cache a record.
    .PARAMETER AgeRecord
        Indicates that the DNS server uses a time stamp for the resource record that this cmdlet adds. A DNS server can scavenge resource records that have become stale based on a time stamp.
    .PARAMETER AllowUpdateAny
        Indicates that any authenticated user can update a resource record that has the same owner name.
    .PARAMETER A
        Indicates that the record that this cmdlet adds to the DNS server is a host address (A) resource record. An A resource record maps a host name to an IPv4 address.
    .PARAMETER IPv6Address
        Specifies the IPv6 address of a host.
    .PARAMETER AAAA
        Indicates that the record that this cmdlet adds to the DNS server is an AAAA resource record. An AAAA resource record maps a host name to an IPv6 address.
    .PARAMETER SubType
        Specifies whether the server is an AFS volume location server. Use a value of 1 indicate that the server is an AFS version 3.0 volume location server for the specified AFS cell. Use a value of 2 to indicate that the server is an authenticated name server that holds the cell-root directory node for the server that uses either Open Software Foundation's (OSF) DCE authenticated cell-naming system or HP/Apollo's Network Computing Architecture (NCA).
        For more information about server subtypes, see RFC 1183 (http://www.ietf.org/rfc/rfc1183.txt).

    .PARAMETER ServerName
        Specifies the subtype of a host AFS server. For subtype 1 (value=1), the host has an AFS version 3.0 Volume Location Server for the named AFS cell. For subtype 2 (value=2), the host has an authenticated name server holding the cell-root directory node for the named DCE/NCA cell.
    .PARAMETER Afsdb
        Indicates that the record that this cmdlet adds to the DNS server is an Andrew File System cell database server (AFSDB) resource record. An AFSDB resource record gives the location of the AFS cell database server and uses DNS to map a DNS domain name to the name of an AFS cell database server.
    .PARAMETER Address
        Specifies a byte array that contains the asynchronous transfer mode (ATM) address of the owner to which this resource record object pertains. The AddressType parameter specifies the format of the byte array. The first 4 bytes of the array store the size of the octet string. The most significant byte is byte 0.
    .PARAMETER AddressType
        Specifies the format of an ATM address in an ATM address (ATMA) resource record. Valid values are: 0, for an ATM End System Address (AESA) format, and 1, for an E.164 address format.
    .PARAMETER Atma
        Indicates that the record that this cmdlet adds to the DNS server is an ATM address resource record.
    .PARAMETER HostNameAlias
        Specifies a a canonical name target for a CNAME record. This must be a fully qualified domain name (FQDN).
    .PARAMETER CName
        Indicates that the record that this cmdlet adds to the DNS server is a canonical name (CNAME) resource record.
    .PARAMETER DhcpIdentifier
        Specifies a public key that is associated with an FQDN, as described in section 3 of RFC 2535.
    .PARAMETER DhcId
        Indicates that the record that this cmdlet adds to the DNS server is a Dynamic Host Configuration Protocol Information (DHCID) resource record.
    .PARAMETER DomainNameAlias
        Specifies the alias for a domain name.
    .PARAMETER DName
        Indicates that the record that this cmdlet adds to the DNS server is a domain alias (DNAME) resource record on a DNS server. A DNAME resource record renames the root and all descendants in a domain namespace subtree and provides nonterminal domain name redirection.
    .PARAMETER Cpu
        Specifies the CPU type of a DNS server. You can find the CPU type in a host information (HINFO) resource record.
    .PARAMETER OperatingSystem
        Specifies the operating system identifier of a DNS server. You can find the operating system identifier in a HINFO resource record.
    .PARAMETER HInfo
        Indicates that the record that this cmdlet adds to the DNS server is a host information (HINFO) resource record on a DNS server.
    .PARAMETER Force
        Adds a resource record without prompting you for confirmation. By default, the cmdlet prompts you for confirmation before it proceeds.
    .PARAMETER IsdnNumber
        Specifies the number in the ISDN address that maps to the FQDN of a DNS server. An ISDN address, which consists of a phone number and an optional subaddress, is located in an ISDN resource record. The phone number can contain a country/region code, an area code, and a local phone number.
    .PARAMETER IsdnSubAddress
        Specifies the number that is contained in an ISDN address that maps to the FQDN of a DNS server. An ISDN address consists of a phone number and an optional subaddress and is located in an ISDN resource record. The subaddress is an identifier that describes the ISDN subaddress encoding type.
    .PARAMETER Isdn
        Indicates that the record that this cmdlet adds to the DNS server is an Integrated Services Digital Network (ISDN) resource record.
    .PARAMETER MailExchange
        Specifies the FQDN of the host that is acting as a mail exchanger for the owner.
    .PARAMETER Preference
        Specifies the priority for this resource record among other resource records that belong to the same owner, where a lower value has a higher priority.
    .PARAMETER MX
        Indicates that the record that this cmdlet adds to the DNS server is a mail exchanger (MX) resource record.
    .PARAMETER NameServer
        Specifies the name server of a domain.
    .PARAMETER NS
        Indicates that the record that this cmdlet adds to the DNS server is a Name Server (NS) resource record on a DNS server.
    .PARAMETER PtrDomainName
        Specifies the FQDN of the host when you add a PTR resource record.
    .PARAMETER Ptr
        Indicates that the record that this cmdlet adds to the DNS server is a PTR resource record.
    .PARAMETER ResponsiblePerson
        Specifies the FQDN for the domain mailbox name of the person who is responsible for the resource record.

        When used together with the MR parameter set, this value specifies a mailbox that is the proper rename of the mailbox that is specified in the resource record's owner name.
    .PARAMETER Description
        Specifies text to describe the person or people that are responsible for the domain.
    .PARAMETER RP
        Indicates that the record that this cmdlet adds to the DNS server is a Responsible Person (RP) resource record.
    .PARAMETER IntermediateHost
        Specifies the FQDN of a host that routes packets to a destination host.
    .PARAMETER RT
        Indicates that the record that this cmdlet adds to the DNS server is a Route Through (RT) resource record.
    .PARAMETER DomainName
        Specifies the name of a domain.
    .PARAMETER Priority
        Specifies the priority of a DNS server. Clients try to contact the server that has the lowest priority.
    .PARAMETER Weight
        Specifies a value for the weight of the target host for a resource record. You can use this parameter when you have multiple hosts that have an identical priority. Use of the host is proportional to its weight.
    .PARAMETER Port
        Specifies the port where the server listens for the service.
    .PARAMETER Srv
        Indicates that the record that this cmdlet adds to the DNS server is a Service (SRV) resource record.
    .PARAMETER TLSA
        Indicates that the record that this cmdlet adds is a TLS authentication resource record.
    .PARAMETER CertificateUsage
        Specifies the certificate usage TLS authentication record.
    .PARAMETER MatchingType
        Specifies the matching type for the record. The acceptable values for this parameter are:
        -- ExactMatch
        -- Sha256Hash
        -- Sha512Hash
    .PARAMETER Selector
        Specifies a selector.
    .PARAMETER CertificateAssociationData
        Specifies the certificate association data for a Transport Layer Security (TLS) authentication record.
    .PARAMETER DescriptiveText
        Specifies additional text to describe a resource record on a DNS server.
    .PARAMETER Txt
        Indicates that the record that this cmdlet adds to the DNS server is a TXT resource record.
    .PARAMETER Type
        Specifies the type of the resource record.
    .PARAMETER RecordData
        Specifies the data contained in the resource record you want to add.
    .PARAMETER LookupTimeout
        Specifies the lookup time-out value for a resource record.
    .PARAMETER Replicate
        Indicates that the DNS server allows WINS replication.
    .PARAMETER WinsServers
        Specifies one or more IP addresses of WINS servers that you want to use for a resource record.
    .PARAMETER CacheTimeout
        Specifies how long, in seconds, that a DNS server caches a response from a WINS server.
    .PARAMETER Wins
        Indicates that the record that this cmdlet adds to the DNS server is a WINS resource record.
    .PARAMETER ResultDomain
        Specifies the domain name to append to returned NetBIOS names.
    .PARAMETER WinsR
        Indicates that the record that this cmdlet adds to the DNS server is a WINS reverse (WinsR) resource record.
    .PARAMETER InternetAddress
        Specifies the IP address of the owner of a resource record.
    .PARAMETER InternetProtocol
        Specifies the Internet Protocol (IP) for a resource record. Valid values are: UDP or TCP.
    .PARAMETER Service
        Specifies the service or services that are available for the current rewrite path. It can also specify a particular protocol to use for a service. Available services include Well-known Service (WKS) and NAPTR.
    .PARAMETER Wks
        Indicates that the record that this cmdlet adds to the DNS server is WKS resource record.
    .PARAMETER PsdnAddress
        Specifies the public switched data network (PSDN) address of the owner of a resource record.
    .PARAMETER X25
        Indicates that the record that this cmdlet adds to the DNS server is an X25 resource record.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='InputObject', SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    param (
        [Parameter(ParameterSetName='X25', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='WKS', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='WINSR', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='WINS', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Unknown', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='TXT', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='TLSA', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='SRV', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='RT', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='RP', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='PTR', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='NS', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='MX', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ISDN', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='InputObject', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='HINFO', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='DNAME', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='DHCID', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='CNAME', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ATMA', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='AFSDB', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='AAAA', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='A', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='X25')]
        [Parameter(ParameterSetName='WKS')]
        [Parameter(ParameterSetName='WINSR')]
        [Parameter(ParameterSetName='WINS')]
        [Parameter(ParameterSetName='Unknown')]
        [Parameter(ParameterSetName='TXT')]
        [Parameter(ParameterSetName='TLSA')]
        [Parameter(ParameterSetName='SRV')]
        [Parameter(ParameterSetName='RT')]
        [Parameter(ParameterSetName='RP')]
        [Parameter(ParameterSetName='PTR')]
        [Parameter(ParameterSetName='NS')]
        [Parameter(ParameterSetName='MX')]
        [Parameter(ParameterSetName='ISDN')]
        [Parameter(ParameterSetName='InputObject')]
        [Parameter(ParameterSetName='HINFO')]
        [Parameter(ParameterSetName='DNAME')]
        [Parameter(ParameterSetName='DHCID')]
        [Parameter(ParameterSetName='CNAME')]
        [Parameter(ParameterSetName='ATMA')]
        [Parameter(ParameterSetName='AFSDB')]
        [Parameter(ParameterSetName='AAAA')]
        [Parameter(ParameterSetName='A')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='X25')]
        [Parameter(ParameterSetName='WKS')]
        [Parameter(ParameterSetName='WINSR')]
        [Parameter(ParameterSetName='WINS')]
        [Parameter(ParameterSetName='Unknown')]
        [Parameter(ParameterSetName='TXT')]
        [Parameter(ParameterSetName='TLSA')]
        [Parameter(ParameterSetName='SRV')]
        [Parameter(ParameterSetName='RT')]
        [Parameter(ParameterSetName='RP')]
        [Parameter(ParameterSetName='PTR')]
        [Parameter(ParameterSetName='NS')]
        [Parameter(ParameterSetName='MX')]
        [Parameter(ParameterSetName='ISDN')]
        [Parameter(ParameterSetName='InputObject')]
        [Parameter(ParameterSetName='HINFO')]
        [Parameter(ParameterSetName='DNAME')]
        [Parameter(ParameterSetName='DHCID')]
        [Parameter(ParameterSetName='CNAME')]
        [Parameter(ParameterSetName='ATMA')]
        [Parameter(ParameterSetName='AFSDB')]
        [Parameter(ParameterSetName='AAAA')]
        [Parameter(ParameterSetName='A')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='X25', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='WKS', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='WINSR', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='WINS', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Unknown', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='TXT', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='TLSA', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='SRV', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='RT', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='RP', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='PTR', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='NS', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='MX', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ISDN', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='InputObject', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='HINFO', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='DNAME', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='DHCID', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='CNAME', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ATMA', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='AFSDB', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='AAAA', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='A', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneScope},

        [Parameter(ParameterSetName='X25', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='WKS', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='WINSR', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='WINS', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Unknown', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='TXT', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='TLSA', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='SRV', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='RT', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='RP', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='PTR', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='NS', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='MX', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ISDN', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='InputObject', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='HINFO', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='DNAME', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='DHCID', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='CNAME', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ATMA', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='AFSDB', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='AAAA', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='A', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${VirtualizationInstance},

        [Parameter(ParameterSetName='AAAA')]
        [Parameter(ParameterSetName='A', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${CreatePtr},

        [Parameter(ParameterSetName='A', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ipaddress]
        ${IPv4Address},

        [Parameter(ParameterSetName='X25', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='WKS', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Unknown', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='TXT', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='TLSA')]
        [Parameter(ParameterSetName='SRV', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='RT', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='RP', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='PTR', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='NS', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='MX', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ISDN', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='HINFO', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='DNAME', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='DHCID', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='CNAME', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ATMA', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='AFSDB', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='AAAA', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='A', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='X25', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='WKS', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Unknown', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='TXT', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='TLSA')]
        [Parameter(ParameterSetName='SRV', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='RT', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='RP', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='PTR', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='NS', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='MX', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ISDN', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='HINFO', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='DNAME', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='DHCID', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='CNAME', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ATMA', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='AFSDB', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='AAAA', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='A', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${TimeToLive},

        [Parameter(ParameterSetName='X25')]
        [Parameter(ParameterSetName='WKS', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Unknown', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='TXT', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='TLSA')]
        [Parameter(ParameterSetName='SRV', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='RT', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='RP', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='PTR', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='NS', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='MX', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ISDN', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='HINFO', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='DNAME', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='DHCID', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='CNAME', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ATMA', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='AFSDB', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='AAAA', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='A', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${AgeRecord},

        [Parameter(ParameterSetName='X25', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='WKS', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Unknown', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='TXT', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='TLSA')]
        [Parameter(ParameterSetName='SRV', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='RT', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='RP', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='PTR', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='NS', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='MX', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ISDN', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='InputObject')]
        [Parameter(ParameterSetName='HINFO', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='DNAME', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='DHCID', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='CNAME', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ATMA', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='AFSDB', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='AAAA', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='A', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${AllowUpdateAny},

        [Parameter(ParameterSetName='A', Mandatory=$true, Position=3)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${A},

        [Parameter(ParameterSetName='AAAA', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ipaddress]
        ${IPv6Address},

        [Parameter(ParameterSetName='AAAA', Mandatory=$true, Position=3)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${AAAA},

        [Parameter(ParameterSetName='AFSDB', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint16]
        ${SubType},

        [Parameter(ParameterSetName='AFSDB', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ServerName},

        [Parameter(ParameterSetName='AFSDB', Mandatory=$true, Position=3)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Afsdb},

        [Parameter(ParameterSetName='ATMA', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Address},

        [Parameter(ParameterSetName='ATMA', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('E164','AESA')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${AddressType},

        [Parameter(ParameterSetName='ATMA', Mandatory=$true, Position=3)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Atma},

        [Parameter(ParameterSetName='CNAME', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${HostNameAlias},

        [Parameter(ParameterSetName='CNAME', Mandatory=$true, Position=3)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${CName},

        [Parameter(ParameterSetName='DHCID', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${DhcpIdentifier},

        [Parameter(ParameterSetName='DHCID', Mandatory=$true, Position=3)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${DhcId},

        [Parameter(ParameterSetName='DNAME', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${DomainNameAlias},

        [Parameter(ParameterSetName='DNAME', Mandatory=$true, Position=3)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${DName},

        [Parameter(ParameterSetName='HINFO', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Cpu},

        [Parameter(ParameterSetName='HINFO', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${OperatingSystem},

        [Parameter(ParameterSetName='HINFO', Mandatory=$true, Position=3)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${HInfo},

        [Parameter(ParameterSetName='InputObject', Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [PSTypeName('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
        [ciminstance]
        ${InputObject},

        [Parameter(ParameterSetName='WINSR')]
        [Parameter(ParameterSetName='WINS')]
        [Parameter(ParameterSetName='InputObject')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='ISDN', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${IsdnNumber},

        [Parameter(ParameterSetName='ISDN', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${IsdnSubAddress},

        [Parameter(ParameterSetName='ISDN', Mandatory=$true, Position=3)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Isdn},

        [Parameter(ParameterSetName='MX', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${MailExchange},

        [Parameter(ParameterSetName='RT', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='MX', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint16]
        ${Preference},

        [Parameter(ParameterSetName='MX', Mandatory=$true, Position=3)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${MX},

        [Parameter(ParameterSetName='NS', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${NameServer},

        [Parameter(ParameterSetName='NS', Mandatory=$true, Position=3)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${NS},

        [Parameter(ParameterSetName='PTR', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${PtrDomainName},

        [Parameter(ParameterSetName='PTR', Mandatory=$true, Position=3)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Ptr},

        [Parameter(ParameterSetName='RP', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ResponsiblePerson},

        [Parameter(ParameterSetName='RP', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Description},

        [Parameter(ParameterSetName='RP', Mandatory=$true, Position=3)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${RP},

        [Parameter(ParameterSetName='RT', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${IntermediateHost},

        [Parameter(ParameterSetName='RT', Mandatory=$true, Position=3)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${RT},

        [Parameter(ParameterSetName='SRV', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${DomainName},

        [Parameter(ParameterSetName='SRV', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint16]
        ${Priority},

        [Parameter(ParameterSetName='SRV', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint16]
        ${Weight},

        [Parameter(ParameterSetName='SRV', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint16]
        ${Port},

        [Parameter(ParameterSetName='SRV', Mandatory=$true, Position=3)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Srv},

        [Parameter(ParameterSetName='TLSA', Mandatory=$true, Position=3)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${TLSA},

        [Parameter(ParameterSetName='TLSA', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('CAConstraint','ServiceCertificateConstraint','TrustAnchorAssertion','DomainIssuedCertificate')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${CertificateUsage},

        [Parameter(ParameterSetName='TLSA', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('ExactMatch','Sha256Hash','Sha512Hash')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${MatchingType},

        [Parameter(ParameterSetName='TLSA', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('FullCertificate','SubjectPublicKeyInfo')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Selector},

        [Parameter(ParameterSetName='TLSA', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${CertificateAssociationData},

        [Parameter(ParameterSetName='TXT', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${DescriptiveText},

        [Parameter(ParameterSetName='TXT', Mandatory=$true, Position=3)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Txt},

        [Parameter(ParameterSetName='Unknown', Mandatory=$true, Position=3, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint16]
        ${Type},

        [Parameter(ParameterSetName='Unknown', Mandatory=$true, Position=4, ValueFromPipelineByPropertyName=$true)]
        [AllowNull()]
        [AllowEmptyString()]
        [string]
        ${RecordData},

        [Parameter(ParameterSetName='WINSR', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='WINS', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${LookupTimeout},

        [Parameter(ParameterSetName='WINSR', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='WINS', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Replicate},

        [Parameter(ParameterSetName='WINS', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ipaddress[]]
        ${WinsServers},

        [Parameter(ParameterSetName='WINSR', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='WINS', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${CacheTimeout},

        [Parameter(ParameterSetName='WINS', Mandatory=$true, Position=3)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Wins},

        [Parameter(ParameterSetName='WINSR', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ResultDomain},

        [Parameter(ParameterSetName='WINSR', Mandatory=$true, Position=3)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${WinsR},

        [Parameter(ParameterSetName='WKS', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ipaddress]
        ${InternetAddress},

        [Parameter(ParameterSetName='WKS', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('UDP','TCP')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${InternetProtocol},

        [Parameter(ParameterSetName='WKS', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string[]]
        ${Service},

        [Parameter(ParameterSetName='WKS', Mandatory=$true, Position=3)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Wks},

        [Parameter(ParameterSetName='X25', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${PsdnAddress},

        [Parameter(ParameterSetName='X25', Mandatory=$true, Position=3)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${X25},

        [Parameter(ParameterSetName='X25')]
        [Parameter(ParameterSetName='WKS')]
        [Parameter(ParameterSetName='WINSR')]
        [Parameter(ParameterSetName='WINS')]
        [Parameter(ParameterSetName='Unknown')]
        [Parameter(ParameterSetName='TXT')]
        [Parameter(ParameterSetName='TLSA')]
        [Parameter(ParameterSetName='SRV')]
        [Parameter(ParameterSetName='RT')]
        [Parameter(ParameterSetName='RP')]
        [Parameter(ParameterSetName='PTR')]
        [Parameter(ParameterSetName='NS')]
        [Parameter(ParameterSetName='MX')]
        [Parameter(ParameterSetName='ISDN')]
        [Parameter(ParameterSetName='InputObject')]
        [Parameter(ParameterSetName='HINFO')]
        [Parameter(ParameterSetName='DNAME')]
        [Parameter(ParameterSetName='DHCID')]
        [Parameter(ParameterSetName='CNAME')]
        [Parameter(ParameterSetName='ATMA')]
        [Parameter(ParameterSetName='AFSDB')]
        [Parameter(ParameterSetName='AAAA')]
        [Parameter(ParameterSetName='A')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='X25')]
        [Parameter(ParameterSetName='WKS')]
        [Parameter(ParameterSetName='WINSR')]
        [Parameter(ParameterSetName='WINS')]
        [Parameter(ParameterSetName='Unknown')]
        [Parameter(ParameterSetName='TXT')]
        [Parameter(ParameterSetName='TLSA')]
        [Parameter(ParameterSetName='SRV')]
        [Parameter(ParameterSetName='RT')]
        [Parameter(ParameterSetName='RP')]
        [Parameter(ParameterSetName='PTR')]
        [Parameter(ParameterSetName='NS')]
        [Parameter(ParameterSetName='MX')]
        [Parameter(ParameterSetName='ISDN')]
        [Parameter(ParameterSetName='InputObject')]
        [Parameter(ParameterSetName='HINFO')]
        [Parameter(ParameterSetName='DNAME')]
        [Parameter(ParameterSetName='DHCID')]
        [Parameter(ParameterSetName='CNAME')]
        [Parameter(ParameterSetName='ATMA')]
        [Parameter(ParameterSetName='AFSDB')]
        [Parameter(ParameterSetName='AAAA')]
        [Parameter(ParameterSetName='A')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='X25')]
        [Parameter(ParameterSetName='WKS')]
        [Parameter(ParameterSetName='WINSR')]
        [Parameter(ParameterSetName='WINS')]
        [Parameter(ParameterSetName='Unknown')]
        [Parameter(ParameterSetName='TXT')]
        [Parameter(ParameterSetName='TLSA')]
        [Parameter(ParameterSetName='SRV')]
        [Parameter(ParameterSetName='RT')]
        [Parameter(ParameterSetName='RP')]
        [Parameter(ParameterSetName='PTR')]
        [Parameter(ParameterSetName='NS')]
        [Parameter(ParameterSetName='MX')]
        [Parameter(ParameterSetName='ISDN')]
        [Parameter(ParameterSetName='InputObject')]
        [Parameter(ParameterSetName='HINFO')]
        [Parameter(ParameterSetName='DNAME')]
        [Parameter(ParameterSetName='DHCID')]
        [Parameter(ParameterSetName='CNAME')]
        [Parameter(ParameterSetName='ATMA')]
        [Parameter(ParameterSetName='AFSDB')]
        [Parameter(ParameterSetName='AAAA')]
        [Parameter(ParameterSetName='A')]
        [switch]
        ${AsJob}
    )
}

function Add-DnsServerResourceRecordA {
    <#
    .SYNOPSIS
        Adds a type A resource record to a DNS zone.
    .PARAMETER AllowUpdateAny
        Indicates that any authenticated user can update a resource record that has the same owner name.
    .PARAMETER CreatePtr
        Indicates that the DNS server automatically creates an associated pointer (PTR) resource record for an A record. A PTR resource record maps an IP address to an FQDN.
    .PARAMETER Name
        Specifies a host name.
    .PARAMETER IPv4Address
        Specifies an array of IPv4 addresses.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER TimeToLive
        Specifies the Time to Live (TTL) value, in seconds, for a resource record. Other DNS servers use this length of time to determine how long to cache a record.
    .PARAMETER ZoneName
        Specifies the name of a DNS zone.
    .PARAMETER AgeRecord
        Indicates that the DNS server uses a time stamp for the resource record that this cmdlet adds. A DNS server can scavenge resource records that have become stale based on a time stamp.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER ZoneScope
        Specifies the name of a zone scope.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    param (
        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${AllowUpdateAny},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${CreatePtr},

        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Alias('DeviceName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=3, ValueFromPipelineByPropertyName=$true)]
        [Alias('IpAddress')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ipaddress[]]
        ${IPv4Address},

        [Parameter(ParameterSetName='Add0')]
        [Alias('Cn','ForwardLookupPrimaryServer')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${TimeToLive},

        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('ForwardLookupZone')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${AgeRecord},

        [Parameter(ParameterSetName='Add0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneScope},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${VirtualizationInstance},

        [Parameter(ParameterSetName='Add0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Add0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Add0')]
        [switch]
        ${AsJob}
    )
}

function Add-DnsServerResourceRecordAAAA {
    <#
    .SYNOPSIS
        Adds a type AAAA resource record to a DNS server.
    .PARAMETER AllowUpdateAny
        Indicates that any authenticated user can update a resource record that has the same owner name.
    .PARAMETER CreatePtr
        Indicates that the DNS server automatically creates an associated pointer (PTR) resource record for an AAAA record. A PTR resource record maps an IP address to an FQDN.
    .PARAMETER IPv6Address
        Specifies an array of IPv6 addresses.
    .PARAMETER Name
        Specifies a host name.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER TimeToLive
        Specifies the Time to Live (TTL) value, in seconds, for a resource record. Other DNS servers use this length of time to determine how long to cache a record.
    .PARAMETER ZoneName
        Specifies the name of the DNS zone to which you add the record.
    .PARAMETER AgeRecord
        Indicates that the DNS server uses a time stamp for the resource record that this cmdlet adds. A DNS server can scavenge resource records that have become stale based on a time stamp.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER ZoneScope
        Specifies the name of a zone scope.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    param (
        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${AllowUpdateAny},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${CreatePtr},

        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=3, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ipaddress[]]
        ${IPv6Address},

        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Add0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${TimeToLive},

        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${AgeRecord},

        [Parameter(ParameterSetName='Add0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneScope},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${VirtualizationInstance},

        [Parameter(ParameterSetName='Add0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Add0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Add0')]
        [switch]
        ${AsJob}
    )
}

function Add-DnsServerResourceRecordCName {
    <#
    .SYNOPSIS
        Adds a type CNAME resource record to a DNS  zone.
    .PARAMETER HostNameAlias
        Specifies the FQDN of the host that gets the alias. This is the canonical name of the host.
    .PARAMETER AllowUpdateAny
        Indicates that any authenticated user can update a resource record that has the same owner name.
    .PARAMETER Name
        Specifies the alias for the CNAME record.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER TimeToLive
        Specifies the Time to Live (TTL) value, in seconds, for a resource record. Other DNS servers use this length of time to determine how long to cache a record.
    .PARAMETER ZoneName
        Specifies the name of a DNS zone.
    .PARAMETER AgeRecord
        Indicates that the DNS server uses a time stamp for the resource record that this cmdlet adds. A DNS server can scavenge resource records that have become stale based on a time stamp.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER ZoneScope
        Specifies the name of a zone scope.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    param (
        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=3, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${HostNameAlias},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${AllowUpdateAny},

        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Alias('RecordName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Add0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${TimeToLive},

        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${AgeRecord},

        [Parameter(ParameterSetName='Add0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneScope},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${VirtualizationInstance},

        [Parameter(ParameterSetName='Add0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Add0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Add0')]
        [switch]
        ${AsJob}
    )
}

function Add-DnsServerResourceRecordDnsKey {
    <#
    .SYNOPSIS
        Adds a type DNSKEY resource record to a DNS zone.
    .PARAMETER Name
        Specifies the name of the resource record that this cmdlet adds to the DNS server.
    .PARAMETER CryptoAlgorithm
        Specifies the cryptographic algorithm the server uses to generate keys. The acceptable values for this parameter are:
        -- RsaSha1
        -- RsaSha256
        -- RsaSha512
        -- RsaSha1NSec3
        -- ECDsaP256Sha256
        -- ECDsaP384Sha384
    .PARAMETER ZoneName
        Specifies the name of a DNS zone.
    .PARAMETER TimeToLive
        Specifies the Time to Live (TTL) value, in seconds, for a resource record. Other DNS servers use this length of time to determine how long to cache a record.
    .PARAMETER AgeRecord
        Indicates that the DNS server uses a time stamp for the resource record that this cmdlet adds. A DNS server can scavenge resource records that have become stale based on a time stamp.
    .PARAMETER Base64Data
        Specifies key data for this resource record.
    .PARAMETER KeyProtocol
        Specifies the key protocol for this resource record. The only value for this parameter is Dnssec.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER SecureEntryPoint
        Specifies whether the key is a secure entry point, as defined in RFC 3757.
    .PARAMETER ZoneKey
        Specifies whether you can use this key to sign the zone. This key can be either a Zone Signing Key (ZSK) or a Key Signing Key (KSK).
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER ZoneScope
        Specifies the name of a zone scope.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    param (
        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=3, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('RsaSha1','RsaSha256','RsaSha512','RsaSha1NSec3','ECDsaP256Sha256','ECDsaP384Sha384')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${CryptoAlgorithm},

        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${TimeToLive},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${AgeRecord},

        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=4, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Base64Data},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('DnsSec')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${KeyProtocol},

        [Parameter(ParameterSetName='Add0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${SecureEntryPoint},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${ZoneKey},

        [Parameter(ParameterSetName='Add0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneScope},

        [Parameter(ParameterSetName='Add0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Add0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Add0')]
        [switch]
        ${AsJob}
    )
}

function Add-DnsServerResourceRecordDS {
    <#
    .SYNOPSIS
        Adds a type DS resource record to a DNS zone.
    .PARAMETER Name
        Specifies the name of the resource record that this cmdlet adds to the DNS server.
    .PARAMETER CryptoAlgorithm
        Specifies the cryptographic algorithm the server uses to generate keys. The acceptable values for this parameter are:
        -- RsaSha1
        -- RsaSha256
        -- RsaSha512
        -- RsaSha1NSec3
        -- ECDsaP256Sha256
        -- ECDsaP384Sha384
    .PARAMETER TimeToLive
        Specifies the Time to Live (TTL) value, in seconds, for a resource record. Other DNS servers use this length of time to determine how long to cache a record.
    .PARAMETER AgeRecord
        Indicates that the DNS server uses a time stamp for the resource record that this cmdlet adds. A DNS server can scavenge resource records that have become stale based on a time stamp.
    .PARAMETER Digest
        Specifies the DS digest data.
    .PARAMETER DigestType
        Specifies the type of digest data. The acceptable values for this parameter are:
        -- Sha1
        -- Sha256
        -- Sha384
    .PARAMETER KeyTag
        Specifies a key tag.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER ZoneName
        Specifies the name of a DNS zone. The cmdlet adds the record to this zone.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER ZoneScope
        Specifies the name of a zone scope.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    param (
        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=4, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('RsaSha1','RsaSha256','RsaSha512','RsaSha1NSec3','ECDsaP256Sha256','ECDsaP384Sha384')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${CryptoAlgorithm},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${TimeToLive},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${AgeRecord},

        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=6, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Digest},

        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=5, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('Sha1','Sha256','Sha384')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${DigestType},

        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=3, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint16]
        ${KeyTag},

        [Parameter(ParameterSetName='Add0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Add0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneScope},

        [Parameter(ParameterSetName='Add0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Add0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Add0')]
        [switch]
        ${AsJob}
    )
}

function Add-DnsServerResourceRecordMX {
    <#
    .SYNOPSIS
        Adds an MX resource record to a DNS server.
    .PARAMETER Name
        Specifies the name of the host or child domain for the mail exchange record. To add an MX resource record for the parent domain, specify a dot (.)..
    .PARAMETER MailExchange
        Specifies an FQDN for a mail exchanger. This value must resolve to a corresponding host (A) resource record.
    .PARAMETER Preference
        Specifies a priority, from 0 to 65535, for this MX resource record. A service attempts to contact mail servers in the order of preference from lowest priority value to highest priority value.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER TimeToLive
        Specifies the Time to Live (TTL) value, in seconds, for a resource record. Other DNS servers use this length of time to determine how long to cache a record.

        The Start of Authority (SOA) record defines the default TTL.
    .PARAMETER ZoneName
        Specifies the name of a DNS zone.
    .PARAMETER AgeRecord
        Indicates that the DNS server uses a time stamp for the resource record that this cmdlet adds. A DNS server can scavenge resource records that have become stale based on a time stamp.
    .PARAMETER AllowUpdateAny
        Indicates that any authenticated user can update a resource record that has the same owner name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER ZoneScope
        Specifies the name of a zone scope.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    param (
        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=3, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${MailExchange},

        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=4, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint16]
        ${Preference},

        [Parameter(ParameterSetName='Add0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${TimeToLive},

        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${AgeRecord},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${AllowUpdateAny},

        [Parameter(ParameterSetName='Add0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneScope},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${VirtualizationInstance},

        [Parameter(ParameterSetName='Add0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Add0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Add0')]
        [switch]
        ${AsJob}
    )
}

function Add-DnsServerResourceRecordPtr {
    <#
    .SYNOPSIS
        Adds a type PTR resource record to a DNS server.
    .PARAMETER AllowUpdateAny
        Indicates that any authenticated user can update a resource record that has the same owner name.
    .PARAMETER PtrDomainName
        Specifies an FQDN for a resource record in the DNS namespace. This value is the response to a reverse lookup using this PTR.
    .PARAMETER Name
        Specifies part of the IP address for the host. You can use either an IPv4 or IPv6 address. For example, if you use an IPv4 class C reverse lookup zone, then Name specifies the last octet of the IP address. If you use a class B reverse lookup zone, then Name specifies the last two octets.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER ZoneName
        Specifies the name of a reverse lookup zone.
    .PARAMETER TimeToLive
        Specifies the Time to Live (TTL) value, in seconds, for a resource record. Other DNS servers use this length of time to determine how long to cache a record.

        The Start of Authority (SOA) record defines the default TTL.
    .PARAMETER AgeRecord
        Indicates that the DNS server uses a time stamp for the resource record that this cmdlet adds. A DNS server can scavenge resource records that have become stale based on a time stamp.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER ZoneScope
        Specifies the name of a zone scope.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    param (
        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${AllowUpdateAny},

        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=3, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${PtrDomainName},

        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Alias('RecordName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Add0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${TimeToLive},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${AgeRecord},

        [Parameter(ParameterSetName='Add0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneScope},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${VirtualizationInstance},

        [Parameter(ParameterSetName='Add0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Add0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Add0')]
        [switch]
        ${AsJob}
    )
}

function Add-DnsServerResponseRateLimitingExceptionlist {
    <#
    .SYNOPSIS
        Adds an RRL exception list on the DNS server.
    .PARAMETER ClientSubnet
        Specifies the client subnet values for the exception list.

        This parameter must have the following format: COMPARATOR, value1, value2,..., COMPARATOR, value 3, value 4,.. where the COMPARATOR can be EQ or NE. There can be only one EQ and one NE in a value.

        The values following the EQ operator will be treated as multiple assertions which are logically combined using the OR operator. The values following the NE operator will be treated as multiple assertions which are logically differenced using the AND operator.

        Multiple values are combined using the Condition parameter as a logical operator. The same operator is also used for combining EQ and NE expressions within a value.

        For example, EQ, America, Asia, NE, Europe specifies that the client subnets of America and Asia are in the exception list, and the client subnet of Europe is not.

        For details, see Add-DnsServerClientSubnet.
    .PARAMETER Fqdn
        Specifies FQDN values for the exception list.

        The value must have the following format: COMPARATOR, value1, value2,..., COMPARATOR, value 3, value 4,.. where the COMPARATOR can be EQ or NE. There can be only one EQ and one NE in a value.

        The values following the EQ operator will be treated as multiple assertions which are logically combined using the OR operator. The values following the NE operator will be treated as multiple assertions which are logically differenced using the AND operator.

        Multiple values are combined using the Condition parameter as a logical operator. The same operator is also used for combining EQ and NE expressions within a value.

        For example, EQ,*.contoso.com specifies that the contoso.com domain should be added to the exception list.
    .PARAMETER ServerInterfaceIP
        Specifies the server interface on which the DNS server is listening.

        The value must have the following format: COMPARATOR, value1, value2,..., COMPARATOR, value 3, value 4,.. where the COMPARATOR can be EQ or NE. There can be only one EQ and one NE in a value.

        The values following the EQ operator are treated as multiple assertions which are logically combined using the OR operator. The values following the NE operator are treated as multiple assertions which are logically differenced using the AND operator.

        Multiple values are combined using the Condition parameter as a logical operator. The same operator is also used for combining EQ and NE expressions within a value.

        For example, EQ,10.0.0.3 specifies that all queries received on a server interface that has the IP address of 10.0.0.3 should be exempt from RRL.
    .PARAMETER Name
        Specifies the name of the RRL exception list.
    .PARAMETER Condition
        Specifies a logical operator for combining multiple values of the ClientSubnet, Fdqn and ServerIp parameters. The values for the parameters are combined using the Condition parameter as a logical operator. The same operator is also used for combining EQ and NE expressions within a value. The default value is AND.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER ComputerName
        Specifies a remote DNS server on which to run the command. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NetBIOS name.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResponseRateLimitingExceptionlist')]
    param (
        [Parameter(ParameterSetName='Add0', Position=2, ValueFromPipelineByPropertyName=$true)]
        [AllowNull()]
        [string]
        ${ClientSubnet},

        [Parameter(ParameterSetName='Add0', Position=3, ValueFromPipelineByPropertyName=$true)]
        [AllowNull()]
        [string]
        ${Fqdn},

        [Parameter(ParameterSetName='Add0', Position=4, ValueFromPipelineByPropertyName=$true)]
        [AllowNull()]
        [string]
        ${ServerInterfaceIP},

        [Parameter(ParameterSetName='Add0', Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Add0', Position=5, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('AND','OR')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Condition},

        [Parameter(ParameterSetName='Add0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Add0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Add0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Add0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Add0')]
        [switch]
        ${AsJob}
    )
}

function Add-DnsServerRootHint {
    <#
    .SYNOPSIS
        Adds root hints on a DNS server.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER IPAddress
        Specifies an array of IPv4 or IPv6 addresses of DNS servers.
    .PARAMETER NameServer
        Specifies the fully qualified domain name of the root name server.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='InputObject', SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerRootHint')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerRootHint')]
    param (
        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='InputObject')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='InputObject')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='InputObject', Mandatory=$true, Position=1, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [PSTypeName('Microsoft.Management.Infrastructure.CimInstance#DnsServerRootHint')]
        [ciminstance]
        ${InputObject},

        [Parameter(ParameterSetName='Parameters', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ipaddress[]]
        ${IPAddress},

        [Parameter(ParameterSetName='Parameters', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${NameServer},

        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='InputObject')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='InputObject')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='InputObject')]
        [switch]
        ${AsJob}
    )
}

function Add-DnsServerSecondaryZone {
    <#
    .SYNOPSIS
        Adds a DNS server secondary zone.
    .PARAMETER LoadExisting
        Indicates that the server loads an existing file for the zone. If you do not specify this parameter, this cmdlet creates default zone records automatically. This parameter is relevant only for file-backed zones.
    .PARAMETER MasterServers
        Specifies an array of IP addresses of the master servers of the zone. You can use both IPv4 and IPv6.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER Name
        Specifies a name of a zone.
    .PARAMETER ZoneFile
        Specifies the name of the zone file. This parameter is only relevant for file-backed DNS.
    .PARAMETER NetworkId
        Specifies a network ID and prefix length for a reverse lookup zone. Use the format A.B.C.D/prefix for IPv4 or 1111:2222:3333:4444::/prefix for IPv6.

        For IPv4, the cmdlet creates only class A, B, C, or D reverse lookup zones. If you specify a prefix that is between classes, the cmdlet uses the longer prefix that is divisible by 8. For example, a value of 10.2.10.0/23 adds the 10.2.10.0/24 reverse lookup zone, and the 10.2.11.0/24 reverse lookup zone is not created. If you enter an IPv4 prefix longer than /24, the cmdlet creates a /32 reverse lookup zone.

        For IPv6, the cmdlet creates ip6.arpa zones for prefixes from /16 to /128 that are divisible by 4. If you specify a prefix that is between values, the cmdlet uses the longer prefix that is divisible by 4. For example, entering a value of AAAA::/58 adds the AAAA::/60  ip6.arpa zone. If you do not enter a prefix, the cmdlet uses a default prefix value of /128.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='ForwardLookupZone', SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerSecondaryZone')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerSecondaryZone')]
    param (
        [Parameter(ParameterSetName='ReverseLookupZone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ForwardLookupZone', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${LoadExisting},

        [Parameter(ParameterSetName='ReverseLookupZone', Mandatory=$true, Position=3, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ForwardLookupZone', Mandatory=$true, Position=3, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ipaddress[]]
        ${MasterServers},

        [Parameter(ParameterSetName='ReverseLookupZone')]
        [Parameter(ParameterSetName='ForwardLookupZone')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='ReverseLookupZone')]
        [Parameter(ParameterSetName='ForwardLookupZone')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='ForwardLookupZone', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('ZoneName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='ReverseLookupZone', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ForwardLookupZone', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneFile},

        [Parameter(ParameterSetName='ReverseLookupZone', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${NetworkId},

        [Parameter(ParameterSetName='ReverseLookupZone')]
        [Parameter(ParameterSetName='ForwardLookupZone')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='ReverseLookupZone')]
        [Parameter(ParameterSetName='ForwardLookupZone')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='ReverseLookupZone')]
        [Parameter(ParameterSetName='ForwardLookupZone')]
        [switch]
        ${AsJob}
    )
}

function Add-DnsServerSigningKey {
    <#
    .SYNOPSIS
        Adds a KSK or ZSK to a signed zone.
    .PARAMETER ZoneName
        Specifies the name of the zone in which DNS Security Extensions (DNSSEC) operations are performed.
    .PARAMETER Type
        Specifies whether a key is a KSK or a ZSK.
    .PARAMETER CryptoAlgorithm
        Specifies a cryptographic algorithm to use for key generation. The acceptable values for this parameter are:
        -- RsaSha1
        -- RsaSha256
        -- RsaSha512
        -- RsaSha1NSec3
        -- ECDsaP256Sha256
        -- ECDsaP384Sha384
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER KeyLength
        Specifies the bit length of a key.
    .PARAMETER InitialRolloverOffset
        Specifies the amount of time to delay the first scheduled key rollover. You can use InitialRolloverOffset to stagger key rollovers.
    .PARAMETER DnsKeySignatureValidityPeriod
        Specifies the amount of time that signatures that cover DNSKEY record sets are valid.
    .PARAMETER DSSignatureValidityPeriod
        Specifies the amount of time that signatures that cover DS record sets are valid.
    .PARAMETER ZoneSignatureValidityPeriod
        Specifies the amount of time that signatures that cover all other record sets are valid.
    .PARAMETER RolloverPeriod
        Specifies the amount of time between scheduled key rollovers.
    .PARAMETER ActiveKey
        Specifies a signing key pointer string for the KSK's active key.
    .PARAMETER StandbyKey
        Specifies a signing key pointer string for the KSK's standby key.
    .PARAMETER NextKey
        Specifies a signing key pointer string for the next key. The DNS server uses this key during the next key rollover event.
    .PARAMETER KeyStorageProvider
        Specifies the Key Storage Provider that the DNS server uses to generate keys.
    .PARAMETER StoreKeysInAD
        Specifies whetehr to store the keys in Active Directory Domain Services (AD DS). This setting applies only to Active Directory-integrated zones when the vendor of KeyStorageProvider is Microsoft.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerSigningKey')]
    param (
        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Add0', Position=2, ValueFromPipelineByPropertyName=$true)]
        [Alias('KeyType')]
        [ValidateSet('KeySigningKey','ZoneSigningKey')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Type},

        [Parameter(ParameterSetName='Add0', Position=3, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('RsaSha1','RsaSha256','RsaSha512','RsaSha1NSec3','ECDsaP256Sha256','ECDsaP384Sha384')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${CryptoAlgorithm},

        [Parameter(ParameterSetName='Add0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Add0', Position=4, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${KeyLength},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${InitialRolloverOffset},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${DnsKeySignatureValidityPeriod},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${DSSignatureValidityPeriod},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${ZoneSignatureValidityPeriod},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${RolloverPeriod},

        [Parameter(ParameterSetName='Add0')]
        [string]
        ${ActiveKey},

        [Parameter(ParameterSetName='Add0')]
        [string]
        ${StandbyKey},

        [Parameter(ParameterSetName='Add0')]
        [string]
        ${NextKey},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${KeyStorageProvider},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${StoreKeysInAD},

        [Parameter(ParameterSetName='Add0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Add0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Add0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Add0')]
        [switch]
        ${AsJob}
    )
}

function Add-DnsServerStubZone {
    <#
    .SYNOPSIS
        Adds a DNS stub zone.
    .PARAMETER LoadExisting
        Indicates that the server loads an existing file for the zone. Otherwise, the cmdlet creates default zone records automatically. This switch is relevant only for file-backed zones.
    .PARAMETER MasterServers
        Specifies an array of IP addresses of the master servers of the zone. You can use both IPv4 and IPv6.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER ReplicationScope
        Specifies a partition on which to store an Active Directory-integrated zone. The acceptable values for this parameter are:
        -- Custom. Any custom directory partition that a user creates. Specify a custom directory partition by using the DirectoryPartitionName parameter.
        -- Domain. The domain directory partition.
        -- Forest. The ForestDnsZone directory partition.
        -- Legacy. A legacy directory partition.
    .PARAMETER Name
        Specifies a name of a zone.
    .PARAMETER DirectoryPartitionName
        Specifies a directory partition on which to store the zone. Use this parameter when the ReplicationScope parameter has a value of Custom.
    .PARAMETER NetworkId
        Specifies a network ID and prefix length for a reverse lookup zone. Use the format A.B.C.D/prefix for IPv4 or 1111:2222:3333:4444::/prefix for IPv6.

        For IPv4, the cmdlet creates only class A, B, C, or D reverse lookup zones. If you specify a prefix that is between classes, the cmdlet uses the longer prefix that is divisible by 8. For example, a value of 10.2.10.0/23 adds the 10.2.10.0/24 reverse lookup zone, and the 10.2.11.0/24 reverse lookup zone is not created. If you enter an IPv4 prefix longer than /24, the cmdlet creates a /32 reverse lookup zone.

        For IPv6, the cmdlet creates ip6.arpa zones for prefixes from /16 to /128 that are divisible by 4. If you specify a prefix that is between values, the cmdlet uses the longer prefix that is divisible by 4. For example, entering a value of AAAA::/58 adds the AAAA::/60  ip6.arpa zone. If you do not enter a prefix, the cmdlet uses a default prefix value of /128.
    .PARAMETER ZoneFile
        Specifies a name of the zone file. This parameter is only relevant for file-backed DNS.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='FileForwardLookupZone', SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerStubZone')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerStubZone')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerStubZone')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerStubZone')]
    param (
        [Parameter(ParameterSetName='FileReverseLookupZone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='FileForwardLookupZone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ADReverseLookupZone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ADForwardLookupZone', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${LoadExisting},

        [Parameter(ParameterSetName='FileReverseLookupZone', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='FileForwardLookupZone', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ADReverseLookupZone', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ADForwardLookupZone', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ipaddress[]]
        ${MasterServers},

        [Parameter(ParameterSetName='FileReverseLookupZone')]
        [Parameter(ParameterSetName='FileForwardLookupZone')]
        [Parameter(ParameterSetName='ADReverseLookupZone')]
        [Parameter(ParameterSetName='ADForwardLookupZone')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='FileReverseLookupZone')]
        [Parameter(ParameterSetName='FileForwardLookupZone')]
        [Parameter(ParameterSetName='ADReverseLookupZone')]
        [Parameter(ParameterSetName='ADForwardLookupZone')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='ADReverseLookupZone', Mandatory=$true, Position=3, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ADForwardLookupZone', Mandatory=$true, Position=3, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('Forest','Domain','Legacy','Custom')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ReplicationScope},

        [Parameter(ParameterSetName='FileForwardLookupZone', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ADForwardLookupZone', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('ZoneName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='ADReverseLookupZone', Position=4, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ADForwardLookupZone', Position=4, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${DirectoryPartitionName},

        [Parameter(ParameterSetName='FileReverseLookupZone', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ADReverseLookupZone', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${NetworkId},

        [Parameter(ParameterSetName='FileReverseLookupZone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='FileForwardLookupZone', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneFile},

        [Parameter(ParameterSetName='FileReverseLookupZone')]
        [Parameter(ParameterSetName='FileForwardLookupZone')]
        [Parameter(ParameterSetName='ADReverseLookupZone')]
        [Parameter(ParameterSetName='ADForwardLookupZone')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='FileReverseLookupZone')]
        [Parameter(ParameterSetName='FileForwardLookupZone')]
        [Parameter(ParameterSetName='ADReverseLookupZone')]
        [Parameter(ParameterSetName='ADForwardLookupZone')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='FileReverseLookupZone')]
        [Parameter(ParameterSetName='FileForwardLookupZone')]
        [Parameter(ParameterSetName='ADReverseLookupZone')]
        [Parameter(ParameterSetName='ADForwardLookupZone')]
        [switch]
        ${AsJob}
    )
}

function Add-DnsServerTrustAnchor {
    <#
    .SYNOPSIS
        Adds a trust anchor to a DNS server.
    .PARAMETER Name
        Specifies the name of a trust anchor on a DNS server.
    .PARAMETER KeyProtocol
        Specifies the key protocol. The default is Dnssec.
    .PARAMETER Base64Data
        Specifies key data.
    .PARAMETER ComputerName
        Specifies a remote DNS server. The acceptable values for this parameter are:an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER CryptoAlgorithm
        Specifies the cryptographic algorithm that the cmdlet uses for key generation. The acceptable values for this parameter are:
        -- RsaSha1
        -- RsaSha256
        -- RsaSha512
        -- RsaSha1NSec3
        -- ECDsaP256Sha256
        -- ECDsaP384Sha384
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER KeyTag
        Specifies the unique key tag that the DNS server uses to identify a key.
    .PARAMETER DigestType
        Specifies the type of algorithm that the zone signing key uses to create the DS record. Valid values are one or more of the following:
        -- Sha1
        -- Sha256
        -- Sha384
    .PARAMETER Digest
        Specifies the DS digest data.
    .PARAMETER Root
        Indicates that the cmdlet adds the trust anchor of the root zone from the URL specified by the RootTrustAnchorsURL property of the DNS server.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='DnsKey', SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerTrustAnchor')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerTrustAnchor')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerTrustAnchor')]
    param (
        [Parameter(ParameterSetName='DS', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='DnsKey', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('TrustAnchorName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='DnsKey', ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('DnsSec')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${KeyProtocol},

        [Parameter(ParameterSetName='DnsKey', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Base64Data},

        [Parameter(ParameterSetName='Root')]
        [Parameter(ParameterSetName='DS')]
        [Parameter(ParameterSetName='DnsKey')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='DS', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='DnsKey', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('RsaSha1','RsaSha256','RsaSha512','RsaSha1NSec3','ECDsaP256Sha256','ECDsaP384Sha384')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${CryptoAlgorithm},

        [Parameter(ParameterSetName='Root')]
        [Parameter(ParameterSetName='DS')]
        [Parameter(ParameterSetName='DnsKey')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='DS', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint16]
        ${KeyTag},

        [Parameter(ParameterSetName='DS', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('Sha1','Sha256','Sha384')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${DigestType},

        [Parameter(ParameterSetName='DS', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Digest},

        [Parameter(ParameterSetName='Root', Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Root},

        [Parameter(ParameterSetName='Root')]
        [Parameter(ParameterSetName='DS')]
        [Parameter(ParameterSetName='DnsKey')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Root')]
        [Parameter(ParameterSetName='DS')]
        [Parameter(ParameterSetName='DnsKey')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Root')]
        [Parameter(ParameterSetName='DS')]
        [Parameter(ParameterSetName='DnsKey')]
        [switch]
        ${AsJob}
    )
}

function Add-DnsServerVirtualizationInstance {
    <#
    .SYNOPSIS
        Add-DnsServerVirtualizationInstance [-Name] <string> [-ComputerName <string>] [-FriendlyName <string>] [-Description <string>] [-PassThru] [-CimSession <CimSession[]>] [-ThrottleLimit <int>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerVirtualizationInstance')]
    param (
        [Parameter(ParameterSetName='Add0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('VirtualizationInstance')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [string]
        ${FriendlyName},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [string]
        ${Description},

        [Parameter(ParameterSetName='Add0')]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Add0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Add0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Add0')]
        [switch]
        ${AsJob}
    )
}

function Add-DnsServerZoneDelegation {
    <#
    .SYNOPSIS
        Adds a new delegated DNS zone to an existing zone.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER ZoneScope
        Specifies the name of a zone scope.

        If you do not specify this parameter, the cmdlet adds the delegation into the default scope of the zone. We recommend that you add the delegations in all available scopes. Not adding delegations in all scopes causes loss in visibility to the child domains by means of certain scopes of parent zone where you do not add delegation.
    .PARAMETER ChildZoneName
        Specifies a name of the child zone.
    .PARAMETER IPAddress
        Specifies an array of IP addresses for DNS servers for the child zone.
    .PARAMETER NameServer
        Specifies the name of the DNS server that hosts the child zone.
    .PARAMETER Name
        Specifies the name of the parent zone. The child zone is part of this zone.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='InputObject', SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerZoneDelegation')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerZoneDelegation')]
    param (
        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='InputObject')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='InputObject')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Parameters', Position=5, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='InputObject', Position=5, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneScope},

        [Parameter(ParameterSetName='InputObject', Mandatory=$true, Position=2, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [PSTypeName('Microsoft.Management.Infrastructure.CimInstance#DnsServerZoneDelegation')]
        [ciminstance]
        ${InputObject},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='InputObject', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${VirtualizationInstance},

        [Parameter(ParameterSetName='Parameters', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ChildZoneName},

        [Parameter(ParameterSetName='Parameters', Mandatory=$true, Position=4, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ipaddress[]]
        ${IPAddress},

        [Parameter(ParameterSetName='Parameters', Mandatory=$true, Position=3, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${NameServer},

        [Parameter(ParameterSetName='Parameters', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('ZoneName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='InputObject')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='InputObject')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='InputObject')]
        [switch]
        ${AsJob}
    )
}

function Add-DnsServerZoneScope {
    <#
    .SYNOPSIS
        Adds a zone scope to an existing zone.
    .PARAMETER ZoneName
        Specifies the name of a zone. This cmdlet adds a zone to the zone that this parameter specifies.
    .PARAMETER Name
        Specifies a name for the zone scope.
    .PARAMETER LoadExisting
        Indicates that the server loads an existing file for the zone. If you do not specify this parameter, the cmdlet creates default zone records automatically.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsZoneScope')]
    param (
        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Add0', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Alias('ZoneScope')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Add0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${LoadExisting},

        [Parameter(ParameterSetName='Add0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Add0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Add0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Add0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Add0')]
        [switch]
        ${AsJob}
    )
}

function Add-DnsServerZoneTransferPolicy {
    <#
    .SYNOPSIS
        Adds a zone transfer policy to a DNS server.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as an FQDN, host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER ZoneName
        Specifies the name of a DNS zone on which this cmdlet creates a zone level policy. The zone must exist on the DNS server.
    .PARAMETER Action
        Specifies the action to take if a zone transfer matches this policy. The acceptable values for this parameter are:
        -- DENY. Respond with SERV_FAIL.
        -- IGNORE. Do not respond.
    .PARAMETER ClientSubnet
        Specifies the client subnet criterion. For more information, see Add-DnsServerClientSubnet. Specify a criterion in the following format:
        operator, value01, value02, . . . , operator, value03, value04, . . .
        The operator is either EQ or NE. You can specify no more than one of each operator in a criterion.

        The policy treats values that follow the EQ operator as multiple assertions which are logically combined (OR'd). The policy treats values that follow the NE operator as multiple assertions which are logically differenced (AND'd). The criterion is satisfied if the subnet of the zone transfer matches one of the EQ values and does not match any of the NE values.

        Example criterion: "EQ,NorthAmerica,Asia,NE,Europe"
    .PARAMETER Condition
        Specifies how the policy treats multiple criteria. The acceptable values for this parameter are:
        -- OR. The policy evaluates criteria as multiple assertions which are logically combined (OR'd).
        -- AND. The policy evaluates criteria as multiple assertions which are logically differenced (AND'd).
        The default value is AND.
    .PARAMETER InternetProtocol
        Specifies the Internet Protocol criterion. Valid values are: IPv4 and IPv6. Specify a criterion in the following format:
        operator, value01, value02, . . . , operator, value03, value04, . . .
        The operator is either EQ or NE. You can specify no more than one of each operator in a criterion.

        The policy treats values that follow the EQ operator as multiple assertions which are logically combined (OR'd). The policy treats values that follow the NE operator as multiple assertions which are logically differenced (AND'd). The criterion is satisfied if the IP address of the zone transfer matches one of the EQ values and does not match any of the NE values.

        Example criteria: "EQ,IPv4" and "EQ,IPv6"
    .PARAMETER Disable
        Indicates that this cmdlet disables the policy. If you do not specify this parameter, the cmdlet creates the policy and enables it.
    .PARAMETER Name
        Specifies a name for the new policy.
    .PARAMETER ProcessingOrder
        Specifies the precedence of the policy. Higher integer values have lower precedence. By default, this cmdlet adds a new policy as the lowest precedence.
    .PARAMETER ServerInterfaceIP
        Specifies the IP address of the server interface on which the DNS server listens. Specify a criterion in the following format:
        operator, value01, value02, . . . , operator, value03, value04, . . .
        The operator is either EQ or NE. You can specify no more than one of each operator in the criterion.

        The policy treats values the follow the EQ operator as multiple assertions which are logically combined (OR'd). The policy treats values that follow the NE operator as multiple assertions which are logically differenced (AND'd). The criterion is satisfied if the IP address of the interface matches one of the EQ values and does not match any of the NE values.

        Example criteria: "EQ,10.0.0.1" and "NE,192.168.1.1"
    .PARAMETER TimeOfDay
        Specifies the time of day criterion. Specify a criterion in the following format:
        operator, value01, value02, . . . , operator, value03, value04, . . .
        The operator is either EQ or NE. You can specify no more than one of each operator in the criterion.

        The policy treats values the follow the EQ operator as multiple assertions which are logically combined (OR'd). The policy treats values that follow the NE operator as multiple assertions which are logically differenced (AND'd). The criterion is satisfied if the time of day of the zone transfer matches one of the EQ values and does not match any of the NE values.

        Example criterion: "EQ,10:00-12:00,22:00-23:00"
    .PARAMETER TransportProtocol
        Specifies the transport protocol criterion. Valid values are: TCP and UDP. Specify a criterion in the following format:
        operator, value01, value02, . . . , operator, value03, value04, . . .
        The operator is either EQ or NE. You can specify no more than one of each operator in the string.

        The policy treats values the follow the EQ operator as multiple assertions which are logically combined (OR'd). The policy treats values that follow the NE operator as multiple assertions which are logically differenced (AND'd). The criterion is satisfied if the transport protocol of the zone transfer matches one of the EQ values and does not match any of the NE values.

        Example criterion: "EQ,TCP,NE,UDP"
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='Server', SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerPolicy')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerPolicy')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerPolicy')]
    param (
        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [Parameter(ParameterSetName='InputObject')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [Parameter(ParameterSetName='InputObject')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='InputObject', Mandatory=$true, Position=1, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [PSTypeName('Microsoft.Management.Infrastructure.CimInstance#DnsServerPolicy')]
        [ciminstance]
        ${InputObject},

        [Parameter(ParameterSetName='Zone', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='InputObject')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Zone', Position=3, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', Position=3, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('DENY','IGNORE')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Action},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ClientSubnet},

        [Parameter(ParameterSetName='Zone', Position=4, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', Position=4, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('AND','OR')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Condition},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${InternetProtocol},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Disable},

        [Parameter(ParameterSetName='Zone', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${ProcessingOrder},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ServerInterfaceIP},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${TimeOfDay},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${TransportProtocol},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [Parameter(ParameterSetName='InputObject')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [Parameter(ParameterSetName='InputObject')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [Parameter(ParameterSetName='InputObject')]
        [switch]
        ${AsJob}
    )
}

function Clear-DnsServerCache {
    <#
    .SYNOPSIS
        Clears resource records from a cache on the DNS server.
    .PARAMETER ComputerName
        Specifies a DNS server. The acceptable values for this parameter are: an IP V4 address; an IP V6 address; any other value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER Force
        Forces the command to run without asking for user confirmation.
    .PARAMETER CacheScope
        Specifies the name of the cache scope to clear.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    param (
        [Parameter(ParameterSetName='Clear0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Clear0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='Clear0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${CacheScope},

        [Parameter(ParameterSetName='Clear0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Clear0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Clear0')]
        [switch]
        ${AsJob}
    )
}

function Clear-DnsServerStatistics {
    <#
    .SYNOPSIS
        Clears all DNS server statistics or statistics for zones.
    .PARAMETER ComputerName
        Specifies a DNS server. The acceptable values for this parameter are: an IP V4 address; an IP V6 address; any other value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name. Type the NetBIOS name, or a fully qualified domain name of a remote computer.
    .PARAMETER Force
        Instructs the cmdlet to perform the operation without prompting for confirmation.
    .PARAMETER ZoneName
        Specifies an array of names of DNS zones. The cmdlet clears DNS server statistics for the zones that you specify. This parameter is mandatory for the ZoneStatistics parameter set.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    param (
        [Parameter(ParameterSetName='ZoneStatistics')]
        [Parameter(ParameterSetName='Clear0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='ZoneStatistics')]
        [Parameter(ParameterSetName='Clear0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='ZoneStatistics', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string[]]
        ${ZoneName},

        [Parameter(ParameterSetName='ZoneStatistics')]
        [Parameter(ParameterSetName='Clear0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='ZoneStatistics')]
        [Parameter(ParameterSetName='Clear0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='ZoneStatistics')]
        [Parameter(ParameterSetName='Clear0')]
        [switch]
        ${AsJob}
    )
}

function ConvertTo-DnsServerPrimaryZone {
    <#
    .SYNOPSIS
        Converts a zone to a DNS primary zone.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER Name
        Specifies the name of a zone.
    .PARAMETER LoadExisting
        Indicates that the DNS server loads an existing file for the zone. If you do not specify this parameter, this cmdlet creates default zone records. This parameter is relevant only for file-backed zones.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER Force
        Converts a zone without prompting you for confirmation. By default, the cmdlet prompts you for confirmation before it proceeds.
    .PARAMETER ReplicationScope
        Specifies a partition on which to store an Active Directory-integrated zone. The acceptable values for this parameter are:
        -- Custom. Any custom directory partition that a user creates. Specify a custom directory partition by using the DirectoryPartitionName parameter.
        -- Domain. The domain directory partition.
        -- Forest. The ForestDnsZone directory partition.
        -- Legacy. A legacy directory partition.
    .PARAMETER DirectoryPartitionName
        Specifies a directory partition on which to store the zone. Use this parameter when the ReplicationScope parameter has a value of Custom.
    .PARAMETER ZoneFile
        Specifies the name of the zone file. This parameter is only relevant for file-backed DNS.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='ADZone', SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerPrimaryZone')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerPrimaryZone')]
    param (
        [Parameter(ParameterSetName='FileZone')]
        [Parameter(ParameterSetName='ADZone')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='FileZone', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ADZone', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('ZoneName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='FileZone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ADZone', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${LoadExisting},

        [Parameter(ParameterSetName='FileZone')]
        [Parameter(ParameterSetName='ADZone')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='FileZone')]
        [Parameter(ParameterSetName='ADZone')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='ADZone', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('Forest','Domain','Legacy','Custom')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ReplicationScope},

        [Parameter(ParameterSetName='ADZone', Position=3, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${DirectoryPartitionName},

        [Parameter(ParameterSetName='FileZone', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneFile},

        [Parameter(ParameterSetName='FileZone')]
        [Parameter(ParameterSetName='ADZone')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='FileZone')]
        [Parameter(ParameterSetName='ADZone')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='FileZone')]
        [Parameter(ParameterSetName='ADZone')]
        [switch]
        ${AsJob}
    )
}

function ConvertTo-DnsServerSecondaryZone {
    <#
    .SYNOPSIS
        Converts a primary zone or stub zone to a secondary zone.
    .PARAMETER ZoneFile
        Specifies the name of the zone file. This parameter is only relevant for file-backed DNS.
    .PARAMETER MasterServers
        Specifies an array of IP addresses of the master servers of the zone. You can use both IPv4 and IPv6.
    .PARAMETER Name
        Specifies the name of a zone to convert.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER Force
        Converts a zone without prompting you for confirmation. By default, the cmdlet prompts you for confirmation before it proceeds.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerSecondaryZone')]
    param (
        [Parameter(ParameterSetName='ConvertTo0', Mandatory=$true, Position=3, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneFile},

        [Parameter(ParameterSetName='ConvertTo0', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ipaddress[]]
        ${MasterServers},

        [Parameter(ParameterSetName='ConvertTo0', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('ZoneName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='ConvertTo0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='ConvertTo0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='ConvertTo0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='ConvertTo0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='ConvertTo0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='ConvertTo0')]
        [switch]
        ${AsJob}
    )
}

function Disable-DnsServerPolicy {
    <#
    .SYNOPSIS
        Disables DNS server policies.
    .PARAMETER Level
        Specifies which level at which to disable policies. The acceptable values for this parameter are: Zone and Server.
    .PARAMETER Name
        Specifies the name of the policy to disable.
    .PARAMETER ComputerName
        Specifies a DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER Force
        Forces the command to run without asking for user confirmation.
    .PARAMETER ZoneName
        Specifies the name of a DNS zone in which to disable policies.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    param (
        [Parameter(ParameterSetName='Disable0', Mandatory=$true, Position=1)]
        [ValidateSet('Zone','Server')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Level},

        [Parameter(ParameterSetName='Disable0', Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Disable0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Disable0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='Disable0', Position=3, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Disable0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Disable0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Disable0')]
        [switch]
        ${AsJob}
    )
}

function Disable-DnsServerSigningKeyRollover {
    <#
    .SYNOPSIS
        Disables key rollover on an input key.
    .PARAMETER ZoneName
        Specifies the name of the zone in which DNS Security Extensions (DNSSEC) operations are performed.
    .PARAMETER Force
        Forces the command to run without asking for user confirmation.
    .PARAMETER KeyId
        Specifies the ID of a key.
    .PARAMETER ComputerName
        Specifies a Domain Name System (DNS) server. The acceptable values for this parameter are: an IP V4 address; an IP V6 address; any other value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerSigningKey')]
    param (
        [Parameter(ParameterSetName='Disable0', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Disable0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='Disable0', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [guid]
        ${KeyId},

        [Parameter(ParameterSetName='Disable0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Disable0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Disable0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Disable0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Disable0')]
        [switch]
        ${AsJob}
    )
}

function Enable-DnsServerPolicy {
    <#
    .SYNOPSIS
        Enables DNS server policies.
    .PARAMETER Level
        Specifies which level at which to enable policies. The acceptable values for this parameter are: Zone and Server.
    .PARAMETER Name
        Specifies the name of the policy to enable.
    .PARAMETER ComputerName
        Specifies a DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER ZoneName
        Specifies the name of a DNS zone in which to enable policies.
    .PARAMETER Force
        Forces the command to run without asking for user confirmation.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    param (
        [Parameter(ParameterSetName='Enable1', Mandatory=$true, Position=1)]
        [ValidateSet('Zone','Server')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Level},

        [Parameter(ParameterSetName='Enable1', Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Enable1')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Enable1', Position=3, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Enable1')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='Enable1')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Enable1')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Enable1')]
        [switch]
        ${AsJob}
    )
}

function Enable-DnsServerSigningKeyRollover {
    <#
    .SYNOPSIS
        Enables rollover on the input key.
    .PARAMETER ComputerName
        Specifies a DNS server. The acceptable values for this parameter are: an IP v4 address, an IP v6 address, and any other value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER RolloverPeriod
        Specifies the amount of time between scheduled key rollovers.
    .PARAMETER InitialRolloverOffset
        Specifies the amount of time before the first scheduled key rollover occurs. You can stagger key rollovers by using this parameter.
    .PARAMETER Force
        Instructs the cmdlet to perform the operation without prompting for confirmation.
    .PARAMETER ZoneName
        Specifies the name of the zone in which DNS Security Extensions (DNSSEC) operations are performed.
    .PARAMETER KeyId
        Specifies the ID of a key.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerSigningKey')]
    param (
        [Parameter(ParameterSetName='Enable1')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Enable1', Position=3, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${RolloverPeriod},

        [Parameter(ParameterSetName='Enable1', Position=4, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${InitialRolloverOffset},

        [Parameter(ParameterSetName='Enable1')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='Enable1', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Enable1', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [guid]
        ${KeyId},

        [Parameter(ParameterSetName='Enable1')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Enable1')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Enable1')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Enable1')]
        [switch]
        ${AsJob}
    )
}

function Export-DnsServerDnsSecPublicKey {
    <#
    .SYNOPSIS
        Exports DS and DNSKEY information for a DNSSEC-signed zone.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER ZoneName
        Specifies the name of the primary zone for which the cmdlet exports the signing keys.
    .PARAMETER Path
        Specifies the absolute path that the cmdlet uses to place the keyset file. The cmdlet automatically names the file according to the zone name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER UnAuthenticated
        Indicates that an unauthenticated user is running this cmdlet. The provider DNS server queries for the DS or DNSKEY information and exports the required data even if you do not have permissions to run the cmdlet on the remote DNS server.
    .PARAMETER Force
        Exports the signing key without prompting you for confirmation. By default, the cmdlet prompts you for confirmation before it proceeds.
    .PARAMETER NoClobber
        Specifies that the export operation does not overwrite an existing export file that has the same name.
    .PARAMETER DigestType
        Specifies an array of algorithms that the zone signing key uses to create the DS record. The acceptable values for this parameter are:
        -- Sha1
        -- Sha256
        -- Sha384
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='DnsKey', SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    param (
        [Parameter(ParameterSetName='DS')]
        [Parameter(ParameterSetName='DnsKey')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='DS', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='DnsKey', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('TrustPointName','TrustAnchorName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='DS', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='DnsKey', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Path},

        [Parameter(ParameterSetName='DS')]
        [Parameter(ParameterSetName='DnsKey')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='DS')]
        [Parameter(ParameterSetName='DnsKey')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${UnAuthenticated},

        [Parameter(ParameterSetName='DS')]
        [Parameter(ParameterSetName='DnsKey')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='DS')]
        [Parameter(ParameterSetName='DnsKey')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${NoClobber},

        [Parameter(ParameterSetName='DS', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('Sha1','Sha256','Sha384')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string[]]
        ${DigestType},

        [Parameter(ParameterSetName='DS')]
        [Parameter(ParameterSetName='DnsKey')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='DS')]
        [Parameter(ParameterSetName='DnsKey')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='DS')]
        [Parameter(ParameterSetName='DnsKey')]
        [switch]
        ${AsJob}
    )
}

function Export-DnsServerZone {
    <#
    .SYNOPSIS
        Exports contents of a zone to a file.
    .PARAMETER FileName
        Specifies a name for the export file. You can include a file path.
    .PARAMETER Name
        Specifies a name of a zone. The cmdlet exports the records for this zone.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerZone')]
    param (
        [Parameter(ParameterSetName='Export0', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${FileName},

        [Parameter(ParameterSetName='Export0', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('ZoneName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Export0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Export0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Export0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Export0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Export0')]
        [switch]
        ${AsJob}
    )
}

function Get-DnsServer {
    <#
    .SYNOPSIS
        Retrieves a DNS server configuration.
    .PARAMETER ComputerName
        Specifies a DNS server.  The acceptable values for this parameter are: an IP V4 address; an IP V6 address; any other value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServer')]
    param (
        [Parameter(ParameterSetName='Get0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Get0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Get0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Get0')]
        [switch]
        ${AsJob}
    )
}

function Get-DnsServerCache {
    <#
    .SYNOPSIS
        Retrieves DNS server cache settings.
    .PARAMETER ComputerName
        Specifies a DNS server. The acceptable values for this parameter are:: an IPv4 address; an IPv6 address; any other value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerCache')]
    param (
        [Parameter(ParameterSetName='Get1')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Get1')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Get1')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Get1')]
        [switch]
        ${AsJob}
    )
}

function Get-DnsServerClientSubnet {
    <#
    .SYNOPSIS
        Gets client subnets for a DNS server.
    .PARAMETER Name
        Specifies the name of the client subnet to get.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerClientSubnet')]
    param (
        [Parameter(ParameterSetName='Get1', Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Get1')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Get1')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Get1')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Get1')]
        [switch]
        ${AsJob}
    )
}

function Get-DnsServerDiagnostics {
    <#
    .SYNOPSIS
        Retrieves DNS event logging details.
    .PARAMETER ComputerName
        Specifies a DNS server. The acceptable values for this parameter are: an IPv4 address; an IPv6 address; any other value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerDiagnostics')]
    param (
        [Parameter(ParameterSetName='Get0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Get0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Get0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Get0')]
        [switch]
        ${AsJob}
    )
}

function Get-DnsServerDirectoryPartition {
    <#
    .SYNOPSIS
        Gets a DNS application directory partition.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER Custom
        Indicates that this cmdlet returns custom directory partitions.
    .PARAMETER Name
        Specifies the FQDN of a DNS application directory partition.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='Custom', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerDirectoryPartition')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerDirectoryPartition')]
    param (
        [Parameter(ParameterSetName='Name')]
        [Parameter(ParameterSetName='Custom')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Custom', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Custom},

        [Parameter(ParameterSetName='Name', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('DirectoryPartitionName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Name')]
        [Parameter(ParameterSetName='Custom')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Name')]
        [Parameter(ParameterSetName='Custom')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Name')]
        [Parameter(ParameterSetName='Custom')]
        [switch]
        ${AsJob}
    )
}

function Get-DnsServerDnsSecZoneSetting {
    <#
    .SYNOPSIS
        Gets DNSSEC settings for a zone.
    .PARAMETER ZoneName
        Specifies an array of names of DNS zones.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER SigningMetadata
        Indicates that the cmdlet includes all signing metadata in the output object.
    .PARAMETER IncludeKSKMetadata
        Indicates that the cmdlet includes KSK metadata in the output object.  You can import the output object that contains the KSK metadata on another server. If the server that imports the input object requires the Key Master role, the server can seize the Key Master role. If the output object does not contain the KSK metadata, the server that imports the output object cannot seize the key Master Role while retaining the existing keys, and you must resign the whole zone with new keys.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='DnsSecSetting', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerDnsSecZoneSetting')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerZoneSigningMetadata')]
    param (
        [Parameter(ParameterSetName='SigningMetadata', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='DnsSecSetting', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string[]]
        ${ZoneName},

        [Parameter(ParameterSetName='SigningMetadata')]
        [Parameter(ParameterSetName='DnsSecSetting')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='SigningMetadata', Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${SigningMetadata},

        [Parameter(ParameterSetName='SigningMetadata')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${IncludeKSKMetadata},

        [Parameter(ParameterSetName='SigningMetadata')]
        [Parameter(ParameterSetName='DnsSecSetting')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='SigningMetadata')]
        [Parameter(ParameterSetName='DnsSecSetting')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='SigningMetadata')]
        [Parameter(ParameterSetName='DnsSecSetting')]
        [switch]
        ${AsJob}
    )
}

function Get-DnsServerDsSetting {
    <#
    .SYNOPSIS
        Retrieves DNS Server Active Directory settings
    .PARAMETER ComputerName
        Specifies a DNS server. The acceptable values for this parameter are: an IP V4 address; an IP V6 address; any other value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerDsSetting')]
    param (
        [Parameter(ParameterSetName='Get0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Get0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Get0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Get0')]
        [switch]
        ${AsJob}
    )
}

function Get-DnsServerEDns {
    <#
    .SYNOPSIS
        Gets EDNS configuration settings on a DNS sever.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerEDns')]
    param (
        [Parameter(ParameterSetName='Get0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Get0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Get0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Get0')]
        [switch]
        ${AsJob}
    )
}

function Get-DnsServerForwarder {
    <#
    .SYNOPSIS
        Gets forwarder configuration settings on a DNS server.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerForwarder')]
    param (
        [Parameter(ParameterSetName='Get1')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Get1')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Get1')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Get1')]
        [switch]
        ${AsJob}
    )
}

function Get-DnsServerGlobalNameZone {
    <#
    .SYNOPSIS
        Retrieves DNS server GlobalName zone configuration details.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerGlobalNameZone')]
    param (
        [Parameter(ParameterSetName='Get0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Get0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Get0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Get0')]
        [switch]
        ${AsJob}
    )
}

function Get-DnsServerGlobalQueryBlockList {
    <#
    .SYNOPSIS
        Gets a global query block list.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerGlobalQueryBlockList')]
    param (
        [Parameter(ParameterSetName='Get0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Get0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Get0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Get0')]
        [switch]
        ${AsJob}
    )
}

function Get-DnsServerQueryResolutionPolicy {
    <#
    .SYNOPSIS
        Gets policies for query resolution from a DNS server.
    .PARAMETER Name
        Specifies the name of the policy to get.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as an FQDN, host name, or NETBIOS name.
    .PARAMETER ZoneName
        Specifies the name of a DNS zone from which to get the zone level policy. The zone must exist on the DNS server.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='Server', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerPolicy')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerPolicy')]
    param (
        [Parameter(ParameterSetName='Zone', Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Zone', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [switch]
        ${AsJob}
    )
}

function Get-DnsServerRecursion {
    <#
    .SYNOPSIS
        Retrieves DNS server recursion settings.
    .PARAMETER ComputerName
        Specifies a DNS server. The acceptable values for this parameter are: an IP V4 address; an IP V6 address; any other value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerRecursion')]
    param (
        [Parameter(ParameterSetName='Get0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Get0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Get0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Get0')]
        [switch]
        ${AsJob}
    )
}

function Get-DnsServerRecursionScope {
    <#
    .SYNOPSIS
        Gets the DNS server recursion scopes.
    .PARAMETER Name
        Specifies the name of the recursion scope to get.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerRecursionScope')]
    param (
        [Parameter(ParameterSetName='Get1', Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Get1')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Get1')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Get1')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Get1')]
        [switch]
        ${AsJob}
    )
}

function Get-DnsServerResourceRecord {
    <#
    .SYNOPSIS
        Gets resource records from a specified DNS zone.
    .PARAMETER Name
        Specifies a node name within the selected zone. If not specified, it defaults to the root (@) node.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER ZoneName
        Specifies the name of a DNS server zone.
    .PARAMETER Node
        Indicates that the command returns only the resource records at the root of the node specified by the Name parameter. If Node is not specified then both the root and any child records in the node are returned.
    .PARAMETER ZoneScope
        Specifies the name of a zone scope.
    .PARAMETER RRType
        Specifies the type of resource record.

        The acceptable values for this parameter are:
        -- HInfo
        -- Afsdb
        -- Atma
        -- Isdn
        -- Key
        -- Mb
        -- Md
        -- Mf
        -- Mg
        -- MInfo
        -- Mr
        -- Mx
        -- NsNxt
        -- Rp
        -- Rt
        -- Wks
        -- X25
        -- A
        -- AAAA
        -- CName
        -- Ptr
        -- Srv
        -- Txt
        -- Wins
        -- WinsR
        -- Ns
        -- Soa
        -- NasP
        -- NasPtr
        -- DName
        -- Gpos
        -- Loc
        -- DhcId
        -- Naptr
        -- RRSig
        -- DnsKey
        -- DS
        -- NSec
        -- NSec3
        -- NSec3Param
    .PARAMETER Type
        Specifies a type of record to get.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    param (
        [Parameter(ParameterSetName='Unknown', Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Name', Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Unknown')]
        [Parameter(ParameterSetName='Name')]
        [Alias('Cn','ForwardLookupPrimaryServer')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Unknown', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Name', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('ForwardLookupZone')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Unknown')]
        [Parameter(ParameterSetName='Name')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Node},

        [Parameter(ParameterSetName='Unknown', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Name', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneScope},

        [Parameter(ParameterSetName='Unknown', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Name', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${VirtualizationInstance},

        [Parameter(ParameterSetName='Name', ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('HInfo','Afsdb','Atma','Isdn','Key','Mb','Md','Mf','Mg','MInfo','Mr','Mx','NsNxt','Rp','Rt','Wks','X25','A','AAAA','CName','Ptr','Srv','Txt','Wins','WinsR','Ns','Soa','NasP','NasPtr','DName','Gpos','Loc','DhcId','Naptr','RRSig','DnsKey','DS','NSec','NSec3','NSec3Param','Tlsa')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${RRType},

        [Parameter(ParameterSetName='Unknown', Mandatory=$true, Position=3, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint16]
        ${Type},

        [Parameter(ParameterSetName='Unknown')]
        [Parameter(ParameterSetName='Name')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Unknown')]
        [Parameter(ParameterSetName='Name')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Unknown')]
        [Parameter(ParameterSetName='Name')]
        [switch]
        ${AsJob}
    )
}

function Get-DnsServerResponseRateLimiting {
    <#
    .SYNOPSIS
        Displays the RRL settings on a DNS server.
    .PARAMETER ComputerName
        Specifies a remote DNS server on which to run the command. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NetBIOS name.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResponseRateLimiting')]
    param (
        [Parameter(ParameterSetName='Get0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Get0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Get0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Get0')]
        [switch]
        ${AsJob}
    )
}

function Get-DnsServerResponseRateLimitingExceptionlist {
    <#
    .SYNOPSIS
        Enumerates the RRL exception lists on a DNS Server.
    .PARAMETER ComputerName
        Specifies a remote DNS server on which to run the command. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NetBIOS name.
    .PARAMETER Name
        Specifies the name of an RRL exception list.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResponseRateLimitingExceptionlist')]
    param (
        [Parameter(ParameterSetName='Get1')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Get1', Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Get1')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Get1')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Get1')]
        [switch]
        ${AsJob}
    )
}

function Get-DnsServerRootHint {
    <#
    .SYNOPSIS
        Gets root hints on a DNS server.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerRootHint')]
    param (
        [Parameter(ParameterSetName='Get0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Get0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Get0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Get0')]
        [switch]
        ${AsJob}
    )
}

function Get-DnsServerScavenging {
    <#
    .SYNOPSIS
        Gets DNS aging and scavenging settings.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerScavenging')]
    param (
        [Parameter(ParameterSetName='Get0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Get0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Get0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Get0')]
        [switch]
        ${AsJob}
    )
}

function Get-DnsServerSetting {
    <#
    .SYNOPSIS
        Retrieves DNS server settings.
    .PARAMETER All
        Indicates that this cmdlet gets all DNS server settings.
    .PARAMETER ComputerName
        Specifies a DNS server. The acceptable values for this parameter are: an IP V4 address; an IP V6 address; any other value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='Brief', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerSetting')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerSettingBrief')]
    param (
        [Parameter(ParameterSetName='All', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${All},

        [Parameter(ParameterSetName='Brief')]
        [Parameter(ParameterSetName='All')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Brief')]
        [Parameter(ParameterSetName='All')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Brief')]
        [Parameter(ParameterSetName='All')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Brief')]
        [Parameter(ParameterSetName='All')]
        [switch]
        ${AsJob}
    )
}

function Get-DnsServerSigningKey {
    <#
    .SYNOPSIS
        Gets zone signing keys.
    .PARAMETER ZoneName
        Specifies the name of the zone in which DNS Security Extensions (DNSSEC) operations are performed.
    .PARAMETER KeyId
        Specifies an array of keys.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerSigningKey')]
    param (
        [Parameter(ParameterSetName='Get1', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Get1', Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [guid[]]
        ${KeyId},

        [Parameter(ParameterSetName='Get1')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Get1')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Get1')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Get1')]
        [switch]
        ${AsJob}
    )
}

function Get-DnsServerStatistics {
    <#
    .SYNOPSIS
        Retrieves DNS server statistics or statistics for zones.
    .PARAMETER ComputerName
        Specifies a DNS server. The acceptable values for this parameter are: an IP V4 address; an IP V6 address; any other value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER Clear
        Indicates that the cmdlet clears statistics for the zones that you specify in the ZoneName parameter.
    .PARAMETER ZoneName
        Specifies an array of names of DNS zones for which to get DNS statistics. This parameter is mandatory for the ZoneStatistics parameter set.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='ServerStatistics', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerStatistics')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerZoneStatistics')]
    param (
        [Parameter(ParameterSetName='ZoneStatistics')]
        [Parameter(ParameterSetName='ServerStatistics')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='ZoneStatistics')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Clear},

        [Parameter(ParameterSetName='ZoneStatistics', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string[]]
        ${ZoneName},

        [Parameter(ParameterSetName='ZoneStatistics')]
        [Parameter(ParameterSetName='ServerStatistics')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='ZoneStatistics')]
        [Parameter(ParameterSetName='ServerStatistics')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='ZoneStatistics')]
        [Parameter(ParameterSetName='ServerStatistics')]
        [switch]
        ${AsJob}
    )
}

function Get-DnsServerTrustAnchor {
    <#
    .SYNOPSIS
        Gets trust anchors on a DNS server.
    .PARAMETER ComputerName
        Specifies a remote DNS server. The acceptable values for this parameter are: an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER Name
        Specifies the name of a trust anchor on a DNS server.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerTrustAnchor')]
    param (
        [Parameter(ParameterSetName='Get0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Get0', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('TrustAnchorName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Get0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Get0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Get0')]
        [switch]
        ${AsJob}
    )
}

function Get-DnsServerTrustPoint {
    <#
    .SYNOPSIS
        Gets trust points on a DNS server.
    .PARAMETER Name
        Specifies an array of names of trust anchor zones on a DNS server.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerTrustPoint')]
    param (
        [Parameter(ParameterSetName='Get0', Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('TrustPointName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string[]]
        ${Name},

        [Parameter(ParameterSetName='Get0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Get0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Get0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Get0')]
        [switch]
        ${AsJob}
    )
}

function Get-DnsServerVirtualizationInstance {
    <#
    .SYNOPSIS
        Get-DnsServerVirtualizationInstance [[-Name] <string[]>] [-ComputerName <string>] [-CimSession <CimSession[]>] [-ThrottleLimit <int>] [-AsJob] [<CommonParameters>]
    #>

    [CmdletBinding(PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerVirtualizationInstance')]
    param (
        [Parameter(ParameterSetName='Get1')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Get1', Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('VirtualizationInstance')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string[]]
        ${Name},

        [Parameter(ParameterSetName='Get1')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Get1')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Get1')]
        [switch]
        ${AsJob}
    )
}

function Get-DnsServerZone {
    <#
    .SYNOPSIS
        Gets details of DNS zones on a DNS server.
    .PARAMETER Name
        Specifies an array of names of zones. If you do not specify one or more names, the cmdlet gets all the zones for the server.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerZone')]
    param (
        [Parameter(ParameterSetName='Get1', Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('ZoneName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string[]]
        ${Name},

        [Parameter(ParameterSetName='Get1')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Get1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${VirtualizationInstance},

        [Parameter(ParameterSetName='Get1')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Get1')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Get1')]
        [switch]
        ${AsJob}
    )
}

function Get-DnsServerZoneAging {
    <#
    .SYNOPSIS
        Gets DNS aging settings for a zone.
    .PARAMETER Name
        Specifies an array of names of zones. This cmdlet is relevant only for DNS primary zones.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerZoneAging')]
    param (
        [Parameter(ParameterSetName='Get0', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('ZoneName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string[]]
        ${Name},

        [Parameter(ParameterSetName='Get0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Get0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Get0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Get0')]
        [switch]
        ${AsJob}
    )
}

function Get-DnsServerZoneDelegation {
    <#
    .SYNOPSIS
        Gets the zone delegations of a DNS server zone.
    .PARAMETER ChildZoneName
        Specifies a name of a child zone. If you do not specify a name, the cmdlet gets all the child zones for the DNS zone.
    .PARAMETER Name
        Specifies the name of a zone. This is the parent DNS zone.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER ZoneScope
        Specifies the name of a zone scope.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerZoneDelegation')]
    param (
        [Parameter(ParameterSetName='Get0', Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ChildZoneName},

        [Parameter(ParameterSetName='Get0', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('ZoneName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Get0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Get0', Position=3, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneScope},

        [Parameter(ParameterSetName='Get0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${VirtualizationInstance},

        [Parameter(ParameterSetName='Get0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Get0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Get0')]
        [switch]
        ${AsJob}
    )
}

function Get-DnsServerZoneScope {
    <#
    .SYNOPSIS
        Gets the scopes of a zone on a DNS server.
    .PARAMETER ZoneName
        Specifies the name of a zone. This cmdlet gets a zone from the zone that this parameter specifies.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER Name
        Specifies the name of the scope to get.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsZoneScope')]
    param (
        [Parameter(ParameterSetName='Get1', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Get1')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Get1', Position=2, ValueFromPipelineByPropertyName=$true)]
        [Alias('ZoneScope')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Get1')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Get1')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Get1')]
        [switch]
        ${AsJob}
    )
}

function Get-DnsServerZoneTransferPolicy {
    <#
    .SYNOPSIS
        Gets the zone transfer policies on a DNS server.
    .PARAMETER Name
        Specifies the name of the policy to get.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as an FQDN, host name, or NETBIOS name.
    .PARAMETER ZoneName
        Specifies the name of a DNS zone. This cmdlet gets policies from the zone that this parameter specifies.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='Server', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerPolicy')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerPolicy')]
    param (
        [Parameter(ParameterSetName='Zone', Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Zone', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [switch]
        ${AsJob}
    )
}

function Import-DnsServerResourceRecordDS {
    <#
    .SYNOPSIS
        Imports DS resource record information from a file.
    .PARAMETER ZoneName
        Specifies the name of a DNS zone.
    .PARAMETER DSSetFile
        Specifies an absolute path for a dsset file. The cmdlet imports the DS record from this file.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER ZoneScope
        Specifies the name of a zone scope.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    param (
        [Parameter(ParameterSetName='Import1', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Import1', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${DSSetFile},

        [Parameter(ParameterSetName='Import1')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Import1')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Import1', Position=3, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneScope},

        [Parameter(ParameterSetName='Import1')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Import1')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Import1')]
        [switch]
        ${AsJob}
    )
}

function Import-DnsServerRootHint {
    <#
    .SYNOPSIS
        Copies root hints from a DNS server.
    .PARAMETER NameServer
        Specifies a DNS name server.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerRootHint')]
    param (
        [Parameter(ParameterSetName='Import1', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${NameServer},

        [Parameter(ParameterSetName='Import1')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Import1')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Import1')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Import1')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Import1')]
        [switch]
        ${AsJob}
    )
}

function Import-DnsServerTrustAnchor {
    <#
    .SYNOPSIS
        Imports a trust anchor for a DNS server.
    .PARAMETER ComputerName
        Specifies a remote DNS server. Specify the IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name, for the DNS server.
    .PARAMETER DSSetFile
        Specifies the path of a DS set file.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER KeySetFile
        Specifies the path of a key set file.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='KeySet', SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerTrustAnchor')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerTrustAnchor')]
    param (
        [Parameter(ParameterSetName='KeySet')]
        [Parameter(ParameterSetName='DSSet')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='DSSet', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${DSSetFile},

        [Parameter(ParameterSetName='KeySet')]
        [Parameter(ParameterSetName='DSSet')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='KeySet', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${KeySetFile},

        [Parameter(ParameterSetName='KeySet')]
        [Parameter(ParameterSetName='DSSet')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='KeySet')]
        [Parameter(ParameterSetName='DSSet')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='KeySet')]
        [Parameter(ParameterSetName='DSSet')]
        [switch]
        ${AsJob}
    )
}

function Invoke-DnsServerSigningKeyRollover {
    <#
    .SYNOPSIS
        Initiates rollover of signing keys for the zone.
    .PARAMETER ZoneName
        Specifies the name of the zone in which DNS Security Extensions (DNSSEC) operations are performed.
    .PARAMETER KeyId
        Specifies a key ID.
    .PARAMETER ComputerName
        Specifies a DNS server. The acceptable values for this parameter are: an IP v4 address, an IP v6 address, and any other value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER Force
        Instructs the cmdlet to perform the operation without prompting for confirmation.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerSigningKey')]
    param (
        [Parameter(ParameterSetName='Invoke2', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Invoke2', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [guid[]]
        ${KeyId},

        [Parameter(ParameterSetName='Invoke2')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Invoke2')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='Invoke2')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Invoke2')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Invoke2')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Invoke2')]
        [switch]
        ${AsJob}
    )
}

function Invoke-DnsServerZoneSign {
    <#
    .SYNOPSIS
        Signs a DNS server zone.
    .PARAMETER ZoneName
        Specifies a name of a primary zone. The cmdlet signs this zone.
    .PARAMETER SignWithDefault
        Indicates that this cmdlet signs a zone with default settings. If a zone is already signed, this parameter removes the existing KSK and ZSK values for the zone, and configures DNSSEC settings to default values. A new KSK and a new ZSK are used to resign the zone.
    .PARAMETER DoResign
        Indicates that this cmdlet re-signs a DNSSEC-signed zone.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER Force
        Signs the DNS Server zone without prompting you for confirmation. By default, the cmdlet prompts you for confirmation before it proceeds.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerPrimaryZone')]
    param (
        [Parameter(ParameterSetName='Invoke0', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Invoke0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${SignWithDefault},

        [Parameter(ParameterSetName='Invoke0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${DoResign},

        [Parameter(ParameterSetName='Invoke0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Invoke0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='Invoke0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Invoke0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Invoke0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Invoke0')]
        [switch]
        ${AsJob}
    )
}

function Invoke-DnsServerZoneUnsign {
    <#
    .SYNOPSIS
        Unsigns a DNS server zone.
    .PARAMETER ZoneName
        Specifies the name of the zone to unsign.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER Force
        Unsigns a DNS zone without prompting you for confirmation. By default, the cmdlet prompts you for confirmation before it proceeds.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerPrimaryZone')]
    param (
        [Parameter(ParameterSetName='Invoke0', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Invoke0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Invoke0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='Invoke0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Invoke0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Invoke0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Invoke0')]
        [switch]
        ${AsJob}
    )
}

function Register-DnsServerDirectoryPartition {
    <#
    .SYNOPSIS
        Registers a DNS server in a DNS application directory partition.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER Name
        Specifies the FQDN of a DNS application directory partition.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerDirectoryPartition')]
    param (
        [Parameter(ParameterSetName='Register0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Register0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Register0', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('DirectoryPartitionName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Register0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Register0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Register0')]
        [switch]
        ${AsJob}
    )
}

function Remove-DnsServerClientSubnet {
    <#
    .SYNOPSIS
        Removes a client subnet from a DNS server.
    .PARAMETER Name
        Specifies the name of the client subnet to remove.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER Force
        Forces the command to run without asking for user confirmation.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerClientSubnet')]
    param (
        [Parameter(ParameterSetName='Remove2', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Remove2')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Remove2')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='Remove2')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Remove2')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Remove2')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Remove2')]
        [switch]
        ${AsJob}
    )
}

function Remove-DnsServerDirectoryPartition {
    <#
    .SYNOPSIS
        Removes a DNS application directory partition.
    .PARAMETER Name
        Specifies the FQDN of a DNS application directory partition.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER Force
        Removes a DNS server from a DNS application directory partition without prompting you for confirmation. By default, the cmdlet prompts you for confirmation before it proceeds.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerDirectoryPartition')]
    param (
        [Parameter(ParameterSetName='Remove1', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('DirectoryPartitionName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Remove1')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Remove1')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Remove1')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='Remove1')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Remove1')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Remove1')]
        [switch]
        ${AsJob}
    )
}

function Remove-DnsServerForwarder {
    <#
    .SYNOPSIS
        Removes server level forwarders from a DNS server.
    .PARAMETER IPAddress
        Specifies an array of IP addresses of the DNS servers to remove from the DNS server's forwarders list.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER Force
        Removes the forwarder without prompting you for confirmation. By default, the cmdlet prompts you for confirmation before it proceeds.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerForwarder')]
    param (
        [Parameter(ParameterSetName='Remove2', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ipaddress[]]
        ${IPAddress},

        [Parameter(ParameterSetName='Remove2')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Remove2')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Remove2')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='Remove2')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Remove2')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Remove2')]
        [switch]
        ${AsJob}
    )
}

function Remove-DnsServerQueryResolutionPolicy {
    <#
    .SYNOPSIS
        Removes a policy for query resolution from a DNS server.
    .PARAMETER Force
        Forces the command to run without asking for user confirmation.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as an FQDN, host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER Name
        Specifies the name of the policy to remove.
    .PARAMETER ZoneName
        Specifies the name of a DNS zone from which to remove the zone level policy.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='Server', SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerPolicy')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerPolicy')]
    param (
        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Zone', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Zone', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [switch]
        ${AsJob}
    )
}

function Remove-DnsServerRecursionScope {
    <#
    .SYNOPSIS
        Removes a recursion scope from a DNS server.
    .PARAMETER Name
        Specifies the name of the recursion scope to remove.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER Force
        Forces the command to run without asking for user confirmation.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerRecursionScope')]
    param (
        [Parameter(ParameterSetName='Remove2', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Remove2')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Remove2')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='Remove2')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Remove2')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Remove2')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Remove2')]
        [switch]
        ${AsJob}
    )
}

function Remove-DnsServerResourceRecord {
    <#
    .SYNOPSIS
        Removes specified DNS server resource records from a zone.
    .PARAMETER ZoneName
        Specifies the name of a DNS zone.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER Force
        Removes a record or records without prompting you for confirmation. By default, the cmdlet prompts you for confirmation before it proceeds.
    .PARAMETER ZoneScope
        Specifies the name of a zone scope.
    .PARAMETER RRType
        Specifies the type of resource record.

        The acceptable values for this parameter are:
        -- HInfo
        -- Afsdb
        -- Atma
        -- Isdn
        -- Key
        -- Mb
        -- Md
        -- Mf
        -- Mg
        -- MInfo
        -- Mr
        -- Mx
        -- NsNxt
        -- Rp
        -- Rt
        -- Wks
        -- X25
        -- A
        -- AAAA
        -- CName
        -- Ptr
        -- Srv
        -- Txt
        -- Wins
        -- WinsR
        -- Ns
        -- Soa
        -- NasP
        -- NasPtr
        -- DName
        -- Gpos
        -- Loc
        -- DhcId
        -- Naptr
        -- RRSig
        -- DnsKey
        -- DS
        -- NSec
        -- NSec3
        -- NSec3Param
    .PARAMETER RecordData
        Specifies the data contained in the resource record you want to delete.
    .PARAMETER Name
        Specifies the name of a DNS server resource record object.
    .PARAMETER Type
        Specifies the type of record to remove.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='InputObject', SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    param (
        [Parameter(ParameterSetName='Unknown', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Name', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='InputObject', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('ForwardLookupZone')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Unknown')]
        [Parameter(ParameterSetName='Name')]
        [Parameter(ParameterSetName='InputObject')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Unknown')]
        [Parameter(ParameterSetName='Name')]
        [Parameter(ParameterSetName='InputObject')]
        [Alias('Cn','ForwardLookupPrimaryServer')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Unknown')]
        [Parameter(ParameterSetName='Name')]
        [Parameter(ParameterSetName='InputObject')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='Unknown', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Name', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='InputObject', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneScope},

        [Parameter(ParameterSetName='Unknown', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Name', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='InputObject', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${VirtualizationInstance},

        [Parameter(ParameterSetName='InputObject', Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [PSTypeName('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
        [ciminstance]
        ${InputObject},

        [Parameter(ParameterSetName='Name', Mandatory=$true, Position=3, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('HInfo','Afsdb','Atma','Isdn','Key','Mb','Md','Mf','Mg','MInfo','Mr','Mx','NsNxt','Rp','Rt','Wks','X25','A','AAAA','CName','Ptr','Srv','Txt','Wins','WinsR','Ns','Soa','NasP','NasPtr','DName','Gpos','Loc','DhcId','Naptr','RRSig','DnsKey','DS','NSec','NSec3','NSec3Param','Tlsa')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${RRType},

        [Parameter(ParameterSetName='Unknown')]
        [Parameter(ParameterSetName='Name')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string[]]
        ${RecordData},

        [Parameter(ParameterSetName='Unknown', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Name', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Alias('RecordName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Unknown', Mandatory=$true, Position=3, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint16]
        ${Type},

        [Parameter(ParameterSetName='Unknown')]
        [Parameter(ParameterSetName='Name')]
        [Parameter(ParameterSetName='InputObject')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Unknown')]
        [Parameter(ParameterSetName='Name')]
        [Parameter(ParameterSetName='InputObject')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Unknown')]
        [Parameter(ParameterSetName='Name')]
        [Parameter(ParameterSetName='InputObject')]
        [switch]
        ${AsJob}
    )
}

function Remove-DnsServerResponseRateLimitingExceptionlist {
    <#
    .SYNOPSIS
        Removes an RRL exception list from a DNS server.
    .PARAMETER ComputerName
        Specifies a remote DNS server on which to run the command. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NetBIOS name.
    .PARAMETER Force
        Forces the command to run without asking for user confirmation.
    .PARAMETER Name
        Specifies the name of the RRL exception list.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResponseRateLimitingExceptionlist')]
    param (
        [Parameter(ParameterSetName='Remove2')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Remove2')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='Remove2', Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Remove2')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Remove2')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Remove2')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Remove2')]
        [switch]
        ${AsJob}
    )
}

function Remove-DnsServerRootHint {
    <#
    .SYNOPSIS
        Removes root hints from a DNS server.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER Force
        Removes the root hints without prompting you for confirmation. By default, the cmdlet prompts you for confirmation before it proceeds.
    .PARAMETER IPAddress
        Specifies an array of IPv4 or IPv6 addresses of DNS servers to remove. If you do not specify IPAddress, this cmdlet removes all root hints on the specified DNS server.
    .PARAMETER NameServer
        Specifies the name of a root hint to remove.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='InputObject', SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerRootHint')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerRootHint')]
    param (
        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='InputObject')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='InputObject')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='InputObject')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='InputObject', Mandatory=$true, Position=1, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [PSTypeName('Microsoft.Management.Infrastructure.CimInstance#DnsServerRootHint')]
        [ciminstance]
        ${InputObject},

        [Parameter(ParameterSetName='Parameters', Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ipaddress[]]
        ${IPAddress},

        [Parameter(ParameterSetName='Parameters', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${NameServer},

        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='InputObject')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='InputObject')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='InputObject')]
        [switch]
        ${AsJob}
    )
}

function Remove-DnsServerSigningKey {
    <#
    .SYNOPSIS
        Removes signing keys.
    .PARAMETER ZoneName
        Specifies the name of the zone in which DNS Security Extensions (DNSSEC) operations are performed.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER KeyId
        Specifies an array of key identifiers.
    .PARAMETER Force
        Removes the signing keys without prompting you for confirmation. By default, the cmdlet prompts you for confirmation before it proceeds.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerSigningKey')]
    param (
        [Parameter(ParameterSetName='Remove2', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Remove2')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Remove2', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [guid[]]
        ${KeyId},

        [Parameter(ParameterSetName='Remove2')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='Remove2')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Remove2')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Remove2')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Remove2')]
        [switch]
        ${AsJob}
    )
}

function Remove-DnsServerTrustAnchor {
    <#
    .SYNOPSIS
        Removes a trust anchor from a DNS server.
    .PARAMETER ComputerName
        Specifies a remote DNS server. The acceptable values for this parameter are: an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER Force
        Removes a trust anchor without prompting you for confirmation. By default, the cmdlet prompts you for confirmation before it proceeds.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER Name
        Specifies the name of a trust anchor on a DNS server.
    .PARAMETER Type
        Specifies the trust anchor type. If you do not specify this parameter, the server removes all trust anchors that match the other parameters that you specify.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='Name', SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerTrustAnchor')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerTrustAnchor')]
    param (
        [Parameter(ParameterSetName='Name')]
        [Parameter(ParameterSetName='InputObject')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Name')]
        [Parameter(ParameterSetName='InputObject')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='Name')]
        [Parameter(ParameterSetName='InputObject')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='InputObject', Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [PSTypeName('Microsoft.Management.Infrastructure.CimInstance#DnsServerTrustAnchor')]
        [ciminstance[]]
        ${InputObject},

        [Parameter(ParameterSetName='Name', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('TrustAnchorName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Name', Position=2, ValueFromPipelineByPropertyName=$true)]
        [Alias('TrustAnchorType')]
        [ValidateSet('DnsKey','DS')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Type},

        [Parameter(ParameterSetName='Name')]
        [Parameter(ParameterSetName='InputObject')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Name')]
        [Parameter(ParameterSetName='InputObject')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Name')]
        [Parameter(ParameterSetName='InputObject')]
        [switch]
        ${AsJob}
    )
}

function Remove-DnsServerVirtualizationInstance {
    <#
    .SYNOPSIS
        Remove-DnsServerVirtualizationInstance [-Name] <string> [-ComputerName <string>] [-PassThru] [-Force] [-RemoveZoneFiles] [-CimSession <CimSession[]>] [-ThrottleLimit <int>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerVirtualizationInstance')]
    param (
        [Parameter(ParameterSetName='Remove2', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('VirtualizationInstance')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Remove2')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Remove2')]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Remove2')]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='Remove2', ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${RemoveZoneFiles},

        [Parameter(ParameterSetName='Remove2')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Remove2')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Remove2')]
        [switch]
        ${AsJob}
    )
}

function Remove-DnsServerZone {
    <#
    .SYNOPSIS
        Removes a zone from a DNS server.
    .PARAMETER Name
        Specifies a name of a zone. The cmdlet removes this zone.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER Force
        Removes a zone without prompting you for confirmation. By default, the cmdlet prompts you for confirmation before it proceeds.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerZone')]
    param (
        [Parameter(ParameterSetName='Remove2', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('ZoneName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Remove2')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Remove2')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Remove2')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='Remove2', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${VirtualizationInstance},

        [Parameter(ParameterSetName='Remove2')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Remove2')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Remove2')]
        [switch]
        ${AsJob}
    )
}

function Remove-DnsServerZoneDelegation {
    <#
    .SYNOPSIS
        Removes a name server or delegation from a DNS zone.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER Force
        Removes the name server or delegation without prompting you for confirmation. By default, the cmdlet prompts you for confirmation before it proceeds.
    .PARAMETER ZoneScope
        Specifies the name of a zone scope.
    .PARAMETER NameServer
        Specifies the name of the DNS server for the child zone.
    .PARAMETER ChildZoneName
        Specifies the name of a child zone. The cmdlet removes the delegation for this zone.
    .PARAMETER Name
        Specifies the name of the parent zone.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='InputObject', SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerZoneDelegation')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerZoneDelegation')]
    param (
        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='InputObject')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='InputObject')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='InputObject')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='Parameters', Position=4, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='InputObject', Position=4, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneScope},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='InputObject', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${VirtualizationInstance},

        [Parameter(ParameterSetName='InputObject', Mandatory=$true, Position=2, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [PSTypeName('Microsoft.Management.Infrastructure.CimInstance#DnsServerZoneDelegation')]
        [ciminstance]
        ${InputObject},

        [Parameter(ParameterSetName='Parameters', Position=3, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${NameServer},

        [Parameter(ParameterSetName='Parameters', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ChildZoneName},

        [Parameter(ParameterSetName='Parameters', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('ZoneName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='InputObject')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='InputObject')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='InputObject')]
        [switch]
        ${AsJob}
    )
}

function Remove-DnsServerZoneScope {
    <#
    .SYNOPSIS
        Removes a zone scope from an existing zone.
    .PARAMETER ZoneName
        Specifies the name of a zone. This cmdlet removes a zone from the zone that this parameter specifies.
    .PARAMETER Name
        Specifies the name of the scope to delete.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER Force
        Forces the command to run without asking for user confirmation.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsZoneScope')]
    param (
        [Parameter(ParameterSetName='Remove2', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Remove2', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Alias('ZoneScope')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Remove2')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Remove2')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='Remove2')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Remove2')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Remove2')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Remove2')]
        [switch]
        ${AsJob}
    )
}

function Remove-DnsServerZoneTransferPolicy {
    <#
    .SYNOPSIS
        Removes a zone transfer policy from a DNS server.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER Name
        Specifies the name of the policy to remove.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as an FQDN, host name, or NETBIOS name.
    .PARAMETER Force
        Forces the command to run without asking for user confirmation.
    .PARAMETER ZoneName
        Specifies the name of a DNS zone. This cmdlet removes the policy from the zone that this parameter specifies.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='Server', SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerPolicy')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerPolicy')]
    param (
        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Zone', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='Zone', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [switch]
        ${AsJob}
    )
}

function Reset-DnsServerZoneKeyMasterRole {
    <#
    .SYNOPSIS
        Transfers the role of Key Master for a DNS zone.
    .PARAMETER ZoneName
        Specifies a name of a zone. The cmdlet transfers the Key Master role for this zone.
    .PARAMETER Force
        Transfers the role without prompting you for confirmation. By default, the cmdlet prompts you for confirmation before it proceeds.
    .PARAMETER KeyMasterServer
        Specifies the name of a DNS server. Use a NetBIOS name, IP address, or fully qualified domain name. The cmdlet makes this server the Key Master server for the specified zone. The specified zone must be present on the DNS server as a primary zone.
    .PARAMETER SeizeRole
        Indicates that this cmdlet seizes the Key Master role. Unless this switch is specified, the cmdlet does not make a change if it cannot reach the current Key Master server.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([System.String])]
    param (
        [Parameter(ParameterSetName='Reset0', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Reset0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='Reset0', Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${KeyMasterServer},

        [Parameter(ParameterSetName='Reset0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${SeizeRole},

        [Parameter(ParameterSetName='Reset0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Reset0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Reset0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Reset0')]
        [switch]
        ${AsJob}
    )
}

function Restore-DnsServerPrimaryZone {
    <#
    .SYNOPSIS
        Restores primary DNS zone contents from Active Directory or from a file.
    .PARAMETER Name
        Specifies the name of a zone.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER Force
        Indicates that this cmdlet restores DNS zone information without prompting you for confirmation. By default, the cmdlet prompts you for confirmation before it proceeds.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerPrimaryZone')]
    param (
        [Parameter(ParameterSetName='Restore0', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('ZoneName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Restore0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Restore0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Restore0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='Restore0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Restore0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Restore0')]
        [switch]
        ${AsJob}
    )
}

function Restore-DnsServerSecondaryZone {
    <#
    .SYNOPSIS
        Restores secondary zone information from its source.
    .PARAMETER Name
        Specifies the name of the secondary zone to restore.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER Force
        Updates the DNS zone without prompting you for confirmation. By default, the cmdlet prompts you for confirmation before it proceeds.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerSecondaryZone')]
    param (
        [Parameter(ParameterSetName='Restore1', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('ZoneName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Restore1')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Restore1')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Restore1')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='Restore1')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Restore1')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Restore1')]
        [switch]
        ${AsJob}
    )
}

function Resume-DnsServerZone {
    <#
    .SYNOPSIS
        Resumes name resolution on a suspended zone.
    .PARAMETER Name
        Specifies the name of a zone.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER Force
        Resumes name resolution without prompting you for confirmation. By default, the cmdlet prompts you for confirmation before it proceeds.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerZone')]
    param (
        [Parameter(ParameterSetName='Resume3', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('ZoneName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Resume3')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Resume3')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Resume3')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='Resume3')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Resume3')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Resume3')]
        [switch]
        ${AsJob}
    )
}

function Set-DnsServer {
    <#
    .SYNOPSIS
        Overwrites a DNS server configuration.
    .PARAMETER ComputerName
        Specifies a DNS server. The acceptable values for this parameter are: an IP v4 address; an IP v6 address; any other value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER Force
        Overrides the default confirmation setting before the cmdlet performs the action.
    .PARAMETER CreateFileBackedPrimaryZones
        Indicates that you must create new file-backed primary zones in the input object. The files that contains the resource records must exist in the %windir%\system32\dns directory.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServer')]
    param (
        [Parameter(ParameterSetName='Set1', Mandatory=$true, Position=1, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [PSTypeName('Microsoft.Management.Infrastructure.CimInstance#DnsServer')]
        [ciminstance]
        ${InputObject},

        [Parameter(ParameterSetName='Set1')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Set1')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='Set1')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${CreateFileBackedPrimaryZones},

        [Parameter(ParameterSetName='Set1')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Set1')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Set1')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Set1')]
        [switch]
        ${AsJob}
    )
}

function Set-DnsServerCache {
    <#
    .SYNOPSIS
        Modifies cache settings for a DNS server.
    .PARAMETER StoreEmptyAuthenticationResponse
        Specifies whether a DNS server stores empty authoritative responses in the cache (RFC-2308). We recommend that you limit this value to either 0x00000000 or 0x00000001, but you can specify any value. The default value is 0x00000001. You must allow and treat literally the value zero.
    .PARAMETER MaxKBSize
        Specifies the maximum size, in kilobytes, of the memory cache of a DNS server.
    .PARAMETER PollutionProtection
        Specifies whether DNS filters name service (NS) resource records that are cached. Valid values are zero, which caches all responses to name queries and is the default value; and one, which caches only the records that belong to the same DNS subtree.

        When you set this parameter value to False, cache pollution protection is disabled. A DNS server caches the Host (A) record and all queried NS resources that are in the DNS server zone. In this case, DNS can also cache the NS record of an unauthorized DNS server. This event causes name resolution to fail or to be appropriated for subsequent queries in the specified domain.

        When you set the value for this parameter to True, the DNS server enables cache pollution protection and ignores the Host (A) record. The DNS server performs a cache update query to resolve the address of the NS if the NS is outside the zone of the DNS server. The additional query minimally affects DNS server performance.

        For more information about DNS cache locking, see DNS Cache Locking. For more information about cache pollution protection, see Securing the DNS Server Service. For more information about NS resource records, see Managing resource records.
    .PARAMETER ComputerName
        Specifies a DNS server. The acceptable values for this parameter are: an IPv4 address, an IPv6 address, and any other value that resolves to an IP address, such as fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER LockingPercent
        Specifies a percentage of the original Time to Live (TTL) value that caching can consume.

        Cache locking is configured as a percent value. For example, if the cache locking value is set to 50, the DNS server does not overwrite a cached entry for half of the duration of the TTL. By default, the cache locking percent value is 100. This value means that the DNS server will not overwrite cached entries for the entire duration of the TTL.
    .PARAMETER MaxNegativeTtl
        Specifies how many seconds (0x1-0xFFFFFFFF) an entry that records a negative answer to a query remains stored in the DNS cache. The default setting is 0x384 (900) seconds
    .PARAMETER MaxTtl
        Specifies how many seconds (0x0-0xFFFFFFFF) a record is saved in cache. If you use the 0x0 setting, the DNS server does not cache records. The default setting is 0x15180 (86,400 seconds, or one day).
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER IgnorePolicies
        Indicates whether to ignore policies for this cache.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerCache')]
    param (
        [Parameter(ParameterSetName='Set2', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${StoreEmptyAuthenticationResponse},

        [Parameter(ParameterSetName='Set2', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${MaxKBSize},

        [Parameter(ParameterSetName='Set2', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${PollutionProtection},

        [Parameter(ParameterSetName='Set2')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Set2', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${LockingPercent},

        [Parameter(ParameterSetName='Set2', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${MaxNegativeTtl},

        [Parameter(ParameterSetName='Set2', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${MaxTtl},

        [Parameter(ParameterSetName='Set2')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Set2')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${IgnorePolicies},

        [Parameter(ParameterSetName='Set2')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Set2')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Set2')]
        [switch]
        ${AsJob}
    )
}

function Set-DnsServerClientSubnet {
    <#
    .SYNOPSIS
        Updates the IP addresses in a client subnet.
    .PARAMETER Name
        Specifies the name of the client subnet to modify.
    .PARAMETER IPv4Subnet
        Specifies an array IPv4 subnet addresses in Classless Interdomain Routing (CIDR) notation.
    .PARAMETER IPv6Subnet
        Specifies an array IPv6 subnet addresses in CIDR notation.
    .PARAMETER Action
        Specifies whether to add to, remove, or replace the IP addresses in the client subnet. The acceptable values for this parameter are:
        -- ADD
        -- REMOVE
        -- REPLACE
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerClientSubnet')]
    param (
        [Parameter(ParameterSetName='Set3', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Set3', Position=3, ValueFromPipelineByPropertyName=$true)]
        [string[]]
        ${IPv4Subnet},

        [Parameter(ParameterSetName='Set3', Position=4, ValueFromPipelineByPropertyName=$true)]
        [string[]]
        ${IPv6Subnet},

        [Parameter(ParameterSetName='Set3', Mandatory=$true, Position=2)]
        [ValidateSet('ADD','REMOVE','REPLACE')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Action},

        [Parameter(ParameterSetName='Set3')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Set3')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Set3')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Set3')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Set3')]
        [switch]
        ${AsJob}
    )
}

function Set-DnsServerConditionalForwarderZone {
    <#
    .SYNOPSIS
        Changes settings for a DNS conditional forwarder.
    .PARAMETER Name
        Specifies the name of a zone that has conditional forwarding configured.
    .PARAMETER ComputerName
        Specifies a DNS server to host the forwarder. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER DirectoryPartitionName
        Specifies a directory partition on which to store the forwarder. Conditional forwarders are internally stored as zones. Use this parameter when the ReplicationScope parameter has a value of Custom.
    .PARAMETER ReplicationScope
        Specifies the replication scope for the conditional forwarder. Conditional forwarders are stored internally as zones. The acceptable values for this parameter are:
        -- Custom. Replicate the conditional forwarder to all DNS servers running on domain controllers enlisted in a custom directory partition.
        -- Domain. Replicate the conditional forwarder to all DNS servers that run on domain controllers in the domain.
        -- Forest. Replicate the conditional forwarder to all DNS servers that run on domain controllers in the forest.
        -- Legacy. Replicate the conditional forwarder to all domain controllers in the domain.
    .PARAMETER UseRecursion
        Specifies whether a DNS server attempts to resolve a query after the forwarder fails to resolve it. A value of $False prevents a DNS server from attempting resolution using other DNS servers. This parameter overrides the Use Recursion setting for a DNS server.
    .PARAMETER MasterServers
        Specifies an array of IP addresses of the master servers of the zone. Conditional forwarders are stored as zones. You can use both IPv4 and IPv6 addresses. Specify at least one master server.
    .PARAMETER ForwarderTimeout
        Specifies a length of time, in seconds, that a DNS server waits for the forwarder to resolve a query. After the DNS server tries all forwarders, it can attempt to resolve the query itself. The minimum value is 0. The maximum value is 15.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='Parameters', SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerConditionalForwarderZone')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerConditionalForwarderZone')]
    param (
        [Parameter(ParameterSetName='Parameters', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ADZone', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('ZoneName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='ADZone')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='ADZone')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='ADZone', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${DirectoryPartitionName},

        [Parameter(ParameterSetName='ADZone', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('Forest','Domain','Legacy','Custom')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ReplicationScope},

        [Parameter(ParameterSetName='Parameters', Position=4, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${UseRecursion},

        [Parameter(ParameterSetName='Parameters', Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ipaddress[]]
        ${MasterServers},

        [Parameter(ParameterSetName='Parameters', Position=3, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${ForwarderTimeout},

        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='ADZone')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='ADZone')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='ADZone')]
        [switch]
        ${AsJob}
    )
}

function Set-DnsServerDiagnostics {
    <#
    .SYNOPSIS
        Sets debugging and logging parameters.
    .PARAMETER ComputerName
        Specifies a DNS server. The acceptable values for this parameter are: an IPv4 address, an IPv6 address, and any other value that resolves to an IP address, such as fully qualified domain name (FQDN), Hostname, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER All
        Specifies whether the DNS server logs all events.
    .PARAMETER DebugLogging
        Specifies the bitmask for debug logging. Valid values are:

        0x00000001. The server logs query packet exchanges.
        0x00000010. The server logs packet exchanges that are related to zone exchanges.
        0x00000020. The server logs packet exchanges that are related to zone updates.
        0x0000010.: The server logs packets that contain questions.
        0x00000200. The server logs packets that contain answers.
        0x00001000. The server logs packets that it sends.
        0x00002000. The server logs packets that it receives.
        0x00004000. The server logs User Datagram Protocol (UDP) packet exchanges.
        0x00008000. The server logs Transmission Control Protocol (TCP) packet exchanges.
        0x0000FFFF. The server logs operations if you set the following fields to $True: 0x00001000, 0x00002000, 0x00008000, 0x00004000, 0x00000001, 0x00000001, 0x00000020, 0x00000100, and 0x00000200S.
        0x00010000. Independent of other field values, this bitmap logs Active Directory write operations.
        0x00020000. Independent of other field values, this bitmap logs Active Directory polling operations and operations that occur during DNS updates (secure and not secure) on Active Directory-integrated zones.
        0x01000000. If other field values allow it, the server logs the entire packet to the log file.
        0x02000000. If other field values allow it, the server logs response packets that do not match any outstanding queries.
        0x80000000. If other field values allow it, the server saves packet logging information to persistent storage.
    .PARAMETER OperationLogLevel2
        Specifies the additional operations that the DNS server logs. The default valid value is:

        0x01000000. Valid values for this parameter are: 0x01, 0x02, and 0x03.The DNS server logs operational logging information for activities that are related to interaction with plug-in DLLs to the log file.
    .PARAMETER OperationLogLevel1
        Specifies a bit flag for the logging level. Valid values are:

        0x00000001. The DNS server saves operational logging information to persistent storage.
        0x00000010: The DNS server logs event logging information to a log file.
        0x00000020: The DNS server logs operational logging information for server start and stop activities to the log file.
        0x00002000: The DNS server logs operational logging information for activities that are related to loading a zone from a directory server to the log file.
        0x00004000. The DNS server logs operational logging information for activities that are related to writing zone data to the directory server to the log file.
        0x00020000. The DNS server logs operational logging information for activities that are related to updating nodes that have exceeded the tombstone lifetime to the log file.
        0x00100000: The DNS server logs operational logging information for local resource lookup activities to the log file.
        0x00200000. The DNS server logs operational logging information for activities that occur during recursive query lookup to the log file.
        0x00400000. The DNS server logs operational logging information for activities that are related to interaction with remote name servers to the log file.
    .PARAMETER Answers
        Specifies wheter to enable the logging of DNS responses.
    .PARAMETER EventLogLevel
        Specifies an event log level. Valid values are Warning, Error, and None.
    .PARAMETER FullPackets
        Specifies whether the DNS server logs full packets.
    .PARAMETER IPFilterList
        Specifies an array of IP addresses to filter. When you enable logging, traffic to and from these IP addresses is logged. If you do not specify any IP addresses, traffic to and from all IP addresses is logged.
    .PARAMETER LogFilePath
        Specifies a log file path.
    .PARAMETER MaxMBFileSize
        Specifies the maximum size of the log file. This parameter is relevant if you set EnableLogFileRollover and EnableLoggingToFile to $True.
    .PARAMETER EnableLoggingForRemoteServerEvent
        Specifies whether the DNS server logs remote server events.
    .PARAMETER EnableLoggingForPluginDllEvent
        Specifies whether the DNS server logs dynamic link library (DLL) plug-in events.
    .PARAMETER UseSystemEventLog
        Specifies whether the DNS server uses the system event log for logging.
    .PARAMETER EnableLogFileRollover
        Specifies whether to enable log file rollover.
    .PARAMETER EnableLoggingForZoneLoadingEvent
        Specifies whether the DNS server logs zone load events.
    .PARAMETER EnableLoggingForLocalLookupEvent
        Specifies whether the DNS server logs local lookup events.
    .PARAMETER EnableLoggingToFile
        Specifies whether the DNS server logs logging-to-file.
    .PARAMETER EnableLoggingForZoneDataWriteEvent
        Specifies Controls whether the DNS server logs zone data write events.
    .PARAMETER EnableLoggingForTombstoneEvent
        Specifies whether the DNS server logs tombstone events.
    .PARAMETER EnableLoggingForRecursiveLookupEvent
        Specifies whether the DNS server logs recursive lookup events.
    .PARAMETER UdpPackets
        Specifies whether the DNS server logs UDP packets.
    .PARAMETER UnmatchedResponse
        Specifies whether the DNS server logs unmatched responses.
    .PARAMETER Updates
        Specifies whether the DNS server logs updates.
    .PARAMETER WriteThrough
        Specifies whether the DNS server logs write-throughs.
    .PARAMETER SaveLogsToPersistentStorage
        Specifies whether the DNS server saves logs to persistent storage.
    .PARAMETER EnableLoggingForServerStartStopEvent
        Specifies whether the DNS server logs server start and stop events.
    .PARAMETER Notifications
        Specifies whether the DNS server logs notifications.
    .PARAMETER Queries
        Specifies whether the DNS server allows query packet exchanges to pass through the content filter, such as the IPFilterList parameter.
    .PARAMETER QuestionTransactions
        Specifies whether the DNS server logs queries.
    .PARAMETER ReceivePackets
        Specifies whether the DNS server logs receive packets.
    .PARAMETER SendPackets
        Specifies whether the DNS server logs send packets.
    .PARAMETER TcpPackets
        Specifies whether the DNS server logs TCP packets.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='Parameters', SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerDiagnostics')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerDiagnostics')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerDiagnostics')]
    param (
        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='LogLevel')]
        [Parameter(ParameterSetName='All')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='LogLevel')]
        [Parameter(ParameterSetName='All')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='All', Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${All},

        [Parameter(ParameterSetName='LogLevel', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${DebugLogging},

        [Parameter(ParameterSetName='LogLevel', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${OperationLogLevel2},

        [Parameter(ParameterSetName='LogLevel', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${OperationLogLevel1},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${Answers},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${EventLogLevel},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${FullPackets},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [Alias('FilterIPAddressList')]
        [ipaddress[]]
        ${IPFilterList},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [string]
        ${LogFilePath},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${MaxMBFileSize},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${EnableLoggingForRemoteServerEvent},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${EnableLoggingForPluginDllEvent},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${UseSystemEventLog},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${EnableLogFileRollover},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${EnableLoggingForZoneLoadingEvent},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${EnableLoggingForLocalLookupEvent},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${EnableLoggingToFile},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${EnableLoggingForZoneDataWriteEvent},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${EnableLoggingForTombstoneEvent},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${EnableLoggingForRecursiveLookupEvent},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${UdpPackets},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${UnmatchedResponse},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${Updates},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${WriteThrough},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${SaveLogsToPersistentStorage},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${EnableLoggingForServerStartStopEvent},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${Notifications},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${Queries},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${QuestionTransactions},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${ReceivePackets},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${SendPackets},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${TcpPackets},

        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='LogLevel')]
        [Parameter(ParameterSetName='All')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='LogLevel')]
        [Parameter(ParameterSetName='All')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='LogLevel')]
        [Parameter(ParameterSetName='All')]
        [switch]
        ${AsJob}
    )
}

function Set-DnsServerDnsSecZoneSetting {
    <#
    .SYNOPSIS
        Changes settings for DNSSEC for a zone.
    .PARAMETER ZoneName
        Specifies the name of a DNS zone.
    .PARAMETER DenialOfExistence
        Specifies which version of NSEC to use. A DNS server uses this setting to provide signed proof of an unregistered name.

        The acceptable values for this parameter are:
        -- NSec
        -- NSec3
    .PARAMETER NSec3HashAlgorithm
        Specifies an NSEC3 hash algorithm. The only possible value is RsaSha1.
    .PARAMETER NSec3Iterations
        Specifies a number of NSEC3 hash iterations to perform when it signs a DNS zone. The default value is 50.
    .PARAMETER NSec3OptOut
        Specifies whether to sign the DNS zone by using NSEC opt-out. The default value is $False.
    .PARAMETER NSec3RandomSaltLength
        Specifies the length of a salt value. The default length is 8.
    .PARAMETER NSec3UserSalt
        Specifies a user salt string. The default value is Null or -.
    .PARAMETER DistributeTrustAnchor
        Specifies an array of trust anchors that a DNS server distributes in Active Directory® Domain Services. DNS servers do not distribute trust anchors by default. If the DNS server is not also a domain controller, it adds trust anchors only to the local trust anchor store.
    .PARAMETER EnableRfc5011KeyRollover
        Specifies whether a server uses RFC 5011 key rollover.
    .PARAMETER DSRecordGenerationAlgorithm
        Specifies an array of cryptographic algorithms for domain service records. The acceptable values for this parameter are:
        -- Sha1
        -- Sha256
        -- Sha384
    .PARAMETER DSRecordSetTtl
        Specifies a TTL time span for the set of domain service records. The default value is the same as the TTL for the zone.
    .PARAMETER DnsKeyRecordSetTtl
        Specifies a time-span object that represents the Time to Live (TTL) value of a DNS key record.
    .PARAMETER SignatureInceptionOffset
        Specifies the signature inception as a time-span object. This value is how far in the past DNSSEC signature validity periods begin. The default value is one hour.
    .PARAMETER SecureDelegationPollingPeriod
        Specifies a delegation polling period as a time-span object. This is the time between polling attempts for key rollovers for child zones. The default value is 12 hours.
    .PARAMETER PropagationTime
        Specifies a propagation time as a time-span object. This is the expected time required to propagate zone changes. The default value is 2 days.
    .PARAMETER ParentHasSecureDelegation
        Specifies whether a parent has secure delegation for a zone. The default value is $False.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='DnsSecSetting', SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerDnsSecZoneSetting')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerZoneSigningMetadata')]
    param (
        [Parameter(ParameterSetName='SigningMetadata', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='DnsSecSetting', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='DnsSecSetting', Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('NSec','NSec3')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${DenialOfExistence},

        [Parameter(ParameterSetName='DnsSecSetting', ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('RsaSha1')]
        [string]
        ${NSec3HashAlgorithm},

        [Parameter(ParameterSetName='DnsSecSetting', ValueFromPipelineByPropertyName=$true)]
        [uint16]
        ${NSec3Iterations},

        [Parameter(ParameterSetName='DnsSecSetting', ValueFromPipelineByPropertyName=$true)]
        [bool]
        ${NSec3OptOut},

        [Parameter(ParameterSetName='DnsSecSetting', ValueFromPipelineByPropertyName=$true)]
        [byte]
        ${NSec3RandomSaltLength},

        [Parameter(ParameterSetName='DnsSecSetting', ValueFromPipelineByPropertyName=$true)]
        [ValidateLength(1, 510)]
        [string]
        ${NSec3UserSalt},

        [Parameter(ParameterSetName='DnsSecSetting', ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('None','DnsKey')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string[]]
        ${DistributeTrustAnchor},

        [Parameter(ParameterSetName='DnsSecSetting', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${EnableRfc5011KeyRollover},

        [Parameter(ParameterSetName='DnsSecSetting', ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('None','Sha1','Sha256','Sha384')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string[]]
        ${DSRecordGenerationAlgorithm},

        [Parameter(ParameterSetName='DnsSecSetting', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${DSRecordSetTtl},

        [Parameter(ParameterSetName='DnsSecSetting', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${DnsKeyRecordSetTtl},

        [Parameter(ParameterSetName='DnsSecSetting', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${SignatureInceptionOffset},

        [Parameter(ParameterSetName='DnsSecSetting', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${SecureDelegationPollingPeriod},

        [Parameter(ParameterSetName='DnsSecSetting', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${PropagationTime},

        [Parameter(ParameterSetName='DnsSecSetting', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${ParentHasSecureDelegation},

        [Parameter(ParameterSetName='SigningMetadata')]
        [Parameter(ParameterSetName='DnsSecSetting')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='SigningMetadata')]
        [Parameter(ParameterSetName='DnsSecSetting')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='SigningMetadata', Position=2, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [PSTypeName('Microsoft.Management.Infrastructure.CimInstance#DnsServerZoneSigningMetadata')]
        [ciminstance]
        ${InputObject},

        [Parameter(ParameterSetName='SigningMetadata')]
        [Parameter(ParameterSetName='DnsSecSetting')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='SigningMetadata')]
        [Parameter(ParameterSetName='DnsSecSetting')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='SigningMetadata')]
        [Parameter(ParameterSetName='DnsSecSetting')]
        [switch]
        ${AsJob}
    )
}

function Set-DnsServerDsSetting {
    <#
    .SYNOPSIS
        Modifies DNS Active Directory settings.
    .PARAMETER DirectoryPartitionAutoEnlistInterval
        Specifies the interval, during which a DNS server tries to enlist itself in a DNS domain partition and DNS forest partition, if it is not already enlisted. We recommend that you limit this value to the range one hour to 180 days, inclusive, but you can use any value. We recommend that you set the default value to one day. You must set the value 0 (zero) as a flag value for the default value. However, you can allow zero and treat it literally.
    .PARAMETER LazyUpdateInterval
        Specifies a value, in seconds, to determine how frequently the DNS server submits updates to the directory server without specifying the LDAP_SERVER_LAZY_COMMIT_OID control ([MS-ADTS] section 3.1.1.3.4.1.7) at the same time that it processes DNS dynamic update requests. We recommend that you limit this value to the range 0x00000000 to 0x0000003c. You must set the default value to 0x00000003. You must set the value zero to indicate that the DNS server does not specify the LDAP_SERVER_LAZY_COMMIT_OID control at the same time that it processes DNS dynamic update requests. For more information about LDAP_SERVER_LAZY_COMMIT_OID, see LDAP_SERVER_LAZY_COMMIT_OID control code.

        The LDAP_SERVER_LAZY_COMMIT_OID control instructs the DNS server to return the results of a directory service modification command after it is completed in memory but before it is committed to disk. In this way, the server can return results quickly and save data to disk without sacrificing performance.

        The DNS server must send this control only to the directory server that is attached to an LDAP update that the DNS server initiates in response to a DNS dynamic update request.

        If the value is nonzero, LDAP updates that occur during the processing of DNS dynamic update requests must not specify the LDAP_SERVER_LAZY_COMMIT_OID control if a period of less than DsLazyUpdateInterval seconds has passed since the last LDAP update that specifies this control. If a period that is greater than DsLazyUpdateInterval seconds passes, during which time the DNS server does not perform an LDAP update that specifies this control, the DNS server must specify this control on the next update.
    .PARAMETER MinimumBackgroundLoadThreads
        Specifies the minimum number of background threads that the DNS server uses to load zone data from the directory service. You must limit this value to the range 0x00000000 to 0x00000005, inclusive. You must set the default value to 0x00000001, and you must treat the value zero as a flag value for the default value.
    .PARAMETER RemoteReplicationDelay
        Specifies the minimum interval, in seconds, that the DNS server waits between the time that it determines that a single object has changed on a remote directory server, to the time that it tries to replicate a single object change. You must limit the value to the range 0x00000005 to 0x00000E10, inclusive. You must set the default value to 0x0000001E, and you must treat the value zero as a flag value for the default value.
    .PARAMETER ComputerName
        Specifies a DNS server. The acceptable values for this parameter are: an IPv4 address; an IPv6 address; and any other value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PollingInterval
        Specifies how frequently the DNS server polls Active Directory Domain Services (AD DS) for changes in Active Directory–integrated zones. You must limit the value to the range 30 seconds to 3,600 seconds, inclusive.
    .PARAMETER TombstoneInterval
        Specifies the amount of time that DNS keeps tombstoned records alive in Active Directory. We recommend that you limit this value to the range three days to eight weeks, inclusive, but you can set it to any value in the range 82 hours to 8 weeks. We recommend that you set the default value to 14 days and treat the value zero as a flag value for the default. However, you can allow the value zero and treat it literally.

        At 2:00 A.M. local time every day, the DNS server must search all directory service zones for nodes that have the Active Directory dnsTombstoned attribute set to True, and for a directory service EntombedTime (section 2.2.2.2.3.23 of MS-DNSP) value that is greater than previous directory service DSTombstoneInterval seconds. You must permanently delete all such nodes from the directory server.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerDsSetting')]
    param (
        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${DirectoryPartitionAutoEnlistInterval},

        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${LazyUpdateInterval},

        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${MinimumBackgroundLoadThreads},

        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${RemoteReplicationDelay},

        [Parameter(ParameterSetName='Set1')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${PollingInterval},

        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${TombstoneInterval},

        [Parameter(ParameterSetName='Set1')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Set1')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Set1')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Set1')]
        [switch]
        ${AsJob}
    )
}

function Set-DnsServerEDns {
    <#
    .SYNOPSIS
        Changes EDNS settings on a DNS server.
    .PARAMETER CacheTimeout
        Specifies the number of seconds that the DNS server caches EDNS information. The default value is 604,800 seconds (one week).
    .PARAMETER EnableProbes
        Specifies whether to enable the server to probe other servers to determine whether they support EDNS.
    .PARAMETER EnableReception
        Specifies whether the DNS server accepts queries that contain an EDNS record.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerEDns')]
    param (
        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${CacheTimeout},

        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${EnableProbes},

        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${EnableReception},

        [Parameter(ParameterSetName='Set1')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Set1')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Set1')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Set1')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Set1')]
        [switch]
        ${AsJob}
    )
}

function Set-DnsServerForwarder {
    <#
    .SYNOPSIS
        Changes forwarder settings on a DNS server.
    .PARAMETER IPAddress
        Specifies an array of IP addresses of DNS servers where queries are forwarded. Specify the forwarders in the order that you want them to be configured.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER UseRootHint
        Specifies whether to prevent the DNS server from performing iterative queries. If you set UseRootHint to $false, the DNS server forwards unresolved queries only to the DNS servers in the forwarders list and does not try iterative queries if the forwarders do not resolve the queries.
    .PARAMETER Timeout
        Specifies the number of seconds that the DNS server waits for a response from the forwarder. The minimum value is 0, and the maximum value is 15. The default value is 5.
    .PARAMETER EnableReordering
        Specifies wheter to enable the DNS server to reorder forwarders dynamically.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerForwarder')]
    param (
        [Parameter(ParameterSetName='Set3', Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ipaddress[]]
        ${IPAddress},

        [Parameter(ParameterSetName='Set3')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Set3', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${UseRootHint},

        [Parameter(ParameterSetName='Set3', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${Timeout},

        [Parameter(ParameterSetName='Set3', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${EnableReordering},

        [Parameter(ParameterSetName='Set3')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Set3')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Set3')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Set3')]
        [switch]
        ${AsJob}
    )
}

function Set-DnsServerGlobalNameZone {
    <#
    .SYNOPSIS
        Changes configuration settings for a GlobalNames zone.
    .PARAMETER AlwaysQueryServer
        Specifies whether a DNS server attempts to use cache values to update a list of DNS servers. This value has no effect if the DNS server hosts a GlobalNames zone.

        If the value is $True, a DNS server queries a remote DNS server for an update to the list of remote DNS servers that are hosting a GlobalNames zone.

        If the value is $False, a DNS server attempts to use cached local service records for a GlobalNames zone to get an update to the list.

        The default value is $False.
    .PARAMETER BlockUpdates
        Specifies whether a DNS server blocks updates in authoritative zones for FQDNs that conflict with labels in a GlobalNames zone. If the value is $True, a DNS server checks for a conflict and blocks an update when it finds a conflict. If the value is $False, the server does not check. The default value is $True.

        To check for conflicts, the DNS server removes the zone name (rightmost labels) and performs a search that is not case sensitive on its locally hosted GlobalNames zone.
    .PARAMETER Enable
        Specifies whether to use a GlobalNames zone to resolve single-label names. A value of $True enables the use of GlobalNames. A value of $False disables the use of GlobalNames.
    .PARAMETER EnableEDnsProbes
        Specifies whether a DNS server honors the EnableEDnsProbes value for a remote GlobalNames zone. A DNS server can allow or refuse queries on Extended DNS (EDNS) information.

        If this value is $True, the server attempts EDNS queries for remote GlobalNames zones if the zones permit.

        If this value is $False, a DNS server does not attempt ENDS queries for remote GlobalNames zones.

        The default value is $False.
    .PARAMETER GlobalOverLocal
        Specifies whether a DNS server first attempts to resolve names through a query of zones for which it is authoritative. If the value is $True, a DNS server queries locally and then queries the GlobalNames zone. If the value is $False, the server queries the GlobalNames zone and then queries globally. The default value is $False.
    .PARAMETER PreferAaaa
        Specifies whether a DNS server prefers IPv6 (AAAA) address records over IPv4 (A) address records for queries to a remote DNS server that hosts a GlobalNames zone.

        If this value is $True, a DNS server uses IPv6 addresses, unless no IPv6 value is available.

        If this value is $False, a DNS server uses IPv4 addresses, unless no IPv4 value is available.

        The default value is $False.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER SendTimeout
        Specifies the number of seconds that a DNS server waits for a response to a query to a remote GlobalNames zone.

        The minimum value is 1. The maximum value is 15.

        The default value is 3. A DNS server interprets a value of 0 as the default value, 3.
    .PARAMETER ServerQueryInterval
        Specifies an interval, as a time-span object, between queries to refresh the set of remote DNS servers that are hosting the GlobalNames zone.

        The minimum value is 60 seconds. The maximum value is 30 days.

        The default value is six hours. A DNS server interprets a value of 0 as the default value, six hours.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerGlobalNameZone')]
    param (
        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${AlwaysQueryServer},

        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${BlockUpdates},

        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${Enable},

        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${EnableEDnsProbes},

        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${GlobalOverLocal},

        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${PreferAaaa},

        [Parameter(ParameterSetName='Set1')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${SendTimeout},

        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${ServerQueryInterval},

        [Parameter(ParameterSetName='Set1')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Set1')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Set1')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Set1')]
        [switch]
        ${AsJob}
    )
}

function Set-DnsServerGlobalQueryBlockList {
    <#
    .SYNOPSIS
        Changes settings of a global query block list.
    .PARAMETER Enable
        Specifies whether the server enables support for the global query block list that blocks name resolution for names in the list. The DNS Server service creates and enables the global query block list by default the first time that the service starts.

        When you disable the global query block list, the DNS Server service responds to queries for names in the block list. When you enable the global query block list, the DNS Server service does not respond to queries for names in the block list.
    .PARAMETER List
        Specifies an array of host names.

        This cmdlet replaces the current global query block list with a list of the names that you specify. To add a name to the list, you must also include all existing names in the list. If you do not specify any names, the cmdlet clears the block list.

        By default, the global query block list contains the following items: ISATAP and WPAD. The DNS Server service removes these names when it starts the first time if it finds these names in an existing zone. If you need the DNS server to resolve names such as ISATAP and WPAD, remove them from the list.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerGlobalQueryBlockList')]
    param (
        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${Enable},

        [Parameter(ParameterSetName='Set1', Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [AllowEmptyString()]
        [string[]]
        ${List},

        [Parameter(ParameterSetName='Set1')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Set1')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Set1')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Set1')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Set1')]
        [switch]
        ${AsJob}
    )
}

function Set-DnsServerPrimaryZone {
    <#
    .SYNOPSIS
        Changes settings for a DNS primary zone.
    .PARAMETER Name
        Specifies the name of a zone.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER ReplicationScope
        Specifies a partition on which to store an Active Directory-integrated zone. The acceptable values for this parameter are:
        -- Custom. Any custom directory partition that a user creates. Specify a custom directory partition by using the DirectoryPartitionName parameter.
        -- Domain. The domain directory partition.
        -- Forest. The ForestDnsZone directory partition.
        -- Legacy. A legacy directory partition.
    .PARAMETER DirectoryPartitionName
        Specifies a directory partition on which to store the zone. Use this parameter when the ReplicationScope parameter has a value of Custom.
    .PARAMETER ZoneFile
        Specifies the name of the zone file. This parameter is relevant only for file-backed DNS.
    .PARAMETER AllowedDcForNsRecordsAutoCreation
        Specifies IP addresses of domain controllers that add their names in Name Server (NS) resource records for the zone.
    .PARAMETER DynamicUpdate
        Specifies how a zone accepts dynamic updates. Servers that accept dynamic updates can receive client registration requests. The acceptable values for this parameter are:
        -- None
        -- Secure
        -- NonsecureAndSecure

        DNS update security is available only for Active Directory-integrated zones.
    .PARAMETER Notify
        Specifies how a DNS master server notifies secondary servers of changes to resource records. The acceptable values for this parameter are:
        -- NoNotify. The zone does not send change notifications to secondary servers.
        -- Notify. The zone sends change notifications to all secondary servers.
        -- NotifyServers. The zone sends change notifications to some secondary servers. If you choose this option, specify the list of secondary servers in the NotifyServers parameter.
    .PARAMETER NotifyServers
        Specifies an array of IP addresses of secondary DNS servers that the DNS master server notifies of changes to resource records. You need this parameter only if you selected the value NotifyServers for the Notify parameter.
    .PARAMETER SecondaryServers
        Specifies an array of IP addresses of DNS servers that are allowed to receive this zone through zone transfers.
    .PARAMETER SecureSecondaries
        Specifies how a DNS master server allows zone transfers to secondary servers. You can configure the DNS server to send zone transfers only certain servers. If other servers request zone transfers, the DNS server rejects the requests.

        The acceptable values for this parameter are:
        -- NoTransfer. Zone transfers are not allowed on this DNS server for this zone.
        -- TransferAnyServer. Zone transfers are allowed to any DNS server.
        -- TransferToZoneNameServer. Zone transfers are allowed only to servers in the name servers (NS) records for this zone.
        -- TransferToSecureServers. Zone transfers are allowed only for secondary servers.
    .PARAMETER IgnorePolicies
        Indicates whether to ignore policies for this zone.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='Parameters', SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerPrimaryZone')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerPrimaryZone')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerPrimaryZone')]
    param (
        [Parameter(ParameterSetName='Parameters', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='FileZone', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ADZone', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('ZoneName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='FileZone')]
        [Parameter(ParameterSetName='ADZone')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='FileZone')]
        [Parameter(ParameterSetName='ADZone')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='ADZone', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('Forest','Domain','Legacy','Custom')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ReplicationScope},

        [Parameter(ParameterSetName='ADZone', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${DirectoryPartitionName},

        [Parameter(ParameterSetName='FileZone', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneFile},

        [Parameter(ParameterSetName='FileZone', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${VirtualizationInstance},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [string[]]
        ${AllowedDcForNsRecordsAutoCreation},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('None','Secure','NonsecureAndSecure')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${DynamicUpdate},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('NoNotify','Notify','NotifyServers')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Notify},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [ipaddress[]]
        ${NotifyServers},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [ipaddress[]]
        ${SecondaryServers},

        [Parameter(ParameterSetName='Parameters', ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('NoTransfer','TransferAnyServer','TransferToZoneNameServer','TransferToSecureServers')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${SecureSecondaries},

        [Parameter(ParameterSetName='Parameters')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${IgnorePolicies},

        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='FileZone')]
        [Parameter(ParameterSetName='ADZone')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='FileZone')]
        [Parameter(ParameterSetName='ADZone')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Parameters')]
        [Parameter(ParameterSetName='FileZone')]
        [Parameter(ParameterSetName='ADZone')]
        [switch]
        ${AsJob}
    )
}

function Set-DnsServerQueryResolutionPolicy {
    <#
    .SYNOPSIS
        Updates settings of a query resolution policy on a DNS server.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as an FQDN, host name, or NETBIOS name.
    .PARAMETER ZoneName
        Specifies the name of a DNS zone on which the zone level policy. The zone must exist on the DNS server.
    .PARAMETER Name
        Specifies the name of the policy to modify.
    .PARAMETER TransportProtocol
        Specifies the transport protocol criterion. Specify a criterion in the following format:
        operator, value01, value02, . . . , operator, value03, value04, . . .
        The operator is either EQ or NE. You can specify no more than one of each operator in the string.

        The policy treats values the follow the EQ operator as multiple assertions which are logically combined (OR'd). The policy treats values that follow the NE operator as multiple assertions which are logically differenced (AND'd). The criterion is satisfied if the transport protocol of the request matches one of the EQ values and does not match any of the NE values.
    .PARAMETER TimeOfDay
        Specifies the time of day criterion. Specify a criterion in the following format:
        operator, value01, value02, . . . , operator, value03, value04, . . .
        The operator is either EQ or NE. You can specify no more than one of each operator in the criterion.

        The policy treats values the follow the EQ operator as multiple assertions which are logically combined (OR'd). The policy treats values that follow the NE operator as multiple assertions which are logically differenced (AND'd). The criterion is satisfied if the time of day of the request matches one of the EQ values and does not match any of the NE values.
    .PARAMETER RecursionScope
        Specifies the scope of recursion. If the policy is a recursion policy, and if a query matches it, the DNS server uses settings from this scope to perform recursion for the query.
    .PARAMETER ServerInterfaceIP
        Specifies the IP address of the server interface on which the DNS server listens. Specify a criterion in the following format:
        operator, value01, value02, . . . , operator, value03, value04, . . .
        The operator is either EQ or NE. You can specify no more than one of each operator in the criterion.

        The policy treats values the follow the EQ operator as multiple assertions which are logically combined (OR'd). The policy treats values that follow the NE operator as multiple assertions which are logically differenced (AND'd). The criterion is satisfied if the IP address of the interface matches one of the EQ values and does not match any of the NE values.
    .PARAMETER QType
        Specifies the query type criterion. Specify a criterion in the following format:
        operator, value01, value02, . . . , operator, value03, value04, . . .
        The operator is either EQ or NE. You can specify no more than one of each operator in a criterion.

        The policy treats values the follow the EQ operator as multiple assertions which are logically combined (OR'd). The policy treats values that follow the NE operator as multiple assertions which are logically differenced (AND'd). The criterion is satisfied if the type of query of the request matches one of the EQ values and does not match any of the NE values.
    .PARAMETER ProcessingOrder
        Specifies the precedence of the policy. Higher integer values have lower precedence. By default, this cmdlet adds a new policy as the lowest precedence.

        If this cmdlet changes the processing order to be equal to the processing order of an existing policy, then the DNS server updates the processing order of the existing policies.
    .PARAMETER ClientSubnet
        Specifies the client subnet criterion. Specify a criterion in the following format:
        operator, value01, value02, . . . , operator, value03, value04, . . .
        The operator is either EQ or NE. You can specify no more than one of each operator in a criterion.

        The policy treats values that follow the EQ operator as multiple assertions which are logically combined (OR'd). The policy treats values that follow the NE operator as multiple assertions which are logically differenced (AND'd). The criterion is satisfied if the subnet of the request matches one of the EQ values and does not match any of the NE values.
    .PARAMETER Condition
        Specifies how the policy treats multiple criteria. The acceptable values for this parameter are:
        -- OR. The policy evaluates criteria as multiple assertions which are logically combined (OR'd).
        -- AND. The policy evaluates criteria as multiple assertions which are logically differenced (AND'd).
        The default value is AND.
    .PARAMETER InternetProtocol
        Specifies the Internet Protocol criterion. Specify a criterion in the following format:
        operator, value01, value02, . . . , operator, value03, value04, . . .
        The operator is either EQ or NE. You can specify no more than one of each operator in a criterion.

        The policy treats values that follow the EQ operator as multiple assertions which are logically combined (OR'd). The policy treats values that follow the NE operator as multiple assertions which are logically differenced (AND'd). The criterion is satisfied if the IP address of the request matches one of the EQ values and does not match any of the NE values.
    .PARAMETER Fqdn
        Specifies the FQDN criterion. Specify a criterion in the following format:
        operator, value01, value02, . . . , operator, value03, value04, . . .
        The operator is either EQ or NE. You can specify no more than one of each operator a criterion.

        The policy treats values that follow the EQ operator as multiple assertions which are logically combined (OR'd). The policy treats values that follow the NE operator as multiple assertions which are logically differenced (AND'd). The criterion is satisfied if the FQDN of the request matches one of the EQ values and does not match any of the NE values. You can include the asterisk (*) as the wildcard character. For example, EQ,*.contoso.com,NE,*.fabricam.com.
    .PARAMETER ZoneScope
        Specifies a list of scopes and weights for the zone. Specify the value as a string in this format:
        Scope01, Weight01; Scope02, Weight02;
        If you do not specify the weight, the default value is one (1).
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='Server', SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerPolicy')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerPolicy')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerPolicy')]
    param (
        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [Parameter(ParameterSetName='InputObject')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [Parameter(ParameterSetName='InputObject')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='InputObject', Mandatory=$true, Position=1, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [PSTypeName('Microsoft.Management.Infrastructure.CimInstance#DnsServerPolicy')]
        [ciminstance]
        ${InputObject},

        [Parameter(ParameterSetName='Zone', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='InputObject')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Zone', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [AllowEmptyString()]
        [string]
        ${TransportProtocol},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [AllowEmptyString()]
        [string]
        ${TimeOfDay},

        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${RecursionScope},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [AllowEmptyString()]
        [string]
        ${ServerInterfaceIP},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [AllowEmptyString()]
        [string]
        ${QType},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${ProcessingOrder},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [AllowEmptyString()]
        [string]
        ${ClientSubnet},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('AND','OR')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Condition},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [AllowEmptyString()]
        [string]
        ${InternetProtocol},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [AllowEmptyString()]
        [string]
        ${Fqdn},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneScope},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [Parameter(ParameterSetName='InputObject')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [Parameter(ParameterSetName='InputObject')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [Parameter(ParameterSetName='InputObject')]
        [switch]
        ${AsJob}
    )
}

function Set-DnsServerRecursion {
    <#
    .SYNOPSIS
        Modifies recursion settings for a DNS server.
    .PARAMETER ComputerName
        Specifies a DNS server. The acceptable values for this parameter are: an IPv4 address; an IPv6 address; and any other value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER AdditionalTimeout
        Specifies the time interval, in seconds, that a DNS server waits as it uses recursion to get resource records from a remote DNS server. We recommend that you limit the value to the range 0x00000000 to 0x0000000F (0 seconds to 15 seconds), inclusive. However, you can use any value. We recommend that you set the default value to 4.
    .PARAMETER RetryInterval
        Specifies elapsed seconds before a DNS server retries a recursive lookup. If the parameter is undefined or zero, the DNS server retries after three seconds. Valid values are in the range of 1 second to 15 seconds.

        We recommend that in general, you do not change the value of this parameter. However, under a few circumstances you should consider changing the parameter value. For example, if a DNS server contacts a remote DNS server over a slow link and retries the lookup before it gets a response, you can raise the retry interval to be slightly longer than the observed response time.
    .PARAMETER Timeout
        Specifies the number of seconds that a DNS server waits before it stops trying to contact a remote server. The valid value is in the range of 0x1 to 0xFFFFFFFF (1 second to 15 seconds). The default setting is 0xF (15 seconds). We recommend that you increase this value when recursion occurs over a slow link.
    .PARAMETER Enable
        Specifies whether the server enables recursion.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER SecureResponse
        Indicates whether a DNS server screens DNS records against the zone of authority for the remote server, to prevent cache pollution. If you set this to $True, the DNS server caches only those records that are in the zone of authority for the queried remote server. Otherwise, the server caches all records in the remote server cache.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerRecursion')]
    param (
        [Parameter(ParameterSetName='Set1')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${AdditionalTimeout},

        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${RetryInterval},

        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${Timeout},

        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [Alias('EnableRecursion')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${Enable},

        [Parameter(ParameterSetName='Set1')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${SecureResponse},

        [Parameter(ParameterSetName='Set1')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Set1')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Set1')]
        [switch]
        ${AsJob}
    )
}

function Set-DnsServerRecursionScope {
    <#
    .SYNOPSIS
        Modifies a recursion scope on a DNS server.
    .PARAMETER EnableRecursion
        Indicates whether to enable recursion.
    .PARAMETER Forwarder
        Specifies an array IP addresses of forwarders for this recursion scope.
    .PARAMETER Name
        Specifies the name of the recursion scope to modify.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerRecursionScope')]
    param (
        [Parameter(ParameterSetName='Set3', Position=3, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${EnableRecursion},

        [Parameter(ParameterSetName='Set3', Position=2, ValueFromPipelineByPropertyName=$true)]
        [ipaddress[]]
        ${Forwarder},

        [Parameter(ParameterSetName='Set3', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Set3')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Set3')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Set3')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Set3')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Set3')]
        [switch]
        ${AsJob}
    )
}

function Set-DnsServerResourceRecord {
    <#
    .SYNOPSIS
        Changes a resource record in a DNS zone.
    .PARAMETER NewInputObject
        Specifies a DNS server resource record object to overwrite the OldInputObject parameter value.
    .PARAMETER OldInputObject
        Specifies a DNS server resource record object.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER ZoneName
        Specifies the name of a DNS zone.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER ZoneScope
        Specifies the name of a zone scope.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    param (
        [Parameter(ParameterSetName='Set0', Mandatory=$true, Position=3, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [PSTypeName('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
        [ciminstance]
        ${NewInputObject},

        [Parameter(ParameterSetName='Set0', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [PSTypeName('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
        [ciminstance]
        ${OldInputObject},

        [Parameter(ParameterSetName='Set0')]
        [Alias('Cn','ForwardLookupPrimaryServer')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Set0', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('ForwardLookupZone')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Set0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Set0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneScope},

        [Parameter(ParameterSetName='Set0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${VirtualizationInstance},

        [Parameter(ParameterSetName='Set0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Set0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Set0')]
        [switch]
        ${AsJob}
    )
}

function Set-DnsServerResourceRecordAging {
    <#
    .SYNOPSIS
        Begins aging of resource records in a specified DNS zone.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER ZoneName
        Specifies the name of a DNS zone.
    .PARAMETER NodeName
        Specifies a node or subtree in DNS zone. The acceptable values for this parameter are:
        -- @ for root node.
        -- The FQDN of a node (the name with a period (.) at the end).
        -- A single label for the name relative to the zone root.
    .PARAMETER Recurse
        Indicates that the DNS server ages all the nodes under the specified node. Use this parameter to age all records in a zone.
    .PARAMETER Force
        Performs the action without a confirmation message.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    param (
        [Parameter(ParameterSetName='Set0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Set0', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Set0', Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${NodeName},

        [Parameter(ParameterSetName='Set0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Recurse},

        [Parameter(ParameterSetName='Set0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='Set0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Set0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Set0')]
        [switch]
        ${AsJob}
    )
}

function Set-DnsServerResponseRateLimiting {
    <#
    .SYNOPSIS
        Enables RRL on a DNS server.
    .PARAMETER ResponsesPerSec
        Specifies the maximum number of times that the server sends a client the same response within a one-second interval.
    .PARAMETER ErrorsPerSec
        Specifies the maximum number of times that the server can send an error response to a client within a one-second interval. The error responses include: REFUSED, FORMERR and SERVFAIL
    .PARAMETER WindowInSec
        Specifies the period (in seconds) over which rates are measured and averaged for RRL. RRL is applied if queries from same subnet, resulting in same response, occur more frequently than expected in a specified time window. The default value is 5.
    .PARAMETER IPv4PrefixLength
        Specifies the IPv4 prefix length, which indicates the size of the subnet in which the incoming queries are grouped. The server applies RRL if queries resulting in the same response occur more frequently than expected in a specified time window. The default value of this parameter is 24.
    .PARAMETER IPv6PrefixLength
        Specifies the IPv6 prefix length, which indicates the size of the IPv6 subnet in which the incoming queries are grouped. The server applies RRL if queries resulting in the same response occur more frequently than expected in a specified time window. The default value of this parameter is 56.
    .PARAMETER LeakRate
        Specifies the rate at which the server responds to dropped queries. For queries that meet criteria to be dropped due to RRL, the DNS server still responds once per LeakRate queries. For example, if LeakRate is 3, the server responds to one in every 3 queries. The allowed range for LeakRate is 2 to 10. If LeakRate is set to zero, then no responses are 'leaked' by RRL. LeakRate leaves a chance for the victims in the same subnet as the forged IP address to get responses to their valid queries. The default value for LeakRate is 3.
    .PARAMETER ResetToDefault
        Indicates that this cmdlet sets all the RRL settings to their default values.
    .PARAMETER TruncateRate
        Specifies the rate at which the server responds with truncated responses. For queries that meet the criteria to be dropped due to RRL, the DNS server still responds with truncated responses once per TruncateRate queries. For example, if TruncateRate is 2, one in every 2 queries receives a truncated response. The TruncateRate parameter provides the valid clients a way to reconnect using TCP. The allowed range for TruncateRate is 2 to 10. If it is set to 0, then this behaviour is disabled. The default value is 2.
    .PARAMETER Mode
        Specifies the state of RRL on the DNS server. The acceptable values for this parameter are: Enable, or Disable, or LogOnly. If the mode is set to LogOnly the DNS server performs all the RRL calculations but instead of taking the preventive actions (dropping or truncating responses), it only logs the potential actions as if RRL were enabled and continues with the normal responses. The default value is Enable.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NetBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER Force
        Forces the command to run without asking for user confirmation.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResponseRateLimiting')]
    param (
        [Parameter(ParameterSetName='SetDnsServerRRL1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${ResponsesPerSec},

        [Parameter(ParameterSetName='SetDnsServerRRL1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${ErrorsPerSec},

        [Parameter(ParameterSetName='SetDnsServerRRL1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${WindowInSec},

        [Parameter(ParameterSetName='SetDnsServerRRL1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${IPv4PrefixLength},

        [Parameter(ParameterSetName='SetDnsServerRRL1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${IPv6PrefixLength},

        [Parameter(ParameterSetName='SetDnsServerRRL1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${LeakRate},

        [Parameter(ParameterSetName='SetDnsServerRRL1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${ResetToDefault},

        [Parameter(ParameterSetName='SetDnsServerRRL1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${TruncateRate},

        [Parameter(ParameterSetName='SetDnsServerRRL1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${MaximumResponsesPerWindow},

        [Parameter(ParameterSetName='SetDnsServerRRL1', ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('LogOnly','Enable','Disable')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Mode},

        [Parameter(ParameterSetName='SetDnsServerRRL1')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='SetDnsServerRRL1')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='SetDnsServerRRL1')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='SetDnsServerRRL1')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='SetDnsServerRRL1')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='SetDnsServerRRL1')]
        [switch]
        ${AsJob}
    )
}

function Set-DnsServerResponseRateLimitingExceptionlist {
    <#
    .SYNOPSIS
        Updates the settings of an RRL exception list.
    .PARAMETER ClientSubnet
        Specifies the client subnet values for the exception list.

        The value must have the following format: COMPARATOR, value1, value2,..., COMPARATOR, value 3, value 4,.. where the COMPARATOR can be EQ or NE. There can be only one EQ and one NE in a value.

        The values following the EQ operator will be treated as multiple assertions which are logically combined using the OR operator. The values following the NE operator will be treated as multiple assertions which are logically differenced using the AND operator.

        Multiple values are combined using the Condition parameter as a logical operator. The same operator is also used for combining EQ and NE expressions within a value.

        For example, EQ, America, Asia, NE, Europe specifies that the client subnets of America and Asia are in the exception list, and the client subnet of Europe is not.

        For details, see Add-DnsServerClientSubnet.
    .PARAMETER Fqdn
        Specifies FQDN values for the exception list.

        The value must have the following format: COMPARATOR, value1, value2,..., COMPARATOR, value 3, value 4,.. where the COMPARATOR can be EQ or NE. There can be only one EQ and one NE in a value.

        The values following the EQ operator will be treated as multiple assertions which are logically combined using the OR operator. The values following the NE operator will be treated as multiple assertions which are logically differenced using the AND operator.

        Multiple values are combined using the Condition parameter as a logical operator. The same operator is also used for combining EQ and NE expressions within a value.

        For example, EQ,*.contoso.com specifies that the contoso.com domain should be added to the exception list.
    .PARAMETER ServerInterfaceIP
        Specifies the server interface on which the DNS server is listening.

        The value must have the following format: COMPARATOR, value1, value2,..., COMPARATOR, value 3, value 4,.. where the COMPARATOR can be EQ or NE. There can be only one EQ and one NE in a value.

        The values following the EQ operator will be treated as multiple assertions which are logically combined using the OR operator. The values following the NE operator will be treated as multiple assertions which are logically differenced using the AND operator.

        Multiple values are combined together using the Condition parameter as a logical operator. The same operator is also used for combining EQ and NE expressions within a value.

        For example, EQ,10.0.0.3 specifies a server interface with IP 10.0.0.3.
    .PARAMETER Name
        Specifies the name of the RRL exception list.
    .PARAMETER Condition
        Specifies a logical operator for combining multiple values of the ClientSubnet, Fdqn and ServerIp parameters. The values for the parameters are combined together using the Condition parameter as a logical operator. The same operator is also used for combining EQ and NE expressions within a value. The default value is AND.
    .PARAMETER ComputerName
        Specifies a remote DNS server on which to run the command. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NetBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResponseRateLimitingExceptionlist')]
    param (
        [Parameter(ParameterSetName='Set3', Position=2, ValueFromPipelineByPropertyName=$true)]
        [AllowNull()]
        [string]
        ${ClientSubnet},

        [Parameter(ParameterSetName='Set3', Position=3, ValueFromPipelineByPropertyName=$true)]
        [AllowNull()]
        [string]
        ${Fqdn},

        [Parameter(ParameterSetName='Set3', Position=4, ValueFromPipelineByPropertyName=$true)]
        [AllowNull()]
        [string]
        ${ServerInterfaceIP},

        [Parameter(ParameterSetName='Set3', Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Set3', Position=5)]
        [ValidateSet('AND','OR')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Condition},

        [Parameter(ParameterSetName='Set3')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Set3')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Set3')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Set3')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Set3')]
        [switch]
        ${AsJob}
    )
}

function Set-DnsServerRootHint {
    <#
    .SYNOPSIS
        Replaces a list of root hints.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerRootHint')]
    param (
        [Parameter(ParameterSetName='Set2', Mandatory=$true, Position=1, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [PSTypeName('Microsoft.Management.Infrastructure.CimInstance#DnsServerRootHint')]
        [ciminstance]
        ${InputObject},

        [Parameter(ParameterSetName='Set2')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Set2')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Set2')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Set2')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Set2')]
        [switch]
        ${AsJob}
    )
}

function Set-DnsServerScavenging {
    <#
    .SYNOPSIS
        Changes DNS server scavenging settings.
    .PARAMETER ApplyOnAllZones
        Indicates that the server settings apply on all zones.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER ScavengingState
        Specifies whether to Enable automatic scavenging of stale records. ScavengingState determines whether the DNS scavenging feature is enabled by default on newly created zones. The acceptable values for this parameter are:
        -- $False. Disables scavenging. This is the default setting.
        -- $True. Enables scavenging
    .PARAMETER RefreshInterval
        Specifies the refresh interval as a TimeSpan object. During this interval, a DNS server can refresh a resource record that has a non-zero time stamp. Zones on the server inherit this value automatically.

        If a DNS server does not refresh a resource record that has a non-zero time stamp, the DNS server can remove that record during the next scavenging.

        Do not select a value smaller than the longest refresh period of a resource record registered in the zone.

        The minimum value is 0. The maximum value is 8760 hours (seven days). The default value is the same as the DefaultRefreshInterval property of the zone DNS server.
    .PARAMETER ScavengingInterval
        Specifies a length of time as a TimeSpan object. ScavengingInterval determines whether the scavenging feature for the DNS server is enabled and sets the number of hours between scavenging cycles.

        The default setting is 0, which disables scavenging for the DNS server. A setting greater than 0 enables scavenging for the server and sets the number of days, hours, minutes, and seconds (formatted as dd.hh:mm:ss) between scavenging cycles. The minimum value is 0. The maximum value is 365.00:00:00 (1 year).
    .PARAMETER NoRefreshInterval
        Specifies a length of time as a TimeSpan object. NoRefreshInterval sets a period of time in which no refreshes are accepted for dynamically updated records. Zones on the server inherit this value automatically.

        This value is the interval between the last update of a timestamp for a record and the earliest time when the timestamp can be refreshed. The minimum value is 0. The maximum value is 8760 hours (seven days).
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerScavenging')]
    param (
        [Parameter(ParameterSetName='Set1')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${ApplyOnAllZones},

        [Parameter(ParameterSetName='Set1')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Set1', Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${ScavengingState},

        [Parameter(ParameterSetName='Set1', Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${RefreshInterval},

        [Parameter(ParameterSetName='Set1', Position=4, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${ScavengingInterval},

        [Parameter(ParameterSetName='Set1', Position=3, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${NoRefreshInterval},

        [Parameter(ParameterSetName='Set1')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Set1')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Set1')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Set1')]
        [switch]
        ${AsJob}
    )
}

function Set-DnsServerSecondaryZone {
    <#
    .SYNOPSIS
        Changes settings for a DNS secondary zone.
    .PARAMETER MasterServers
        Specifies an array of IP addresses of the master servers of the zone. You can use both IPv4 and IPv6.
    .PARAMETER Name
        Specifies the name of the zone.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER ZoneFile
        Specifies the name of the zone file.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER IgnorePolicies
        Indicates whether to ignore policies for this zone.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerSecondaryZone')]
    param (
        [Parameter(ParameterSetName='Set2', Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ipaddress[]]
        ${MasterServers},

        [Parameter(ParameterSetName='Set2', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('ZoneName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Set2')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Set2', Position=3, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneFile},

        [Parameter(ParameterSetName='Set2')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Set2')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${IgnorePolicies},

        [Parameter(ParameterSetName='Set2')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Set2')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Set2')]
        [switch]
        ${AsJob}
    )
}

function Set-DnsServerSetting {
    <#
    .SYNOPSIS
        Modifies DNS server settings.
    .PARAMETER ComputerName
        Specifies a DNS server. Valid values are an IPv4 address; an IPv6 address; and any other value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerSetting')]
    param (
        [Parameter(ParameterSetName='Set0', Position=1, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [PSTypeName('Microsoft.Management.Infrastructure.CimInstance#DnsServerSetting')]
        [ciminstance]
        ${InputObject},

        [Parameter(ParameterSetName='Set0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Set0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Set0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Set0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Set0')]
        [switch]
        ${AsJob}
    )
}

function Set-DnsServerSigningKey {
    <#
    .SYNOPSIS
        Changes settings of a signing key.
    .PARAMETER ZoneName
        Specifies the name of the zone in which DNS Security Extensions (DNSSEC) operations are performed.
    .PARAMETER RolloverPeriod
        Specifies the amount of time between scheduled key rollovers.
    .PARAMETER DnsKeySignatureValidityPeriod
        Specifies the amount of time that signatures that cover DNSKEY record sets are valid.
    .PARAMETER DSSignatureValidityPeriod
        Specifies the amount of time that signatures that cover DS record sets are valid.
    .PARAMETER ZoneSignatureValidityPeriod
        Specifies the amount of time that signatures that cover all other record sets are valid.
    .PARAMETER KeyId
        Specifies the unique identifier of a key.
    .PARAMETER NextRolloverAction
        Specifies the next rollover action.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerSigningKey')]
    param (
        [Parameter(ParameterSetName='Set3', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Set3', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${RolloverPeriod},

        [Parameter(ParameterSetName='Set3', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${DnsKeySignatureValidityPeriod},

        [Parameter(ParameterSetName='Set3', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${DSSignatureValidityPeriod},

        [Parameter(ParameterSetName='Set3', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${ZoneSignatureValidityPeriod},

        [Parameter(ParameterSetName='Set3', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [guid]
        ${KeyId},

        [Parameter(ParameterSetName='Set3', ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('Normal','RevokeStandby','Retire')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${NextRolloverAction},

        [Parameter(ParameterSetName='Set3')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Set3')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Set3')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Set3')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Set3')]
        [switch]
        ${AsJob}
    )
}

function Set-DnsServerStubZone {
    <#
    .SYNOPSIS
        Changes settings for a DNS server stub zone.
    .PARAMETER Name
        Specifies the name of a zone. The cmdlet modifies settings for this zone.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), Hostname, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER DirectoryPartitionName
        Specifies a directory partition on which to store the zone. Use this parameter when the ReplicationScope parameter has a value of Custom.
    .PARAMETER ReplicationScope
        Specifies a partition on which to store an Active Directory-integrated zone. The acceptable values for this parameter are:
        -- Custom. Any custom directory partition that a user creates. Specify a custom directory partition by using the DirectoryPartitionName parameter.
        -- Domain. The domain directory partition.
        -- Forest. The ForestDnsZone directory partition.
        -- Legacy. A legacy directory partition.
    .PARAMETER MasterServers
        Specifies a list of IP addresses of primary DNS servers for a zone. This value must be non-empty for any zone of a type that requires primary DNS servers: secondary, stub, or forwarder.
    .PARAMETER LocalMasters
        Specifies a list of IP addresses of a zone's primary DNS servers used locally by this DNS server only. If not configured, the MasterServers value is used; otherwise, this list is used in place of the MasterServers value. This value is ignored if the zone type is not stub.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='Parameter', SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerStubZone')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerStubZone')]
    param (
        [Parameter(ParameterSetName='Parameter', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ADZone', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('ZoneName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Parameter')]
        [Parameter(ParameterSetName='ADZone')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Parameter')]
        [Parameter(ParameterSetName='ADZone')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='ADZone', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${DirectoryPartitionName},

        [Parameter(ParameterSetName='ADZone', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('Forest','Domain','Legacy','Custom')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ReplicationScope},

        [Parameter(ParameterSetName='Parameter', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ipaddress[]]
        ${MasterServers},

        [Parameter(ParameterSetName='Parameter', ValueFromPipelineByPropertyName=$true)]
        [ipaddress[]]
        ${LocalMasters},

        [Parameter(ParameterSetName='Parameter')]
        [Parameter(ParameterSetName='ADZone')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Parameter')]
        [Parameter(ParameterSetName='ADZone')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Parameter')]
        [Parameter(ParameterSetName='ADZone')]
        [switch]
        ${AsJob}
    )
}

function Set-DnsServerVirtualizationInstance {
    <#
    .SYNOPSIS
        Set-DnsServerVirtualizationInstance [-Name] <string> [-ComputerName <string>] [-PassThru] [-Description <string>] [-FriendlyName <string>] [-CimSession <CimSession[]>] [-ThrottleLimit <int>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerVirtualizationInstance')]
    param (
        [Parameter(ParameterSetName='Set3')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Set3', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('VirtualizationInstance')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Set3')]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Set3', ValueFromPipelineByPropertyName=$true)]
        [string]
        ${Description},

        [Parameter(ParameterSetName='Set3', ValueFromPipelineByPropertyName=$true)]
        [string]
        ${FriendlyName},

        [Parameter(ParameterSetName='Set3')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Set3')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Set3')]
        [switch]
        ${AsJob}
    )
}

function Set-DnsServerZoneAging {
    <#
    .SYNOPSIS
        Configures DNS aging settings for a zone.
    .PARAMETER Aging
        Indicates whether to enable aging and scavenging for a zone. Aging and scavenging are not enabled by default.

        For a value of $True, a DNS server refreshes time stamps for resource records when the server receives a dynamic update request. This enables DNS servers to scavenge resource records.

        For a value of $False, DNS servers do not refresh time stamps for resource records and do not scavenge resource records.
    .PARAMETER Name
        Specifies the name of a zone. This cmdlet is relevant only for primary zones.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER ScavengeServers
        Specifies an array of IP addresses for DNS servers. These servers can scavenge records in this zone. If you do not specify any scavenge servers, any primary DNS server that is authoritative for the zone can scavenge.
    .PARAMETER RefreshInterval
        Specifies the refresh interval as a TimeSpan object. During this interval, a DNS server can refresh a resource record that has a non-zero time stamp.

        If a resource record that has a non-zero time stamp is not refreshed for a period of the sum the values defined in the NoRefreshInterval parameter and the RefreshInterval parameter, a DNS server can remove that record during the next scavenging.

        Do not select a value smaller than the longest refresh period of a resource record registered in the zone.

        The minimum value is 0. The maximum value is 8760 hours. The default value is the same as the DefaultRefreshInterval property of the zone DNS server.
    .PARAMETER NoRefreshInterval
        Specifies the length of time as a TimeSpan object. This value is the interval between the last update of a timestamp for a record and the earliest time when the timestamp can be refreshed. The minimum value is 0. The maximum value is 8760 hours.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerZoneAging')]
    param (
        [Parameter(ParameterSetName='Set1', Position=2, ValueFromPipelineByPropertyName=$true)]
        [Alias('AgingEnabled')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [bool]
        ${Aging},

        [Parameter(ParameterSetName='Set1', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('ZoneName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Set1')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [ipaddress[]]
        ${ScavengeServers},

        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${RefreshInterval},

        [Parameter(ParameterSetName='Set1', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [timespan]
        ${NoRefreshInterval},

        [Parameter(ParameterSetName='Set1')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Set1')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Set1')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Set1')]
        [switch]
        ${AsJob}
    )
}

function Set-DnsServerZoneDelegation {
    <#
    .SYNOPSIS
        Changes delegation settings for a child zone.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER ZoneScope
        Specifies the name of a zone scope.
    .PARAMETER ChildZoneName
        Specifies a name for the child zone.
    .PARAMETER IPAddress
        Specifies an array of IP addresses for DNS servers for the child zone. This value replaces any previously specified values.
    .PARAMETER NameServer
        Specifies a name for the DNS server that hosts the child zone.
    .PARAMETER Name
        Specifies a name of a zone. The child zone is part of this zone.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='InputObject', SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerZoneDelegation')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerZoneDelegation')]
    param (
        [Parameter(ParameterSetName='Name')]
        [Parameter(ParameterSetName='InputObject')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Name')]
        [Parameter(ParameterSetName='InputObject')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Name', Position=5, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='InputObject', Position=5, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneScope},

        [Parameter(ParameterSetName='Name', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='InputObject', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${VirtualizationInstance},

        [Parameter(ParameterSetName='InputObject', Mandatory=$true, Position=2, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [PSTypeName('Microsoft.Management.Infrastructure.CimInstance#DnsServerZoneDelegation')]
        [ciminstance]
        ${InputObject},

        [Parameter(ParameterSetName='Name', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ChildZoneName},

        [Parameter(ParameterSetName='Name', Mandatory=$true, Position=4, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ipaddress[]]
        ${IPAddress},

        [Parameter(ParameterSetName='Name', Mandatory=$true, Position=3, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${NameServer},

        [Parameter(ParameterSetName='Name', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('ZoneName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Name')]
        [Parameter(ParameterSetName='InputObject')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Name')]
        [Parameter(ParameterSetName='InputObject')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Name')]
        [Parameter(ParameterSetName='InputObject')]
        [switch]
        ${AsJob}
    )
}

function Set-DnsServerZoneTransferPolicy {
    <#
    .SYNOPSIS
        Updates a zone transfer policy on a DNS server.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as an FQDN, host name, or NETBIOS name.
    .PARAMETER ZoneName
        Specifies the name of a DNS zone on which the zone level policy exists. The zone must exist on the DNS server.
    .PARAMETER ClientSubnet
        Specifies the client subnet criterion. Specify a criterion in the following format:
        operator, value01, value02, . . . , operator, value03, value04, . . .
        The operator is either EQ or NE. You can specify no more than one of each operator in a criterion.

        The policy treats values that follow the EQ operator as multiple assertions which are logically combined (OR'd). The policy treats values that follow the NE operator as multiple assertions which are logically differenced (AND'd). The criterion is satisfied if the subnet of the zone transfer matches one of the EQ values and does not match any of the NE values.
    .PARAMETER Condition
        Specifies how the policy treats multiple criteria. The acceptable values for this parameter are:
        -- OR. The policy evaluates criteria as multiple assertions which are logically combined (OR'd).
        -- AND. The policy evaluates criteria as multiple assertions which are logically differenced (AND'd).
        The default value is AND.
    .PARAMETER InternetProtocol
        Specifies the Internet Protocol criterion. Specify a criterion in the following format:
        operator, value01, value02, . . . , operator, value03, value04, . . .
        The operator is either EQ or NE. You can specify no more than one of each operator in a criterion.

        The policy treats values that follow the EQ operator as multiple assertions which are logically combined (OR'd). The policy treats values that follow the NE operator as multiple assertions which are logically differenced (AND'd). The criterion is satisfied if the IP address of the zone transfer matches one of the EQ values and does not match any of the NE values.
    .PARAMETER Name
        Specifies the name of the policy to update.
    .PARAMETER ProcessingOrder
        Specifies the precedence of the policy. Higher integer values have lower precedence. By default, this cmdlet adds a new policy as the lowest precedence.
    .PARAMETER ServerInterfaceIP
        Specifies the IP address of the server interface on which the DNS server listens. Specify a criterion in the following format:
        operator, value01, value02, . . . , operator, value03, value04, . . .
        The operator is either EQ or NE. You can specify no more than one of each operator in the criterion.

        The policy treats values the follow the EQ operator as multiple assertions which are logically combined (OR'd). The policy treats values that follow the NE operator as multiple assertions which are logically differenced (AND'd). The criterion is satisfied if the IP address of the interface matches one of the EQ values and does not match any of the NE values.
    .PARAMETER TimeOfDay
        Specifies the time of day criterion. Specify a criterion in the following format:
        operator, value01, value02, . . . , operator, value03, value04, . . .
        The operator is either EQ or NE. You can specify no more than one of each operator in the criterion.

        The policy treats values the follow the EQ operator as multiple assertions which are logically combined (OR'd). The policy treats values that follow the NE operator as multiple assertions which are logically differenced (AND'd). The criterion is satisfied if the time of day of the zone transfer matches one of the EQ values and does not match any of the NE values.
    .PARAMETER TransportProtocol
        Specifies the transport protocol criterion. Specify a criterion in the following format:
        operator, value01, value02, . . . , operator, value03, value04, . . .
        The operator is either EQ or NE. You can specify no more than one of each operator in the string.

        The policy treats values the follow the EQ operator as multiple assertions which are logically combined (OR'd). The policy treats values that follow the NE operator as multiple assertions which are logically differenced (AND'd). The criterion is satisfied if the transport protocol of the zone transfer matches one of the EQ values and does not match any of the NE values.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='Server', SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerPolicy')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerPolicy')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerPolicy')]
    param (
        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [Parameter(ParameterSetName='InputObject')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [Parameter(ParameterSetName='InputObject')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='InputObject', Mandatory=$true, Position=1, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [PSTypeName('Microsoft.Management.Infrastructure.CimInstance#DnsServerPolicy')]
        [ciminstance]
        ${InputObject},

        [Parameter(ParameterSetName='Zone', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='InputObject')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [AllowEmptyString()]
        [string]
        ${ClientSubnet},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('AND','OR')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Condition},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [AllowEmptyString()]
        [string]
        ${InternetProtocol},

        [Parameter(ParameterSetName='Zone', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [uint32]
        ${ProcessingOrder},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [AllowEmptyString()]
        [string]
        ${ServerInterfaceIP},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [AllowEmptyString()]
        [string]
        ${TimeOfDay},

        [Parameter(ParameterSetName='Zone', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Server', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [AllowEmptyString()]
        [string]
        ${TransportProtocol},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [Parameter(ParameterSetName='InputObject')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [Parameter(ParameterSetName='InputObject')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Zone')]
        [Parameter(ParameterSetName='Server')]
        [Parameter(ParameterSetName='InputObject')]
        [switch]
        ${AsJob}
    )
}

function Show-DnsServerCache {
    <#
    .SYNOPSIS
        Shows the records in a DNS Server Cache.
    .PARAMETER ComputerName
        Specifies a DNS server. The acceptable values for this parameter are: an IP V4 address; an IP V6 address; any other value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER CacheScope
        Specifies the name of the cache scope to show.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerResourceRecord')]
    param (
        [Parameter(ParameterSetName='Show3')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Show3', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${CacheScope},

        [Parameter(ParameterSetName='Show3')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Show3')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Show3')]
        [switch]
        ${AsJob}
    )
}

function Show-DnsServerKeyStorageProvider {
    <#
    .SYNOPSIS
        Returns a list of key storage providers.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(PositionalBinding=$false)]
    [OutputType([System.String[]])]
    param (
        [Parameter(ParameterSetName='Show0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Show0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Show0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Show0')]
        [switch]
        ${AsJob}
    )
}

function Start-DnsServerScavenging {
    <#
    .SYNOPSIS
        Notifies a DNS server to attempt a search for stale resource records.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER Force
        Notifies the DNS server to attempt an scavange without prompting you for confirmation. By default, the cmdlet prompts you for confirmation before it proceeds.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    param (
        [Parameter(ParameterSetName='Start2')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Start2')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='Start2')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Start2')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Start2')]
        [switch]
        ${AsJob}
    )
}

function Start-DnsServerZoneTransfer {
    <#
    .SYNOPSIS
        Starts a zone transfer for a secondary DNS zone from master servers.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), Hostname, or NETBIOS name.
    .PARAMETER Name
        Specifies the name of a zone. The cmdlet transfers records for this zone.
    .PARAMETER FullTransfer
        Specifies that this cmdlet performs a full transfer. Without this parameter, the cmdlet does an incremental transfer.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerZone')]
    param (
        [Parameter(ParameterSetName='Start0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Start0', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('ZoneName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Start0', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${FullTransfer},

        [Parameter(ParameterSetName='Start0')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Start0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Start0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Start0')]
        [switch]
        ${AsJob}
    )
}

function Step-DnsServerSigningKeyRollover {
    <#
    .SYNOPSIS
        Rolls over a KSK that is waiting for a parent DS update.
    .PARAMETER ZoneName
        Specifies the name of the DNS zone in which the cmdlet performs the KSK rollover.
    .PARAMETER KeyId
        Specifies the ID of the key for which to perform the KSK rollover.
    .PARAMETER Force
        Forces the command to run without asking for user confirmation.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER ComputerName
        Specifies a remote DNS server. Specify the IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name, for the DNS server.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerSigningKey')]
    param (
        [Parameter(ParameterSetName='Step3', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Step3', Mandatory=$true, Position=2, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [guid]
        ${KeyId},

        [Parameter(ParameterSetName='Step3')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='Step3')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Step3')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Step3')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Step3')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Step3')]
        [switch]
        ${AsJob}
    )
}

function Suspend-DnsServerZone {
    <#
    .SYNOPSIS
        Suspends a zone on a DNS server.
    .PARAMETER Name
        Specifies the name of a zone.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER Force
        Suspends a zone without prompting you for confirmation. By default, the cmdlet prompts you for confirmation before it proceeds.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerZone')]
    param (
        [Parameter(ParameterSetName='Suspend4', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('ZoneName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Suspend4')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Suspend4')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Suspend4')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='Suspend4')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Suspend4')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Suspend4')]
        [switch]
        ${AsJob}
    )
}

function Sync-DnsServerZone {
    <#
    .SYNOPSIS
        Checks the DNS server memory for changes, and writes them to persistent storage.
    .PARAMETER Name
        Specifies the name of a zone. If you do not specify a zone, the cmdlet syncs all zones on the DNS server.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerZone')]
    param (
        [Parameter(ParameterSetName='Sync5', Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('ZoneName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Sync5')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Sync5')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Sync5')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Sync5')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Sync5')]
        [switch]
        ${AsJob}
    )
}

function Test-DnsServer {
    <#
    .SYNOPSIS
        Tests that a specified computer is a functioning DNS server.
    .PARAMETER IPAddress
        Specifies an array of DNS server IP addresses.
    .PARAMETER ComputerName
        Specifies a DNSserver. The acceptable values for this parameter are: an IPv4 address; an IPv6 address; any other value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER Context
        Specifies functionalities to test. Valid values are: DnsServer, Forwarder , and RootHints.
    .PARAMETER ZoneName
        Specifies the name of the zone that the server hosts.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(DefaultParameterSetName='Context', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerValidity')]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerValidity')]
    param (
        [Parameter(ParameterSetName='ZoneMaster', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Context', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ipaddress[]]
        ${IPAddress},

        [Parameter(ParameterSetName='ZoneMaster')]
        [Parameter(ParameterSetName='Context')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Context', Position=2)]
        [ValidateSet('DnsServer','Forwarder','RootHints')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Context},

        [Parameter(ParameterSetName='ZoneMaster', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='ZoneMaster')]
        [Parameter(ParameterSetName='Context')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='ZoneMaster')]
        [Parameter(ParameterSetName='Context')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='ZoneMaster')]
        [Parameter(ParameterSetName='Context')]
        [switch]
        ${AsJob}
    )
}

function Test-DnsServerDnsSecZoneSetting {
    <#
    .SYNOPSIS
        Validates DNSSEC settings for a zone.
    .PARAMETER ZoneName
        Specifies the name of a DNS zone.
    .PARAMETER ComputerName
        Specifies a DNS server. If you do not specify this parameter, the command runs on the local system. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerZoneDnsSecValidationResult')]
    param (
        [Parameter(ParameterSetName='Test0', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ZoneName},

        [Parameter(ParameterSetName='Test0')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Test0')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Test0')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Test0')]
        [switch]
        ${AsJob}
    )
}

function Unregister-DnsServerDirectoryPartition {
    <#
    .SYNOPSIS
        Deregisters a DNS server from a DNS application directory partition.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER PassThru
        Returns an object representing the item with which you are working. By default, this cmdlet does not generate any output.
    .PARAMETER Name
        Specifies the FQDN of a DNS application directory partition.
    .PARAMETER Force
        Deregisters a DNS server from a DNS application directory partition without prompting you for confirmation. By default, the cmdlet prompts you for confirmation before it proceeds.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [OutputType('Microsoft.Management.Infrastructure.CimInstance#DnsServerDirectoryPartition')]
    param (
        [Parameter(ParameterSetName='Unregister2')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [ValidateLength(1, 255)]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Unregister2')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Unregister2', Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [Alias('DirectoryPartitionName')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${Name},

        [Parameter(ParameterSetName='Unregister2')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='Unregister2')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Unregister2')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Unregister2')]
        [switch]
        ${AsJob}
    )
}

function Update-DnsServerTrustPoint {
    <#
    .SYNOPSIS
        Updates all trust points in a DNS trust anchor zone.
    .PARAMETER Force
        Refreshes a DNS server trust point object without prompting you for confirmation.
    .PARAMETER ComputerName
        Specifies a remote DNS server. You can specify an IP address or any value that resolves to an IP address, such as a fully qualified domain name (FQDN), host name, or NETBIOS name.
    .PARAMETER CimSession
        Runs the cmdlet in a remote session or on a remote computer. Enter a computer name or a session object, such as the output of a New-CimSession or Get-CimSession cmdlet. The default is the current session on the local computer.
    .PARAMETER ThrottleLimit
        Specifies the maximum number of concurrent operations that can be established to run the cmdlet. If this parameter is omitted or a value of 0 is entered, then Windows PowerShell® calculates an optimum throttle limit for the cmdlet based on the number of CIM cmdlets that are running on the computer. The throttle limit applies only to the current cmdlet, not to the session or to the computer.
    #>

    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium', PositionalBinding=$false)]
    param (
        [Parameter(ParameterSetName='Update1')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [switch]
        ${Force},

        [Parameter(ParameterSetName='Update1')]
        [Alias('Cn')]
        [ValidateNotNullOrEmpty()]
        [ValidateNotNull()]
        [string]
        ${ComputerName},

        [Parameter(ParameterSetName='Update1')]
        [Alias('Session')]
        [ValidateNotNullOrEmpty()]
        [CimSession[]]
        ${CimSession},

        [Parameter(ParameterSetName='Update1')]
        [int]
        ${ThrottleLimit},

        [Parameter(ParameterSetName='Update1')]
        [switch]
        ${AsJob}
    )
}

