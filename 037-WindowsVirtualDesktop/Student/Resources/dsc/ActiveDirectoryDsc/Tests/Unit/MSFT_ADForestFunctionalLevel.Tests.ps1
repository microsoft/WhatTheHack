Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath '..\TestHelpers\ActiveDirectoryDsc.TestHelper.psm1')

if (-not (Test-RunForCITestCategory -Type 'Unit' -Category 'Tests'))
{
    return
}

$script:dscModuleName = 'ActiveDirectoryDsc'
$script:dscResourceName = 'MSFT_ADForestFunctionalLevel'

#region HEADER

# Unit Test Template Version: 1.2.4
$script:moduleRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
if ( (-not (Test-Path -Path (Join-Path -Path $script:moduleRoot -ChildPath 'DSCResource.Tests'))) -or `
    (-not (Test-Path -Path (Join-Path -Path $script:moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1'))) )
{
    & git @('clone', 'https://github.com/PowerShell/DscResource.Tests.git', (Join-Path -Path $script:moduleRoot -ChildPath 'DscResource.Tests'))
}

Import-Module -Name (Join-Path -Path $script:moduleRoot -ChildPath (Join-Path -Path 'DSCResource.Tests' -ChildPath 'TestHelper.psm1')) -Force

# TODO: Insert the correct <ModuleName> and <ResourceName> for your resource
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
        # Load the AD Module Stub, so we can mock the cmdlets, then load the AD types.
        Import-Module (Join-Path -Path $PSScriptRoot -ChildPath 'Stubs\ActiveDirectory_2019.psm1') -Force

        $mockDefaultParameters = @{
            ForestIdentity = 'contoso.com'
            ForestMode = 'Windows2016Forest'
            Verbose = $true
        }

        Describe 'MSFT_ADForestFunctionalLevel\Get-TargetResource' -Tag 'Get' {
            Context 'When the current property values are returned' {
                BeforeAll {
                    Mock -CommandName Get-ADForest -MockWith {
                        return @{
                            ForestMode = 'Windows2012R2Forest'
                        }
                    }
                }

                It 'Should return the the same values as was passed as parameters' {
                    $getTargetResourceResult = Get-TargetResource @mockDefaultParameters
                    $getTargetResourceResult.ForestIdentity | Should -Be $mockDefaultParameters.ForestIdentity

                    Assert-MockCalled -CommandName Get-ADForest -Exactly -Times 1 -Scope It
                }

                It 'Should return the correct value for ForestMode' {
                    $getTargetResourceResult = Get-TargetResource @mockDefaultParameters
                    $getTargetResourceResult.ForestMode | Should -Be 'Windows2012R2Forest'

                    Assert-MockCalled -CommandName Get-ADForest -Exactly -Times 1 -Scope It
                }
            }
        }

        Describe 'MSFT_ADForestFunctionalLevel\Test-TargetResource' -Tag 'Test' {
            Context 'When the system is in the desired state' {
                Context 'When the property ForestMode is in desired state' {
                    BeforeAll {
                        Mock -CommandName Compare-TargetResourceState -MockWith {
                            return @(
                                @{
                                    ParameterName  = 'ForestMode'
                                    InDesiredState = $true
                                }
                            )
                        }
                    }

                    It 'Should return $true' {
                        $testTargetResourceResult = Test-TargetResource @mockDefaultParameters
                        $testTargetResourceResult | Should -BeTrue

                        Assert-MockCalled -CommandName Compare-TargetResourceState -Exactly -Times 1 -Scope It
                    }
                }
            }

            Context 'When the system is not in the desired state' {
                Context 'When the property ForestMode is not in desired state' {
                    BeforeAll {
                        Mock -CommandName Compare-TargetResourceState -MockWith {
                            return @(
                                @{
                                    ParameterName  = 'ForestMode'
                                    InDesiredState = $false
                                }
                            )
                        }

                        $testTargetResourceParameters = $mockDefaultParameters.Clone()
                        $testTargetResourceParameters['ForestMode'] = 'Windows2012R2Forest'
                    }

                    It 'Should return $false' {
                        $testTargetResourceResult = Test-TargetResource @testTargetResourceParameters
                        $testTargetResourceResult | Should -BeFalse

                        Assert-MockCalled -CommandName Compare-TargetResourceState -Exactly -Times 1 -Scope It
                    }
                }
            }
        }

        Describe 'MSFT_ADForestFunctionalLevel\Compare-TargetResourceState' -Tag 'Compare' {
            Context 'When the system is in the desired state' {
                Context 'When the property ForestMode is in desired state' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith {
                            return @{
                                ForestIdentity = 'contoso.com'
                                ForestMode = $mockDefaultParameters.ForestMode
                            }
                        }
                    }

                    It 'Should return $true' {
                        $compareTargetResourceStateResult = Compare-TargetResourceState @mockDefaultParameters
                        $compareTargetResourceStateResult | Should -HaveCount 1

                        $comparedReturnValue = $compareTargetResourceStateResult.Where( { $_.ParameterName -eq 'ForestMode' })
                        $comparedReturnValue | Should -Not -BeNullOrEmpty
                        $comparedReturnValue.Expected | Should -Be $mockDefaultParameters.ForestMode
                        $comparedReturnValue.Actual | Should -Be $mockDefaultParameters.ForestMode
                        $comparedReturnValue.InDesiredState | Should -BeTrue

                        Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                    }
                }
            }

            Context 'When the system is not in the desired state' {
                Context 'When the property ForestMode is not in desired state' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith {
                            return @{
                                ForestIdentity = 'contoso.com'
                                ForestMode = $mockDefaultParameters.ForestMode
                            }
                        }

                        $compareTargetResourceStateParameters = $mockDefaultParameters.Clone()
                        $compareTargetResourceStateParameters['ForestMode'] = 'Windows2012R2Forest'
                    }

                    It 'Should return $false' {
                        $compareTargetResourceStateResult = Compare-TargetResourceState @compareTargetResourceStateParameters
                        $compareTargetResourceStateResult | Should -HaveCount 1

                        $comparedReturnValue = $compareTargetResourceStateResult.Where( { $_.ParameterName -eq 'ForestMode' })
                        $comparedReturnValue | Should -Not -BeNullOrEmpty
                        $comparedReturnValue.Expected | Should -Be 'Windows2012R2Forest'
                        $comparedReturnValue.Actual | Should -Be $mockDefaultParameters.ForestMode
                        $comparedReturnValue.InDesiredState | Should -BeFalse

                        Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                    }
                }
            }
        }

        Describe 'MSFT_ADForestFunctionalLevel\Set-TargetResource' -Tag 'Set' {
            Context 'When the system is in the desired state' {
                Context 'When the property ForestMode is in desired state' {
                    BeforeAll {
                        Mock -CommandName Set-ADForestMode
                        Mock -CommandName Compare-TargetResourceState -MockWith {
                            return @(
                                @{
                                    ParameterName  = 'ForestMode'
                                    Actual  = 'Windows2016Forest'
                                    Expected  = 'Windows2016Forest'
                                    InDesiredState = $true
                                }
                            )
                        }
                    }

                    It 'Should not throw and do not call Set-CimInstance' {
                        { Set-TargetResource @mockDefaultParameters } | Should -Not -Throw

                        Assert-MockCalled -CommandName Compare-TargetResourceState -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Set-ADForestMode -Exactly -Times 0 -Scope It
                    }
                }
            }

            Context 'When the system is not in the desired state' {
                Context 'When the property ForestMode is not in desired state' {
                    BeforeAll {
                        Mock -CommandName Set-ADForestMode
                        Mock -CommandName Compare-TargetResourceState -MockWith {
                            return @(
                                @{
                                    ParameterName  = 'ForestMode'
                                    Actual  = 'Windows2016Forest'
                                    Expected  = 'Windows2012R2Forest'
                                    InDesiredState = $false
                                }
                            )
                        }

                        $setTargetResourceParameters = $mockDefaultParameters.Clone()
                        $setTargetResourceParameters['ForestMode'] = 'Windows2012R2Forest'
                    }

                    It 'Should not throw and call the correct mocks' {
                        { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw

                        Assert-MockCalled -CommandName Compare-TargetResourceState -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Set-ADForestMode -Exactly -Times 1 -Scope It
                    }
                }
            }
        }
    }
}
finally
{
    Invoke-TestCleanup
}
