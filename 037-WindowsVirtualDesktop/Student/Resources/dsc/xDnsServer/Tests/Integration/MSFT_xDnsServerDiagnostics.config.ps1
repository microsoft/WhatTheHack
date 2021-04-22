
$testParameters = @{
    Name                                 = 'xDnsServerDiagnostics_Integration'
    Answers                              = $true
    EnableLogFileRollover                = $true
    EnableLoggingForLocalLookupEvent     = $true
    EnableLoggingForPluginDllEvent       = $true
    EnableLoggingForRecursiveLookupEvent = $true
    EnableLoggingForRemoteServerEvent    = $true
    EnableLoggingForServerStartStopEvent = $true
    EnableLoggingForTombstoneEvent       = $true
    EnableLoggingForZoneDataWriteEvent   = $true
    EnableLoggingForZoneLoadingEvent     = $true
    EnableLoggingToFile                  = $true
    EventLogLevel                        = 4
    FilterIPAddressList                  = "192.168.1.1","192.168.1.2"
    FullPackets                          = $true
    LogFilePath                          = 'C:\Windows\System32\DNS\DNSDiagnostics.log'
    MaxMBFileSize                        = 500000000
    Notifications                        = $true
    Queries                              = $true
    QuestionTransactions                 = $true
    ReceivePackets                       = $true
    SaveLogsToPersistentStorage          = $true
    SendPackets                          = $true
    TcpPackets                           = $true
    UdpPackets                           = $true
    UnmatchedResponse                    = $true
    Update                               = $true
    UseSystemEventLog                    = $true
    WriteThrough                         = $true
}

configuration MSFT_xDnsServerDiagnostics_config
{

    Import-DscResource -ModuleName xDnsServer

    node localhost
    {
        WindowsFeature InstallDns
        {
            Name = 'DNS'
            Ensure = 'Present'
            IncludeAllSubFeature = $true
        }

        xDnsServerDiagnostics Integration_Test
        {
            Name                                 = $testParameters.Name
            Answers                              = $testParameters.Answers
            EnableLogFileRollover                = $testParameters.EnableLogFileRollover
            EnableLoggingForLocalLookupEvent     = $testParameters.EnableLoggingForLocalLookupEvent
            EnableLoggingForPluginDllEvent       = $testParameters.EnableLoggingForPluginDllEvent
            EnableLoggingForRecursiveLookupEvent = $testParameters.EnableLoggingForRecursiveLookupEvent
            EnableLoggingForRemoteServerEvent    = $testParameters.EnableLoggingForRemoteServerEvent
            EnableLoggingForServerStartStopEvent = $testParameters.EnableLoggingForServerStartStopEvent
            EnableLoggingForTombstoneEvent       = $testParameters.EnableLoggingForTombstoneEvent
            EnableLoggingForZoneDataWriteEvent   = $testParameters.EnableLoggingForZoneDataWriteEvent
            EnableLoggingForZoneLoadingEvent     = $testParameters.EnableLoggingForZoneLoadingEvent
            EnableLoggingToFile                  = $testParameters.EnableLoggingToFile
            EventLogLevel                        = $testParameters.EventLogLevel
            FilterIPAddressList                  = $testParameters.FilterIPAddressList
            FullPackets                          = $testParameters.FullPackets
            LogFilePath                          = $testParameters.LogFilePath
            MaxMBFileSize                        = $testParameters.MaxMBFileSize
            Notifications                        = $testParameters.Notifications
            Queries                              = $testParameters.Queries
            QuestionTransactions                 = $testParameters.QuestionTransactions
            ReceivePackets                       = $testParameters.ReceivePackets
            SaveLogsToPersistentStorage          = $testParameters.SaveLogsToPersistentStorage
            SendPackets                          = $testParameters.SendPackets
            TcpPackets                           = $testParameters.TcpPackets
            UdpPackets                           = $testParameters.UdpPackets
            UnmatchedResponse                    = $testParameters.UnmatchedResponse
            Update                               = $testParameters.Update
            UseSystemEventLog                    = $testParameters.UseSystemEventLog
            WriteThrough                         = $testParameters.WriteThrough
            DependsOn                            = '[WindowsFeature]InstallDns'
        }
    }
}
