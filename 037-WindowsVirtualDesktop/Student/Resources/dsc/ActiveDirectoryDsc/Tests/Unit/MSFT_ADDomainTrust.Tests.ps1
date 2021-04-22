Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath '..\TestHelpers\ActiveDirectoryDsc.TestHelper.psm1')

if (-not (Test-RunForCITestCategory -Type 'Unit' -Category 'Tests'))
{
    return
}

$script:dscModuleName = 'ActiveDirectoryDsc'
$script:dscResourceName = 'MSFT_ADDomainTrust'

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
        $mockSourceDomainName = 'contoso.com'
        $mockTargetDomainName = 'lab.local'

        $mockCredentialUserName = 'COMPANY\User'
        $mockCredentialPassword = 'dummyPassw0rd' | ConvertTo-SecureString -AsPlainText -Force
        $mockCredential = New-Object -TypeName 'System.Management.Automation.PSCredential' -ArgumentList @(
            $mockCredentialUserName, $mockCredentialPassword
        )

        Describe 'MSFT_ADDomainTrust\Get-TargetResource' -Tag 'Get' {
            BeforeAll {
                $mockDefaultParameters = @{
                    SourceDomainName                    = $mockSourceDomainName
                    TargetDomainName                    = $mockTargetDomainName
                    TargetCredential = $mockCredential
                    TrustDirection                      = 'Outbound'
                    Verbose                             = $true
                }
            }

            Context 'When the system is in the desired state' {
                Context 'When the domain trust is present in Active Directory' {
                    Context 'When the called with the TrustType ''External''' {
                        BeforeAll {
                            Mock -CommandName Get-TrustSourceAndTargetObject -MockWith {
                                $mockTrustSource = New-Object -TypeName Object |
                                    Add-Member -MemberType ScriptMethod -Name 'GetTrustRelationship' -Value {
                                        $script:getTrustRelationshipMethodCallCount += 1

                                        return @{
                                            TrustType      = 'Domain'
                                            TrustDirection = 'Outbound'
                                        }
                                    } -PassThru -Force

                                $mockTrustTarget = New-Object -TypeName Object

                                return $mockTrustSource, $mockTrustTarget
                            }
                        }

                        BeforeEach {
                            $script:getTrustRelationshipMethodCallCount = 0

                            $mockGetTargetResourceParameters = $mockDefaultParameters.Clone()
                            $mockGetTargetResourceParameters['TrustType'] = 'External'
                        }

                        AfterEach {
                            $script:getTrustRelationshipMethodCallCount | Should -Be 1

                            Assert-MockCalled -CommandName Get-TrustSourceAndTargetObject -Exactly -Times 1 -Scope It
                        }

                        It 'Should return the state as present' {
                            $getTargetResourceResult = Get-TargetResource @mockGetTargetResourceParameters
                            $getTargetResourceResult.Ensure | Should -Be 'Present'
                        }

                        It 'Should return the same values as passed as parameters' {
                            $getTargetResourceResult = Get-TargetResource @mockGetTargetResourceParameters
                            $getTargetResourceResult.SourceDomainName | Should -Be $mockGetTargetResourceParameters.SourceDomainName
                            $getTargetResourceResult.TargetDomainName | Should -Be $mockGetTargetResourceParameters.TargetDomainName
                            $getTargetResourceResult.TargetCredential.UserName | Should -Be $mockCredential.UserName
                        }

                        It 'Should return the correct values for the other properties' {
                            $getTargetResourceResult = Get-TargetResource @mockGetTargetResourceParameters
                            $getTargetResourceResult.TrustDirection | Should -Be $mockGetTargetResourceParameters.TrustDirection
                            $getTargetResourceResult.TrustType | Should -Be $mockGetTargetResourceParameters.TrustType
                            $getTargetResourceResult.AllowTrustRecreation | Should -BeFalse
                        }

                        Context 'When the called with the AllowTrustRecreation set to $true' {
                            BeforeEach {
                                $mockGetTargetResourceParameters['AllowTrustRecreation'] = $true
                            }

                            It 'Should return the state as present' {
                                $getTargetResourceResult = Get-TargetResource @mockGetTargetResourceParameters
                                $getTargetResourceResult.Ensure | Should -Be 'Present'
                            }

                            It 'Should return the same values as passed as parameters' {
                                $getTargetResourceResult = Get-TargetResource @mockGetTargetResourceParameters
                                $getTargetResourceResult.SourceDomainName | Should -Be $mockGetTargetResourceParameters.SourceDomainName
                                $getTargetResourceResult.TargetDomainName | Should -Be $mockGetTargetResourceParameters.TargetDomainName
                                $getTargetResourceResult.TargetCredential.UserName | Should -Be $mockCredential.UserName
                                $getTargetResourceResult.AllowTrustRecreation | Should -BeTrue
                            }

                            It 'Should return the correct values for the other properties' {
                                $getTargetResourceResult = Get-TargetResource @mockGetTargetResourceParameters
                                $getTargetResourceResult.TrustDirection | Should -Be $mockGetTargetResourceParameters.TrustDirection
                                $getTargetResourceResult.TrustType | Should -Be $mockGetTargetResourceParameters.TrustType
                            }
                        }
                    }

                    Context 'When the called with the TrustType ''Forest''' {
                        BeforeAll {
                            Mock -CommandName Get-TrustSourceAndTargetObject -MockWith {
                                $mockTrustSource = New-Object -TypeName Object |
                                    Add-Member -MemberType ScriptMethod -Name 'GetTrustRelationship' -Value {
                                        $script:getTrustRelationshipMethodCallCount += 1

                                        return @{
                                            TrustType      = 'Forest'
                                            TrustDirection = 'Outbound'
                                        }
                                    } -PassThru -Force

                                $mockTrustTarget = New-Object -TypeName Object

                                return $mockTrustSource, $mockTrustTarget
                            }
                        }

                        BeforeEach {
                            $script:getTrustRelationshipMethodCallCount = 0

                            $mockGetTargetResourceParameters = $mockDefaultParameters.Clone()
                            $mockGetTargetResourceParameters['TrustType'] = 'Forest'
                        }

                        AfterEach {
                            $script:getTrustRelationshipMethodCallCount | Should -Be 1

                            Assert-MockCalled -CommandName Get-TrustSourceAndTargetObject -Exactly -Times 1 -Scope It
                        }

                        It 'Should return the state as present' {
                            $getTargetResourceResult = Get-TargetResource @mockGetTargetResourceParameters
                            $getTargetResourceResult.Ensure | Should -Be 'Present'
                        }

                        It 'Should return the same values as passed as parameters' {
                            $getTargetResourceResult = Get-TargetResource @mockGetTargetResourceParameters
                            $getTargetResourceResult.SourceDomainName | Should -Be $mockGetTargetResourceParameters.SourceDomainName
                            $getTargetResourceResult.TargetDomainName | Should -Be $mockGetTargetResourceParameters.TargetDomainName
                            $getTargetResourceResult.TargetCredential.UserName | Should -Be $mockCredential.UserName
                        }

                        It 'Should return the correct values for the other properties' {
                            $getTargetResourceResult = Get-TargetResource @mockGetTargetResourceParameters
                            $getTargetResourceResult.TrustDirection | Should -Be $mockGetTargetResourceParameters.TrustDirection
                            $getTargetResourceResult.TrustType | Should -Be $mockGetTargetResourceParameters.TrustType
                            $getTargetResourceResult.AllowTrustRecreation | Should -BeFalse
                        }
                    }
                }

                Context 'When the domain trust is absent from Active Directory' {
                    BeforeAll {
                        Mock -CommandName Get-TrustSourceAndTargetObject -MockWith {
                            $mockTrustSource = New-Object -TypeName Object |
                                Add-Member -MemberType ScriptMethod -Name 'GetTrustRelationship' -Value {
                                    $script:getTrustRelationshipMethodCallCount += 1

                                    throw
                                } -PassThru -Force

                            $mockTrustTarget = New-Object -TypeName Object

                            return $mockTrustSource, $mockTrustTarget
                        }
                    }

                    BeforeEach {
                        $script:GetTrustRelationshipMethodCallCount = 0

                        $mockGetTargetResourceParameters = $mockDefaultParameters.Clone()
                        $mockGetTargetResourceParameters['TrustType'] = 'Forest'
                    }

                    AfterEach {
                        $script:getTrustRelationshipMethodCallCount | Should -Be 1

                        Assert-MockCalled -CommandName Get-TrustSourceAndTargetObject -Exactly -Times 1 -Scope It
                    }

                    It 'Should return the state as absent' {
                        $getTargetResourceResult = Get-TargetResource @mockGetTargetResourceParameters
                        $getTargetResourceResult.Ensure | Should -Be 'Absent'
                    }

                    It 'Should return the same values as passed as parameters' {
                        $getTargetResourceResult = Get-TargetResource @mockGetTargetResourceParameters
                        $getTargetResourceResult.SourceDomainName | Should -Be $mockGetTargetResourceParameters.SourceDomainName
                        $getTargetResourceResult.TargetDomainName | Should -Be $mockGetTargetResourceParameters.TargetDomainName
                        $getTargetResourceResult.TargetCredential.UserName | Should -Be $mockCredential.UserName
                    }

                    It 'Should return the correct values for the other properties' {
                        $getTargetResourceResult = Get-TargetResource @mockGetTargetResourceParameters
                        $getTargetResourceResult.TrustDirection | Should -BeNullOrEmpty
                        $getTargetResourceResult.TrustType | Should -BeNullOrEmpty
                        $getTargetResourceResult.AllowTrustRecreation | Should -BeFalse
                    }
                }
            }

        }

        Describe 'MSFT_ADDomainTrust\Test-TargetResource' -Tag 'Test' {
            BeforeAll {
                $mockDefaultParameters = @{
                    SourceDomainName                    = $mockSourceDomainName
                    TargetDomainName                    = $mockTargetDomainName
                    TargetCredential = $mockCredential
                    Verbose                             = $true
                }
            }

            Context 'When the system is in the desired state' {
                Context 'When the trust is absent from Active Directory' {
                    BeforeAll {
                        Mock -CommandName Compare-TargetResourceState -MockWith {
                            return @(
                                @{
                                    ParameterName  = 'Ensure'
                                    InDesiredState = $true
                                }
                                @{
                                    ParameterName  = 'TrustType'
                                    InDesiredState = $true
                                }
                                @{
                                    ParameterName  = 'TrustDirection'
                                    InDesiredState = $true
                                }
                            )
                        }

                        $testTargetResourceParameters = $mockDefaultParameters.Clone()
                        $testTargetResourceParameters['Ensure'] = 'Absent'
                        $testTargetResourceParameters['TrustType'] = 'External'
                        $testTargetResourceParameters['TrustDirection'] = 'Outbound'
                    }

                    It 'Should return $true' {
                        $testTargetResourceResult = Test-TargetResource @testTargetResourceParameters
                        $testTargetResourceResult | Should -BeTrue

                        Assert-MockCalled -CommandName Compare-TargetResourceState -Exactly -Times 1 -Scope It
                    }
                }

                Context 'When the trust is present in Active Directory' {
                    BeforeAll {
                        Mock -CommandName Compare-TargetResourceState -MockWith {
                            return @(
                                @{
                                    ParameterName  = 'Ensure'
                                    InDesiredState = $true
                                }
                                @{
                                    ParameterName  = 'TrustType'
                                    InDesiredState = $true
                                }
                                @{
                                    ParameterName  = 'TrustDirection'
                                    InDesiredState = $true
                                }
                            )
                        }

                        $testTargetResourceParameters = $mockDefaultParameters.Clone()
                        $testTargetResourceParameters['TrustType'] = 'External'
                        $testTargetResourceParameters['TrustDirection'] = 'Outbound'
                    }

                    It 'Should return $true' {
                        $testTargetResourceResult = Test-TargetResource @testTargetResourceParameters
                        $testTargetResourceResult | Should -BeTrue

                        Assert-MockCalled -CommandName Compare-TargetResourceState -Exactly -Times 1 -Scope It
                    }
                }
            }

            Context 'When the system is not in the desired state' {
                Context 'When the trust should be absent from Active Directory' {
                    BeforeAll {
                        Mock -CommandName Compare-TargetResourceState -MockWith {
                            return @(
                                @{
                                    ParameterName  = 'Ensure'
                                    InDesiredState = $false
                                }
                                @{
                                    ParameterName  = 'TrustType'
                                    InDesiredState = $true
                                }
                                @{
                                    ParameterName  = 'TrustDirection'
                                    InDesiredState = $true
                                }
                            )
                        }

                        $testTargetResourceParameters = $mockDefaultParameters.Clone()
                        $testTargetResourceParameters['Ensure'] = 'Absent'
                        $testTargetResourceParameters['TrustType'] = 'External'
                        $testTargetResourceParameters['TrustDirection'] = 'Outbound'
                    }

                    It 'Should return $false' {
                        $testTargetResourceResult = Test-TargetResource @testTargetResourceParameters
                        $testTargetResourceResult | Should -BeFalse

                        Assert-MockCalled -CommandName Compare-TargetResourceState -Exactly -Times 1 -Scope It
                    }
                }

                Context 'When the trust should be present in Active Directory' {
                    BeforeAll {
                        Mock -CommandName Compare-TargetResourceState -MockWith {
                            return @(
                                @{
                                    ParameterName  = 'Ensure'
                                    InDesiredState = $true
                                }
                                @{
                                    ParameterName  = 'TrustType'
                                    InDesiredState = $true
                                }
                                @{
                                    ParameterName  = 'TrustDirection'
                                    InDesiredState = $false
                                }
                            )
                        }

                        $testTargetResourceParameters = $mockDefaultParameters.Clone()
                        $testTargetResourceParameters['TrustType'] = 'External'
                        $testTargetResourceParameters['TrustDirection'] = 'Outbound'
                    }

                    It 'Should return $false' {
                        $testTargetResourceResult = Test-TargetResource @testTargetResourceParameters
                        $testTargetResourceResult | Should -BeFalse

                        Assert-MockCalled -CommandName Compare-TargetResourceState -Exactly -Times 1 -Scope It
                    }
                }
            }
        }

        Describe 'MSFT_ADDomainTrust\Compare-TargetResourceState' -Tag 'Compare' {
            BeforeAll {
                $mockDefaultParameters = @{
                    SourceDomainName                    = $mockSourceDomainName
                    TargetDomainName                    = $mockTargetDomainName
                    TargetCredential = $mockCredential
                    Verbose                             = $true
                }

                $mockGetTargetResource_Absent = {
                    return @{
                        Ensure                              = 'Absent'
                        SourceDomainName                    = $mockSourceDomainName
                        TargetDomainName                    = $mockTargetDomainName
                        TargetCredential = $mockCredential
                        TrustDirection                      = $null
                        TrustType                           = $null
                    }
                }

                $mockGetTargetResource_Present = {
                    return @{
                        Ensure                              = 'Present'
                        SourceDomainName                    = $mockSourceDomainName
                        TargetDomainName                    = $mockTargetDomainName
                        TargetCredential = $mockCredential
                        TrustDirection                      = 'Outbound'
                        TrustType                           = 'External'
                    }
                }
            }

            Context 'When the system is in the desired state' {
                Context 'When the trust is absent from Active Directory' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith $mockGetTargetResource_Absent

                        $testTargetResourceParameters = $mockDefaultParameters.Clone()
                        $testTargetResourceParameters['Ensure'] = 'Absent'
                        $testTargetResourceParameters['TrustType'] = 'External'
                        $testTargetResourceParameters['TrustDirection'] = 'Outbound'
                    }

                    It 'Should return the correct values' {
                        $compareTargetResourceStateResult = Compare-TargetResourceState @testTargetResourceParameters
                        $compareTargetResourceStateResult | Should -HaveCount 1

                        $comparedReturnValue = $compareTargetResourceStateResult.Where( { $_.ParameterName -eq 'Ensure' })
                        $comparedReturnValue | Should -Not -BeNullOrEmpty
                        $comparedReturnValue.Expected | Should -Be 'Absent'
                        $comparedReturnValue.Actual | Should -Be 'Absent'
                        $comparedReturnValue.InDesiredState | Should -BeTrue

                        Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                    }
                }

                Context 'When the trust is present in Active Directory' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith $mockGetTargetResource_Present

                        $testTargetResourceParameters = $mockDefaultParameters.Clone()
                        $testTargetResourceParameters['TrustType'] = 'External'
                        $testTargetResourceParameters['TrustDirection'] = 'Outbound'
                    }

                    It 'Should return the correct values' {
                        $compareTargetResourceStateResult = Compare-TargetResourceState @testTargetResourceParameters
                        $compareTargetResourceStateResult | Should -HaveCount 3

                        $comparedReturnValue = $compareTargetResourceStateResult.Where( { $_.ParameterName -eq 'Ensure' })
                        $comparedReturnValue | Should -Not -BeNullOrEmpty
                        $comparedReturnValue.Expected | Should -Be 'Present'
                        $comparedReturnValue.Actual | Should -Be 'Present'
                        $comparedReturnValue.InDesiredState | Should -BeTrue

                        $comparedReturnValue = $compareTargetResourceStateResult.Where( { $_.ParameterName -eq 'TrustType' })
                        $comparedReturnValue | Should -Not -BeNullOrEmpty
                        $comparedReturnValue.Expected | Should -Be 'External'
                        $comparedReturnValue.Actual | Should -Be 'External'
                        $comparedReturnValue.InDesiredState | Should -BeTrue

                        $comparedReturnValue = $compareTargetResourceStateResult.Where( { $_.ParameterName -eq 'TrustDirection' })
                        $comparedReturnValue | Should -Not -BeNullOrEmpty
                        $comparedReturnValue.Expected | Should -Be 'Outbound'
                        $comparedReturnValue.Actual | Should -Be 'Outbound'
                        $comparedReturnValue.InDesiredState | Should -BeTrue

                        Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                    }
                }
            }

            Context 'When the system is not in the desired state' {
                Context 'When the trust should be absent from Active Directory' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith $mockGetTargetResource_Present

                        $testTargetResourceParameters = $mockDefaultParameters.Clone()
                        $testTargetResourceParameters['Ensure'] = 'Absent'
                        $testTargetResourceParameters['TrustType'] = 'External'
                        $testTargetResourceParameters['TrustDirection'] = 'Outbound'
                    }

                    It 'Should return the correct values' {
                        $compareTargetResourceStateResult = Compare-TargetResourceState @testTargetResourceParameters
                        $compareTargetResourceStateResult | Should -HaveCount 1

                        $comparedReturnValue = $compareTargetResourceStateResult.Where( { $_.ParameterName -eq 'Ensure' })
                        $comparedReturnValue | Should -Not -BeNullOrEmpty
                        $comparedReturnValue.Expected | Should -Be 'Absent'
                        $comparedReturnValue.Actual | Should -Be 'Present'
                        $comparedReturnValue.InDesiredState | Should -BeFalse

                        Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                    }
                }

                Context 'When the trust should be present in Active Directory' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith $mockGetTargetResource_Absent

                        $testTargetResourceParameters = $mockDefaultParameters.Clone()
                        $testTargetResourceParameters['TrustType'] = 'External'
                        $testTargetResourceParameters['TrustDirection'] = 'Outbound'
                    }

                    It 'Should return the correct values' {
                        $compareTargetResourceStateResult = Compare-TargetResourceState @testTargetResourceParameters
                        $compareTargetResourceStateResult | Should -HaveCount 3

                        $comparedReturnValue = $compareTargetResourceStateResult.Where( { $_.ParameterName -eq 'Ensure' })
                        $comparedReturnValue | Should -Not -BeNullOrEmpty
                        $comparedReturnValue.Expected | Should -Be 'Present'
                        $comparedReturnValue.Actual | Should -Be 'Absent'
                        $comparedReturnValue.InDesiredState | Should -BeFalse

                        $comparedReturnValue = $compareTargetResourceStateResult.Where( { $_.ParameterName -eq 'TrustType' })
                        $comparedReturnValue | Should -Not -BeNullOrEmpty
                        $comparedReturnValue.Expected | Should -Be 'External'
                        $comparedReturnValue.Actual | Should -BeNullOrEmpty
                        $comparedReturnValue.InDesiredState | Should -BeFalse

                        $comparedReturnValue = $compareTargetResourceStateResult.Where( { $_.ParameterName -eq 'TrustDirection' })
                        $comparedReturnValue | Should -Not -BeNullOrEmpty
                        $comparedReturnValue.Expected | Should -Be 'Outbound'
                        $comparedReturnValue.Actual | Should -BeNullOrEmpty
                        $comparedReturnValue.InDesiredState | Should -BeFalse

                        Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                    }
                }

                Context 'When a property is not in desired state' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith $mockGetTargetResource_Present


                        # One test case per property with a value that differs from the desired state.
                        $testCases_Properties = @(
                            @{
                                ParameterName = 'TrustType'
                                Value         = 'Forest'
                            },
                            @{
                                ParameterName = 'TrustDirection'
                                Value         = 'Inbound'
                            }
                        )
                    }

                    It 'Should return the correct values when the property <ParameterName> is not in desired state' -TestCases $testCases_Properties {
                        param
                        (
                            [Parameter()]
                            $ParameterName,

                            [Parameter()]
                            $Value
                        )

                        # Set up all mandatory parameters to use the values in the mock.
                        $testTargetResourceParameters = $mockDefaultParameters.Clone()
                        $testTargetResourceParameters['TrustType'] = 'External'
                        $testTargetResourceParameters['TrustDirection'] = 'Outbound'

                        # Change the property we are currently testing to a different value.
                        $testTargetResourceParameters[$ParameterName] = $Value

                        $compareTargetResourceStateResult = Compare-TargetResourceState @testTargetResourceParameters
                        $compareTargetResourceStateResult | Should -HaveCount 3

                        $comparedReturnValue = $compareTargetResourceStateResult.Where( { $_.ParameterName -eq $ParameterName })
                        $comparedReturnValue | Should -Not -BeNullOrEmpty
                        $comparedReturnValue.Expected | Should -Be $Value
                        $comparedReturnValue.Actual | Should -Be (& $mockGetTargetResource_Present).$ParameterName
                        $comparedReturnValue.InDesiredState | Should -BeFalse

                        Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                    }
                }
            }
        }

         Describe 'MSFT_ADDomainTrust\Set-TargetResource' -Tag 'Set' {
            BeforeAll {
                Mock -CommandName Get-TrustSourceAndTargetObject -MockWith {
                    $mockTrustSource = New-Object -TypeName Object |
                        Add-Member -MemberType ScriptMethod -Name 'CreateTrustRelationship' -Value {
                            $script:createTrustRelationshipMethodCallCount += 1
                        } -PassThru |
                        Add-Member -MemberType ScriptMethod -Name 'DeleteTrustRelationship' -Value {
                            $script:deleteTrustRelationshipMethodCallCount += 1
                        } -PassThru |
                        Add-Member -MemberType ScriptMethod -Name 'UpdateTrustRelationship' -Value {
                            $script:updateTrustRelationshipMethodCallCount += 1
                        } -PassThru -Force

                    $mockTrustTarget = New-Object -TypeName Object

                    return $mockTrustSource, $mockTrustTarget
                }

                  $mockDefaultParameters = @{
                    SourceDomainName                    = $mockSourceDomainName
                    TargetDomainName                    = $mockTargetDomainName
                    TargetCredential = $mockCredential
                    TrustDirection                      = 'Outbound'
                    Verbose                             = $true
                }
            }

            Context 'When the system is in the desired state' {
                Context 'When the domain trust is present in Active Directory' {
                    Context 'When the called with the TrustType ''External''' {
                        BeforeAll {
                            Mock -CommandName Compare-TargetResourceState -MockWith {
                                return @(
                                    @{
                                        ParameterName  = 'Ensure'
                                        InDesiredState = $true
                                    }
                                    @{
                                        ParameterName  = 'TrustType'
                                        InDesiredState = $true
                                    }
                                    @{
                                        ParameterName  = 'TrustDirection'
                                        InDesiredState = $true
                                    }
                                )
                            }
                        }

                        BeforeEach {
                            $script:createTrustRelationshipMethodCallCount = 0
                            $script:deleteTrustRelationshipMethodCallCount = 0
                            $script:updateTrustRelationshipMethodCallCount = 0

                            $setTargetResourceParameters = $mockDefaultParameters.Clone()
                            $setTargetResourceParameters['TrustType'] = 'External'
                        }

                        It 'Should not throw and not call any methods' {
                            { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw

                            $script:createTrustRelationshipMethodCallCount | Should -Be 0
                            $script:deleteTrustRelationshipMethodCallCount | Should -Be 0
                            $script:updateTrustRelationshipMethodCallCount | Should -Be 0

                            Assert-MockCalled -CommandName Get-TrustSourceAndTargetObject -Exactly -Times 1 -Scope It
                        }
                    }

                    Context 'When the called with the TrustType ''Forest''' {
                        BeforeAll {
                            Mock -CommandName Compare-TargetResourceState -MockWith {
                                return @(
                                    @{
                                        ParameterName  = 'Ensure'
                                        InDesiredState = $true
                                    }
                                    @{
                                        ParameterName  = 'TrustType'
                                        InDesiredState = $true
                                    }
                                    @{
                                        ParameterName  = 'TrustDirection'
                                        InDesiredState = $true
                                    }
                                )
                            }
                        }

                        BeforeEach {
                            $script:createTrustRelationshipMethodCallCount = 0
                            $script:deleteTrustRelationshipMethodCallCount = 0
                            $script:updateTrustRelationshipMethodCallCount = 0

                            $setTargetResourceParameters = $mockDefaultParameters.Clone()
                            $setTargetResourceParameters['TrustType'] = 'Forest'
                        }

                        It 'Should not throw and not call any methods' {
                            { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw

                            $script:createTrustRelationshipMethodCallCount | Should -Be 0
                            $script:deleteTrustRelationshipMethodCallCount | Should -Be 0
                            $script:updateTrustRelationshipMethodCallCount | Should -Be 0

                            Assert-MockCalled -CommandName Get-TrustSourceAndTargetObject -Exactly -Times 1 -Scope It
                        }
                    }
                }

                Context 'When the domain trust is absent in Active Directory' {
                    Context 'When the called with the TrustType ''External''' {
                        BeforeAll {
                            Mock -CommandName Compare-TargetResourceState -MockWith {
                                return @(
                                    @{
                                        ParameterName  = 'Ensure'
                                        InDesiredState = $true
                                    }
                                )
                            }
                        }

                        BeforeEach {
                            $script:createTrustRelationshipMethodCallCount = 0
                            $script:deleteTrustRelationshipMethodCallCount = 0
                            $script:updateTrustRelationshipMethodCallCount = 0

                            $setTargetResourceParameters = $mockDefaultParameters.Clone()
                            $setTargetResourceParameters['TrustType'] = 'External'
                            $setTargetResourceParameters['Ensure'] = 'Absent'
                        }

                        It 'Should not throw and not call any methods' {
                            { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw

                            $script:createTrustRelationshipMethodCallCount | Should -Be 0
                            $script:deleteTrustRelationshipMethodCallCount | Should -Be 0
                            $script:updateTrustRelationshipMethodCallCount | Should -Be 0

                            Assert-MockCalled -CommandName Get-TrustSourceAndTargetObject -Exactly -Times 1 -Scope It
                        }
                    }
                }
            }

            Context 'When the system is not in the desired state' {
                Context 'When the domain trust should be present in Active Directory' {
                    BeforeAll {
                        Mock -CommandName Compare-TargetResourceState -MockWith {
                            return @(
                                @{
                                    ParameterName  = 'Ensure'
                                    InDesiredState = $false
                                }
                                @{
                                    ParameterName  = 'TrustType'
                                    InDesiredState = $false
                                }
                                @{
                                    ParameterName  = 'TrustDirection'
                                    InDesiredState = $false
                                }
                            )
                        }
                    }

                    BeforeEach {
                        $script:createTrustRelationshipMethodCallCount = 0
                        $script:deleteTrustRelationshipMethodCallCount = 0
                        $script:updateTrustRelationshipMethodCallCount = 0

                        $setTargetResourceParameters = $mockDefaultParameters.Clone()
                        $setTargetResourceParameters['TrustType'] = 'External'
                    }

                    It 'Should not throw and call the correct method' {
                        { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw

                        $script:createTrustRelationshipMethodCallCount | Should -Be 1
                        $script:deleteTrustRelationshipMethodCallCount | Should -Be 0
                        $script:updateTrustRelationshipMethodCallCount | Should -Be 0

                        Assert-MockCalled -CommandName Get-TrustSourceAndTargetObject -Exactly -Times 1 -Scope It
                    }
                }

                Context 'When the domain trust should be absent from Active Directory' {
                    BeforeAll {
                        Mock -CommandName Compare-TargetResourceState -MockWith {
                            return @(
                                @{
                                    ParameterName  = 'Ensure'
                                    InDesiredState = $false
                                }
                                @{
                                    ParameterName  = 'TrustType'
                                    InDesiredState = $true
                                }
                                @{
                                    ParameterName  = 'TrustDirection'
                                    InDesiredState = $true
                                }
                            )
                        }
                    }

                    BeforeEach {
                        $script:createTrustRelationshipMethodCallCount = 0
                        $script:deleteTrustRelationshipMethodCallCount = 0
                        $script:updateTrustRelationshipMethodCallCount = 0

                        $setTargetResourceParameters = $mockDefaultParameters.Clone()
                        $setTargetResourceParameters['TrustType'] = 'External'
                        $setTargetResourceParameters['Ensure'] = 'Absent'
                    }

                    It 'Should not throw and call the correct method' {
                        { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw

                        $script:createTrustRelationshipMethodCallCount | Should -Be 0
                        $script:deleteTrustRelationshipMethodCallCount | Should -Be 1
                        $script:updateTrustRelationshipMethodCallCount | Should -Be 0

                        Assert-MockCalled -CommandName Get-TrustSourceAndTargetObject -Exactly -Times 1 -Scope It
                    }
                }

                Context 'When a property of a domain trust is not in desired state' {
                    Context 'When property TrustType is not in desired state, and not opt-in to recreate trust' {
                        BeforeAll {
                            Mock -CommandName Compare-TargetResourceState -MockWith {
                                return @(
                                    @{
                                        ParameterName  = 'Ensure'
                                        Actual = 'Present'
                                        Expected = 'Present'
                                        InDesiredState = $true
                                    }
                                    @{
                                        ParameterName  = 'TrustType'
                                        Actual = 'Domain'
                                        Expected = 'Forest'
                                        InDesiredState = $false
                                    }
                                )
                            }
                        }

                        BeforeEach {
                            $setTargetResourceParameters = $mockDefaultParameters.Clone()
                            $setTargetResourceParameters['TrustType'] = 'Forest'
                            $setTargetResourceParameters['TrustDirection'] = 'Inbound'
                        }

                        It 'Should not throw and call the correct methods' {
                            { Set-TargetResource @setTargetResourceParameters } | Should -Throw $script:localizedData.NotOptInToRecreateTrust

                            Assert-MockCalled -CommandName Get-TrustSourceAndTargetObject -Exactly -Times 1 -Scope It
                        }
                    }

                    Context 'When both properties TrustType and and TrustDirection is not in desired state' {
                        BeforeAll {
                            Mock -CommandName Compare-TargetResourceState -MockWith {
                                return @(
                                    @{
                                        ParameterName  = 'Ensure'
                                        Actual = 'Present'
                                        Expected = 'Present'
                                        InDesiredState = $true
                                    }
                                    @{
                                        ParameterName  = 'TrustType'
                                        Actual = 'Domain'
                                        Expected = 'Forest'
                                        InDesiredState = $false
                                    }
                                    @{
                                        ParameterName  = 'TrustDirection'
                                        Actual = 'Outbound'
                                        Expected = 'Inbound'
                                        InDesiredState = $false
                                    }
                                )
                            }
                        }

                        BeforeEach {
                            $script:createTrustRelationshipMethodCallCount = 0
                            $script:deleteTrustRelationshipMethodCallCount = 0
                            $script:updateTrustRelationshipMethodCallCount = 0

                            $setTargetResourceParameters = $mockDefaultParameters.Clone()
                            $setTargetResourceParameters['TrustType'] = 'Forest'
                            $setTargetResourceParameters['TrustDirection'] = 'Inbound'
                            $setTargetResourceParameters['AllowTrustRecreation'] = $true
                        }

                        It 'Should not throw and call the correct methods' {
                            { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw

                            $script:createTrustRelationshipMethodCallCount | Should -Be 1
                            $script:deleteTrustRelationshipMethodCallCount | Should -Be 1
                            $script:updateTrustRelationshipMethodCallCount | Should -Be 0

                            Assert-MockCalled -CommandName Get-TrustSourceAndTargetObject -Exactly -Times 1 -Scope It
                        }
                    }

                    Context 'When property TrustDirection is not in desired state' {
                        BeforeAll {
                            Mock -CommandName Compare-TargetResourceState -MockWith {
                                return @(
                                    @{
                                        ParameterName  = 'Ensure'
                                        Actual = 'Present'
                                        Expected = 'Present'
                                        InDesiredState = $true
                                    }
                                    @{
                                        ParameterName  = 'TrustType'
                                        Actual = 'Domain'
                                        Expected = 'Domain'
                                        InDesiredState = $true
                                    }
                                    @{
                                        ParameterName  = 'TrustDirection'
                                        Actual = 'Outbound'
                                        Expected = 'Inbound'
                                        InDesiredState = $false
                                    }
                                )
                            }
                        }

                        BeforeEach {
                            $script:createTrustRelationshipMethodCallCount = 0
                            $script:deleteTrustRelationshipMethodCallCount = 0
                            $script:updateTrustRelationshipMethodCallCount = 0

                            $setTargetResourceParameters = $mockDefaultParameters.Clone()
                            $setTargetResourceParameters['TrustType'] = 'External'
                            $setTargetResourceParameters['TrustDirection'] = 'Inbound'
                        }

                        It 'Should not throw and call the correct method' {
                            { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw

                            $script:createTrustRelationshipMethodCallCount | Should -Be 0
                            $script:deleteTrustRelationshipMethodCallCount | Should -Be 0
                            $script:updateTrustRelationshipMethodCallCount | Should -Be 1

                            Assert-MockCalled -CommandName Get-TrustSourceAndTargetObject -Exactly -Times 1 -Scope It
                        }
                    }
                }
            }
        }

        Describe 'MSFT_ADDomainTrust\ConvertTo-DirectoryContextType' -Tag 'Helper' {
            BeforeAll {
                $testCases = @(
                    @{
                        TrustTypeValue            = 'External'
                        DirectoryContextTypeValue = 'Domain'
                    },
                    @{
                        TrustTypeValue            = 'Forest'
                        DirectoryContextTypeValue = 'Forest'
                    }
                )
            }

            It 'Should return the correct converted value for the trust type value <TrustTypeValue>' -TestCases $testCases {
                param
                (
                    [Parameter()]
                    $TrustTypeValue,

                    [Parameter()]
                    $DirectoryContextTypeValue
                )

                $convertToDirectoryContextTypeResult = ConvertTo-DirectoryContextType -TrustType $TrustTypeValue
                $convertToDirectoryContextTypeResult | Should -Be $DirectoryContextTypeValue
            }

            It 'Should return the correct converted value for the directory context type value <DirectoryContextTypeValue>' -TestCases $testCases {
                param
                (
                    [Parameter()]
                    $TrustTypeValue,

                    [Parameter()]
                    $DirectoryContextTypeValue
                )

                $convertFromDirectoryContextTypeResult = ConvertFrom-DirectoryContextType -DirectoryContextType $DirectoryContextTypeValue
                $convertFromDirectoryContextTypeResult | Should -Be $TrustTypeValue
            }
        }

        Describe 'MSFT_ADDomainTrust\Get-TrustSourceAndTargetObject' -Tag 'Helper' {
            BeforeAll {
                Mock -CommandName Get-ADDirectoryContext -MockWith {
                    # This should work on any client, domain joined or not.
                    return [System.DirectoryServices.ActiveDirectory.DirectoryContext]::new('Domain')
                }

                Mock -CommandName Get-ActiveDirectoryDomain
                Mock -CommandName Get-ActiveDirectoryForest

                $testCases = @(
                    @{
                        TrustType = 'External'
                    },
                    @{
                        TrustType = 'Forest'
                    }
                )
            }

            It 'Should not throw and call the correct mocks when called with the trust type value ''<TrustType>''' -TestCases $testCases {
                param
                (
                    [Parameter()]
                    $TrustType
                )

                $testParameters = @{
                    SourceDomainName                    = $mockSourceDomainName
                    TargetDomainName                    = $mockTargetDomainName
                    TargetCredential = $mockCredential
                    TrustType                           = $TrustType
                    Verbose                             = $true
                }

                { Get-TrustSourceAndTargetObject @testParameters } | Should -Not -Throw

                if ($TrustType -eq 'External')
                {
                    Assert-MockCalled -CommandName Get-ActiveDirectoryDomain -Exactly -Times 2 -Scope It
                }
                else
                {
                    Assert-MockCalled -CommandName Get-ActiveDirectoryForest -Exactly -Times 2 -Scope It
                }
            }
        }
    }
}
finally
{
    Invoke-TestCleanup
}
