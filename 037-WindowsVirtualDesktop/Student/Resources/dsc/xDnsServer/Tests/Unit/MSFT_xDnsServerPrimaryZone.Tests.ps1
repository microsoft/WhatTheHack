$Global:DSCModuleName      = 'xDnsServer'
$Global:DSCResourceName    = 'MSFT_xDnsServerPrimaryZone'

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
        $testZoneName = 'example.com';
        $testZoneFile = 'example.com.dns';
        $testDynamicUpdate = 'None';
        $testParams = @{ Name = $testZoneName; }

        $fakeDnsFileZone = [PSCustomObject] @{
            DistinguishedName = $null;
            ZoneName = $testZoneName;
            ZoneType = 'Primary';
            DynamicUpdate = $testDynamicUpdate;
            ReplicationScope = 'None';
            DirectoryPartitionName = $null;
            ZoneFile = $testZoneFile;
        }
        #endregion

        #region Function Get-TargetResource
        Describe 'Validates Get-TargetResource Method' {
            function Get-DnsServerZone { }

            Mock -CommandName 'Assert-Module' -MockWith { }

            It 'Returns a "System.Collections.Hashtable" object type' {
                $targetResource = Get-TargetResource @testParams;
                $targetResource -is [System.Collections.Hashtable] | Should Be $true;
            }

            It 'Returns "Present" when DNS zone exists and "Ensure" = "Present"' {
                Mock -CommandName Get-DnsServerZone -MockWith { return $fakeDnsFileZone; }
                $targetResource = Get-TargetResource @testParams -ZoneFile 'example.com.dns';
                $targetResource.Ensure | Should Be 'Present';
            }

            It 'Returns "Absent" when DNS zone does not exists and "Ensure" = "Present"' {
                Mock -CommandName Get-DnsServerZone -MockWith { }
                $targetResource = Get-TargetResource @testParams -ZoneFile 'example.com.dns';
                $targetResource.Ensure | Should Be 'Absent';
            }

            It 'Returns "Present" when DNS zone exists and "Ensure" = "Absent"' {
                Mock -CommandName Get-DnsServerZone -MockWith { return $fakeDnsFileZone; }
                $targetResource = Get-TargetResource @testParams -ZoneFile 'example.com.dns' -Ensure Absent;
                $targetResource.Ensure | Should Be 'Present';
            }

            It 'Returns "Absent" when DNS zone does not exist and "Ensure" = "Absent"' {
                Mock -CommandName Get-DnsServerZone -MockWith { }
                $targetResource = Get-TargetResource @testParams -ZoneFile 'example.com.dns' -Ensure Absent;
                $targetResource.Ensure | Should Be 'Absent';
            }
        }
        #endregion


        #region Function Test-TargetResource
        Describe 'Validates Test-TargetResource Method' {
            function Get-DnsServerZone { }

            It 'Returns a "System.Boolean" object type' {
                Mock -CommandName Get-DnsServerZone -MockWith { return $fakeDnsFileZone; }
                $targetResource =  Test-TargetResource @testParams;
                $targetResource -is [System.Boolean] | Should Be $true;
            }

            It 'Passes when DNS zone exists and "Ensure" = "Present"' {
                Mock -CommandName Get-DnsServerZone -MockWith { return $fakeDnsFileZone; }
                Test-TargetResource @testParams -Ensure Present | Should Be $true;
            }

            It 'Passes when DNS zone does not exist and "Ensure" = "Absent"' {
                Mock -CommandName Get-DnsServerZone -MockWith { }
                Test-TargetResource @testParams -Ensure Absent | Should Be $true;
            }

            It 'Passes when DNS zone "DynamicUpdate" is correct' {
                Mock -CommandName Get-DnsServerZone -MockWith { return $fakeDnsFileZone; }
                Test-TargetResource @testParams -Ensure Present -DynamicUpdate $testDynamicUpdate | Should Be $true;
            }

            It 'Fails when DNS zone exists and "Ensure" = "Absent"' {
                Mock -CommandName Get-DnsServerZone -MockWith { return $fakeDnsFileZone; }
                Test-TargetResource @testParams -Ensure Absent | Should Be $false;
            }

            It 'Fails when DNS zone does not exist and "Ensure" = "Present"' {
                Mock -CommandName Get-DnsServerZone -MockWith { }
                Test-TargetResource @testParams -Ensure Present | Should Be $false;
            }

            It 'Fails when DNS zone "DynamicUpdate" is incorrect' {
                Mock -CommandName Get-DnsServerZone -MockWith { return $fakeDnsFileZone; }
                Test-TargetResource @testParams -Ensure Present -DynamicUpdate 'NonsecureAndSecure' -ZoneFile $testZoneFile | Should Be $false;
            }

            It 'Fails when DNS zone "ZoneFile" is incorrect' {
                Mock -CommandName Get-DnsServerZone -MockWith { return $fakeDnsFileZone; }
                Test-TargetResource @testParams -Ensure Present -DynamicUpdate $testDynamicUpdate -ZoneFile 'nonexistent.com.dns' | Should Be $false;
            }
        }
        #endregion


        #region Function Set-TargetResource
        Describe 'Validates Set-TargetResource Method' {
            It 'Calls "Add-DnsServerPrimaryZone" when DNS zone does not exist and "Ensure" = "Present"' {
                function Get-DnsServerZone { }
                function Add-DnsServerPrimaryZone { param ( $Name ) }
                function Set-DnsServerPrimaryZone { [CmdletBinding()] param (
                    [Parameter(ValueFromPipeline)] $Name,
                    [Parameter(ValueFromPipeline)] $DynamicUpdate,
                    [Parameter(ValueFromPipeline)] $ZoneFile ) }
                function Remove-DnsServerZone { }

                Mock -CommandName Get-DnsServerZone -MockWith { }
                Mock -CommandName Add-DnsServerPrimaryZone -ParameterFilter { $Name -eq $testZoneName } -MockWith { }
                Set-TargetResource @testParams -Ensure Present -DynamicUpdate $testDynamicUpdate -ZoneFile $testZoneFile;
                Assert-MockCalled -CommandName Add-DnsServerPrimaryZone -ParameterFilter { $Name -eq $testZoneName } -Scope It;
            }

            It 'Calls "Remove-DnsServerZone" when DNS zone does exist and "Ensure" = "Absent"' {
                Mock -CommandName Get-DnsServerZone -MockWith { return $fakeDnsFileZone }
                Mock -CommandName Remove-DnsServerZone -MockWith { }
                Set-TargetResource @testParams -Ensure Absent -DynamicUpdate $testDynamicUpdate -ZoneFile $testZoneFile;
                Assert-MockCalled -CommandName Remove-DnsServerZone -Scope It;
            }

            It 'Calls "Set-DnsServerPrimaryZone" when DNS zone "DynamicUpdate" is incorrect' {
                Mock -CommandName Get-DnsServerZone -MockWith { return $fakeDnsFileZone }
                Mock -CommandName Set-DnsServerPrimaryZone -ParameterFilter { $DynamicUpdate -eq 'NonsecureAndSecure' } -MockWith { }
                Set-TargetResource @testParams -Ensure Present -DynamicUpdate 'NonsecureAndSecure' -ZoneFile $testZoneFile;
                Assert-MockCalled -CommandName Set-DnsServerPrimaryZone -ParameterFilter { $DynamicUpdate -eq 'NonsecureAndSecure' } -Scope It;
            }

            It 'Calls "Set-DnsServerPrimaryZone" when DNS zone "ZoneFile" is incorrect' {
                Mock -CommandName Get-DnsServerZone -MockWith { return $fakeDnsFileZone }
                Mock -CommandName Set-DnsServerPrimaryZone -ParameterFilter { $ZoneFile -eq 'nonexistent.com.dns' } -MockWith { }
                Set-TargetResource @testParams -Ensure Present -DynamicUpdate $testDynamicUpdate -ZoneFile 'nonexistent.com.dns';
                Assert-MockCalled -CommandName Set-DnsServerPrimaryZone -ParameterFilter { $ZoneFile -eq 'nonexistent.com.dns' } -Scope It;
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
