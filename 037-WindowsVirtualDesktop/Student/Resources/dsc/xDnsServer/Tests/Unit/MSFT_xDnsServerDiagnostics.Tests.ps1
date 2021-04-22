
$script:DSCModuleName   = 'xDnsServer'
$script:DSCResourceName = 'MSFT_xDnsServerDiagnostics'

#region HEADER
# Unit Test Template Version: 1.1.0
$moduleRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $Script:MyInvocation.MyCommand.Path))
if ( (-not (Test-Path -Path (Join-Path -Path $moduleRoot -ChildPath 'DSCResource.Tests'))) -or `
(-not (Test-Path -Path (Join-Path -Path $moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1'))) )
{
    & git @('clone','https://github.com/PowerShell/DscResource.Tests.git',(Join-Path -Path $moduleRoot -ChildPath '\DSCResource.Tests\'))
}

Import-Module (Join-Path -Path $moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1') -Force
$testEnvironment = Initialize-TestEnvironment `
-DSCModuleName $script:DSCModuleName `
-DSCResourceName $script:DSCResourceName `
-TestType Unit
#endregion HEADER

# Begin Testing
try
{
    InModuleScope $script:DSCResourceName {
        function Get-DnsServerDiagnostics {}
        function Set-DnsServerDiagnostics {}

        #region Pester Test Initialization

        $testParameters = [PSCustomObject]@{
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

        $mockGetDnsServerDiagnostics = [PSCustomObject]@{
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

        $commonParameters += [System.Management.Automation.PSCmdlet]::CommonParameters
        $commonParameters += [System.Management.Automation.PSCmdlet]::OptionalCommonParameters

        $mockParameters = @{
            Verbose             = $true
            Debug               = $true
            ErrorAction         = 'stop'
            WarningAction       = 'Continue'
            InformationAction   = 'Continue'
            ErrorVariable       = 'err'
            WarningVariable     = 'warn'
            OutVariable         = 'out'
            OutBuffer           = 'outbuff'
            PipelineVariable    = 'pipe'
            InformationVariable = 'info'
            WhatIf              = $true
            Confirm             = $true
            UseTransaction      = $true
            Name                = 'DnsServerDiagnostic'
        }

        #endregion Pester Test Initialization

        #region Example state 1
        Describe 'The system is not in the desired state' {

            Context 'Get-TargetResource' {
                It "Get method returns 'something'" {
                    Mock Get-DnsServerDiagnostics -MockWith {$mockGetDnsServerDiagnostics}
                    Mock Assert-Module
                    $getResult = Get-TargetResource -Name 'DnsServerDiagnostic'

                    foreach ($key in $getResult.Keys)
                    {
                        if ($null -ne $getResult[$key] -and $key -ne 'Name')
                        {
                            $getResult[$key] | Should be $mockGetDnsServerDiagnostics.$key
                        }
                    }
                }

                It 'Get throws when DnsServerDiagnostics is not found' {
                    Mock Get-DnsServerDiagnostics -MockWith {throw 'Invalid Class'}

                    {Get-TargetResource -Name 'DnsServerDiagnostics'} | should throw 'Invalid Class'
                }
            }

            Context 'Test-TargetResource' {

                $falseParameters = @{Name = 'DnsServerDiagnostic'}

                foreach ($key in $testParameters.Keys)
                {
                    if ($key -ne 'Name')
                    {
                        $falseTestParameters = $falseParameters.Clone()
                        $falseTestParameters.Add($key,$testParameters[$key])
                        It "Test method returns false when testing $key" {
                            Mock Get-TargetResource -MockWith {$mockGetDnsServerDiagnostics}
                            Test-TargetResource @falseTestParameters | Should be $false
                        }
                    }
                }
            }

            Context 'Error handling' {
                It 'Test throws when DnsServerDiagnostics is not found' {
                    Mock Get-DnsServerDiagnostics -MockWith {throw 'Invalid Class'}

                    {Get-TargetResource -Name 'xDnsServerSetting_Integration'} | should throw 'Invalid Class'
                }
            }

            Context 'Set-TargetResource' {
                It 'Set method calls Set-CimInstance' {
                    Mock Get-DnsServerDiagnostics -MockWith {$mockGetDnsServerDiagnostics}
                    Mock Set-DnsServerDiagnostics {}

                    Set-TargetResource @testParameters

                    Assert-MockCalled Set-DnsServerDiagnostics -Exactly 1
                }
            }
        }
        #endregion Example state 1

        #region Example state 2
        Describe 'The system is in the desired state' {

            Context 'Test-TargetResource' {

                Mock Get-TargetResource -MockWith { $mockGetDnsServerDiagnostics }

                $trueParameters = @{ Name = 'xDnsServerDiagnostics_Integration' }

                foreach ($key in $testParameters.Keys)
                {
                    if ($key -ne 'Name')
                    {
                        $trueTestParameters = $trueParameters.Clone()

                        $trueTestParameters.Add($key,$mockGetDnsServerDiagnostics.$key)

                        It "Test method returns true when testing $key" {
                            $result = Test-TargetResource @trueTestParameters
                            $result | Should be $true
                        }
                    }
                }

            }
        }
        #endregion Example state 2

        #region Non-Exported Function Unit Tests

        Describe 'Private functions' {

            Context 'Remove-CommonParameters' {
                It 'Should not contain any common parameters' {
                    $removeResults = Remove-CommonParameter $mockParameters

                    foreach ($key in $removeResults.Keys)
                    {
                        $commonParameters -notcontains $key | should be $true
                    }
                }
            }
        }
        #endregion Non-Exported Function Unit Tests
    }
}
finally
{
    #region FOOTER
    Restore-TestEnvironment -TestEnvironment $testEnvironment
    #endregion
}
