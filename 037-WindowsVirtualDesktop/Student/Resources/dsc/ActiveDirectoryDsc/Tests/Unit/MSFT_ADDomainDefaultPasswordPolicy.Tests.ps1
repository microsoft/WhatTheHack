Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath '..\TestHelpers\ActiveDirectoryDsc.TestHelper.psm1')

if (-not (Test-RunForCITestCategory -Type 'Unit' -Category 'Tests'))
{
    return
}

$script:dscModuleName = 'ActiveDirectoryDsc'
$script:dscResourceName = 'MSFT_ADDomainDefaultPasswordPolicy'

#region HEADER

# Unit Test Template Version: 1.2.4
$script:moduleRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
if ( (-not (Test-Path -Path (Join-Path -Path $script:moduleRoot -ChildPath 'DSCResource.Tests'))) -or `
    (-not (Test-Path -Path (Join-Path -Path $script:moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1'))) )
{
    & git @('clone', 'https://github.com/PowerShell/DscResource.Tests.git', (Join-Path -Path $script:moduleRoot -ChildPath 'DscResource.Tests'))
}

Import-Module -Name (Join-Path -Path $script:moduleRoot -ChildPath (Join-Path -Path 'DSCResource.Tests' -ChildPath 'TestHelper.psm1')) -Force

$TestEnvironment = Initialize-TestEnvironment `
    -DSCModuleName $script:dscModuleName `
    -DSCResourceName $script:dscResourceName `
    -ResourceType 'Mof' `
    -TestType Unit

#endregion HEADER

function Invoke-TestSetup
{
}

function Invoke-TestCleanup
{
    Restore-TestEnvironment -TestEnvironment $TestEnvironment
}

# Begin Testing
try
{
    Invoke-TestSetup

    InModuleScope $script:dscResourceName {
        # Load stub cmdlets and classes.
        Import-Module (Join-Path -Path $PSScriptRoot -ChildPath 'Stubs\ActiveDirectory_2019.psm1') -Force

        $testDomainName = 'contoso.com'
        $testDefaultParams = @{
            DomainName = $testDomainName
        }
        $testDomainController = 'testserver.contoso.com'

        $testPassword = ConvertTo-SecureString -String 'DummyPassword' -AsPlainText -Force
        $testCredential = New-Object -TypeName 'System.Management.Automation.PSCredential' -ArgumentList @(
            'Safemode',
            $testPassword
        )

        $fakePasswordPolicy = @{
            ComplexityEnabled = $true
            LockoutDuration = New-TimeSpan -Minutes 30
            LockoutObservationWindow = New-TimeSpan -Minutes 30
            LockoutThreshold = 3
            MinPasswordAge = New-TimeSpan -Days 1
            MaxPasswordAge = New-TimeSpan -Days 42
            MinPasswordLength = 7
            PasswordHistoryCount = 12
            ReversibleEncryptionEnabled = $false
        }

        #region Function Get-TargetResource
        Describe 'ADDomainDefaultPasswordPolicy\Get-TargetResource' {
            Mock -CommandName Assert-Module -ParameterFilter { $ModuleName -eq 'ActiveDirectory' }

            It 'Calls "Assert-Module" to check "ActiveDirectory" module is installed' {
                Mock -CommandName Get-ADDefaultDomainPasswordPolicy { return $fakePasswordPolicy; }

                $result = Get-TargetResource @testDefaultParams

                Assert-MockCalled -CommandName Assert-Module -ParameterFilter { $ModuleName -eq 'ActiveDirectory' } -Scope It
            }

            It 'Returns "System.Collections.Hashtable" object type' {
                Mock -CommandName Get-ADDefaultDomainPasswordPolicy { return $fakePasswordPolicy; }

                $result = Get-TargetResource @testDefaultParams

                $result -is [System.Collections.Hashtable] | Should -BeTrue
            }

            It 'Calls "Get-ADDefaultDomainPasswordPolicy" without credentials by default' {
                Mock -CommandName Get-ADDefaultDomainPasswordPolicy -ParameterFilter { $Credential -eq $null } -MockWith { return $fakePasswordPolicy; }

                $result = Get-TargetResource @testDefaultParams

                Assert-MockCalled -CommandName Get-ADDefaultDomainPasswordPolicy -ParameterFilter { $Credential -eq $null } -Scope It
            }

            It 'Calls "Get-ADDefaultDomainPasswordPolicy" with credentials when specified' {
                Mock -CommandName Get-ADDefaultDomainPasswordPolicy -ParameterFilter { $Credential -eq $testCredential } -MockWith { return $fakePasswordPolicy; }

                $result = Get-TargetResource @testDefaultParams -Credential $testCredential

                Assert-MockCalled -CommandName Get-ADDefaultDomainPasswordPolicy -ParameterFilter { $Credential -eq $testCredential } -Scope It
            }

            It 'Calls "Get-ADDefaultDomainPasswordPolicy" without server by default' {
                Mock -CommandName Get-ADDefaultDomainPasswordPolicy -ParameterFilter { $Server -eq $null } -MockWith { return $fakePasswordPolicy; }

                $result = Get-TargetResource @testDefaultParams

                Assert-MockCalled -CommandName Get-ADDefaultDomainPasswordPolicy -ParameterFilter { $Server -eq $null } -Scope It
            }

            It 'Calls "Get-ADDefaultDomainPasswordPolicy" with server when specified' {
                Mock -CommandName Get-ADDefaultDomainPasswordPolicy -ParameterFilter { $Server -eq $testDomainController } -MockWith { return $fakePasswordPolicy; }

                $result = Get-TargetResource @testDefaultParams -DomainController $testDomainController

                Assert-MockCalled -CommandName Get-ADDefaultDomainPasswordPolicy -ParameterFilter { $Server -eq $testDomainController } -Scope It
            }

        }
        #endregion

        #region Function Test-TargetResource
        Describe 'ADDomainDefaultPasswordPolicy\Test-TargetResource' {
            $testDomainName = 'contoso.com'
            $testDefaultParams = @{
                DomainName = $testDomainName
            }
            $testDomainController = 'testserver.contoso.com'

            $testPassword = ConvertTo-SecureString -String 'DummyPassword' -AsPlainText -Force
            $testCredential = New-Object -TypeName 'System.Management.Automation.PSCredential' -ArgumentList @(
                'Safemode',
                $testPassword
            )

            $stubPasswordPolicy = @{
                ComplexityEnabled = $true
                LockoutDuration = (New-TimeSpan -Minutes 30).TotalMinutes
                LockoutObservationWindow = (New-TimeSpan -Minutes 30).TotalMinutes
                LockoutThreshold = 3
                MinPasswordAge = (New-TimeSpan -Days 1).TotalMinutes
                MaxPasswordAge = (New-TimeSpan -Days 42).TotalMinutes
                MinPasswordLength = 7
                PasswordHistoryCount = 12
                ReversibleEncryptionEnabled = $true
            }

            It 'Returns "System.Boolean" object type' {
                Mock -CommandName Get-TargetResource -MockWith { return $stubPasswordPolicy; }

                $result = Test-TargetResource @testDefaultParams

                $result -is [System.Boolean] | Should -BeTrue
            }

            It 'Calls "Get-TargetResource" with "Credential" parameter when specified' {
                Mock -CommandName Get-TargetResource -ParameterFilter { $Credential -eq $testCredential } { return $stubPasswordPolicy; }

                $result = Test-TargetResource @testDefaultParams -Credential $testCredential

                Assert-MockCalled -CommandName Get-TargetResource -ParameterFilter { $Credential -eq $testCredential } -Scope It
            }

            It 'Calls "Get-TargetResource" with "DomainController" parameter when specified' {
                Mock -CommandName Get-TargetResource -ParameterFilter { $DomainController -eq $testDomainController } { return $stubPasswordPolicy; }

                $result = Test-TargetResource @testDefaultParams -DomainController $testDomainController

                Assert-MockCalled -CommandName Get-TargetResource -ParameterFilter { $DomainController -eq $testDomainController } -Scope It
            }

            foreach ($propertyName in $stubPasswordPolicy.Keys)
            {
                It "Passes when '$propertyName' parameter matches resource property value" {
                    Mock -CommandName Get-TargetResource -MockWith { return $stubPasswordPolicy; }
                    $propertyDefaultParams = $testDefaultParams.Clone()
                    $propertyDefaultParams[$propertyName] = $stubPasswordPolicy[$propertyName]

                    $result = Test-TargetResource @propertyDefaultParams

                    $result | Should -BeTrue
                }

                It "Fails when '$propertyName' parameter does not match resource property value" {
                    Mock -CommandName Get-TargetResource -MockWith { return $stubPasswordPolicy; }
                    $propertyDefaultParams = $testDefaultParams.Clone()

                    switch ($stubPasswordPolicy[$propertyName].GetType())
                    {
                        'bool' {
                            $propertyDefaultParams[$propertyName] = -not $stubPasswordPolicy[$propertyName]
                        }
                        'string' {
                            $propertyDefaultParams[$propertyName] = 'not{0}' -f $stubPasswordPolicy[$propertyName]
                        }
                        default {
                            $propertyDefaultParams[$propertyName] = $stubPasswordPolicy[$propertyName] + 1
                        }
                    }

                    $result = Test-TargetResource @propertyDefaultParams

                    $result | Should -BeFalse
                }
            } #end foreach property

        }
        #endregion

        #region Function Set-TargetResource
        Describe 'ADDomainDefaultPasswordPolicy\Set-TargetResource' {
            $testDomainName = 'contoso.com'
            $testDefaultParams = @{
                DomainName = $testDomainName
            }
            $testDomainController = 'testserver.contoso.com'

            $testPassword = ConvertTo-SecureString -String 'DummyPassword' -AsPlainText -Force
            $testCredential = New-Object -TypeName 'System.Management.Automation.PSCredential' -ArgumentList @(
                'Safemode',
                $testPassword
            )

            $stubPasswordPolicy = @{
                ComplexityEnabled = $true
                LockoutDuration = (New-TimeSpan -Minutes 30).TotalMinutes
                LockoutObservationWindow = (New-TimeSpan -Minutes 30).TotalMinutes
                LockoutThreshold = 3
                MinPasswordAge = (New-TimeSpan -Days 1).TotalMinutes
                MaxPasswordAge = (New-TimeSpan -Days 42).TotalMinutes
                MinPasswordLength = 7
                PasswordHistoryCount = 12
                ReversibleEncryptionEnabled = $true
            }

            Mock -CommandName Assert-Module -ParameterFilter { $ModuleName -eq 'ActiveDirectory' }

            It 'Calls "Assert-Module" to check "ActiveDirectory" module is installed' {
                Mock -CommandName Set-ADDefaultDomainPasswordPolicy

                $result = Set-TargetResource @testDefaultParams

                Assert-MockCalled -CommandName Assert-Module -ParameterFilter { $ModuleName -eq 'ActiveDirectory' } -Scope It
            }

            It 'Calls "Set-ADDefaultDomainPasswordPolicy" without "Credential" parameter by default' {
                Mock -CommandName Set-ADDefaultDomainPasswordPolicy -ParameterFilter { $Credential -eq $null }

                $result = Set-TargetResource @testDefaultParams

                Assert-MockCalled -CommandName Set-ADDefaultDomainPasswordPolicy -ParameterFilter { $Credential -eq $null } -Scope It
            }

            It 'Calls "Set-ADDefaultDomainPasswordPolicy" with "Credential" parameter when specified' {
                Mock -CommandName Set-ADDefaultDomainPasswordPolicy -ParameterFilter { $Credential -eq $testCredential }

                $result = Set-TargetResource @testDefaultParams -Credential $testCredential

                Assert-MockCalled -CommandName Set-ADDefaultDomainPasswordPolicy -ParameterFilter { $Credential -eq $testCredential } -Scope It
            }

            It 'Calls "Set-ADDefaultDomainPasswordPolicy" without "Server" parameter by default' {
                Mock -CommandName Set-ADDefaultDomainPasswordPolicy -ParameterFilter { $Server -eq $null }

                $result = Set-TargetResource @testDefaultParams

                Assert-MockCalled -CommandName Set-ADDefaultDomainPasswordPolicy -ParameterFilter { $Server -eq $null } -Scope It
            }

            It 'Calls "Set-ADDefaultDomainPasswordPolicy" with "Server" parameter when specified' {
                Mock -CommandName Set-ADDefaultDomainPasswordPolicy -ParameterFilter { $Server -eq $testDomainController }

                $result = Set-TargetResource @testDefaultParams -DomainController $testDomainController

                Assert-MockCalled -CommandName Set-ADDefaultDomainPasswordPolicy -ParameterFilter { $Server -eq $testDomainController } -Scope It
            }

            foreach ($propertyName in $stubPasswordPolicy.Keys)
            {
                It "Calls 'Set-ADDefaultDomainPasswordPolicy' with '$propertyName' parameter when specified" {
                    $propertyDefaultParams = $testDefaultParams.Clone()
                    $propertyDefaultParams[$propertyName] = $stubPasswordPolicy[$propertyName]
                    Mock -CommandName Set-ADDefaultDomainPasswordPolicy -ParameterFilter { $PSBoundParameters.ContainsKey($propertyName) }

                    $result = Set-TargetResource @propertyDefaultParams

                    Assert-MockCalled -CommandName Set-ADDefaultDomainPasswordPolicy -ParameterFilter { $PSBoundParameters.ContainsKey($propertyName) } -Scope It
                }

            } #end foreach property name

        }
        #endregion

    }
    #endregion
}
finally
{
    Invoke-TestCleanup
}
