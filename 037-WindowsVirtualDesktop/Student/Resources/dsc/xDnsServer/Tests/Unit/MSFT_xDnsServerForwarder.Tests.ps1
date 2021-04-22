$Global:DSCModuleName      = 'xDnsServer'
$Global:DSCResourceName    = 'MSFT_xDnsServerForwarder'

#region HEADER
[String] $moduleRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $Script:MyInvocation.MyCommand.Path))
if ( (-not (Test-Path -Path (Join-Path -Path $moduleRoot -ChildPath 'DSCResource.Tests'))) -or `
     (-not (Test-Path -Path (Join-Path -Path $moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1'))) )
{
    & git @('clone','https://github.com/PowerShell/DscResource.Tests.git',(Join-Path -Path $moduleRoot -ChildPath '\DSCResource.Tests\'))
}
else
{
    & git @('-C',(Join-Path -Path $moduleRoot -ChildPath '\DSCResource.Tests\'),'pull')
}
Import-Module (Join-Path -Path $moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1') -Force
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
        function Get-DnsServerForwarder {}
        function Set-DnsServerForwarder {}

        $forwarders = '192.168.0.1','192.168.0.2'
        $UseRootHint = $true
        $testParams = @{
            IsSingleInstance = 'Yes'
            IPAddresses = $forwarders
            UseRootHint = $UseRootHint
        }
        $testParamLimited = @{
            IsSingleInstance = 'Yes'
            IPAddresses = $forwarders
        }
        $fakeDNSForwarder = @{
            IPAddress = $forwarders
            UseRootHint = $UseRootHint
        }
        $fakeUseRootHint = @{
            IPAddress = $forwarders
            UseRootHint = -not $UseRootHint
        }
        #endregion


        #region Function Get-TargetResource
        Describe "$($Global:DSCResourceName)\Get-TargetResource" {
            It 'Returns a "System.Collections.Hashtable" object type' {
                Mock -CommandName Get-DnsServerForwarder -MockWith {return $fakeDNSForwarder}
                $targetResource = Get-TargetResource -IsSingleInstance $testParams.IsSingleInstance
                $targetResource -is [System.Collections.Hashtable] | Should Be $true
            }

            It "Returns IPAddresses = $($testParams.IPAddresses) and UseRootHint = $($testParams.UseRootHint) when forwarders exist" {
                Mock -CommandName Get-DnsServerForwarder -MockWith {return $fakeDNSForwarder}
                $targetResource = Get-TargetResource -IsSingleInstance $testParams.IsSingleInstance
                $targetResource.IPAddresses | Should Be $testParams.IPAddresses
                $targetResource.UseRootHint | Should Be $testParams.UseRootHint
            }

            It "Returns an empty IPAddresses and UseRootHint at True when forwarders don't exist" {
                Mock -CommandName Get-DnsServerForwarder -MockWith {return @{IPAddress = @(); UseRootHint = $true}}
                $targetResource = Get-TargetResource -IsSingleInstance $testParams.IsSingleInstance
                $targetResource.IPAddresses | Should Be $null
                $targetResource.UseRootHint | Should Be $true
            }
        }
        #endregion


        #region Function Test-TargetResource
        Describe "$($Global:DSCResourceName)\Test-TargetResource" {
            It 'Returns a "System.Boolean" object type' {
                Mock -CommandName Get-DnsServerForwarder -MockWith {return $fakeDNSForwarder}
                $targetResource =  Test-TargetResource @testParams
                $targetResource -is [System.Boolean] | Should Be $true
            }

            It 'Passes when forwarders match' {
                Mock -CommandName Get-DnsServerForwarder -MockWith {return $fakeDNSForwarder}
                Test-TargetResource @testParams | Should Be $true
            }

            It 'Passes when forwarders match but root hint do not and are not spcified' {
                Mock -CommandName Get-DnsServerForwarder -MockWith {return $fakeUseRootHint}
                Test-TargetResource @testParamLimited | Should Be $true
            }

            It "Fails when forwarders don't match" {
                Mock -CommandName Get-DnsServerForwarder -MockWith {return @{IPAddress = @(); UseRootHint = $true}}
                Test-TargetResource @testParams | Should Be $false
            }

            It "Fails when UseRootHint don't match" {
                Mock -CommandName Get-DnsServerForwarder -MockWith {return @{IPAddress = $fakeDNSForwarder.IpAddress; UseRootHint = $false}}
                Test-TargetResource @testParams | Should Be $false
            }
        }
        #endregion


        #region Function Set-TargetResource
        Describe "$($Global:DSCResourceName)\Set-TargetResource" {
            It "Calls Set-DnsServerForwarder once" {
                Mock -CommandName Set-DnsServerForwarder -MockWith {}
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName Set-DnsServerForwarder -Times 1 -Exactly -Scope It
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
