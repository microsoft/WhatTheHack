$Global:DSCModuleName      = 'xDnsServer'
$Global:DSCResourceName    = 'MSFT_xDnsServerZoneTransfer'

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
        $testName = 'example.com';
        $testType = 'Any';
        $testSecondaryServer = '192.168.0.1','192.168.0.2';
        $testParams = @{
            Name = $testName;
            Type = $testType;
        }
        $testParamsAny = @{
            Name = $testName;
            Type = 'Any';
            SecondaryServer = '';
        }
        $testParamsSpecific = @{
            Name = $testName;
            Type = 'Specific';
            SecondaryServer = $testSecondaryServer;
        }
        $testParamsSpecificDifferent = @{
            Name = $testName;
            Type = 'Specific';
            SecondaryServer = '192.168.0.1','192.168.0.2','192.168.0.3';
        }
        $fakeCimInstanceAny = @{
            Name              = $testName;
            SecureSecondaries = $XferId2Name.IndexOf('Any');
            SecondaryServers  = '';
        }
        $fakeCimInstanceNamed = @{
            Name              = $testName;
            SecureSecondaries = $XferId2Name.IndexOf('Named');
            SecondaryServers  = '';
        }
        $fakeCimInstanceSpecific = @{
            Name              = $testName;
            SecureSecondaries = $XferId2Name.IndexOf('Specific');
            SecondaryServers  = $testSecondaryServer;
        }
        #endregion


        #region Function Get-TargetResource
        Describe "$($Global:DSCResourceName)\Get-TargetResource" {
            It 'Returns a "System.Collections.Hashtable" object type' {
                Mock -CommandName Get-CimInstance -MockWith {return $fakeCimInstanceAny}
                $targetResource = Get-TargetResource @testParams
                $targetResource -is [System.Collections.Hashtable] | Should Be $true
            }

            It "Returns SecondaryServer = $($testParams.SecondaryServer) when zone transfers set to specific" {
                Mock -CommandName Get-CimInstance -MockWith {return $fakeCimInstanceSpecific}
                $targetResource = Get-TargetResource @testParams
                $targetResource.SecondaryServers | Should Be $testParams.SecondaryServers
            }
        }
        #endregion


        #region Function Test-TargetResource
        Describe "$($Global:DSCResourceName)\Test-TargetResource" {
            It 'Returns a "System.Boolean" object type' {
                Mock -CommandName Get-CimInstance -MockWith {return $fakeCimInstanceAny}
                $targetResource =  Test-TargetResource @testParamsAny
                $targetResource -is [System.Boolean] | Should Be $true
            }

            It 'Passes when Zone Transfer Type matches' {
                Mock -CommandName Get-CimInstance -MockWith {return $fakeCimInstanceAny}
                Test-TargetResource @testParamsAny | Should Be $true
            }

            It "Fails when Zone Transfer Type does not match" {
                Mock -CommandName Get-CimInstance -MockWith {return $fakeCimInstanceNamed}
                Test-TargetResource @testParamsAny | Should Be $false
            }

            It 'Passes when Zone Transfer Secondaries matches' {
                Mock -CommandName Get-CimInstance -MockWith {return $fakeCimInstanceSpecific}
                Test-TargetResource @testParamsSpecific | Should Be $true
            }

            It 'Passes when Zone Transfer Secondaries does not match' {
                Mock -CommandName Get-CimInstance -MockWith {return $fakeCimInstanceSpecific}
                Test-TargetResource @testParamsSpecificDifferent | Should Be $false
            }
        }
        #endregion


        #region Function Set-TargetResource
        Describe "$($Global:DSCResourceName)\Set-TargetResource" {
            function Invoke-CimMethod { [CmdletBinding()]
                param ( $InputObject, $MethodName, $Arguments )
            }

            Mock -CommandName Invoke-CimMethod -MockWith {}
            Mock -CommandName Restart-Service -MockWith {}

            It "Calls Invoke-CimMethod not called when Zone Transfer Type matches" {
                Mock -CommandName Get-CimInstance -MockWith {return $fakeCimInstanceAny}
                Set-TargetResource @testParamsAny
                Assert-MockCalled -CommandName Invoke-CimMethod -Times 0 -Exactly -Scope It
            }

            It "Calls Invoke-CimMethod called once when Zone Transfer Type does not match" {
                Mock -CommandName Get-CimInstance -MockWith {return $fakeCimInstanceNamed}
                Set-TargetResource @testParamsAny
                Assert-MockCalled -CommandName Invoke-CimMethod -Times 1 -Exactly -Scope It
            }

            It "Calls Invoke-CimMethod not called when Zone Transfer Secondaries matches" {
                Mock -CommandName Get-CimInstance -MockWith {return $fakeCimInstanceSpecific}
                Set-TargetResource @testParamsSpecific
                Assert-MockCalled -CommandName Invoke-CimMethod -Times 0 -Exactly -Scope It
            }

            It "Calls Invoke-CimMethod called once when Zone Transfer Secondaries does not match" {
                Mock -CommandName Get-CimInstance -MockWith {return $fakeCimInstanceSpecific}
                Set-TargetResource @testParamsSpecificDifferent
                Assert-MockCalled -CommandName Invoke-CimMethod -Times 1 -Exactly -Scope It
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
