Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath '..\TestHelpers\ActiveDirectoryDsc.TestHelper.psm1')

if (-not (Test-RunForCITestCategory -Type 'Unit' -Category 'Tests'))
{
    return
}

$script:dscModuleName = 'ActiveDirectoryDsc'
$script:dscResourceName = 'MSFT_ADDomainControllerProperties'

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
        $mockDefaultParameters = @{
            IsSingleInstance = 'Yes'
            Verbose = $true
        }

        Describe 'MSFT_ADDomainControllerProperties\Get-TargetResource' -Tag 'Get' {
            Context 'When the current property values are returned' {
                BeforeAll {
                    Mock -CommandName Get-CimInstance -MockWith {
                        return @{
                            MaxOfflineTimeInDays = 60
                        }
                    }
                }

                It 'Should return the correct values' {
                    $getTargetResourceResult = Get-TargetResource @mockDefaultParameters
                    $getTargetResourceResult.IsSingleInstance | Should -Be $mockDefaultParameters.IsSingleInstance
                    $getTargetResourceResult.ContentFreshness | Should -Be 60

                    Assert-MockCalled -CommandName Get-CimInstance -Exactly -Times 1 -Scope It
                }
            }
        }

        Describe 'MSFT_ADDomainControllerProperties\Test-TargetResource' -Tag 'Test' {
            Context 'When the system is in the desired state' {
                Context 'When the property ContentFreshness is in desired state' {
                    BeforeAll {
                        Mock -CommandName Compare-TargetResourceState -MockWith {
                            return @(
                                @{
                                    ParameterName  = 'ContentFreshness'
                                    InDesiredState = $true
                                }
                            )
                        }

                        $testTargetResourceParameters = $mockDefaultParameters.Clone()
                        $testTargetResourceParameters['ContentFreshness'] = 60
                    }

                    It 'Should return $true' {
                        $testTargetResourceResult = Test-TargetResource @testTargetResourceParameters
                        $testTargetResourceResult | Should -BeTrue

                        Assert-MockCalled -CommandName Compare-TargetResourceState -Exactly -Times 1 -Scope It
                    }
                }
            }

            Context 'When the system is not in the desired state' {
                Context 'When the property ContentFreshness is not in desired state' {
                    BeforeAll {
                        Mock -CommandName Compare-TargetResourceState -MockWith {
                            return @(
                                @{
                                    ParameterName  = 'ContentFreshness'
                                    InDesiredState = $false
                                }
                            )
                        }

                        $testTargetResourceParameters = $mockDefaultParameters.Clone()
                        $testTargetResourceParameters['ContentFreshness'] = 100
                    }

                    It 'Should return $false' {
                        $testTargetResourceResult = Test-TargetResource @testTargetResourceParameters
                        $testTargetResourceResult | Should -BeFalse

                        Assert-MockCalled -CommandName Compare-TargetResourceState -Exactly -Times 1 -Scope It
                    }
                }
            }
        }

        Describe 'MSFT_ADDomainControllerProperties\Compare-TargetResourceState' -Tag 'Compare' {
            Context 'When the system is in the desired state' {
                Context 'When the property ContentFreshness is in desired state' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith {
                            return @{
                                IsSingleInstance = 'Yes'
                                ContentFreshness = 60
                            }
                        }

                        $compareTargetResourceStateParameters = $mockDefaultParameters.Clone()
                        $compareTargetResourceStateParameters['ContentFreshness'] = 60
                    }

                    It 'Should return $true' {
                        $compareTargetResourceStateResult = Compare-TargetResourceState @compareTargetResourceStateParameters
                        $compareTargetResourceStateResult | Should -HaveCount 1

                        $comparedReturnValue = $compareTargetResourceStateResult.Where( { $_.ParameterName -eq 'ContentFreshness' })
                        $comparedReturnValue | Should -Not -BeNullOrEmpty
                        $comparedReturnValue.Expected | Should -Be 60
                        $comparedReturnValue.Actual | Should -Be 60
                        $comparedReturnValue.InDesiredState | Should -BeTrue

                        Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                    }
                }
            }

            Context 'When the system is not in the desired state' {
                Context 'When the property ContentFreshness is not in desired state' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith {
                            return @{
                                IsSingleInstance = 'Yes'
                                ContentFreshness = 60
                            }
                        }

                        $compareTargetResourceStateParameters = $mockDefaultParameters.Clone()
                        $compareTargetResourceStateParameters['ContentFreshness'] = 100
                    }

                    It 'Should return $false' {
                        $compareTargetResourceStateResult = Compare-TargetResourceState @compareTargetResourceStateParameters
                        $compareTargetResourceStateResult | Should -HaveCount 1

                        $comparedReturnValue = $compareTargetResourceStateResult.Where( { $_.ParameterName -eq 'ContentFreshness' })
                        $comparedReturnValue | Should -Not -BeNullOrEmpty
                        $comparedReturnValue.Expected | Should -Be 100
                        $comparedReturnValue.Actual | Should -Be 60
                        $comparedReturnValue.InDesiredState | Should -BeFalse

                        Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                    }
                }
            }
        }

        Describe 'MSFT_ADDomainControllerProperties\Set-TargetResource' -Tag 'Set' {
            Context 'When the system is in the desired state' {
                Context 'When the property ContentFreshness is in desired state' {
                    BeforeAll {
                        Mock -CommandName Set-CimInstance
                        Mock -CommandName Compare-TargetResourceState -MockWith {
                            return @(
                                @{
                                    ParameterName  = 'ContentFreshness'
                                    InDesiredState = $true
                                }
                            )
                        }

                        $setTargetResourceParameters = $mockDefaultParameters.Clone()
                        $setTargetResourceParameters['ContentFreshness'] = 60
                    }

                    It 'Should not throw and do not call Set-CimInstance' {
                        { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw

                        Assert-MockCalled -CommandName Compare-TargetResourceState -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Set-CimInstance -Exactly -Times 0 -Scope It
                    }
                }
            }

            Context 'When the system is not in the desired state' {
                Context 'When the property ContentFreshness is not in desired state' {
                    BeforeAll {
                        Mock -CommandName Set-CimInstance
                        Mock -CommandName Compare-TargetResourceState -MockWith {
                            return @(
                                @{
                                    ParameterName  = 'ContentFreshness'
                                    InDesiredState = $false
                                }
                            )
                        }

                        $setTargetResourceParameters = $mockDefaultParameters.Clone()
                        $setTargetResourceParameters['ContentFreshness'] = 100
                    }

                    It 'Should not throw and call the correct mocks' {
                        { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw

                        Assert-MockCalled -CommandName Compare-TargetResourceState -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Set-CimInstance -Exactly -Times 1 -Scope It
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
