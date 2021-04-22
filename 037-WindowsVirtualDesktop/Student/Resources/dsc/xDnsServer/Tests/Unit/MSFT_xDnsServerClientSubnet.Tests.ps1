#region HEADER
$script:DSCModuleName = 'xDnsServer'
$script:DSCResourceName = 'MSFT_xDnsServerClientSubnet'

$script:moduleRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
if ( (-not (Test-Path -Path (Join-Path -Path $script:moduleRoot -ChildPath 'DSCResource.Tests'))) -or `
    (-not (Test-Path -Path (Join-Path -Path $script:moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1'))) )
{
    & git @('clone', 'https://github.com/PowerShell/DscResource.Tests.git', (Join-Path -Path $script:moduleRoot -ChildPath 'DSCResource.Tests'))
}

Import-Module -Name (Join-Path -Path $script:moduleRoot -ChildPath (Join-Path -Path 'DSCResource.Tests' -ChildPath 'TestHelper.psm1')) -Force

$TestEnvironment = Initialize-TestEnvironment `
    -DSCModuleName $script:DSCModuleName `
    -DSCResourceName $script:DSCResourceName `
    -TestType Unit
#endregion HEADER

# Begin Testing
try
{
    #region Pester Tests

    InModuleScope $script:DSCResourceName {
        #region Pester Test Initialization
        $mocks = @{
            IPv4Present = {
                [PSCustomObject]@{
                    Name       = 'ClientSubnetA'
                    IPv4Subnet = '10.1.1.0/24'
                    IPv6Subnet = $null
                }
            }
            Absent  = { }
            IPv6Present = {
                [PSCustomObject]@{
                    Name       = 'ClientSubnetB'
                    IPv4Subnet = $null
                    IPv6Subnet = 'db8::1/28'
                }
            }
            BothPresent = {
                [PSCustomObject]@{
                    Name       = 'ClientSubnetC'
                    IPv4Subnet = '10.1.1.0/24'
                    IPv6Subnet = 'db8::1/28'
                }
            }
            GetIPv4Present = {
                [PSCustomObject]@{
                    Name       = 'ClientSubnetA'
                    IPv4Subnet = '10.1.1.0/24'
                    IPv6Subnet = $null
                }
            }
            GetIPv6Present = {
                [PSCustomObject]@{
                    Name       = 'ClientSubnetB'
                    IPv4Subnet = $null
                    IPv6Subnet = 'db8::1/28'
                    Ensure     = 'Present'
                }
            }
            GetBothPresent = {
                [PSCustomObject]@{
                    Name       = 'ClientSubnetC'
                    IPv4Subnet = '10.1.1.0/24'
                    IPv6Subnet = 'db8::1/28'
                }
            }
        }
        #endregion

        #region Function Get-TargetResource
        Describe "MSFT_xDnsServerClientSubnet\Get-TargetResource" -Tag 'Get' {
            Context 'When the system is in the desired state' {
                It 'Should set Ensure to Present when the IPv4 client subnet is present' {
                    Mock -CommandName Get-DnsServerClientSubnet $mocks.IPv4Present

                    $getTargetResourceResult = Get-TargetResource 'ClientSubnetA'
                    $getTargetResourceResult.Ensure | Should -Be 'Present'
                    $getTargetResourceResult.IPv4Subnet | Should -Be '10.1.1.0/24'
                    $getTargetResourceResult.IPv6Subnet | Should -BeNullOrEmpty

                    Assert-MockCalled -CommandName Get-DnsServerClientSubnet -Exactly -Times 1 -Scope It
                }

                It 'Should set Ensure to Present when the IPv6 client subnet is present' {
                    Mock -CommandName Get-DnsServerClientSubnet $mocks.IPv6Present

                    $getTargetResourceResult = Get-TargetResource 'ClientSubnetB'
                    $getTargetResourceResult.Ensure | Should -Be 'Present'
                    $getTargetResourceResult.IPv4Subnet | Should -BeNullOrEmpty
                    $getTargetResourceResult.IPv6Subnet | Should -Be 'db8::1/28'

                    Assert-MockCalled -CommandName Get-DnsServerClientSubnet -Exactly -Times 1 -Scope It
                }
                It 'Should set Ensure to Present when both client subnets are present' {
                    Mock -CommandName Get-DnsServerClientSubnet $mocks.BothPresent

                    $getTargetResourceResult = Get-TargetResource 'ClientSubnetC'
                    $getTargetResourceResult.Ensure | Should -Be 'Present'
                    $getTargetResourceResult.IPv4Subnet | Should -Be '10.1.1.0/24'
                    $getTargetResourceResult.IPv6Subnet | Should -Be 'db8::1/28'

                    Assert-MockCalled -CommandName Get-DnsServerClientSubnet -Exactly -Times 1 -Scope It
                }
            }

            Context 'When the system is not in the desired state' {
                It 'Should set Ensure to Absent when the IPv4 client subnet is not present' {
                    Mock -CommandName Get-DnsServerClientSubnet $mocks.Absent

                    $getTargetResourceResult = Get-TargetResource 'ClientSubnetA'
                    $getTargetResourceResult.Ensure | Should -Be 'Absent'
                    $getTargetResourceResult.IPv4Subnet | Should -BeNullOrEmpty
                    $getTargetResourceResult.IPv6Subnet | Should -BeNullOrEmpty

                    Assert-MockCalled -CommandName Get-DnsServerClientSubnet -Exactly -Times 1 -Scope It
                }

                It 'Should set Ensure to Absent when the IPv6 client subnet is not present' {
                    Mock -CommandName Get-DnsServerClientSubnet $mocks.Absent

                    $getTargetResourceResult = Get-TargetResource 'ClientSubnetB'
                    $getTargetResourceResult.Ensure | Should -Be 'Absent'
                    $getTargetResourceResult.IPv4Subnet | Should -BeNullOrEmpty
                    $getTargetResourceResult.IPv6Subnet | Should -BeNullOrEmpty

                    Assert-MockCalled -CommandName Get-DnsServerClientSubnet -Exactly -Times 1 -Scope It
                }
                It 'Should set Ensure to Absent when both client subnets are not present' {
                    Mock -CommandName Get-DnsServerClientSubnet $mocks.Absent

                    $getTargetResourceResult = Get-TargetResource 'ClientSubnetC'
                    $getTargetResourceResult.Ensure | Should -Be 'Absent'
                    $getTargetResourceResult.IPv4Subnet | Should -BeNullOrEmpty
                    $getTargetResourceResult.IPv6Subnet | Should -BeNullOrEmpty

                    Assert-MockCalled -CommandName Get-DnsServerClientSubnet -Exactly -Times 1 -Scope It
                }
            }
        }
        #endregion Function Get-TargetResource

        #region Function Test-TargetResource
        Describe "MSFT_xDnsServerClientSubnet\Test-TargetResource" -Tag 'Test' {
            Context 'When the system is in the desired state' {
                It 'Should return True when the IPv4Subnet matches' {
                    Mock -CommandName Get-DnsServerClientSubnet $mocks.IPv4Present
                    $params = @{
                        Ensure     = 'Present'
                        Name       = 'ClientSubnetA'
                        IPv4Subnet = '10.1.1.0/24'
                    }
                    Test-TargetResource @params | Should -BeTrue
                }

                It 'Should return True when the IPv6Subnet matches' {
                    Mock -CommandName Get-DnsServerClientSubnet $mocks.IPv6Present
                    $params = @{
                        Ensure     = 'Present'
                        Name       = 'ClientSubnetB'
                        IPv6Subnet = 'db8::1/28'
                    }
                    Test-TargetResource @params | Should -BeTrue
                }

                It 'Should return True when both IPv4 and IPv6 Subnets match' {
                    Mock -CommandName Get-DnsServerClientSubnet $mocks.BothPresent
                    $params = @{
                        Ensure     = 'Present'
                        Name       = 'ClientSubnetC'
                        IPv4Subnet = '10.1.1.0/24'
                        IPv6Subnet = 'db8::1/28'
                    }
                    Test-TargetResource @params | Should -BeTrue
                }
            }

            Context 'When the system is not in the desired state' {
                It 'Should return False when the Ensure doesnt match' {
                    Mock -CommandName Get-DnsServerClientSubnet $mocks.Absent
                    $params = @{
                        Ensure     = 'Present'
                        Name       = 'ClientSubnetA'
                        IPv4Subnet = '10.1.20.0/24'
                    }
                    Test-TargetResource @params | Should -BeFalse

                    Assert-MockCalled -CommandName Get-DnsServerClientSubnet -Exactly -Times 1 -Scope It
                }

                It 'Should return False when an IPv4 Subnet does not exist but one is configured' {
                    Mock -CommandName Get-DnsServerClientSubnet $mocks.Absent
                    $params = @{
                        Ensure     = 'Present'
                        Name       = 'ClientSubnetA'
                        IPv4Subnet = '10.1.20.0/24'
                    }
                    Test-TargetResource @params | Should -BeFalse

                    Assert-MockCalled -CommandName Get-DnsServerClientSubnet -Exactly -Times 1 -Scope It
                }

                It 'Should return False when the IPv4 Subnet does not match what is configured' {
                    Mock -CommandName Get-DnsServerClientSubnet $mocks.GetIPv4Present
                    $params = @{
                        Ensure     = 'Present'
                        Name       = 'ClientSubnetA'
                        IPv4Subnet = '10.1.20.0/24'
                    }
                    Test-TargetResource @params | Should -BeFalse

                    Assert-MockCalled -CommandName Get-DnsServerClientSubnet -Exactly -Times 1 -Scope It
                }

                It 'Should return False when the IPv6 Subnet does not match what is configured' {
                    Mock -CommandName Get-DnsServerClientSubnet $mocks.GetIPv6Present
                    $params = @{
                        Ensure     = 'Present'
                        Name       = 'ClientSubnetB'
                        IPv6Subnet = 'aab8::1/28'
                    }
                    Test-TargetResource @params | Should -BeFalse

                    Assert-MockCalled -CommandName Get-DnsServerClientSubnet -Exactly -Times 1 -Scope It
                }

                It 'Should return False when an IPv6 Subnet does not exist but one is configured' {
                    Mock -CommandName Get-DnsServerClientSubnet $mocks.Absent
                    $params = @{
                        Ensure     = 'Present'
                        Name       = 'ClientSubnetB'
                        IPv6Subnet = 'db8::1/28'
                    }
                    Test-TargetResource @params | Should -BeFalse

                    Assert-MockCalled -CommandName Get-DnsServerClientSubnet -Exactly -Times 1 -Scope It
                }
            }
       }
        #endregion

        #region Function Set-TargetResource
        Describe "MSFT_xDnsServerClientSubnet\Set-TargetResource" -Tag 'Set' {
            Context 'When configuring DNS Server Client Subnets' {
                It 'Calls Add-DnsServerClientSubnet in the set method when the subnet does not exist' {
                    Mock -CommandName Get-DnsServerClientSubnet
                    Mock -CommandName Add-DnsServerClientSubnet

                    $params = @{
                        Ensure     = 'Present'
                        Name       = 'ClientSubnetA'
                        IPv4Subnet = '10.1.20.0/24'
                    }
                    Set-TargetResource @params

                    Assert-MockCalled Add-DnsServerClientSubnet -Scope It -ParameterFilter {
                        $Name -eq 'ClientSubnetA' -and $IPv4Subnet -eq '10.1.20.0/24'
                    }
                }

                It 'Calls Remove-DnsServerClientSubnet in the set method when Ensure is Absent' {
                    Mock -CommandName Remove-DnsServerClientSubnet
                    Mock -CommandName Get-DnsServerClientSubnet { return $mocks.IPv4Present }
                    $params = @{
                        Ensure     = 'Absent'
                        Name       = 'ClientSubnetA'
                        IPv4Subnet = '10.1.20.0/24'
                    }
                    Set-TargetResource @params

                    Assert-MockCalled Remove-DnsServerClientSubnet -Scope It
                }

                It "Calls Set-DnsServerClientSubnet in the set method when Ensure is Present subnet is found" {

                    Mock -CommandName Set-DnsServerClientSubnet
                    Mock -CommandName Get-DnsServerClientSubnet $mocks.IPv4Present
                    $params = @{
                        Ensure     = 'Present'
                        Name       = 'ClientSubnetX'
                        IPv4Subnet = '10.1.1.0/24'
                    }
                    Set-TargetResource @params

                    Assert-MockCalled Set-DnsServerClientSubnet -Scope It
                }

            }
        }
        #endregion
    } #end InModuleScope
}
finally
{
    #region FOOTER
    Restore-TestEnvironment -TestEnvironment $TestEnvironment
    #endregion
}
