#region HEADER
$script:DSCModuleName = 'xDnsServer'
$script:DSCResourceName = 'MSFT_xDnsServerZoneScope'

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
            ZoneScopePresent = {
                [PSCustomObject]@{
                    ZoneName = 'contoso.com'
                    Name     = 'ZoneScope'
                }
            }
            Absent  = { }
        }
        #endregion

        #region Function Get-TargetResource
        Describe "MSFT_xDnsServerZoneScope\Get-TargetResource" -Tag 'Get' {
            Context 'When the system is in the desired state' {
                It 'Should set Ensure to Present when the Zone Scope is Present' {
                    Mock -CommandName Get-DnsServerZoneScope $mocks.ZoneScopePresent

                    $getTargetResourceResult = Get-TargetResource -ZoneName 'contoso.com' -Name 'ZoneScope'
                    $getTargetResourceResult.Ensure | Should -Be 'Present'
                    $getTargetResourceResult.Name | Should -Be 'ZoneScope'
                    $getTargetResourceResult.ZoneName | Should -Be 'contoso.com'

                    Assert-MockCalled -CommandName Get-DnsServerZoneScope -Exactly -Times 1 -Scope It
                }
            }

            Context 'When the system is not in the desired state' {
                It 'Should set Ensure to Absent when the Zone Scope is not present' {
                    Mock -CommandName Get-DnsServerZoneScope $mocks.Absent

                    $getTargetResourceResult = Get-TargetResource -ZoneName 'contoso.com' -Name 'ZoneScope'
                    $getTargetResourceResult.Ensure | Should -Be 'Absent'
                    $getTargetResourceResult.Name | Should -Be 'ZoneScope'
                    $getTargetResourceResult.ZoneName | Should -Be 'contoso.com'

                    Assert-MockCalled -CommandName Get-DnsServerZoneScope -Exactly -Times 1 -Scope It
                }
            }
        }
        #endregion Function Get-TargetResource

        #region Function Test-TargetResource
        Describe "MSFT_xDnsServerZoneScope\Test-TargetResource" -Tag 'Test' {
            Context 'When the system is in the desired state' {
                It 'Should return True when the Zone Scope exists' {
                    Mock -CommandName Get-DnsServerZoneScope $mocks.ZoneScopePresent
                    $params = @{
                        Ensure   = 'Present'
                        ZoneName = 'contoso.com'
                        Name     = 'ZoneScope'
                    }
                    Test-TargetResource @params | Should -BeTrue

                    Assert-MockCalled -CommandName Get-DnsServerZoneScope -Exactly -Times 1 -Scope It
                }
            }

            Context 'When the system is not in the desired state' {
                It 'Should return False when the Ensure doesnt match' {
                    Mock -CommandName Get-DnsServerZoneScope $mocks.Absent
                    $params = @{
                        Ensure   = 'Present'
                        ZoneName = 'contoso.com'
                        Name     = 'ZoneScope'
                    }
                    Test-TargetResource @params | Should -BeFalse

                    Assert-MockCalled -CommandName Get-DnsServerZoneScope -Exactly -Times 1 -Scope It
                }
            }
       }
        #endregion

        #region Function Set-TargetResource
        Describe "MSFT_xDnsServerZoneScope\Set-TargetResource" -Tag 'Set' {
            Context 'When configuring DNS Server Zone Scopes' {
                It 'Calls Add-DnsServerZoneScope in the set method when the subnet does not exist' {
                    Mock -CommandName Get-DnsServerZoneScope
                    Mock -CommandName Add-DnsServerZoneScope

                    $params = @{
                        Ensure   = 'Present'
                        ZoneName = 'contoso.com'
                        Name     = 'ZoneScope'
                    }
                    Set-TargetResource @params

                    Assert-MockCalled Add-DnsServerZoneScope -Scope It -ParameterFilter {
                        $Name -eq 'ZoneScope' -and $ZoneName -eq 'contoso.com'
                    }
                }

                It 'Calls Remove-DnsServerZoneScope in the set method when Ensure is Absent' {
                    Mock -CommandName Remove-DnsServerZoneScope
                    Mock -CommandName Get-DnsServerZoneScope { return $mocks.ZoneScopePresent }
                    $params = @{
                        Ensure   = 'Absent'
                        ZoneName = 'contoso.com'
                        Name     = 'ZoneScope'
                    }
                    Set-TargetResource @params

                    Assert-MockCalled Remove-DnsServerZoneScope -Scope It
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
