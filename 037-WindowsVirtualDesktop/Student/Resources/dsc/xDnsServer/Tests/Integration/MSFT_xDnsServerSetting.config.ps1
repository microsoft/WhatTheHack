
$testParameters = @{
    Name                      = 'xDnsServerSetting_Integration'
    AddressAnswerLimit        = 0
    AllowUpdate               = 1
    AutoCacheUpdate           = $false
    AutoConfigFileZones       = 1
    BindSecondaries           = $false
    BootMethod                = 3
    DefaultAgingState         = $false
    DefaultNoRefreshInterval  = 168
    DefaultRefreshInterval    = 168
    DisableAutoReverseZones   = $false
    DisjointNets              = $false
    DsPollingInterval         = 180
    DsTombstoneInterval       = 1209600
    EDnsCacheTimeout          = 900
    EnableDirectoryPartitions = $true
    EnableDnsSec              = 1
    EnableEDnsProbes          = $true
    EventLogLevel             = 4
    ForwardDelegations        = 0
    Forwarders                = {168.63.129.16}
    ForwardingTimeout         = 3
    IsSlave                   = $false
    ListenAddresses           = $null
    LocalNetPriority          = $true
    LogFileMaxSize            =  500000000
    LogFilePath               = 'C:\Windows\System32\DNS\DNS.log'
    LogIpFilterList           = "10.0.0.1","10.0.0.10"
    LogLevel                  = 0
    LooseWildcarding          = $false
    MaxCacheTTL               = 86400
    MaxNegativeCacheTTL       = 900
    NameCheckFlag             = 2
    NoRecursion               = $true
    RecursionRetry            = 3
    RecursionTimeout          = 8
    RoundRobin                = $true
    RpcProtocol               = 5
    ScavengingInterval        = 168
    SecureResponses           = $true
    SendPort                  = 0
    StrictFileParsing         =  $false
    UpdateOptions             = 783
    WriteAuthorityNS          = $false
    XfrConnectTimeout         = 30
}

configuration MSFT_xDnsServerSetting_config {

    Import-DscResource -ModuleName xDnsServer

    node localhost 
    {
        WindowsFeature InstallDns
        {
            Name = 'DNS'
            Ensure = 'Present'
            IncludeAllSubFeature = $true
        }

        xDnsServerSetting Integration_Test {

            Name                      = $testParameters.Name
            AddressAnswerLimit        = $testParameters.AddressAnswerLimit
            AllowUpdate               = $testParameters.AllowUpdate
            AutoCacheUpdate           = $testParameters.AutoCacheUpdate
            AutoConfigFileZones       = $testParameters.AutoConfigFileZones
            BindSecondaries           = $testParameters.BindSecondaries
            BootMethod                = $testParameters.BootMethod
            DefaultAgingState         = $testParameters.DefaultAgingState
            DefaultNoRefreshInterval  = $testParameters.DefaultNoRefreshInterval
            DefaultRefreshInterval    = $testParameters.DefaultRefreshInterval
            DisableAutoReverseZones   = $testParameters.DisableAutoReverseZones
            DisjointNets              = $testParameters.DisjointNets
            DsPollingInterval         = $testParameters.DsPollingInterval
            DsTombstoneInterval       = $testParameters.DsTombstoneInterval
            EDnsCacheTimeout          = $testParameters.EDnsCacheTimeout
            EnableDirectoryPartitions = $testParameters.EnableDirectoryPartitions
            EnableDnsSec              = $testParameters.EnableDnsSec
            EnableEDnsProbes          = $testParameters.EnableEDnsProbes
            EventLogLevel             = $testParameters.EventLogLevel
            ForwardDelegations        = $testParameters.ForwardDelegations
            Forwarders                = $testParameters.Forwarders
            ForwardingTimeout         = $testParameters.ForwardingTimeout
            IsSlave                   = $testParameters.IsSlave
            ListenAddresses           = $testParameters.ListenAddresses
            LocalNetPriority          = $testParameters.LocalNetPriority
            LogFileMaxSize            = $testParameters.LogFileMaxSize
            LogFilePath               = $testParameters.LogFilePath
            LogIPFilterList           = $testParameters.LogIPFilterList
            LogLevel                  = $testParameters.LogLevel
            LooseWildcarding          = $testParameters.LooseWildcarding
            MaxCacheTTL               = $testParameters.MaxCacheTTL
            MaxNegativeCacheTTL       = $testParameters.MaxNegativeCacheTTL
            NameCheckFlag             = $testParameters.NameCheckFlag
            NoRecursion               = $testParameters.NoRecursion
            RecursionRetry            = $testParameters.RecursionRetry
            RecursionTimeout          = $testParameters.RecursionTimeout
            RoundRobin                = $testParameters.RoundRobin
            RpcProtocol               = $testParameters.RpcProtocol
            ScavengingInterval        = $testParameters.ScavengingInterval
            SecureResponses           = $testParameters.SecureResponses
            SendPort                  = $testParameters.SendPort
            StrictFileParsing         = $testParameters.StrictFileParsing
            UpdateOptions             = $testParameters.UpdateOptions
            WriteAuthorityNS          = $testParameters.WriteAuthorityNS
            XfrConnectTimeout         = $testParameters.XfrConnectTimeout
            DependsOn                 = '[WindowsFeature]InstallDns'
        }
    }
}
