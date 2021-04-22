$Global:DSCModuleName   = 'xDnsServer'
$Global:DSCResourceName = 'MSFT_xDnsServerZoneAging'

#region HEADER

# Unit Test Template Version: 1.2.1
$script:moduleRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
if ( (-not (Test-Path -Path (Join-Path -Path $script:moduleRoot -ChildPath 'DSCResource.Tests'))) -or `
     (-not (Test-Path -Path (Join-Path -Path $script:moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1'))) )
{
    & git @('clone','https://github.com/PowerShell/DscResource.Tests.git',(Join-Path -Path $script:moduleRoot -ChildPath 'DSCResource.Tests'))
}

Import-Module -Name (Join-Path -Path $script:moduleRoot -ChildPath (Join-Path -Path 'DSCResource.Tests' -ChildPath 'TestHelper.psm1')) -Force

$TestEnvironment = Initialize-TestEnvironment `
    -DSCModuleName $Global:DSCModuleName `
    -DSCResourceName $Global:DSCResourceName `
    -TestType Unit

#endregion HEADER

function Invoke-TestSetup { }

function Invoke-TestCleanup {
    Restore-TestEnvironment -TestEnvironment $TestEnvironment
}

# Begin Testing
try
{
    Invoke-TestSetup

    InModuleScope $Global:DSCResourceName {

        #region Pester Test Initialization
        $zoneName = 'contoso.com'
        $getParameterEnable = @{
            Name              = $zoneName
            Enabled           = $true
        }
        $getParameterDisable = @{
            Name              = $zoneName
            Enabled           = $false
        }
        $testParameterEnable = @{
            Name              = $zoneName
            Enabled           = $true
            RefreshInterval   = 168
            NoRefreshInterval = 168
        }
        $testParameterDisable = @{
            Name              = $zoneName
            Enabled           = $false
            RefreshInterval   = 168
            NoRefreshInterval = 168
        }
        $setParameterEnable = @{
            Name              = $zoneName
            Enabled           = $true
        }
        $setParameterDisable = @{
            Name              = $zoneName
            Enabled           = $false
        }
        $setParameterRefreshInterval = @{
            Name              = $zoneName
            Enabled           = $true
            RefreshInterval   = 24
        }
        $setParameterNoRefreshInterval = @{
            Name              = $zoneName
            Enabled           = $true
            NoRefreshInterval = 36
        }
        $setFilterEnable = {
            $Name -eq $zoneName -and
            $Aging -eq $true
        }
        $setFilterDisable = {
            $Name -eq $zoneName -and
            $Aging -eq $false
        }
        $setFilterRefreshInterval = {
            $Name -eq $zoneName -and
            $RefreshInterval -eq ([System.TimeSpan]::FromHours(24))
        }
        $setFilterNoRefreshInterval = {
            $Name -eq $zoneName -and
            $NoRefreshInterval -eq ([System.TimeSpan]::FromHours(36))
        }
        $fakeDnsServerZoneAgingEnabled = @{
            ZoneName          = $zoneName
            AgingEnabled      = $true
            RefreshInterval   = [System.TimeSpan]::FromHours(168)
            NoRefreshInterval = [System.TimeSpan]::FromHours(168)
        }
        $fakeDnsServerZoneAgingDisabled = @{
            ZoneName          = $zoneName
            AgingEnabled      = $false
            RefreshInterval   = [System.TimeSpan]::FromHours(168)
            NoRefreshInterval = [System.TimeSpan]::FromHours(168)
        }
        #endregion

        #region Function Get-TargetResource
        Describe "$($Global:DSCResourceName)\Get-TargetResource" {

            Context "The zone aging on $zoneName is enabled" {

                Mock -CommandName Get-DnsServerZoneAging -MockWith { return $fakeDnsServerZoneAgingEnabled }

                It 'Should return a "System.Collections.Hashtable" object type' {
                    # Act
                    $targetResource = Get-TargetResource @getParameterDisable

                    # Assert
                    $targetResource | Should BeOfType [System.Collections.Hashtable]
                }

                It 'Should return valid values when aging is enabled' {
                    # Act
                    $targetResource = Get-TargetResource @getParameterEnable

                    # Assert
                    $targetResource.Name              | Should Be $testParameterEnable.Name
                    $targetResource.Enabled           | Should Be $testParameterEnable.Enabled
                    $targetResource.RefreshInterval   | Should Be $testParameterEnable.RefreshInterval
                    $targetResource.NoRefreshInterval | Should Be $testParameterEnable.NoRefreshInterval
                }
            }

            Context "The zone aging on $zoneName is disabled" {

                Mock -CommandName Get-DnsServerZoneAging -MockWith { return $fakeDnsServerZoneAgingDisabled }

                It 'Should return valid values when aging is not enabled' {
                    # Act
                    $targetResource = Get-TargetResource @getParameterDisable

                    # Assert
                    $targetResource.Name              | Should Be $testParameterDisable.Name
                    $targetResource.Enabled           | Should Be $testParameterDisable.Enabled
                    $targetResource.RefreshInterval   | Should Be $testParameterDisable.RefreshInterval
                    $targetResource.NoRefreshInterval | Should Be $testParameterDisable.NoRefreshInterval
                }
            }
        }
        #endregion

        #region Function Test-TargetResource
        Describe "$($Global:DSCResourceName)\Test-TargetResource" {

            Context "The zone aging on $zoneName is enabled" {

                Mock -CommandName Get-DnsServerZoneAging -MockWith { return $fakeDnsServerZoneAgingEnabled }

                It 'Should return a "System.Boolean" object type' {
                    # Act
                    $targetResource = Test-TargetResource @testParameterDisable

                    # Assert
                    $targetResource | Should BeOfType [System.Boolean]
                }

                It 'Should pass when everything matches (enabled)' {
                    # Act
                    $targetResource = Test-TargetResource @testParameterEnable

                    # Assert
                    $targetResource | Should Be $true
                }

                It 'Should fail when everything matches (enabled)' {
                    # Act
                    $targetResource = Test-TargetResource @testParameterDisable

                    # Assert
                    $targetResource | Should Be $false
                }
            }

            Context "The zone aging on $zoneName is disabled" {

                Mock -CommandName Get-DnsServerZoneAging -MockWith { return $fakeDnsServerZoneAgingDisabled }

                It 'Should pass when everything matches (disabled)' {
                    # Act
                    $targetResource = Test-TargetResource @testParameterDisable

                    # Assert
                    $targetResource | Should Be $true
                }

                It 'Should fail when everything matches (disabled)' {
                    # Act
                    $targetResource = Test-TargetResource @testParameterEnable

                    # Assert
                    $targetResource | Should Be $false
                }
            }
        }
        #endregion

        #region Function Set-TargetResource
        Describe "$($Global:DSCResourceName)\Set-TargetResource" {

            Context "The zone aging on $zoneName is enabled" {

                Mock -CommandName Get-DnsServerZoneAging -MockWith { return $fakeDnsServerZoneAgingEnabled }

                It 'Should disable the DNS zone aging' {
                    # Arrange
                    Mock -CommandName Set-DnsServerZoneAging -ParameterFilter $setFilterDisable -Verifiable

                    # Act
                    Set-TargetResource @setParameterDisable

                    # Assert
                    Assert-MockCalled -CommandName Set-DnsServerZoneAging -ParameterFilter $setFilterDisable -Times 1 -Exactly -Scope It
                }

                It 'Should set the DNS zone refresh interval' {
                    # Arrange
                    Mock -CommandName Set-DnsServerZoneAging -ParameterFilter $setFilterRefreshInterval -Verifiable

                    # Act
                    Set-TargetResource @setParameterRefreshInterval

                    # Assert
                    Assert-MockCalled -CommandName Set-DnsServerZoneAging -ParameterFilter $setFilterRefreshInterval -Times 1 -Exactly -Scope It
                }

                It 'Should set the DNS zone no refresh interval' {
                    # Arrange
                    Mock -CommandName Set-DnsServerZoneAging -ParameterFilter $setFilterNoRefreshInterval -Verifiable

                    # Act
                    Set-TargetResource @setParameterNoRefreshInterval

                    # Assert
                    Assert-MockCalled -CommandName Set-DnsServerZoneAging -ParameterFilter $setFilterNoRefreshInterval -Times 1 -Exactly -Scope It
                }
            }

            Context "The zone aging on $zoneName is disabled" {

                Mock -CommandName Get-DnsServerZoneAging -MockWith { return $fakeDnsServerZoneAgingDisabled }

                It 'Should enable the DNS zone aging' {
                    # Arrange
                    Mock -CommandName Set-DnsServerZoneAging -ParameterFilter $setFilterEnable -Verifiable

                    # Act
                    Set-TargetResource @setParameterEnable

                    # Assert
                    Assert-MockCalled -CommandName Set-DnsServerZoneAging -ParameterFilter $setFilterEnable -Times 1 -Exactly -Scope It
                }
            }
        }
        #endregion
    }
}
finally
{
    Invoke-TestCleanup
}
