Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath '..\TestHelpers\ActiveDirectoryDsc.TestHelper.psm1')

if (-not (Test-RunForCITestCategory -Type 'Unit' -Category 'Tests'))
{
    return
}

$script:dscModuleName = 'ActiveDirectoryDsc'
$script:dscResourceName = 'MSFT_WaitForADDomain'

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
        $mockUserName = 'User1'
        $mockDomainUserCredential = New-Object -TypeName 'System.Management.Automation.PSCredential' -ArgumentList @(
            $mockUserName,
            (ConvertTo-SecureString -String 'Password' -AsPlainText -Force)
        )

        $mockDomainName = 'example.com'
        $mockSiteName = 'Europe'

        $mockDefaultParameters = @{
            DomainName = $mockDomainName
            Verbose    = $true
        }

        #region Function Get-TargetResource
        Describe 'WaitForADDomain\Get-TargetResource' -Tag 'Get' {
            Context 'When the system is in the desired state' {
                Context 'When no domain controller is found in the domain' {
                    BeforeAll {
                        Mock -CommandName Find-DomainController -MockWith {
                            return $null
                        }

                        $getTargetResourceParameters = $mockDefaultParameters.Clone()
                    }

                    It 'Should return the same values as passed as parameters' {
                        $result = Get-TargetResource @getTargetResourceParameters
                        $result.DomainName | Should -Be $mockDomainName
                    }

                    It 'Should return default value for property WaitTimeout' {
                        $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters
                        $getTargetResourceResult.WaitTimeout | Should -Be 300
                    }

                    It 'Should return $null for the rest of the properties' {
                        $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters
                        $getTargetResourceResult.SiteName | Should -BeNullOrEmpty
                        $getTargetResourceResult.Credential | Should -BeNullOrEmpty
                        $getTargetResourceResult.RestartCount | Should -Be 0
                        $getTargetResourceResult.WaitForValidCredentials | Should -BeFalse
                    }
                }

                Context 'When a domain controller is found in the domain' {
                    BeforeAll {
                        Mock -CommandName Find-DomainController -MockWith {
                            return New-Object -TypeName PSObject |
                                Add-Member -MemberType ScriptProperty -Name 'Domain' -Value {
                                    New-Object -TypeName PSObject |
                                        Add-Member -MemberType ScriptMethod -Name 'ToString' -Value {
                                            return $mockDomainName
                                        } -PassThru -Force
                                } -PassThru |
                                Add-Member -MemberType NoteProperty -Name 'SiteName' -Value $mockSiteName -PassThru -Force
                        }

                        $getTargetResourceParameters = $mockDefaultParameters.Clone()
                    }

                    Context 'When using the default parameters' {
                        It 'Should return the same values as passed as parameters' {
                            $result = Get-TargetResource @getTargetResourceParameters
                            $result.DomainName | Should -Be $mockDomainName
                        }

                        It 'Should return default value for property WaitTimeout' {
                            $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters
                            $getTargetResourceResult.WaitTimeout | Should -Be 300
                        }

                        It 'Should return $null for the rest of the properties' {
                            $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters
                            $getTargetResourceResult.SiteName | Should -Be 'Europe'
                            $getTargetResourceResult.Credential | Should -BeNullOrEmpty
                            $getTargetResourceResult.RestartCount | Should -Be 0
                            $getTargetResourceResult.WaitForValidCredentials | Should -BeFalse
                        }
                    }

                    Context 'When using all available parameters' {
                        BeforeAll {
                            $getTargetResourceParameters['Credential'] = $mockDomainUserCredential
                            $getTargetResourceParameters['SiteName'] = 'Europe'
                            $getTargetResourceParameters['WaitTimeout'] = 600
                            $getTargetResourceParameters['RestartCount'] = 2
                            $getTargetResourceParameters['WaitForValidCredentials'] = $true
                        }

                        It 'Should return the same values as passed as parameters' {
                            $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters
                            $getTargetResourceResult.DomainName | Should -Be $mockDomainName
                            $getTargetResourceResult.SiteName | Should -Be 'Europe'
                            $getTargetResourceResult.WaitTimeout | Should -Be 600
                            $getTargetResourceResult.RestartCount | Should -Be 2
                            $getTargetResourceResult.Credential.UserName | Should -Be $mockUserName
                            $getTargetResourceResult.WaitForValidCredentials | Should -BeTrue

                            Assert-MockCalled -CommandName Find-DomainController -ParameterFilter {
                                $PSBoundParameters.ContainsKey('WaitForValidCredentials')
                            } -Exactly -Times 1 -Scope It
                        }
                    }

                    Context 'When using BuiltInCredential parameter' {
                        BeforeAll {
                            $mockBuiltInCredentialName = 'BuiltInCredential'

                            # Mock PsDscRunAsCredential context.
                            $PsDscContext = @{
                                RunAsUser = $mockBuiltInCredentialName
                            }

                            Mock -CommandName Write-Verbose -ParameterFilter {
                                $Message -eq ($script:localizedData.ImpersonatingCredentials -f $mockBuiltInCredentialName)
                            } -MockWith {
                                Write-Verbose -Message ('VERBOSE OUTPUT FROM MOCK: {0}' -f $Message) -Verbose
                            }

                            $getTargetResourceParameters = $mockDefaultParameters.Clone()
                        }

                        It 'Should return the same values as passed as parameters' {
                            $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters
                            $getTargetResourceResult.DomainName | Should -Be $mockDomainName
                            $getTargetResourceResult.Credential | Should -BeNullOrEmpty

                            Assert-MockCalled -CommandName Write-Verbose -Exactly -Times 1 -Scope It
                        }
                    }
                }
            }
        }
        #endregion


        #region Function Test-TargetResource
        Describe 'WaitForADDomain\Test-TargetResource' -tag 'Test' {
            Context 'When the system is in the desired state' {
                Context 'When a domain controller is found' {
                    BeforeAll {
                        Mock -CommandName Compare-TargetResourceState -MockWith {
                            return @(
                                @{
                                    ParameterName  = 'IsAvailable'
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

                Context 'When a domain controller is found, and RestartCount was used' {
                    BeforeAll {
                        Mock -CommandName Compare-TargetResourceState -MockWith {
                            return @(
                                @{
                                    ParameterName  = 'IsAvailable'
                                    InDesiredState = $true
                                }
                            )
                        }

                        Mock -CommandName Remove-Item
                        Mock -CommandName Test-Path -MockWith {
                            return $true
                        }

                        $testTargetResourceParameters = $mockDefaultParameters.Clone()
                        $testTargetResourceParameters['RestartCount'] = 2
                    }

                    It 'Should return $true' {
                        $testTargetResourceResult = Test-TargetResource @testTargetResourceParameters
                        $testTargetResourceResult | Should -BeTrue

                        Assert-MockCalled -CommandName Compare-TargetResourceState -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Test-Path -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Remove-Item -Exactly -Times 1 -Scope It
                    }
                }
            }

            Context 'When the system is not in the desired state' {
                Context 'When a domain controller cannot be reached' {
                    BeforeAll {
                        Mock -CommandName Compare-TargetResourceState -MockWith {
                            return @(
                                @{
                                    ParameterName  = 'IsAvailable'
                                    InDesiredState = $false
                                }
                            )
                        }
                    }

                    It 'Should return $false' {
                        $testTargetResourceResult = Test-TargetResource @mockDefaultParameters
                        $testTargetResourceResult | Should -BeFalse

                        Assert-MockCalled -CommandName Compare-TargetResourceState -Exactly -Times 1 -Scope It
                    }
                }
            }
        }
        #endregion

        Describe 'MSFT_ADDomainTrust\Compare-TargetResourceState' -Tag 'Compare' {
            BeforeAll {
                $mockGetTargetResource_Absent = {
                    return @{
                        DomainName   = $mockDomainName
                        SiteName     = $null
                        Credential   = $null
                        WaitTimeout  = 300
                        RestartCount = 0
                        IsAvailable  = $false
                    }
                }

                $mockGetTargetResource_Present = {
                    return @{
                        DomainName   = $mockDomainName
                        SiteName     = $mockSiteName
                        Credential   = $null
                        WaitTimeout  = 300
                        RestartCount = 0
                        IsAvailable  = $true
                    }
                }
            }

            Context 'When the system is in the desired state' {
                Context 'When a domain controller is found' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith $mockGetTargetResource_Present

                        $testTargetResourceParameters = $mockDefaultParameters.Clone()
                        $testTargetResourceParameters['DomainName'] = $mockDomainName
                    }

                    It 'Should return the correct values' {
                        $compareTargetResourceStateResult = Compare-TargetResourceState @testTargetResourceParameters
                        $compareTargetResourceStateResult | Should -HaveCount 1

                        $comparedReturnValue = $compareTargetResourceStateResult.Where( { $_.ParameterName -eq 'IsAvailable' })
                        $comparedReturnValue | Should -Not -BeNullOrEmpty
                        $comparedReturnValue.Expected | Should -BeTrue
                        $comparedReturnValue.Actual | Should -BeTrue
                        $comparedReturnValue.InDesiredState | Should -BeTrue

                        Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                    }
                }

            }

            Context 'When the system is not in the desired state' {
                BeforeAll {
                    Mock -CommandName Get-TargetResource -MockWith $mockGetTargetResource_Absent

                    $testTargetResourceParameters = $mockDefaultParameters.Clone()
                    $testTargetResourceParameters['DomainName'] = $mockDomainName
                }

                It 'Should return the correct values' {
                    $compareTargetResourceStateResult = Compare-TargetResourceState @testTargetResourceParameters
                    $compareTargetResourceStateResult | Should -HaveCount 1

                    $comparedReturnValue = $compareTargetResourceStateResult.Where( { $_.ParameterName -eq 'IsAvailable' })
                    $comparedReturnValue | Should -Not -BeNullOrEmpty
                    $comparedReturnValue.Expected | Should -BeTrue
                    $comparedReturnValue.Actual | Should -BeFalse
                    $comparedReturnValue.InDesiredState | Should -BeFalse

                    Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                }
            }
        }

        #region Function Set-TargetResource
        Describe 'WaitForADDomain\Set-TargetResource' -Tag 'Set' {
            BeforeEach {
                $global:DSCMachineStatus = 0
            }

            Context 'When the system is in the desired state' {
                BeforeAll {
                    Mock -CommandName Remove-RestartLogFile
                    Mock -CommandName Receive-Job
                    Mock -CommandName Start-Job
                    Mock -CommandName Wait-Job
                    Mock -CommandName Remove-Job

                    Mock -CommandName Compare-TargetResourceState -MockWith {
                        return @(
                            @{
                                ParameterName  = 'IsAvailable'
                                InDesiredState = $true
                            }
                        )
                    }
                }

                Context 'When a domain controller is found' {
                    It 'Should not throw and call the correct mocks' {
                        { Set-TargetResource @mockDefaultParameters } | Should -Not -Throw

                        $global:DSCMachineStatus | Should -Be 0

                        Assert-MockCalled -CommandName Compare-TargetResourceState -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Receive-Job -Exactly -Times 0 -Scope It
                        Assert-MockCalled -CommandName Start-Job -Exactly -Times 0 -Scope It
                        Assert-MockCalled -CommandName Wait-Job -Exactly -Times 0 -Scope It
                        Assert-MockCalled -CommandName Remove-Job -Exactly -Times 0 -Scope It
                        Assert-MockCalled -CommandName Remove-RestartLogFile -Exactly -Times 0 -Scope It
                    }
                }
            }

            Context 'When the system is not in the desired state' {
                BeforeAll {
                    Mock -CommandName Remove-RestartLogFile
                    Mock -CommandName Receive-Job

                    <#
                        The code being tested is using parameter Job, so here
                        that parameter must be avoided so that we don't mock
                        in an endless loop.
                    #>
                    Mock -CommandName Start-Job -ParameterFilter {
                        $PSBoundParameters.ContainsKey('ArgumentList')
                    } -MockWith {
                        <#
                            Need to mock an object by actually creating a job
                            that completes successfully.
                        #>
                        $mockJobObject = Start-Job -ScriptBlock {
                            Start-Sleep -Milliseconds 1
                        }

                        Remove-Job -Id $mockJobObject.Id -Force

                        return $mockJobObject
                    }

                    <#
                        The code being tested is using parameter Job, so here
                        that parameter must be avoided so that we don't mock
                        in an endless loop.
                    #>
                    Mock -CommandName Remove-Job -ParameterFilter {
                        $null -ne $Job
                    }

                    Mock -CommandName Compare-TargetResourceState -MockWith {
                        return @(
                            @{
                                ParameterName  = 'IsAvailable'
                                InDesiredState = $false
                            }
                        )
                    }
                }

                Context 'When a domain controller is reached before the timeout period' {
                    BeforeAll {
                        <#
                            The code being tested is using parameter Job, so here
                            that parameter must be avoided so that we don't mock
                            in an endless loop.
                        #>
                        Mock -CommandName Wait-Job -ParameterFilter {
                            $null -ne $Job
                        } -MockWith {
                            <#
                                Need to mock an object by actually creating a job
                                that completes successfully.
                            #>
                            $mockJobObject = Start-Job -ScriptBlock {
                                Start-Sleep -Milliseconds 1
                            }

                            <#
                                The variable name must not be the same as the one
                                used in the call to Wait-Job.
                            #>
                            $mockWaitJobObject = Wait-Job -Id $mockJobObject.Id

                            Remove-Job -Id $mockJobObject.Id -Force

                            return $mockJobObject
                        }
                    }

                    BeforeEach {
                        $setTargetResourceParameters = $mockDefaultParameters.Clone()
                    }

                    Context 'When only specifying the default parameter' {
                        It 'Should not throw and call the correct mocks' {
                            { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw

                            $global:DSCMachineStatus | Should -Be 0

                            Assert-MockCalled -CommandName Compare-TargetResourceState -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName Receive-Job -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName Wait-Job -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName Remove-Job -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName Remove-RestartLogFile -Exactly -Times 0 -Scope It

                            Assert-MockCalled -CommandName Start-Job -ParameterFilter {
                                $PSBoundParameters.ContainsKey('ArgumentList') `
                                -and $ArgumentList[0] -eq $false `
                                -and $ArgumentList[1] -eq $setTargetResourceParameters.DomainName `
                                -and [System.String]::IsNullOrEmpty($ArgumentList[2]) `
                                -and [System.String]::IsNullOrEmpty($ArgumentList[3]) `
                                -and $ArgumentList[4] -eq $false
                            } -Exactly -Times 1 -Scope It
                        }
                    }

                    Context 'When specifying a site name' {
                        BeforeEach {
                            $setTargetResourceParameters['SiteName'] = $mockSiteName
                        }

                        It 'Should not throw and call the correct mocks' {
                            { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw

                            $global:DSCMachineStatus | Should -Be 0

                            Assert-MockCalled -CommandName Compare-TargetResourceState -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName Receive-Job -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName Wait-Job -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName Remove-Job -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName Remove-RestartLogFile -Exactly -Times 0 -Scope It

                            Assert-MockCalled -CommandName Start-Job -ParameterFilter {
                                $PSBoundParameters.ContainsKey('ArgumentList') `
                                -and $ArgumentList[0] -eq $false `
                                -and $ArgumentList[1] -eq $setTargetResourceParameters.DomainName `
                                -and $ArgumentList[2] -eq $setTargetResourceParameters.SiteName `
                                -and [System.String]::IsNullOrEmpty($ArgumentList[3]) `
                                -and $ArgumentList[4] -eq $false
                            } -Exactly -Times 1 -Scope It
                        }
                    }

                    Context 'When specifying credentials' {
                        BeforeEach {
                            $setTargetResourceParameters['Credential'] = $mockDomainUserCredential
                        }

                        It 'Should not throw and call the correct mocks' {
                            { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw

                            $global:DSCMachineStatus | Should -Be 0

                            Assert-MockCalled -CommandName Compare-TargetResourceState -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName Receive-Job -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName Wait-Job -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName Remove-Job -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName Remove-RestartLogFile -Exactly -Times 0 -Scope It

                            Assert-MockCalled -CommandName Start-Job -ParameterFilter {
                                $PSBoundParameters.ContainsKey('ArgumentList') `
                                -and $ArgumentList[0] -eq $false `
                                -and $ArgumentList[1] -eq $setTargetResourceParameters.DomainName `
                                -and [System.String]::IsNullOrEmpty($ArgumentList[2]) `
                                -and $ArgumentList[3].UserName -eq $setTargetResourceParameters.Credential.UserName `
                                -and $ArgumentList[4] -eq $false
                            } -Exactly -Times 1 -Scope It
                        }
                    }

                    Context 'When specifying that credentials errors should be ignored' {
                        BeforeEach {
                            $setTargetResourceParameters['WaitForValidCredentials'] = $true
                        }

                        It 'Should not throw and call the correct mocks' {
                            { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw

                            $global:DSCMachineStatus | Should -Be 0

                            Assert-MockCalled -CommandName Compare-TargetResourceState -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName Receive-Job -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName Wait-Job -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName Remove-Job -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName Remove-RestartLogFile -Exactly -Times 0 -Scope It

                            Assert-MockCalled -CommandName Start-Job -ParameterFilter {
                                $PSBoundParameters.ContainsKey('ArgumentList') `
                                -and $ArgumentList[0] -eq $false `
                                -and $ArgumentList[1] -eq $setTargetResourceParameters.DomainName `
                                -and [System.String]::IsNullOrEmpty($ArgumentList[2]) `
                                -and [System.String]::IsNullOrEmpty($ArgumentList[2]) `
                                -and $ArgumentList[4] -eq $true
                            } -Exactly -Times 1 -Scope It
                        }
                    }

                    Context 'When a restart was requested' {
                        BeforeAll {
                            $setTagetResourceParameters = $mockDefaultParameters.Clone()
                            $setTagetResourceParameters['RestartCount'] = 1
                        }

                        It 'Should not throw and call the correct mocks' {
                            { Set-TargetResource @setTagetResourceParameters  } | Should -Not -Throw

                            $global:DSCMachineStatus | Should -Be 0

                            Assert-MockCalled -CommandName Remove-RestartLogFile -Exactly -Times 1 -Scope It
                        }
                    }
                }

                Context 'When the script that searches for a domain controller fails' {
                    BeforeAll {
                        <#
                            The code being tested is using parameter Job, so here
                            that parameter must be avoided so that we don't mock
                            in an endless loop.
                        #>
                        Mock -CommandName Wait-Job -ParameterFilter {
                            $null -ne $Job
                        } -MockWith {
                            <#
                                Need to mock an object by actually creating a job
                                that completes successfully.
                            #>
                            $mockJobObject = Start-Job -ScriptBlock {
                                throw 'Mocked error in mocked script'
                            }

                            <#
                                The variable name must not be the same as the one
                                used in the call to Wait-Job.
                            #>
                            $mockWaitJobObject = Wait-Job -Id $mockJobObject.Id

                            Remove-Job -Id $mockJobObject.Id -Force

                            return $mockJobObject
                        }

                        $setTagetResourceParameters = $mockDefaultParameters.Clone()

                        <#
                            To test that the background job output is written when
                            the job fails even if `Verbose` is not set.
                        #>
                        $setTagetResourceParameters.Remove('Verbose')
                    }

                    It 'Should not throw and call the correct mocks' {
                        { Set-TargetResource @setTagetResourceParameters } | Should -Throw $script:localizedData.NoDomainController

                        $global:DSCMachineStatus | Should -Be 0

                        Assert-MockCalled -CommandName Compare-TargetResourceState -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Receive-Job -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Start-Job -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Wait-Job -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Remove-Job -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Remove-RestartLogFile -Exactly -Times 0 -Scope It
                    }
                }

                Context 'When a domain controller cannot be reached before the timeout period' {
                    BeforeAll {
                        <#
                            The code being tested is using parameter Job, so here
                            that parameter must be avoided so that we don't mock
                            in an endless loop.
                        #>
                        Mock -CommandName Wait-Job -ParameterFilter {
                            $null -ne $Job
                        } -MockWith {
                            return $null
                        }
                    }

                    It 'Should throw the correct error message and call the correct mocks' {
                        { Set-TargetResource @mockDefaultParameters } | Should -Throw $script:localizedData.NoDomainController

                        $global:DSCMachineStatus | Should -Be 0

                        Assert-MockCalled -CommandName Compare-TargetResourceState -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Receive-Job -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Start-Job -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Wait-Job -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Remove-Job -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Remove-RestartLogFile -Exactly -Times 0 -Scope It
                    }

                    Context 'When a restart is requested when a domain controller cannot be found' {
                        BeforeAll {
                            Mock -CommandName Get-Content
                            Mock -CommandName Set-Content

                            <#
                                The code being tested is using parameter Job, so here
                                that parameter must be avoided so that we don't mock
                                in an endless loop.
                            #>
                            Mock -CommandName Wait-Job -ParameterFilter {
                                $null -ne $Job
                            } -MockWith {
                                return $null
                            }

                            $setTagetResourceParameters = $mockDefaultParameters.Clone()
                            $setTagetResourceParameters['RestartCount'] = 1
                        }

                        It 'Should throw the correct error message and call the correct mocks' {
                            { Set-TargetResource @setTagetResourceParameters  } | Should -Throw $script:localizedData.NoDomainController

                            $global:DSCMachineStatus | Should -Be 1

                            Assert-MockCalled -CommandName Compare-TargetResourceState -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName Receive-Job -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName Start-Job -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName Wait-Job -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName Remove-Job -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName Get-Content -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName Set-Content -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName Remove-RestartLogFile -Exactly -Times 0 -Scope It
                        }
                    }
                }
            }
        }
        #endregion

        Describe 'MSFT_ADDomainTrust\WaitForDomainControllerScriptBlock' -Tag 'Helper' {
            BeforeAll {
                Mock -CommandName Clear-DnsClientCache
                Mock -CommandName Start-Sleep
            }

            Context 'When a domain controller cannot be found' {
                BeforeAll {
                    Mock -CommandName Find-DomainController
                }

                It 'Should not throw and call the correct mocks' {
                    Invoke-Command -ScriptBlock $script:waitForDomainControllerScriptBlock -ArgumentList @(
                        $true # RunOnce
                        'contoso.com' # DomainName
                        'Europe' # SiteName
                        $mockDomainUserCredential # Credential
                    )

                    Assert-MockCalled -CommandName Find-DomainController -ParameterFilter {
                        -not $PSBoundParameters.ContainsKey('WaitForValidCredentials')
                    } -Exactly -Times 1 -Scope It

                    Assert-MockCalled -CommandName Clear-DnsClientCache -Exactly -Times 1 -Scope It
                    Assert-MockCalled -CommandName Start-Sleep -Exactly -Times 1 -Scope It
                }
            }

            Context 'When the Find-DomainController should ignore authentication exceptions' {
                BeforeAll {
                    Mock -CommandName Find-DomainController
                }

                Context 'When the parameter WaitForValidCredentials is set to $true' {
                    It 'Should output a warning message' {
                        Invoke-Command -ScriptBlock $script:waitForDomainControllerScriptBlock -ArgumentList @(
                                $true # RunOnce
                                'contoso.com' # DomainName
                                'Europe' # SiteName
                                $mockDomainUserCredential # Credential
                                $true
                            )

                        Assert-MockCalled -CommandName Find-DomainController -ParameterFilter {
                            $PSBoundParameters.ContainsKey('WaitForValidCredentials')
                        } -Exactly -Times 1 -Scope It
                    }
                }
            }

            Context 'When a domain controller is found' {
                BeforeAll {
                    Mock -CommandName Find-DomainController -MockWith {
                        return New-Object -TypeName 'PSObject'
                    }
                }

                It 'Should not throw and call the correct mocks' {
                    Invoke-Command -ScriptBlock $script:waitForDomainControllerScriptBlock -ArgumentList @(
                        $true # RunOnce
                        'contoso.com' # DomainName
                        'Europe' # SiteName
                        $null # Credential
                    )

                    Assert-MockCalled -CommandName Find-DomainController -Exactly -Times 1 -Scope It
                    Assert-MockCalled -CommandName Clear-DnsClientCache -Exactly -Times 0 -Scope It
                    Assert-MockCalled -CommandName Start-Sleep -Exactly -Times 0 -Scope It
                }
            }
        }
    }
    #endregion
}
finally
{
    Invoke-TestCleanup
}
