$global:DSCModuleName = 'xDnsServer'
$global:DSCResourceName = 'MSFT_xDnsServerRootHint'

#region HEADER
$moduleRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $Script:MyInvocation.MyCommand.Path))
if ( (-not (Test-Path -Path (Join-Path -Path $moduleRoot -ChildPath 'DSCResource.Tests'))) -or `
    (-not (Test-Path -Path (Join-Path -Path $moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1'))) )
{
    & git @('clone', 'https://github.com/PowerShell/DscResource.Tests.git', (Join-Path -Path $moduleRoot -ChildPath '\DSCResource.Tests\'))
}
else
{
    & git @('-C', (Join-Path -Path $moduleRoot -ChildPath '\DSCResource.Tests\'), 'pull')
}
Import-Module -Name (Join-Path -Path $moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1') -Force
$TestEnvironment = Initialize-TestEnvironment `
    -DSCModuleName $Global:DSCModuleName `
    -DSCResourceName $Global:DSCResourceName `
    -TestType Unit
#endregion

# Begin Testing
try
{
    #region Pester Tests

    InModuleScope $Global:DSCResourceName {
        #region Pester Test Initialization

        $rootHints = @(
            [PSCustomObject]  @{
                NameServer = @{
                    RecordData = @{
                        NameServer = 'B.ROOT-SERVERS.NET.'
                    }
                }
                IPAddress  = @{
                    RecordData = @{
                        IPv4Address = @{
                            IPAddressToString = [IPAddress] '199.9.14.201'
                        }
                    }

                }
            }
            [PSCustomObject] @{
                NameServer = @{
                    RecordData = @{
                        NameServer = 'M.ROOT-SERVERS.NET.'
                    }
                }
                IPAddress  = @{
                    RecordData = @{
                        IPv4Address = @{
                            IPAddressToString = [IPAddress] '202.12.27.33'
                        }
                    }

                }
            }
        )
        $rootHintsHashtable = Convert-RootHintsToHashtable -RootHints $rootHints
        $rootHintsCim = ConvertTo-CimInstance -Hashtable $rootHintsHashtable
        #endregion

        #region Function Get-TargetResource
        Describe "$($Global:DSCResourceName)\Get-TargetResource" {
            It 'Returns a "System.Collections.Hashtable" object type' {
                Mock -CommandName Get-DnsServerRootHint -MockWith { return $rootHints }
                $targetResource = Get-TargetResource -IsSingleInstance Yes -NameServer $rootHintsCim
                $targetResource -is [System.Collections.Hashtable] | Should Be $true
            }

            It "Returns NameServer = <PrefedinedValue> when root hints exist" {
                Mock -CommandName Get-DnsServerRootHint -MockWith { return $rootHints }
                $targetResource = Get-TargetResource -IsSingleInstance Yes -NameServer $rootHintsCim
                Test-DscParameterState -CurrentValues $targetResource.NameServer -DesiredValues $rootHintsHashtable | Should -Be $true
            }

            It "Returns an empty NameServer when root hints don't exist" {
                Mock -CommandName Get-DnsServerRootHint -MockWith { return @() }
                $targetResource = Get-TargetResource -IsSingleInstance Yes -NameServer $rootHintsCim
                $targetResource.NameServer.Count | Should Be 0
            }
        }
        #endregion

        #region Function Test-TargetResource
        Describe "$($Global:DSCResourceName)\Test-TargetResource" {
            It 'Returns a "System.Boolean" object type' {
                Mock -CommandName Get-DnsServerRootHint -MockWith { return $rootHints }
                $targetResource = Test-TargetResource -IsSingleInstance Yes -NameServer $rootHintsCim
                $targetResource -is [System.Boolean] | Should Be $true
            }

            It 'Passes when forwarders match' {
                Mock -CommandName Get-DnsServerRootHint -MockWith { return $rootHints }
                Test-TargetResource -IsSingleInstance Yes -NameServer $rootHintsCim | Should Be $true
            }

            It "Fails when root hints don't match" {
                Mock -CommandName Get-DnsServerRootHint -MockWith { return @{ NameServer = @() } }
                Test-TargetResource -IsSingleInstance Yes -NameServer $rootHintsCim | Should Be $false
            }
        }
        #endregion


        #region Function Set-TargetResource
        Describe "$($Global:DSCResourceName)\Set-TargetResource" {
            It "Calls Add-DnsServerRootHint 2 times" {
                Mock -CommandName Remove-DnsServerRootHint -MockWith { }
                Mock -CommandName Add-DnsServerRootHint -MockWith { }
                Mock -CommandName Get-DnsServerRootHint -MockWith { }
                Set-TargetResource -IsSingleInstance Yes -NameServer $rootHintsCim
                Assert-MockCalled -CommandName Add-DnsServerRootHint -Times 2 -Exactly -Scope It
            }
        }
    } #end InModuleScope
}
finally
{
    #region FOOTER
    Restore-TestEnvironment -TestEnvironment $TestEnvironment
    #endregion
}
