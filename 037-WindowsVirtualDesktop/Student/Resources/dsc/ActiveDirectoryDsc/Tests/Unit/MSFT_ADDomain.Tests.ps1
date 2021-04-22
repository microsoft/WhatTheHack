Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath '..\TestHelpers\ActiveDirectoryDsc.TestHelper.psm1')

if (-not (Test-RunForCITestCategory -Type 'Unit' -Category 'Tests'))
{
    return
}

$script:dscModuleName = 'ActiveDirectoryDsc'
$script:dscResourceName = 'MSFT_ADDomain'

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
        Import-Module (Join-Path -Path $PSScriptRoot -ChildPath 'Stubs\ADDSDeployment_2019.psm1') -Force

        $mockDomainName = 'contoso.com'
        $mockNetBiosName = 'CONTOSO'
        $mockDnsRoot = $mockDomainName
        $forestMode = [Microsoft.DirectoryServices.Deployment.Types.ForestMode]::Win2012R2
        $mgmtForestMode = [Microsoft.ActiveDirectory.Management.ADForestMode]::Windows2012R2Forest
        $domainMode = [Microsoft.DirectoryServices.Deployment.Types.DomainMode]::Win2012R2
        $mgmtDomainMode = [Microsoft.ActiveDirectory.Management.ADDomainMode]::Windows2012R2Domain

        $mockAdministratorCredential = New-Object -TypeName 'System.Management.Automation.PSCredential' -ArgumentList @(
            'DummyUser',
            (ConvertTo-SecureString -String 'DummyPassword' -AsPlainText -Force)
        )

        $mockDefaultParameters = @{
            DomainName = $mockDomainName
            Credential = $mockAdministratorCredential
            SafeModeAdministratorPassword = $mockAdministratorCredential
            Verbose = $true
        }

        #region Function Get-TargetResource
        Describe 'ADDomain\Get-TargetResource' {
            BeforeEach {
                Mock -CommandName Assert-Module
            }

            Context 'When there is an authentication error' {
                BeforeAll {
                    Mock -CommandName Get-ADDomain -MockWith {
                        throw New-Object -TypeName 'System.Security.Authentication.AuthenticationException'
                    }

                    Mock -CommandName Test-Path -MockWith {
                        return $false
                    }

                    Mock -CommandName Test-DomainMember -MockWith {
                        return $false
                    }

                    $getTargetResourceParameters = $mockDefaultParameters.Clone()
                }

                It 'Should throw the correct error' {
                    { Get-TargetResource @getTargetResourceParameters } | Should -Throw ($script:localizedData.InvalidCredentialError -f $mockDomainName)
                }
            }

            Context 'When an exception other than the known is thrown' {
                BeforeAll {
                    Mock -CommandName Get-ADDomain -MockWith {
                        throw New-Object -TypeName 'System.Management.Automation.RunTimeException' -ArgumentList @('mocked error')
                    }

                    Mock -CommandName Test-Path -MockWith {
                        return $false
                    }

                    Mock -CommandName Test-DomainMember -MockWith {
                        return $true
                    }

                    $getTargetResourceParameters = $mockDefaultParameters.Clone()
                }

                It 'Should throw the correct error' {
                    { Get-TargetResource @getTargetResourceParameters } | Should -Throw 'mocked error'
                }
            }

            Context 'When the node is already a domain member and cannot be provisioned as a domain controller for another domain' {
                BeforeAll {
                    Mock -CommandName Get-ADDomain -MockWith {
                        throw New-Object -TypeName 'Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException'
                    }

                    Mock -CommandName Test-Path -MockWith {
                        return $false
                    }

                    Mock -CommandName Test-DomainMember -MockWith {
                        return $true
                    }

                    $getTargetResourceParameters = $mockDefaultParameters.Clone()
                }

                It 'Should throw the correct error' {
                    { Get-TargetResource @getTargetResourceParameters } | Should -Throw ($script:localizedData.ExistingDomainMemberError -f $mockDomainName)
                }
            }

            Context 'When the system is in the desired state' {
                BeforeAll {
                    Mock -CommandName Get-ADDomain -MockWith {
                        [PSObject] @{
                            Forest     = $mockDomainName
                            DomainMode = $mgmtDomainMode
                            ParentDomain = $mockDomainName
                            NetBIOSName = $mockNetBiosName
                            DnsRoot = $mockDnsRoot
                        }
                    }

                    Mock -CommandName Get-ADForest -MockWith {
                        [PSObject] @{
                            Name = $mockDomainName
                            ForestMode = $mgmtForestMode
                        }
                    }
                }

                Context 'When the domain exists' {
                    Context 'When the node is a domain member' {
                        BeforeAll {
                            Mock -CommandName Test-Path -MockWith {
                                return $true
                            }

                            Mock -CommandName Test-DomainMember -MockWith {
                                return $true
                            }

                            $getTargetResourceParameters = $mockDefaultParameters.Clone()
                        }

                        It 'Should call the correct mocks' {
                            $null = Get-TargetResource @getTargetResourceParameters

                            Assert-MockCalled -CommandName Test-DomainMember -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName Get-ADDomain -ParameterFilter {
                                -not $PSBoundParameters.ContainsKey('Credential')
                            } -Exactly -Times 1 -Scope It

                            Assert-MockCalled -CommandName Get-ADForest -ParameterFilter {
                                -not $PSBoundParameters.ContainsKey('Credential')
                            } -Exactly -Times 1 -Scope It
                        }

                        It 'Should return the same values as passed as parameters' {
                            $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters
                            $getTargetResourceResult.DomainName | Should -Be $getTargetResourceParameters.DomainName
                            $getTargetResourceResult.Credential.UserName | Should -Be $getTargetResourceParameters.Credential.UserName
                            $getTargetResourceResult.SafeModeAdministratorPassword.UserName | Should -Be $getTargetResourceParameters.SafeModeAdministratorPassword.UserName
                        }

                        It 'Should return correct values for the rest of the properties' {
                            $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters
                            $getTargetResourceResult.DnsRoot | Should -Be $mockDomainName
                            $getTargetResourceResult.ParentDomainName | Should -Be $mockDomainName
                            $getTargetResourceResult.DomainNetBiosName | Should -Be $mockNetBiosName
                            $getTargetResourceResult.DnsDelegationCredential | Should -BeNullOrEmpty
                            $getTargetResourceResult.DatabasePath | Should -BeNullOrEmpty
                            $getTargetResourceResult.LogPath | Should -BeNullOrEmpty
                            $getTargetResourceResult.SysvolPath | Should -BeNullOrEmpty
                            $getTargetResourceResult.ForestMode | Should -Be 'Win2012R2'
                            $getTargetResourceResult.DomainMode | Should -Be 'Win2012R2'
                            $getTargetResourceResult.DomainExist | Should -BeTrue
                        }
                    }

                    Context 'When no tracking file was found' {
                        BeforeAll {
                            Mock -CommandName Write-Warning
                            Mock -CommandName Test-Path -MockWith {
                                return $false
                            }

                            Mock -CommandName Test-DomainMember -MockWith {
                                return $true
                            }

                            $getTargetResourceParameters = $mockDefaultParameters.Clone()
                        }

                        It 'Should call the correct mocks' {
                            $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters

                            Assert-MockCalled -CommandName Write-Warning -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName Test-DomainMember -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName Get-ADDomain -ParameterFilter {
                                -not $PSBoundParameters.ContainsKey('Credential')
                            } -Exactly -Times 1 -Scope It

                            Assert-MockCalled -CommandName Get-ADForest -ParameterFilter {
                                -not $PSBoundParameters.ContainsKey('Credential')
                            } -Exactly -Times 1 -Scope It
                        }
                    }

                    Context 'When the node is not a domain member' {
                        BeforeAll {
                            Mock -CommandName Test-Path -MockWith {
                                return $true
                            }

                            Mock -CommandName Test-DomainMember -MockWith {
                                return $false
                            }

                            $getTargetResourceParameters = $mockDefaultParameters.Clone()
                        }

                        It 'Should call the correct mocks' {
                            $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters

                            Assert-MockCalled -CommandName Test-DomainMember -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName Get-ADDomain -ParameterFilter {
                                $PSBoundParameters.ContainsKey('Credential')
                            } -Exactly -Times 1 -Scope It

                            Assert-MockCalled -CommandName Get-ADForest -ParameterFilter {
                                $PSBoundParameters.ContainsKey('Credential')
                            } -Exactly -Times 1 -Scope It
                        }

                        It 'Should return the same values as passed as parameters' {
                            $result = Get-TargetResource @getTargetResourceParameters
                            $result.DomainName | Should -Be $getTargetResourceParameters.DomainName
                            $result.Credential.UserName | Should -Be $getTargetResourceParameters.Credential.UserName
                            $result.SafeModeAdministratorPassword.UserName | Should -Be $getTargetResourceParameters.SafeModeAdministratorPassword.UserName
                        }

                        It 'Should return correct values for the rest of the properties' {
                            $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters
                            $getTargetResourceResult.DnsRoot | Should -Be $mockDomainName
                            $getTargetResourceResult.ParentDomainName | Should -Be $mockDomainName
                            $getTargetResourceResult.DomainNetBiosName | Should -Be $mockNetBiosName
                            $getTargetResourceResult.DnsDelegationCredential | Should -BeNullOrEmpty
                            $getTargetResourceResult.DatabasePath | Should -BeNullOrEmpty
                            $getTargetResourceResult.LogPath | Should -BeNullOrEmpty
                            $getTargetResourceResult.SysvolPath | Should -BeNullOrEmpty
                            $getTargetResourceResult.ForestMode | Should -Be 'Win2012R2'
                            $getTargetResourceResult.DomainMode | Should -Be 'Win2012R2'
                            $getTargetResourceResult.DomainExist | Should -BeTrue
                        }
                    }
                }
            }

            Context 'When the system is not in the desired state' {
                BeforeAll {
                    Mock -CommandName Get-ADForest
                    Mock -CommandName Get-ADDomain -MockWith {
                        throw New-Object -TypeName 'Microsoft.ActiveDirectory.Management.ADServerDownException'
                    }
                }

                Context 'When the domain does not exist' {
                    BeforeAll {
                        Mock -CommandName Test-Path -MockWith {
                            return $false
                        }

                        Mock -CommandName Test-DomainMember -MockWith {
                            return $false
                        }

                        $getTargetResourceParameters = $mockDefaultParameters.Clone()
                    }

                    It 'Should call the correct mocks' {
                        $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters

                        Assert-MockCalled -CommandName Test-DomainMember -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Get-ADForest -Exactly -Times 0 -Scope It
                        Assert-MockCalled -CommandName Get-ADDomain -ParameterFilter {
                            $PSBoundParameters.ContainsKey('Credential')
                        } -Exactly -Times 1 -Scope It
                    }

                    It 'Should return the same values as passed as parameters' {
                        $result = Get-TargetResource @getTargetResourceParameters
                        $result.DomainName | Should -Be $getTargetResourceParameters.DomainName
                        $result.Credential.UserName | Should -Be $getTargetResourceParameters.Credential.UserName
                        $result.SafeModeAdministratorPassword.UserName | Should -Be $getTargetResourceParameters.SafeModeAdministratorPassword.UserName
                    }

                    It 'Should return $false for the property DomainExist' {
                        $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters
                        $getTargetResourceResult.DomainExist | Should -BeFalse
                    }

                    It 'Should return $null for the rest of the properties' {
                        $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters
                        $getTargetResourceResult.DnsRoot | Should -BeNullOrEmpty
                        $getTargetResourceResult.ParentDomainName | Should -BeNullOrEmpty
                        $getTargetResourceResult.DomainNetBiosName | Should -BeNullOrEmpty
                        $getTargetResourceResult.DnsDelegationCredential | Should -BeNullOrEmpty
                        $getTargetResourceResult.DatabasePath | Should -BeNullOrEmpty
                        $getTargetResourceResult.LogPath | Should -BeNullOrEmpty
                        $getTargetResourceResult.SysvolPath | Should -BeNullOrEmpty
                        $getTargetResourceResult.ForestMode | Should -BeNullOrEmpty
                        $getTargetResourceResult.DomainMode | Should -BeNullOrEmpty
                    }
                }

                Context 'When the domain cannot be found, but should exist (tracking file exist)' {
                    BeforeAll {
                        Mock -CommandName Start-Sleep
                        Mock -CommandName Test-Path -MockWith {
                            return $true
                        }

                        Mock -CommandName Test-DomainMember -MockWith {
                            return $true
                        }

                        $getTargetResourceParameters = $mockDefaultParameters.Clone()
                    }

                    It 'Should call the correct mocks the correct number of times' {
                        $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters

                        Assert-MockCalled -CommandName Test-DomainMember -Exactly -Times 5 -Scope It
                        Assert-MockCalled -CommandName Get-ADForest -Exactly -Times 0 -Scope It
                        Assert-MockCalled -CommandName Start-Sleep -Exactly -Times 5 -Scope It
                        Assert-MockCalled -CommandName Get-ADDomain -Exactly -Times 5 -Scope It
                    }

                    It 'Should return the same values as passed as parameters' {
                        $result = Get-TargetResource @getTargetResourceParameters
                        $result.DomainName | Should -Be $getTargetResourceParameters.DomainName
                        $result.Credential.UserName | Should -Be $getTargetResourceParameters.Credential.UserName
                        $result.SafeModeAdministratorPassword.UserName | Should -Be $getTargetResourceParameters.SafeModeAdministratorPassword.UserName
                    }

                    It 'Should return $false for the property DomainExist' {
                        $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters
                        $getTargetResourceResult.DomainExist | Should -BeFalse
                    }

                    It 'Should return $null for the rest of the properties' {
                        $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters
                        $getTargetResourceResult.DnsRoot | Should -BeNullOrEmpty
                        $getTargetResourceResult.ParentDomainName | Should -BeNullOrEmpty
                        $getTargetResourceResult.DomainNetBiosName | Should -BeNullOrEmpty
                        $getTargetResourceResult.DnsDelegationCredential | Should -BeNullOrEmpty
                        $getTargetResourceResult.DatabasePath | Should -BeNullOrEmpty
                        $getTargetResourceResult.LogPath | Should -BeNullOrEmpty
                        $getTargetResourceResult.SysvolPath | Should -BeNullOrEmpty
                        $getTargetResourceResult.ForestMode | Should -BeNullOrEmpty
                        $getTargetResourceResult.DomainMode | Should -BeNullOrEmpty
                    }
                }
            }
        }
        #endregion

        #region Function Test-TargetResource
        Describe 'ADDomain\Test-TargetResource' {
            $mockDomainName = 'present.com'
            $correctChildDomainName = 'present'
            $correctDomainNetBIOSName = 'PRESENT'
            $incorrectDomainName = 'incorrect.com'
            $parentDomainName = 'parent.com'
            $mockAdministratorCredential = New-Object -TypeName 'System.Management.Automation.PSCredential' -ArgumentList @(
                'DummyUser',
                (ConvertTo-SecureString -String 'DummyPassword' -AsPlainText -Force)
            )

            $mockDefaultParameters = @{
                Credential = $mockAdministratorCredential
                SafeModeAdministratorPassword = $mockAdministratorCredential
            }

            $stubDomain = @{
                DnsRoot = $mockDomainName
                DomainNetBIOSName = $correctDomainNetBIOSName
            }

            # Get-TargetResource returns the domain FQDN for .DomainName
            $stubChildDomain = @{
                DnsRoot = "$correctChildDomainName.$parentDomainName"
                ParentDomainName = $parentDomainName
                DomainNetBIOSName = $correctDomainNetBIOSName
            }

            It 'Returns "True" when "DomainName" matches' {
                Mock -CommandName Get-TargetResource -MockWith { return $stubDomain }

                $result = Test-TargetResource @mockDefaultParameters -DomainName $mockDomainName

                $result | Should -BeTrue
            }

            It 'Returns "False" when "DomainName" does not match' {
                Mock -CommandName Get-TargetResource -MockWith { return $stubDomain }

                $result = Test-TargetResource @mockDefaultParameters -DomainName $incorrectDomainName

                $result | Should -BeFalse
            }

            It 'Returns "True" when "DomainNetBIOSName" matches' {
                Mock -CommandName Get-TargetResource -MockWith { return $stubDomain }

                $result = Test-TargetResource @mockDefaultParameters -DomainName $mockDomainName -DomainNetBIOSName $correctDomainNetBIOSName

                $result | Should -BeTrue
            }

            It 'Returns "False" when "DomainNetBIOSName" does not match' {
                Mock -CommandName Get-TargetResource -MockWith { return $stubDomain }

                $result = Test-TargetResource @mockDefaultParameters -DomainName $mockDomainName -DomainNetBIOSName 'INCORRECT'

                $result | Should -BeFalse
            }

            It 'Returns "True" when "ParentDomainName" matches' {
                Mock -CommandName Get-TargetResource -MockWith { return $stubChildDomain }

                $result = Test-TargetResource @mockDefaultParameters -DomainName $correctChildDomainName -ParentDomainName $parentDomainName

                $result | Should -BeTrue
            }

            It 'Returns "False" when "ParentDomainName" does not match' {
                Mock -CommandName Get-TargetResource -MockWith { return $stubChildDomain }

                $result = Test-TargetResource @mockDefaultParameters -DomainName $correctChildDomainName -ParentDomainName 'incorrect.com'

                $result | Should -BeFalse
            }

        }
        #endregion

        #region Function Set-TargetResource
        Describe 'ADDomain\Set-TargetResource' {
            $testDomainName = 'present.com'
            $testParentDomainName = 'parent.com'
            $testDomainNetBIOSNameName = 'PRESENT'
            $testDomainForestMode = 'WinThreshold'

            $mockAdministratorCredential = New-Object -TypeName 'System.Management.Automation.PSCredential' -ArgumentList @(
                'Admin',
                (ConvertTo-SecureString -String 'DummyPassword' -AsPlainText -Force)
            )

            $testSafemodePassword = (ConvertTo-SecureString -String 'DummyPassword' -AsPlainText -Force)
            $testSafemodeCredential = New-Object -TypeName 'System.Management.Automation.PSCredential' -ArgumentList @(
                'Safemode',
                $testSafemodePassword
            )

            $testDelegationCredential = New-Object -TypeName 'System.Management.Automation.PSCredential' -ArgumentList @(
                'Delegation',
                (ConvertTo-SecureString -String 'DummyPassword' -AsPlainText -Force)
            )

            $newForestParams = @{
                DomainName = $testDomainName
                Credential = $mockAdministratorCredential
                SafeModeAdministratorPassword = $testSafemodeCredential
            }

            $newDomainParams = @{
                DomainName = $testDomainName
                ParentDomainName = $testParentDomainName
                Credential = $mockAdministratorCredential
                SafeModeAdministratorPassword = $testSafemodeCredential
            }

            $stubTargetResource = @{
                DomainName = $testDomainName
                ParentDomainName = $testParentDomainName
                DomainNetBIOSName = $testDomainNetBIOSNameName
                ForestName = $testParentDomainName
                ForestMode = $testDomainForestMode
                DomainMode = $testDomainForestMode
                DomainExist = $false
            }

            Mock -CommandName Get-TargetResource -MockWith { return $stubTargetResource }
            Mock -CommandName Out-File

            It 'Calls "Install-ADDSForest" with "DomainName" when creating forest' {
                Mock -CommandName Install-ADDSForest -ParameterFilter { $DomainName -eq $testDomainName }

                Set-TargetResource @newForestParams

                Assert-MockCalled -CommandName Install-ADDSForest -ParameterFilter  { $DomainName -eq $testDomainName } -Scope It
            }

            It 'Calls "Install-ADDSForest" with "SafeModeAdministratorPassword" when creating forest' {
                Mock -CommandName Install-ADDSForest -ParameterFilter { $SafeModeAdministratorPassword -eq $testSafemodePassword }

                Set-TargetResource @newForestParams

                Assert-MockCalled -CommandName Install-ADDSForest -ParameterFilter { $SafeModeAdministratorPassword -eq $testSafemodePassword } -Scope It
            }

            It 'Calls "Install-ADDSForest" with "DnsDelegationCredential" when creating forest, if specified' {
                Mock -CommandName Install-ADDSForest -ParameterFilter { $DnsDelegationCredential -eq $testDelegationCredential }

                Set-TargetResource @newForestParams -DnsDelegationCredential $testDelegationCredential

                Assert-MockCalled -CommandName Install-ADDSForest -ParameterFilter  { $DnsDelegationCredential -eq $testDelegationCredential } -Scope It
            }

            It 'Calls "Install-ADDSForest" with "CreateDnsDelegation" when creating forest, if specified' {
                Mock -CommandName Install-ADDSForest -ParameterFilter { $CreateDnsDelegation -eq $true }

                Set-TargetResource @newForestParams -DnsDelegationCredential $testDelegationCredential

                Assert-MockCalled -CommandName Install-ADDSForest -ParameterFilter  { $CreateDnsDelegation -eq $true } -Scope It
            }

            It 'Calls "Install-ADDSForest" with "DatabasePath" when creating forest, if specified' {
                $testPath = 'TestPath'
                Mock -CommandName Install-ADDSForest -ParameterFilter { $DatabasePath -eq $testPath }

                Set-TargetResource @newForestParams -DatabasePath $testPath

                Assert-MockCalled -CommandName Install-ADDSForest -ParameterFilter { $DatabasePath -eq $testPath } -Scope It
            }

            It 'Calls "Install-ADDSForest" with "LogPath" when creating forest, if specified' {
                $testPath = 'TestPath'
                Mock -CommandName Install-ADDSForest -ParameterFilter { $LogPath -eq $testPath }

                Set-TargetResource @newForestParams -LogPath $testPath

                Assert-MockCalled -CommandName Install-ADDSForest -ParameterFilter { $LogPath -eq $testPath } -Scope It
            }

            It 'Calls "Install-ADDSForest" with "SysvolPath" when creating forest, if specified' {
                $testPath = 'TestPath'
                Mock -CommandName Install-ADDSForest -ParameterFilter { $SysvolPath -eq $testPath }

                Set-TargetResource @newForestParams -SysvolPath $testPath

                Assert-MockCalled -CommandName Install-ADDSForest -ParameterFilter { $SysvolPath -eq $testPath } -Scope It
            }

            It 'Calls "Install-ADDSForest" with "DomainNetbiosName" when creating forest, if specified' {
                Mock -CommandName Install-ADDSForest -ParameterFilter { $DomainNetbiosName -eq $testDomainNetBIOSNameName }

                Set-TargetResource @newForestParams -DomainNetBIOSName $testDomainNetBIOSNameName

                Assert-MockCalled -CommandName Install-ADDSForest -ParameterFilter { $DomainNetbiosName -eq $testDomainNetBIOSNameName } -Scope It
            }

            It 'Calls "Install-ADDSForest" with "ForestMode" when creating forest, if specified' {
                Mock -CommandName Install-ADDSForest -ParameterFilter { $ForestMode -eq $testDomainForestMode }

                Set-TargetResource @newForestParams -ForestMode $testDomainForestMode

                Assert-MockCalled -CommandName Install-ADDSForest -ParameterFilter { $ForestMode -eq $testDomainForestMode } -Scope It
            }

            It 'Calls "Install-ADDSForest" with "DomainMode" when creating forest, if specified' {
                Mock -CommandName Install-ADDSForest -ParameterFilter { $DomainMode -eq $testDomainForestMode }

                Set-TargetResource @newForestParams -DomainMode $testDomainForestMode

                Assert-MockCalled -CommandName Install-ADDSForest -ParameterFilter { $DomainMode -eq $testDomainForestMode } -Scope It
            }

            # ADDSDomain

            It 'Calls "Install-ADDSDomain" with "NewDomainName" when creating child domain' {
                Mock -CommandName Install-ADDSDomain -ParameterFilter { $NewDomainName -eq $testDomainName }

                Set-TargetResource @newDomainParams

                Assert-MockCalled -CommandName Install-ADDSDomain -ParameterFilter  { $NewDomainName -eq $testDomainName } -Scope It
            }

            It 'Calls "Install-ADDSDomain" with "ParentDomainName" when creating child domain' {
                Mock -CommandName Install-ADDSDomain -ParameterFilter { $ParentDomainName -eq $testParentDomainName }

                Set-TargetResource @newDomainParams

                Assert-MockCalled -CommandName Install-ADDSDomain -ParameterFilter  { $ParentDomainName -eq $testParentDomainName } -Scope It
            }

            It 'Calls "Install-ADDSDomain" with "DomainType" when creating child domain' {
                Mock -CommandName Install-ADDSDomain -ParameterFilter { $DomainType -eq 'ChildDomain' }

                Set-TargetResource @newDomainParams

                Assert-MockCalled -CommandName Install-ADDSDomain -ParameterFilter  { $DomainType -eq 'ChildDomain' } -Scope It
            }

            It 'Calls "Install-ADDSDomain" with "SafeModeAdministratorPassword" when creating child domain' {
                Mock -CommandName Install-ADDSDomain -ParameterFilter { $SafeModeAdministratorPassword -eq $testSafemodePassword }

                Set-TargetResource @newDomainParams

                Assert-MockCalled -CommandName Install-ADDSDomain -ParameterFilter { $SafeModeAdministratorPassword -eq $testSafemodePassword } -Scope It
            }

            It 'Calls "Install-ADDSDomain" with "Credential" when creating child domain' {
                Mock -CommandName Install-ADDSDomain -ParameterFilter { $Credential -eq $testParentDomainName }

                Set-TargetResource @newDomainParams

                Assert-MockCalled -CommandName Install-ADDSDomain -ParameterFilter  { $ParentDomainName -eq $testParentDomainName } -Scope It
            }

            It 'Calls "Install-ADDSDomain" with "ParentDomainName" when creating child domain' {
                Mock -CommandName Install-ADDSDomain -ParameterFilter { $ParentDomainName -eq $testParentDomainName }

                Set-TargetResource @newDomainParams

                Assert-MockCalled -CommandName Install-ADDSDomain -ParameterFilter  { $ParentDomainName -eq $testParentDomainName } -Scope It
            }

            It 'Calls "Install-ADDSDomain" with "DnsDelegationCredential" when creating child domain, if specified' {
                Mock -CommandName Install-ADDSDomain -ParameterFilter { $DnsDelegationCredential -eq $testDelegationCredential }

                Set-TargetResource @newDomainParams -DnsDelegationCredential $testDelegationCredential

                Assert-MockCalled -CommandName Install-ADDSDomain -ParameterFilter  { $DnsDelegationCredential -eq $testDelegationCredential } -Scope It
            }

            It 'Calls "Install-ADDSDomain" with "CreateDnsDelegation" when creating child domain, if specified' {
                Mock -CommandName Install-ADDSDomain -ParameterFilter { $CreateDnsDelegation -eq $true }

                Set-TargetResource @newDomainParams -DnsDelegationCredential $testDelegationCredential

                Assert-MockCalled -CommandName Install-ADDSDomain -ParameterFilter  { $CreateDnsDelegation -eq $true } -Scope It
            }

            It 'Calls "Install-ADDSDomain" with "DatabasePath" when creating child domain, if specified' {
                $testPath = 'TestPath'
                Mock -CommandName Install-ADDSDomain -ParameterFilter { $DatabasePath -eq $testPath }

                Set-TargetResource @newDomainParams -DatabasePath $testPath

                Assert-MockCalled -CommandName Install-ADDSDomain -ParameterFilter { $DatabasePath -eq $testPath } -Scope It
            }

            It 'Calls "Install-ADDSDomain" with "LogPath" when creating child domain, if specified' {
                $testPath = 'TestPath'
                Mock -CommandName Install-ADDSDomain -ParameterFilter { $LogPath -eq $testPath }

                Set-TargetResource @newDomainParams -LogPath $testPath

                Assert-MockCalled -CommandName Install-ADDSDomain -ParameterFilter { $LogPath -eq $testPath } -Scope It
            }

            It 'Calls "Install-ADDSDomain" with "SysvolPath" when creating child domain, if specified' {
                $testPath = 'TestPath'
                Mock -CommandName Install-ADDSDomain -ParameterFilter { $SysvolPath -eq $testPath }

                Set-TargetResource @newDomainParams -SysvolPath $testPath

                Assert-MockCalled -CommandName Install-ADDSDomain -ParameterFilter { $SysvolPath -eq $testPath } -Scope It
            }

            It 'Calls "Install-ADDSDomain" with "NewDomainNetbiosName" when creating child domain, if specified' {
                Mock -CommandName Install-ADDSDomain -ParameterFilter { $NewDomainNetbiosName -eq $testDomainNetBIOSNameName }

                Set-TargetResource @newDomainParams -DomainNetBIOSName $testDomainNetBIOSNameName

                Assert-MockCalled -CommandName Install-ADDSDomain -ParameterFilter { $NewDomainNetbiosName -eq $testDomainNetBIOSNameName } -Scope It
            }

            It 'Calls "Install-ADDSDomain" with "DomainMode" when creating child domain, if specified' {
                Mock -CommandName Install-ADDSDomain -ParameterFilter { $DomainMode -eq $testDomainForestMode }

                Set-TargetResource @newDomainParams -DomainMode $testDomainForestMode

                Assert-MockCalled -CommandName Install-ADDSDomain -ParameterFilter { $DomainMode -eq $testDomainForestMode } -Scope It
            }
        }
        #endregion

    }
    #endregion
}
finally
{
    Invoke-TestCleanup
}
