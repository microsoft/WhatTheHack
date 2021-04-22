# Import the Helper module
$modulePath = Join-Path -Path (Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent) -ChildPath 'Modules'
Import-Module -Name (Join-Path -Path $modulePath -ChildPath (Join-Path -Path Helper -ChildPath Helper.psm1))

data LocalizedData
{
    ConvertFrom-StringData -StringData @'
NotInDesiredState="{0}" not in desired state. Expected: "{1}" Actual: "{2}".
DnsClassNotFound=MicrosoftDNS_Server class not found. DNS role is not installed.
ParameterExpectedNull={0} expected to be NULL nut is not.
GettingDnsServerSettings=Getting DNS Server Settings.
SetDnsServerSetting=Setting Dns setting '{0}' to value '{1}'.
'@
}

$properties = 'LocalNetPriority', 'AutoConfigFileZones', 'MaxCacheTTL', 'AddressAnswerLimit', 'UpdateOptions', 'DisableAutoReverseZones', 'StrictFileParsing', 'ForwardingTimeout', 'NoRecursion', 'ScavengingInterval', 'DisjointNets', 'Forwarders', 'DefaultAgingState', 'EnableDirectoryPartitions', 'LogFilePath', 'XfrConnectTimeout', 'AllowUpdate', 'Name', 'DsAvailable', 'BootMethod', 'LooseWildcarding', 'DsPollingInterval', 'BindSecondaries', 'LogLevel', 'AutoCacheUpdate', 'EnableDnsSec', 'EnableEDnsProbes', 'NameCheckFlag', 'EDnsCacheTimeout', 'SendPort', 'WriteAuthorityNS', 'IsSlave', 'LogIPFilterList', 'RecursionTimeout', 'ListenAddresses', 'DsTombstoneInterval', 'EventLogLevel', 'RecursionRetry', 'RpcProtocol', 'SecureResponses', 'RoundRobin', 'ForwardDelegations', 'LogFileMaxSize', 'DefaultNoRefreshInterval', 'MaxNegativeCacheTTL', 'DefaultRefreshInterval'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $Name
    )

    Assert-Module -Name DnsServer

    Write-Verbose ($LocalizedData.GettingDnsServerSettings)
    $dnsServerInstance = Get-CimInstance -Namespace root\MicrosoftDNS -ClassName MicrosoftDNS_Server -ErrorAction Stop

    $returnValue = @{}

    foreach ($property in $properties)
    {
        $returnValue.Add($property, $dnsServerInstance."$property")
    }
    $returnValue.LogIPFilterList = (Get-PsDnsServerDiagnosticsClass).FilterIPAddressList
    $returnValue.Name = $Name

    $returnValue
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $Name,

        [Parameter()]
        [uint32]
        $AddressAnswerLimit,

        [Parameter()]
        [uint32]
        $AllowUpdate,

        [Parameter()]
        [bool]
        $AutoCacheUpdate,

        [Parameter()]
        [uint32]
        $AutoConfigFileZones,

        [Parameter()]
        [bool]
        $BindSecondaries,

        [Parameter()]
        [uint32]
        $BootMethod,

        [Parameter()]
        [bool]
        $DefaultAgingState,

        [Parameter()]
        [uint32]
        $DefaultNoRefreshInterval,

        [Parameter()]
        [uint32]
        $DefaultRefreshInterval,

        [Parameter()]
        [bool]
        $DisableAutoReverseZones,

        [Parameter()]
        [bool]
        $DisjointNets,

        [Parameter()]
        [uint32]
        $DsPollingInterval,

        [Parameter()]
        [uint32]
        $DsTombstoneInterval,

        [Parameter()]
        [uint32]
        $EDnsCacheTimeout,

        [Parameter()]
        [bool]
        $EnableDirectoryPartitions,

        [Parameter()]
        [uint32]
        $EnableDnsSec,

        [Parameter()]
        [bool]
        $EnableEDnsProbes,

        [Parameter()]
        [uint32]
        $EventLogLevel,

        [Parameter()]
        [uint32]
        $ForwardDelegations,

        [Parameter()]
        [string[]]
        $Forwarders,

        [Parameter()]
        [uint32]
        $ForwardingTimeout,

        [Parameter()]
        [bool]
        $IsSlave,

        [Parameter()]
        [string[]]
        $ListenAddresses,

        [Parameter()]
        [bool]
        $LocalNetPriority,

        [Parameter()]
        [uint32]
        $LogFileMaxSize,

        [Parameter()]
        [string]
        $LogFilePath,

        [Parameter()]
        [string[]]
        $LogIPFilterList,

        [Parameter()]
        [uint32]
        $LogLevel,

        [Parameter()]
        [bool]
        $LooseWildcarding,

        [Parameter()]
        [uint32]
        $MaxCacheTTL,

        [Parameter()]
        [uint32]
        $MaxNegativeCacheTTL,

        [Parameter()]
        [uint32]
        $NameCheckFlag,

        [Parameter()]
        [bool]
        $NoRecursion,

        [Parameter()]
        [uint32]
        $RecursionRetry,

        [Parameter()]
        [uint32]
        $RecursionTimeout,

        [Parameter()]
        [bool]
        $RoundRobin,

        [Parameter()]
        [int16]
        $RpcProtocol,

        [Parameter()]
        [uint32]
        $ScavengingInterval,

        [Parameter()]
        [bool]
        $SecureResponses,

        [Parameter()]
        [uint32]
        $SendPort,

        [Parameter()]
        [bool]
        $StrictFileParsing,

        [Parameter()]
        [uint32]
        $UpdateOptions,

        [Parameter()]
        [bool]
        $WriteAuthorityNS,

        [Parameter()]
        [uint32]
        $XfrConnectTimeout
    )

    Assert-Module -Name DnsServer

    $PSBoundParameters.Remove('Name')
    $dnsProperties = Remove-CommonParameter -Hashtable $PSBoundParameters

    $dnsServerInstance = Get-CimInstance -Namespace root\MicrosoftDNS -ClassName MicrosoftDNS_Server

    try
    {
        foreach ($property in $dnsProperties.keys)
        {
            Write-Verbose -Message ($LocalizedData.SetDnsServerSetting -f $property, $dnsProperties[$property])
        }

        Set-CimInstance -InputObject $dnsServerInstance -Property $dnsProperties -ErrorAction Stop
    }
    catch
    {
        throw $_
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([bool])]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $Name,

        [Parameter()]
        [uint32]
        $AddressAnswerLimit,

        [Parameter()]
        [uint32]
        $AllowUpdate,

        [Parameter()]
        [bool]
        $AutoCacheUpdate,

        [Parameter()]
        [uint32]
        $AutoConfigFileZones,

        [Parameter()]
        [bool]
        $BindSecondaries,

        [Parameter()]
        [uint32]
        $BootMethod,

        [Parameter()]
        [bool]
        $DefaultAgingState,

        [Parameter()]
        [uint32]
        $DefaultNoRefreshInterval,

        [Parameter()]
        [uint32]
        $DefaultRefreshInterval,

        [Parameter()]
        [bool]
        $DisableAutoReverseZones,

        [Parameter()]
        [bool]
        $DisjointNets,

        [Parameter()]
        [uint32]
        $DsPollingInterval,

        [Parameter()]
        [uint32]
        $DsTombstoneInterval,

        [Parameter()]
        [uint32]
        $EDnsCacheTimeout,

        [Parameter()]
        [bool]
        $EnableDirectoryPartitions,

        [Parameter()]
        [uint32]
        $EnableDnsSec,

        [Parameter()]
        [bool]
        $EnableEDnsProbes,

        [Parameter()]
        [uint32]
        $EventLogLevel,

        [Parameter()]
        [uint32]
        $ForwardDelegations,

        [Parameter()]
        [string[]]
        $Forwarders,

        [Parameter()]
        [uint32]
        $ForwardingTimeout,

        [Parameter()]
        [bool]
        $IsSlave,

        [Parameter()]
        [string[]]
        $ListenAddresses,

        [Parameter()]
        [bool]
        $LocalNetPriority,

        [Parameter()]
        [uint32]
        $LogFileMaxSize,

        [Parameter()]
        [string]
        $LogFilePath,

        [Parameter()]
        [string[]]
        $LogIPFilterList,

        [Parameter()]
        [uint32]
        $LogLevel,

        [Parameter()]
        [bool]
        $LooseWildcarding,

        [Parameter()]
        [uint32]
        $MaxCacheTTL,

        [Parameter()]
        [uint32]
        $MaxNegativeCacheTTL,

        [Parameter()]
        [uint32]
        $NameCheckFlag,

        [Parameter()]
        [bool]
        $NoRecursion,

        [Parameter()]
        [uint32]
        $RecursionRetry,

        [Parameter()]
        [uint32]
        $RecursionTimeout,

        [Parameter()]
        [bool]
        $RoundRobin,

        [Parameter()]
        [int16]
        $RpcProtocol,

        [Parameter()]
        [uint32]
        $ScavengingInterval,

        [Parameter()]
        [bool]
        $SecureResponses,

        [Parameter()]
        [uint32]
        $SendPort,

        [Parameter()]
        [bool]
        $StrictFileParsing,

        [Parameter()]
        [uint32]
        $UpdateOptions,

        [Parameter()]
        [bool]
        $WriteAuthorityNS,

        [Parameter()]
        [uint32]
        $XfrConnectTimeout
    )

    Write-Verbose -Message 'Evaluating the DNS server settings.'

    $currentState = Get-TargetResource -Name $Name

    $desiredState = $PSBoundParameters
    $result = Test-DscParameterState -CurrentValues $currentState -DesiredValues $desiredState -TurnOffTypeChecking -Verbose:$VerbosePreference

    return $result
}

<#
        .SYNOPSIS
        Internal function to get results from the PS_DnsServerDiagnostics.
        This is needed because LogIpFilterList is not returned by querying the MicrosoftDNS_Server class.
#>
function Get-PsDnsServerDiagnosticsClass
{
    [CmdletBinding()]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]

    $invokeCimMethodParameters = @{
        NameSpace   = 'root/Microsoft/Windows/DNS'
        ClassName   = 'PS_DnsServerDiagnostics'
        MethodName  = 'Get'
        ErrorAction = 'Stop'
    }

    $cimDnsServerDiagnostics = Invoke-CimMethod @invokeCimMethodParameters
    $cimDnsServerDiagnostics.cmdletOutput
}

Export-ModuleMember -Function *-TargetResource
