# xDnsServer

The **xDnsServer** module contains DSC resources for the management and
configuration of Windows Server DNS Server.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Branches

### master

[![Build status](https://ci.appveyor.com/api/projects/status/qqspiio117bgaieo/branch/master?svg=true)](https://ci.appveyor.com/project/PowerShell/xDnsServer/branch/master)
[![codecov](https://codecov.io/gh/PowerShell/xDnsServer/branch/master/graph/badge.svg)](https://codecov.io/gh/PowerShell/xDnsServer/branch/master)

This is the branch containing the latest release -
no contributions should be made directly to this branch.

### dev

[![Build status](https://ci.appveyor.com/api/projects/status/qqspiio117bgaieo/branch/dev?svg=true)](https://ci.appveyor.com/project/PowerShell/xDnsServer/branch/dev)
[![codecov](https://codecov.io/gh/PowerShell/xDnsServer/branch/dev/graph/badge.svg)](https://codecov.io/gh/PowerShell/xDnsServer/branch/dev)

This is the development branch
to which contributions should be proposed by contributors as pull requests.
This development branch will periodically be merged to the master branch,
and be released to [PowerShell Gallery](https://www.powershellgallery.com/).

## Contributing

Please check out common DSC Resources [contributing guidelines](https://github.com/PowerShell/DscResource.Kit/blob/master/CONTRIBUTING.md).

## Resources

* **xDnsServerForwarder** sets a DNS forwarder on a given DNS server.
* **xDnsServerADZone** sets an AD integrated zone on a given DNS server.
* **xDnsServerPrimaryZone** sets a standalone Primary zone on a given DNS server.
* **xDnsServerSecondaryZone** sets a Secondary zone on a given DNS server.
  * Secondary zones allow client machine in primary DNS zones to do DNS resolution of machines in the secondary DNS zone.
* **xDnsServerZoneTransfer** This resource allows a DNS Server zone data to be replicated to another DNS server.
* **xDnsRecord** This resource allows for the creation of IPv4 host (A) records, CNames, or PTRs against a specific zone on the DNS server.
* **xDnsServerSetting** This resource manages the DNS sever settings/properties.
* **xDnsServerDiagnostics** This resource manages the DNS server diagnostic settings/properties.
* **xDnsServerClientSubnet** This resource manages the DNS Client Subnets that are used in DNS Policies.

### xDnsServerForwarder

* **IsSingleInstance**: Specifies the resource is a single instance, the value must be 'Yes'
* **IPAddresses**: IP addresses of the forwarders
* **UseRootHint**: Specifies if you want to use root hint or not

### xDnsServerADZone

* **Name**: Name of the AD DNS zone
* **Ensure**: Whether the AD zone should be present or removed
* **DynamicUpdate**: AD zone dynamic DNS update option.
  * If not specified, defaults to 'Secure'.
  * Valid values include: { None | NonsecureAndSecure | Secure }
* **ReplicationScope**: AD zone replication scope option.
  * Valid values include: { Custom | Domain | Forest | Legacy }
* **DirectoryPartitionName**: Name of the directory partition on which to store the zone.
  * Use this parameter when the ReplicationScope parameter has a value of Custom.
* **ComputerName**: Specifies a DNS server.
  * If you do not specify this parameter, the command runs on the local system.
* **Credential**: Specifies the credential to use to create the AD zone on a remote computer.
  * This parameter can only be used when you also are passing a value for the `ComputerName` parameter.

### xDnsServerPrimaryZone

* **Name**: Name of the primary DNS zone
* **ZoneFile**: Name of the primary DNS zone file.
  * If not specified, defaults to 'ZoneName.dns'.
* **Ensure**: Whether the primary zone should be present or removed
* **DynamicUpdate**: Primary zone dynamic DNS update option.
  * If not specified, defaults to 'None'.
  * Valid values include: { None | NonsecureAndSecure }

### xDnsServerSecondaryZone

* **Name**: Name of the secondary zone
* **MasterServers**: IP address or DNS name of the secondary DNS servers
* **Ensure**: Whether the secondary zone should be present or removed
* **Type**: Type of the DNS server zone

### xDnsServerConditionalForwarder

* **Ensure**: Ensure whether the zone is absent or present.
* **Name**: The name of the zone to manage.
* **MasterServers**: The IP addresses the forwarder should use. Mandatory if Ensure is present.
* **ReplicationScope**: Whether the conditional forwarder should be replicated in AD, and the scope of that replication.
  * Valid values are: { None | Custom | Domain | Forest | Legacy }
  * Default is None.
* **DirectoryPartitionName**: The name of the directory partition to use when the ReplicationScope is Custom. This value is ignored for all other replication scopes.

### xDnsServerZoneAging

* **Name**: Name of the DNS forward or reverse loookup zone.
* **Enabled**: Option to enable scavenge stale resource records on the zone.
* **RefreshInterval**: Refresh interval for record scavencing in hours. Default value is 7 days.
* **NoRefreshInterval**: No-refresh interval for record scavencing in hours. Default value is 7 days.

### xDnsServerZoneTransfer

* **Name**: Name of the DNS zone
* **Type**: Type of transfer allowed.
  * Values include: { None | Any | Named | Specific }
* **SecondaryServer**: IP address or DNS name of DNS servers where zone information can be transfered.

### xDnsARecord {Will be removed in a future release}

* **Name**: Name of the host
* **Zone**: The name of the zone to create the host record in
* **Target**: Target Hostname or IP Address {*Only Supports IPv4 in the current release*}
* **Ensure**: Whether the host record should be present or removed

### xDnsRecord

* **Name**: Specifies the name of the DNS server resource record object
* **Zone**: The name of the zone to create the host record in
* **Target**: Target Hostname or IP Address {*Only Supports IPv4 in the current release*}
* **DnsServer**: Name of the DnsServer to create the record on.
  * If not specified, defaults to 'localhost'.
* **Type**: DNS Record Type.
  * Values include: { ARecord | CName | Ptr }
* **Ensure**: Whether the host record should be present or removed

### xDnsServerSetting

* **Name**: Key for the resource.  It doesn't matter what it is as long as it's unique within the configuration.
* **AddressAnswerLimit**: Maximum number of host records returned in response to an address request. Values between 5 and 28 are valid.
* **AllowUpdate**: Specifies whether the DNS Server accepts dynamic update requests.
* **AutoCacheUpdate**: Indicates whether the DNS Server attempts to update its cache entries using data from root servers.
* **AutoConfigFileZones**: Indicates which standard primary zones that are authoritative for the name of the DNS Server must be updated when the name server changes.
* **BindSecondaries**: Determines the AXFR message format when sending to non-Microsoft DNS Server secondaries.
* **BootMethod**: Initialization method for the DNS Server.
* **DefaultAgingState**: Default ScavengingInterval value set for all Active Directory-integrated zones created on this DNS Server.
* **DefaultNoRefreshInterval**: No-refresh interval, in hours, set for all Active Directory-integrated zones created on this DNS Server.
* **DefaultRefreshInterval**:  Refresh interval, in hours, set for all Active Directory-integrated zones created on this DNS Server.
* **DisableAutoReverseZones**: Indicates whether the DNS Server automatically creates standard reverse look up zones.
* **DisjointNets**: Indicates whether the default port binding for a socket used to send queries to remote DNS Servers can be overridden.
* **DsPollingInterval**: Interval, in seconds, to poll the DS-integrated zones.
* **DsTombstoneInterval**: Lifetime of tombstoned records in Directory Service integrated zones, expressed in seconds.
* **EDnsCacheTimeout**: Lifetime, in seconds, of the cached information describing the EDNS version supported by other DNS Servers.
* **EnableDirectoryPartitions**: Specifies whether support for application directory partitions is enabled on the DNS Server.
* **EnableDnsSec**: Specifies whether the DNS Server includes DNSSEC-specific RRs, KEY, SIG, and NXT in a response.
* **EnableEDnsProbes** :Specifies the behavior of the DNS Server. When TRUE, the DNS Server always responds with OPT resource records according to RFC 2671, unless the remote server has indicated it does not support EDNS in a prior exchange. If FALSE, the DNS Server responds to queries with OPTs only if OPTs are sent in the original query.
* **EventLogLevel**: Indicates which events the DNS Server records in the Event Viewer system log.
* **ForwardDelegations**: Specifies whether queries to delegated sub-zones are forwarded.
* **Forwarders**: Enumerates the list of IP addresses of Forwarders to which the DNS Server forwards queries.
* **ForwardingTimeout**: Time, in seconds, a DNS Server forwarding a query will wait for resolution from the forwarder before attempting to resolve the query itself.
* **IsSlave**: TRUE if the DNS server does not use recursion when name-resolution through forwarders fails.
* **ListenAddresses**: Enumerates the list of IP addresses on which the DNS Server can receive queries.
* **LocalNetPriority**: Indicates whether the DNS Server gives priority to the local net address when returning A records.
* **LogFileMaxSize**: Size of the DNS Server debug log, in bytes.
* **LogFilePath**: File name and path for the DNS Server debug log.
* **LogIPFilterList**: List of IP addresses used to filter DNS events written to the debug log.
* **LogLevel**: Indicates which policies are activated in the Event Viewer system log.
* **LooseWildcarding**: Indicates whether the DNS Server performs loose wildcarding.
* **MaxCacheTTL**: Maximum time, in seconds, the record of a recursive name query may remain in the DNS Server cache.
* **MaxNegativeCacheTTL**: Maximum time, in seconds, a name error result from a recursive query may remain in the DNS Server cache.
* **NameCheckFlag**: Indicates the set of eligible characters to be used in DNS names.
* **NoRecursion**: Indicates whether the DNS Server performs recursive look ups. TRUE indicates recursive look ups are not performed.
* **RecursionRetry**: Elapsed seconds before retrying a recursive look up.
* **RecursionTimeout**: Elapsed seconds before the DNS Server gives up recursive query.
* **RoundRobin**: Indicates whether the DNS Server round robins multiple A records.
* **RpcProtocol**: RPC protocol or protocols over which administrative RPC runs.
* **ScavengingInterval**: Interval, in hours, between two consecutive scavenging operations performed by the DNS Server.
* **SecureResponses**: Indicates whether the DNS Server exclusively saves records of names in the same subtree as the server that provided them.
* **SendPort**: Port on which the DNS Server sends UDP queries to other servers.
* **StrictFileParsing**: Indicates whether the DNS Server parses zone files strictly.
* **UpdateOptions**: Restricts the type of records that can be dynamically updated on the server, used in addition to the AllowUpdate settings on Server and Zone objects.
* **WriteAuthorityNS**: Specifies whether the DNS Server writes NS and SOA records to the authority section on successful response.
* **XfrConnectTimeout**: Time, in seconds, the DNS Server waits for a successful TCP connection to a remote server when attempting a zone transfer.
* **DsAvailable**: Indicates whether there is an available DS on the DNS Server. This is a read-only property.

### xDnsServerDiagnostics

* **Name**: Key for the resource. It doesn't matter what it is as long as it's unique within the configuration.
* **Answers**: Specifies whether to enable the logging of DNS responses.
* **NaEnableLogFileRolloverme**: Specifies whether to enable log file rollover.
* **EnableLoggingForLocalLookupEvent**: Specifies whether the DNS server logs local lookup events.
* **EnableLoggingForPluginDllEvent**: Specifies whether the DNS server logs dynamic link library (DLL) plug-in events.
* **EnableLoggingForRecursiveLookupEvent**: Specifies whether the DNS server logs recursive lookup events.
* **EnableLoggingForRemoteServerEvent**: Specifies whether the DNS server logs remote server events.
* **EnableLoggingForServerStartStopEvent**: Specifies whether the DNS server logs server start and stop events.
* **EnableLoggingForTombstoneEvent**: Specifies whether the DNS server logs tombstone events.
* **EnableLoggingForZoneDataWriteEvent**: Specifies Controls whether the DNS server logs zone data write events.
* **EnableLoggingForZoneLoadingEvent**: Specifies whether the DNS server logs zone load events.
* **EnableLoggingToFile**: Specifies whether the DNS server logs logging-to-file.
* **EventLogLevel**: Specifies an event log level. Valid values are Warning, Error, and None.
* **FilterIPAddressList**: Specifies an array of IP addresses to filter. When you enable logging, traffic to and from these IP addresses is logged. If you do not specify any IP addresses, traffic to and from all IP addresses is logged.
* **FullPackets**: Specifies whether the DNS server logs full packets.
* **LogFilePath**: Specifies a log file path.
* **MaxMBFileSize**: Specifies the maximum size of the log file. This parameter is relevant if you set EnableLogFileRollover and EnableLoggingToFile to $True.
* **Notifications**: Specifies whether the DNS server logs notifications.
* **Queries**: Specifies whether the DNS server allows query packet exchanges to pass through the content filter, such as the IPFilterList parameter.
* **QuestionTransactions**: Specifies whether the DNS server logs queries.
* **ReceivePackets**: Specifies whether the DNS server logs receive packets.
* **SaveLogsToPersistentStorage**: Specifies whether the DNS server saves logs to persistent storage.
* **SendPackets**: Specifies whether the DNS server logs send packets.
* **TcpPackets**: Specifies whether the DNS server logs TCP packets.
* **UdpPackets**: Specifies whether the DNS server logs UDP packets.
* **UnmatchedResponse**: Specifies whether the DNS server logs unmatched responses.
* **Update**: Specifies whether the DNS server logs updates.
* **UseSystemEventLog**: Specifies whether the DNS server uses the system event log for logging.
* **WriteThrough**: Specifies whether the DNS server logs write-throughs.

### xDnsServerClientSubnet

Requires Windows Server 2016 onwards

* **Name**: Specifies the name of the client subnet.
* **IPv4Subnet**: Specify an array (1 or more values) of IPv4 Subnet addresses in CIDR Notation.
* **IPv6Subnet**: Specify an array (1 of more values) of IPv6 Subnet addresses in CIDR Notation.
* **Ensure**: Whether the client subnet should be present or removed.

### xDnsServerRootHint

* **IsSingleInstance**: Specifies the resource is a single instance, the value must be 'Yes'
* **NameServer**: A hashtable that defines the name server. Key and value must be strings.

### xDnsServerZoneScope

Requires Windows Server 2016 onwards

* **Name**: Specifies the name of the Zone Scope.
* **ZoneName**: Specify the existing DNS Zone to add a scope to.
* **Ensure**: Whether the Zone Scope should be present or removed.

## Versions

### Unreleased

### 1.16.0.0

* Changes to XDnsServerADZone
  * Raise an exception if `DirectoryPartitionName` is specified and `ReplicationScope` is not `Custom`.
  ([issue #110](https://github.com/PowerShell/xDnsServer/issues/110)).
  * Enforce the `ReplicationScope` parameter being passed to `Set-DnsServerPrimaryZone` if
  `DirectoryPartitionName` has changed.
* xDnsServer:
  * OptIn to the following Dsc Resource Meta Tests:
    * Common Tests - Relative Path Length
    * Common Tests - Validate Markdown Links
    * Common Tests - Custom Script Analyzer Rules
    * Common Tests - Required Script Analyzer Rules
    * Common Tests - Flagged Script Analyzer Rules

### 1.15.0.0

* Fixed: Ignore UseRootHint in xDnsServerForwarder test function if it was not
  specified in the resource [Claudio Spizzi (@claudiospizzi)](https://github.com/claudiospizzi)

### 1.14.0.0

* Copied enhancements to Test-DscParameterState from NetworkingDsc
* Put the helper module to its own folder
* Copied enhancements to Test-DscParameterState from NetworkingDsc
* Put the helper module to its own folder
* Added xDnsServerRootHint resource
* Added xDnsServerClientSubnet resource
* Added xDnsServerZoneScope resource

### 1.13.0.0

* Added resource xDnsServerConditionalForwarder
* Added xDnsServerDiagnostics resource to this module.

### 1.12.0.0

* Update appveyor.yml to use the default template.
* Added default template files .codecov.yml, .gitattributes, and .gitignore, and .vscode folder.
* Added UseRootHint property to xDnsServerForwarder resource.

### 1.11.0.0

* Changes to xDnsServer
  * Updated appveyor.yml to use the default template and add CodeCov support
    ([issue #73](https://github.com/PowerShell/xActiveDirectory/issues/73)).
  * Adding a Branches section to the README.md with Codecov badges for both
    master and dev branch ([issue #73](https://github.com/PowerShell/xActiveDirectory/issues/73)).
  * Updated description of resource module in README.md.
* Added resource xDnsServerZoneAging. [Claudio Spizzi (@claudiospizzi)](https://github.com/claudiospizzi)
* Changes to xDnsServerPrimaryZone
  * Fix bug in Get-TargetResource that caused the Zone Name to be null
    ([issue #63](https://github.com/PowerShell/xDnsServer/issues/63)).
    [Brandon Padgett (@gerane)](https://github.com/gerane)
* Changes to xDnsRecord
  * Added Ptr record support (partly resolves issue #34).
    [Reggie Gibson (@regedit32)](https://github.com/regedit32)

### 1.10.0.0

* Changes to xDnsServerADZone
  * Fixed bug introduced by [PR #49](https://github.com/PowerShell/xDnsServer/pull/49).
    Previously, CimSessions were always used regardless of connecting to a remote
    machine or the local machine.  Now CimSessions are only utilized when a
    computername, or computername and credential are used
    ([issue #53](https://github.com/PowerShell/xDnsServer/issues/53)).
  [Michael Fyffe (@TraGicCode)](https://github.com/TraGicCode)
* Fixed all PSSA rule warnings. [Michael Fyffe (@TraGicCode)](https://github.com/TraGicCode)
* Fix DsAvailable key missing ([#66](https://github.com/PowerShell/xDnsServer/issues/66)).
  [Claudio Spizzi (@claudiospizzi)](https://github.com/claudiospizzi)

### 1.9.0.0

* Added resource xDnsServerSetting
* MSFT_xDnsRecord: Added DnsServer property

### 1.8.0.0

* Converted AppVeyor.yml to pull Pester from PSGallery instead of Chocolatey
* Fixed bug in xDnsServerADZone causing Get-TargetResource to fail with an extra property.

### 1.7.0.0

* Unit tests updated to use standard unit test templates.
* MSFT_xDnsServerZoneTransfer: Added unit tests.
                               Updated to meet Style Guidelines.
* MSFT_xDnsARecord: Removed hard coding of Localhost computer name to eliminate PSSA rule violation.

### 1.6.0.0

* Added Resource xDnsServerForwarder.
* Updated README.md with documentation and examples for xDnsServerForwarder resource.
* Added Resource xDnsServerADZone that sets an AD integrated DNS zone.
* Updated README.md with documentation and examples for xDnsServerADZone resource.
* Fixed bug in xDnsRecord causing Test-TargetResource to fail with multiple (round-robin) entries.
* Updated README.md with example DNS round-robin configuration.

### 1.5.0.0

* Added Resource xDnsRecord with support for CNames.
  * This will replace xDnsARecord in a future release.
* Added **xDnsServerPrimaryZone** resource

### 1.4.0.0

* Added support for removing DNS A records

### 1.3.0.0

* Fix to retrieving settings for record data

### 1.2.0.0

* Removed UTF8 BOM from MOF schema

### 1.1

* Add **xDnsARecord** resource.

### 1.0

* Initial release with the following resources
  * **xDnsServerSecondaryZone**
  * **xDnsServerZoneTransfer**

## Examples

### Setting DNS Forwarders

```powershell
configuration Sample_Set_Forwarders
{
    Import-DscResource -module xDnsServer
    xDnsServerForwarder SetForwarders
    {
        IsSingleInstance = 'Yes'
        IPAddresses = '192.168.0.10','192.168.0.11'
        UseRootHint = $false
    }
}
Sample_Set_Forwarders
```

### Removing All DNS Forwarders

```powershell
configuration Sample_Remove_All_Forwarders
{
    Import-DscResource -module xDnsServer
    xDnsServerForwarder RemoveAllForwarders
    {
        IsSingleInstance = 'Yes'
        IPAddresses = @()
        UseRootHint = $false
    }
}
Sample_Remove_All_Forwarders
```

### Configuring an AD integrated Forward Lookup Zone

```powershell
configuration Sample_xDnsServerForwardADZone
{
    param
    (
        [pscredential]$Credential,
    )
    Import-DscResource -module xDnsServer
    xDnsServerADZone addForwardADZone
    {
        Name = 'MyDomainName.com'
        DynamicUpdate = 'Secure'
        ReplicationScope = 'Forest'
        ComputerName = 'MyDnsServer.MyDomain.com'
        Credential = $Credential
        Ensure = 'Present'
    }
}
Sample_xDnsServerForwardADZone -Credential (Get-Credential)
```

### Configuring an AD integrated Reverse Lookup Zone

```powershell
configuration Sample_xDnsServerReverseADZone
{
    Import-DscResource -module xDnsServer
    xDnsServerADZone addReverseADZone
    {
        Name = '1.168.192.in-addr.arpa'
        DynamicUpdate = 'Secure'
        ReplicationScope = 'Forest'
        Ensure = 'Present'
    }
}
Sample_xDnsServerReverseADZone
```

### Configuring a DNS Transfer Zone

```powershell
configuration Sample_xDnsServerZoneTransfer_TransferToAnyServer
{
    param
    (
        [Parameter(Mandatory)]
        [String]$DnsZoneName,

        [Parameter(Mandatory)]
        [String]$TransferType
    )
    Import-DscResource -module xDnsServer
    xDnsServerZoneTransfer TransferToAnyServer
    {
        Name = $DnsZoneName
        Type = $TransferType
    }
}
Sample_xDnsServerZoneTransfer_TransferToAnyServer -DnsZoneName 'demo.contoso.com' -TransferType 'Any'
```

### Configuring a Primary Standalone DNS Zone

```powershell
configuration Sample_xDnsServerPrimaryZone
{
    param
    (
        [Parameter(Mandatory)]
        [String]$ZoneName,
        [Parameter()] [ValidateNotNullOrEmpty()]
        [String]$ZoneFile = "$ZoneName.dns",
        [Parameter()] [ValidateSet('None','NonsecureAndSecure')]
        [String]$DynamicUpdate = 'None'
    )

    Import-DscResource -module xDnsServer
    xDnsServerPrimaryZone addPrimaryZone
    {
        Ensure        = 'Present'
        Name          = $ZoneName
        ZoneFile      = $ZoneFile
        DynamicUpdate = $DynamicUpdate
    }
}
Sample_xDnsServerPrimaryZone -ZoneName 'demo.contoso.com' -DyanmicUpdate 'NonsecureAndSecure'
```

### Configuring a Secondary DNS Zone

```powershell
configuration Sample_xDnsServerSecondaryZone
{
    param
    (
        [Parameter(Mandatory)]
        [String]$ZoneName,
        [Parameter(Mandatory)]
        [String[]]$SecondaryDnsServer
    )

    Import-DscResource -module xDnsServer
    xDnsServerSecondaryZone sec
    {
        Ensure        = 'Present'
        Name          = $ZoneName
        MasterServers = $SecondaryDnsServer

    }
}
Sample_xDnsServerSecondaryZone -ZoneName 'demo.contoso.com' -SecondaryDnsServer '192.168.10.2'
```

### Adding a DNS ARecord

```powershell
configuration Sample_Arecord
{
    Import-DscResource -module xDnsServer
    xDnsRecord TestRecord
    {
        Name = "testArecord"
        Target = "192.168.0.123"
        Zone = "contoso.com"
        Type = "ARecord"
        Ensure = "Present"
    }
}
Sample_Arecord
```

### Adding round-robin DNS ARecords

```powershell
configuration Sample_RoundRobin_Arecord
{
    Import-DscResource -module xDnsServer
    xDnsRecord TestRecord1
    {
        Name = "testArecord"
        Target = "192.168.0.123"
        Zone = "contoso.com"
        Type = "ARecord"
        Ensure = "Present"
    }
    xDnsRecord TestRecord2
    {
        Name = "testArecord"
        Target = "192.168.0.124"
        Zone = "contoso.com"
        Type = "ARecord"
        Ensure = "Present"
    }

}
Sample_RoundRobin_Arecord
```

### Adding a DNS CName

```powershell
configuration Sample_CName
{
    Import-DscResource -module xDnsServer
    xDnsRecord TestRecord
    {
        Name = "testCName"
        Target = "test.contoso.com"
        Zone = "contoso.com"
        Type = "CName"
        Ensure = "Present"
    }
}
Sample_Crecord
```

### Adding a DNS PTR record

```powershell
configuration Sample_Ptr
{
    Import-DscResource -module xDnsServer
    xDnsRecord TestPtrRecord
    {
        Name = "123"
        Target = "TestA.contoso.com"
        Zone = "0.168.192.in-addr.arpa"
        Type = "PTR"
        Ensure = "Present"
    }
}
Sample_Ptr
```

### Removing a DNS A Record

```powershell
configuration Sample_Remove_Record
{
    Import-DscResource -module xDnsServer
    xDnsARecord RemoveTestRecord
    {
        Name = "testArecord"
        Target = "192.168.0.123"
        Zone = "contoso.com"
        Type = "ARecord"
        Ensure = "Absent"
    }
}
Sample_Sample_Remove_Record
```

### Configuring Dns Server properties

```powershell
configuration Sample_DnsSettings
{
    Import-DscResource -ModuleName xDnsServer

    node localhost
    {
        xDnsServerSetting DnsServerProperties
        {
            Name = 'DnsServerSetting'
            ListenAddresses = '10.0.0.4'
            IsSlave = $true
            Forwarders = '168.63.129.16','168.63.129.18'
            RoundRobin = $true
            LocalNetPriority = $true
            SecureResponses = $true
            NoRecursion = $false
            BindSecondaries = $false
            StrictFileParsing = $false
            ScavengingInterval = 168
            LogLevel = 50393905
        }
    }
}

Sample_DnsSettings
```

### Enable DNS Zone Aging

```powershell
configuration Sample_DnsZoneAging
{
    Import-DscResource -ModuleName xDnsServer

    node localhost
    {
        xDnsServerZoneAging DnsServerZoneAging
        {
            Name              = 'contoso.com'
            Enabled           = $true
            RefreshInterval   = 120   # 5 days
            NoRefreshInterval = 240   # 10 days
        }
    }
}

Sample_DnsZoneAging
```

### Enable DNS Reverse Zone Aging

```powershell
configuration Sample_DnsReverseZoneAging
{
    Import-DscResource -ModuleName xDnsServer

    node localhost
    {
        xDnsServerZoneAging DnsServerReverseZoneAging
        {
            Name              = '168.192.in-addr-arpa'
            Enabled           = $true
            RefreshInterval   = 168   # 7 days
            NoRefreshInterval = 168   # 7 days
        }
    }
}

Sample_DnsReverseZoneAging
```

### Set DNS server root hints to Windows Server 2016 defaults

```powershell
configuration DefaultDnsServerRootHints
{
    Import-DscResource -ModuleName xDnsServer

    xDnsServerRootHint RootHints
    {
        IsSingleInstance = 'Yes'
        NameServer = @{
            'A.ROOT-SERVERS.NET.' = '2001:503:ba3e::2:30'
            'B.ROOT-SERVERS.NET.' = '2001:500:84::b'
            'C.ROOT-SERVERS.NET.' = '2001:500:2::c'
            'D.ROOT-SERVERS.NET.' = '2001:500:2d::d'
            'E.ROOT-SERVERS.NET.' = '192.203.230.10'
            'F.ROOT-SERVERS.NET.' = '2001:500:2f::f'
            'G.ROOT-SERVERS.NET.' = '192.112.36.4'
            'H.ROOT-SERVERS.NET.' = '2001:500:1::53'
            'I.ROOT-SERVERS.NET.' = '2001:7fe::53'
            'J.ROOT-SERVERS.NET.' = '2001:503:c27::2:30'
            'K.ROOT-SERVERS.NET.' = '2001:7fd::1'
            'L.ROOT-SERVERS.NET.' = '2001:500:9f::42'
            'M.ROOT-SERVERS.NET.' = '2001:dc3::353'
        }
    }
}

DefaultDnsServerRootHints
```

### Remove DNS server root hints

```powershell
configuration RemoveDnsServerRootHints
{
    Import-DscResource -ModuleName xDnsServer

    xDnsServerRootHint RootHints
    {
        IsSingleInstance = 'Yes'
        NameServer = @{ }
    }
}

RemoveDnsServerRootHints
```
