Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath '..\TestHelpers\ActiveDirectoryDsc.TestHelper.psm1')

if (-not (Test-RunForCITestCategory -Type 'Unit' -Category 'Tests'))
{
    return
}

$script:dscModuleName = 'ActiveDirectoryDsc'
$script:dscResourceName = 'MSFT_ADKDSKey'

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

        # Need to do a deep copy of the Array of objects that compare returns
        function Copy-ArrayObjects
        {
            param
            (
                [Parameter(Mandatory = $true)]
                [ValidateNotNullOrEmpty()]
                [System.Array]
                $DeepCopyObject
            )

            $memStream = New-Object -TypeName 'IO.MemoryStream'
            $formatter = New-Object -TypeName 'Runtime.Serialization.Formatters.Binary.BinaryFormatter'
            $formatter.Serialize($memStream,$DeepCopyObject)
            $memStream.Position = 0
            $formatter.Deserialize($memStream)
        }

        $mockADDomain = 'OU=Fake,DC=contoso,DC=com'

        $mockKDSServerConfiguration = [pscustomobject] @{
            AttributeOfWrongFormat          = $null
            KdfParameters                   = $null #Byte[], not currently needed
            SecretAgreementParameters       = $null #Byte[], not currently needed
            IsValidFormat                   = $true
            SecretAgreementAlgorithm        = 'DH'
            KdfAlgorithm                    = 'SP800_108_CTR_HMAC'
            SecretAgreementPublicKeyLength  = 2048
            SecretAgreementPrivateKeyLength = 512
            VersionNumber                   = 1
        }

        $mockKDSRootKeyFuture = [pscustomobject] @{
            AttributeOfWrongFormat = $null
            KeyValue               = $null #Byte[], not currently needed
            EffectiveTime          = [DateTime]::Parse('1/1/3000 13:00')
            CreationTime           = [DateTime]::Parse('1/1/3000 08:00')
            IsFormatValid          = $true
            DomainController       = 'CN=MockDC,{0}' -f $mockADDomain
            ServerConfiguration    = $mockKDSServerConfiguration
            KeyId                  = '92051014-f6c5-4a09-8f7a-f747728d1b9a'
            VersionNumber          = 1
        }

        $mockKDSRootKeyPast = [pscustomobject] @{
            AttributeOfWrongFormat = $null
            KeyValue               = $null #Byte[], not currently needed
            EffectiveTime          = [DateTime]::Parse('1/1/2000 13:00')
            CreationTime           = [DateTime]::Parse('1/1/2000 08:00')
            IsFormatValid          = $true
            DomainController       = 'CN=MockDC,{0}' -f $mockADDomain
            ServerConfiguration    = $mockKDSServerConfiguration
            KeyId                  = '92051014-f6c5-4a09-8f7a-f747728d1b9a'
            VersionNumber          = 1
        }

        $mockKDSRootKeyFutureGet = @{
            EffectiveTime     = ($mockKDSRootKeyFuture.EffectiveTime).ToString()
            CreationTime      = $mockKDSRootKeyFuture.CreationTime
            KeyId             = $mockKDSRootKeyFuture.KeyId
            Ensure            = 'Present'
            DistinguishedName = 'CN={0},CN=Master Root Keys,CN=Group Key Distribution Service,CN=Services,CN=Configuration,{1}' -f
                                    $mockKDSRootKeyFuture.KeyId, $mockADDomain
        }

        $mockKDSRootKeyPastGet = @{
            EffectiveTime     = ($mockKDSRootKeyPast.EffectiveTime).ToString()
            CreationTime      = $mockKDSRootKeyPast.CreationTime
            KeyId             = $mockKDSRootKeyPast.KeyId
            Ensure            = 'Present'
            DistinguishedName = 'CN={0},CN=Master Root Keys,CN=Group Key Distribution Service,CN=Services,CN=Configuration,{1}' -f
                                    $mockKDSRootKeyPast.KeyId, $mockADDomain
        }

        $mockKDSRootKeyFutureCompare = @(
            [pscustomobject] @{
                Parameter = 'EffectiveTime'
                Expected  = $mockKDSRootKeyFutureGet.EffectiveTime
                Actual    = $mockKDSRootKeyFutureGet.EffectiveTime
                Pass      = $true
            }
            [pscustomobject] @{
                Parameter = 'Ensure'
                Expected  = $mockKDSRootKeyFutureGet.Ensure
                Actual    = $mockKDSRootKeyFutureGet.Ensure
                Pass      = $true
            }
            [pscustomobject] @{
                Parameter = 'DistinguishedName'
                Expected  = $mockKDSRootKeyFutureGet.DistinguishedName
                Actual    = $mockKDSRootKeyFutureGet.DistinguishedName
                Pass      = $true
            }
        )

        $mockKDSRootKeyPastCompare = @(
            [pscustomobject] @{
                Parameter = 'EffectiveTime'
                Expected  = $mockKDSRootKeyPastGet.EffectiveTime
                Actual    = $mockKDSRootKeyPastGet.EffectiveTime
                Pass      = $true
            }
            [pscustomobject] @{
                Parameter = 'Ensure'
                Expected  = $mockKDSRootKeyPastGet.Ensure
                Actual    = $mockKDSRootKeyPastGet.Ensure
                Pass      = $true
            }
            [pscustomobject] @{
                Parameter = 'DistinguishedName'
                Expected  = $mockKDSRootKeyPastGet.DistinguishedName
                Actual    = $mockKDSRootKeyPastGet.DistinguishedName
                Pass      = $true
            }
        )

        #region Function Assert-HasDomainAdminRights
        Describe -Name 'MSFT_ADKDSKey\Assert-HasDomainAdminRights' {
            Context 'When Assert-HasDomainAdminRights returns true' {
                Context 'When the user has proper permissions' {
                    BeforeAll {
                        Mock -CommandName New-Object -MockWith {
                            $object = New-MockObject -Type 'System.Security.Principal.WindowsPrincipal'
                            $object | Add-Member -MemberType ScriptMethod -Name 'IsInRole' -Force -Value { return $true }
                            return $object
                        }

                        Mock -CommandName Get-CimInstance -MockWith { return @{ProductType = 0} }
                    }

                    It "Should Call 'New-Object' and 'Get-CimInstance'" {
                        $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
                        Assert-HasDomainAdminRights -User $currentUser | Should -BeTrue

                        Assert-MockCalled -CommandName New-Object -Scope It -Exactly -Times 1
                        Assert-MockCalled -CommandName Get-CimInstance -Scope It -Exactly -Times 1
                    }
                }

                Context 'When the resource is run on a domain controller' {
                    BeforeAll {
                        Mock -CommandName New-Object -MockWith {
                            $object = New-MockObject -Type 'System.Security.Principal.WindowsPrincipal'
                            $object | Add-Member -MemberType ScriptMethod -Name 'IsInRole' -Force -Value { return $false }
                            return $object
                        }

                        Mock -CommandName Get-CimInstance -MockWith { return @{ProductType = 2} }
                    }

                    It "Should Call 'New-Object' and 'Get-CimInstance'" {
                        $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()

                        Assert-HasDomainAdminRights -User $currentUser | Should -BeTrue

                        Assert-MockCalled -CommandName New-Object -Scope It -Exactly -Times 1
                        Assert-MockCalled -CommandName Get-CimInstance -Scope It -Exactly -Times 1
                    }
                }
            }

            Context 'When Assert-HasDomainAdminRights returns false' {
                Context 'When the user does NOT have proper permissions' {
                    BeforeAll {
                        Mock -CommandName New-Object -MockWith {
                            $object = New-MockObject -Type 'System.Security.Principal.WindowsPrincipal'
                            $object | Add-Member -MemberType ScriptMethod -Name 'IsInRole' -Force -Value { return $false }
                            return $object
                        }

                        Mock -CommandName Get-CimInstance -MockWith { return @{ProductType = 0} }
                    }

                    It "Should Call 'New-Object' and 'Get-CimInstance'" {
                        $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
                        Assert-HasDomainAdminRights -User $currentUser | Should -BeFalse

                        Assert-MockCalled -CommandName New-Object -Scope It -Exactly -Times 1
                        Assert-MockCalled -CommandName Get-CimInstance -Scope It -Exactly -Times 1
                    }
                }

                Context 'When the resource is NOT run on a domain controller' {
                    BeforeAll {
                        Mock -CommandName New-Object -MockWith {
                            $object = New-MockObject -Type 'System.Security.Principal.WindowsPrincipal'
                            $object | Add-Member -MemberType ScriptMethod -Name 'IsInRole' -Force -Value { return $false }
                            return $object
                        }

                        Mock -CommandName Get-CimInstance -MockWith { return @{ProductType = 0} }
                    }

                    It "Should Call 'New-Object' and 'Get-CimInstance'" {
                        $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()

                        Assert-HasDomainAdminRights -User $currentUser | Should -BeFalse

                        Assert-MockCalled -CommandName New-Object -Scope It -Exactly -Times 1
                        Assert-MockCalled -CommandName Get-CimInstance -Scope It -Exactly -Times 1
                    }
                }
            }
        }
        #endregion Function Assert-HasDomainAdminRights

        #region Function Get-ADRootDomainDN
        Describe -Name 'MSFT_ADKDSKey\Get-ADRootDomainDN' {
            BeforeAll {
                Mock -CommandName New-Object -MockWith {
                    $object = [PSCustomObject] @{}
                    $object | Add-Member -MemberType ScriptMethod -Name 'Get' -Value { return $mockADDomain }

                    return $object
                }
            }

            It 'Should return domain distinguished name' {
                Get-ADRootDomainDN | Should -Be $mockADDomain
            }
        }
        #endregion Function Get-ADRootDomainDN

        #region Function Get-TargetResource
        Describe -Name 'MSFT_ADKDSKey\Get-TargetResource' -Tag 'Get' {
            BeforeAll {
                Mock -CommandName Assert-Module -ParameterFilter {
                    $ModuleName -eq 'ActiveDirectory'
                }

                Mock -CommandName Get-ADRootDomainDN -MockWith {
                    return $mockADDomain
                }

                Mock -CommandName Assert-HasDomainAdminRights -MockWith {
                    return $true
                }

                Mock -CommandName Get-KdsRootKey
            }

            Context -Name 'When the system uses specific parameters' {
                It 'Should call "Assert-Module" to check AD module is installed' {
                    $getTargetResourceParameters = @{
                        EffectiveTime = ($mockKDSRootKeyFuture.EffectiveTime).ToString()
                    }

                    { Get-TargetResource @getTargetResourceParameters } | Should -Not -Throw

                    Assert-MockCalled -CommandName Assert-Module -Scope It -Exactly -Times 1
                }
            }

            Context -Name "When 'EffectiveTime' is not parsable by DateTime" {
                It 'Should call throw an error if EffectiveTime cannot be parsed' {
                    $getTargetResourceParameters = @{
                        EffectiveTime = 'Useless Time'
                    }

                    { Get-TargetResource  @getTargetResourceParameters -ErrorAction 'SilentlyContinue' } |
                        Should -Throw ($script:localizedData.EffectiveTimeInvalid -f
                                            $getTargetResourceParameters.EffectiveTime)
                }

                Assert-MockCalled -CommandName Assert-HasDomainAdminRights -Scope It -Exactly -Times 0
                Assert-MockCalled -CommandName Get-KdsRootKey -Scope It -Exactly -Times 0
            }

            Context -Name "When the Current User does not have proper permissions" {
                Mock -CommandName Assert-HasDomainAdminRights -MockWith { return $false }

                It 'Should call throw an error if Context User does not have correct permissions' {
                    $getTargetResourceParameters = @{
                        EffectiveTime = ($mockKDSRootKeyFuture.EffectiveTime).ToString()
                    }

                    $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()

                    { Get-TargetResource  @getTargetResourceParameters -ErrorAction 'SilentlyContinue' } |
                        Should -Throw ($script:localizedData.IncorrectPermissions -f $currentUser.Name)

                    Assert-MockCalled -CommandName Assert-HasDomainAdminRights -Scope It -Exactly -Times 1
                    Assert-MockCalled -CommandName Get-KdsRootKey -Scope It -Exactly -Times 0
                }
            }

            Context -Name "When 'Get-KdsRootKey' throws an error" {
                Mock -CommandName Get-KdsRootKey -MockWith {
                    throw 'Microsoft.ActiveDirectory.Management.ADServerDownException'
                }

                It "Should call 'Get-KdsRootKey' and throw an error when catching any errors" {
                    $getTargetResourceParameters = @{
                        EffectiveTime = ($mockKDSRootKeyFuture.EffectiveTime).ToString()
                    }

                    { Get-TargetResource  @getTargetResourceParameters -ErrorAction 'SilentlyContinue' } |
                        Should -Throw ($script:localizedData.RetrievingKDSRootKeyError -f
                                            $getTargetResourceParameters.EffectiveTime)

                    Assert-MockCalled -CommandName Assert-HasDomainAdminRights -Scope It -Exactly -Times 1
                    Assert-MockCalled -CommandName Get-KdsRootKey -Scope It -Exactly -Times 1
                }
            }

            Context -Name 'When the system is in desired state' {
                Mock -CommandName Get-KdsRootKey -MockWith {
                    return ,@($mockKDSRootKeyFuture)
                }

                It 'Should mock call to Get-KdsRootKey and return identical information' {
                    $getTargetResourceParametersFuture = @{
                        EffectiveTime = ($mockKDSRootKeyFuture.EffectiveTime).ToString()
                    }

                    $getTargetResourceResult = Get-TargetResource @getTargetResourceParametersFuture

                    $getTargetResourceResult.EffectiveTime | Should -Be $mockKDSRootKeyFuture.EffectiveTime
                    $getTargetResourceResult.CreationTime | Should -Be $mockKDSRootKeyFuture.CreationTime
                    $getTargetResourceResult.KeyId | Should -Be $mockKDSRootKeyFuture.KeyId
                    $getTargetResourceResult.Ensure | Should -Be 'Present'

                    $dn = 'CN={0},CN=Master Root Keys,CN=Group Key Distribution Service,CN=Services,CN=Configuration,{1}' -f
                                $mockKDSRootKeyFuture.KeyId, $mockADDomain

                    $getTargetResourceResult.DistinguishedName | Should -Be $dn

                    Assert-MockCalled -CommandName Assert-HasDomainAdminRights -Scope It -Exactly -Times 1
                    Assert-MockCalled -CommandName Get-KdsRootKey -Scope It -Exactly -Times 1
                }

                Context -Name 'When system has two or more KDS keys with the same effective date' {
                    Mock -CommandName Write-Warning

                    Mock -CommandName Get-KdsRootKey -MockWith {
                        return @($mockKDSRootKeyFuture,$mockKDSRootKeyFuture)
                    }

                    It 'Should return Warning that more than one key exists and Error that two keys exist with the same dates' {
                        $getTargetResourceParameters = @{
                            EffectiveTime = ($mockKDSRootKeyFuture.EffectiveTime).ToString()
                        }

                        { Get-TargetResource @getTargetResourceParameters -ErrorAction 'SilentlyContinue' } |
                            Should -Throw ($script:localizedData.FoundKDSRootKeySameEffectiveTime -f
                                                $getTargetResourceParameters.EffectiveTime)

                        Assert-MockCalled -CommandName Write-Warning -Scope It -Times 1
                        Assert-MockCalled -CommandName Assert-HasDomainAdminRights -Scope It -Exactly -Times 1
                        Assert-MockCalled -CommandName Get-KdsRootKey -Scope It -Exactly -Times 1
                    }
                }
            }

            Context -Name 'When the system is NOT in the desired state' {
                Context -Name 'When no KDS root keys exists' {
                    Mock -CommandName Get-KdsRootKey -MockWith {
                        return $null
                    }

                    It "Should return 'Ensure' is 'Absent'" {
                        $getTargetResourceParametersFuture = @{
                            EffectiveTime = ($mockKDSRootKeyFuture.EffectiveTime).ToString()
                        }

                        $getTargetResourceResult = Get-TargetResource @getTargetResourceParametersFuture

                        $getTargetResourceResult.Ensure | Should -Be 'Absent'

                        Assert-MockCalled -CommandName Assert-HasDomainAdminRights -Scope It -Exactly -Times 1
                        Assert-MockCalled -CommandName Get-KdsRootKey -Scope It -Exactly -Times 1
                    }
                }

                Context -Name 'When the KDS root key does not exist' {
                    Mock -CommandName Get-KdsRootKey -MockWith {
                        return ,@($mockKDSRootKeyPast)
                    }

                    It "Should return 'Ensure' is 'Absent'" {
                        $getTargetResourceParametersFuture = @{
                            EffectiveTime = ($mockKDSRootKeyFuture.EffectiveTime).ToString()
                        }

                        $getTargetResourceResult = Get-TargetResource @getTargetResourceParametersFuture
                        $getTargetResourceResult.Ensure | Should -Be 'Absent'

                        Assert-MockCalled -CommandName Assert-HasDomainAdminRights -Scope It -Exactly -Times 1
                        Assert-MockCalled -CommandName Get-KdsRootKey -Scope It -Exactly -Times 1
                    }

                }
            }

        }
        #endregion Function Get-TargetResource

        #region Function Compare-TargetResourceState
        Describe -Name 'MSFT_ADKDSKey\Compare-TargetResourceState' -Tag 'Compare' {
            BeforeAll {
                Mock -CommandName Get-TargetResource -ParameterFilter {
                    $mockKDSRootKeyFuture.EffectiveTime -eq $EffectiveTime
                } -MockWith {
                    return $mockKDSRootKeyFutureGet
                }
            }

            Context -Name 'When the system is in the desired state' {
                $compareTargetResourceParametersFuture = @{
                    EffectiveTime = ($mockKDSRootKeyFuture.EffectiveTime).ToString()
                }

                $compareTargetResourceResult = Compare-TargetResourceState @compareTargetResourceParametersFuture
                $testCases = @()
                $compareTargetResourceResult | ForEach-Object {
                    $testCases += @{
                        Parameter = $_.Parameter
                        Expected  = $_.Expected
                        Actual    = $_.Actual
                        Pass      = $_.Pass
                    }
                }

                It "Should return identical information for <Parameter>" -TestCases $testCases {
                    param
                    (
                        [Parameter()]
                        $Parameter,

                        [Parameter()]
                        $Expected,

                        [Parameter()]
                        $Actual,

                        [Parameter()]
                        $Pass
                    )

                    $Expected | Should -BeExactly $Actual
                    $Pass | Should -BeTrue
                }
            }

            Context -Name 'When the system is NOT in the desired state' {
                $compareTargetResourceParametersFuture = @{
                    EffectiveTime = ($mockKDSRootKeyFuture.EffectiveTime).ToString()
                    Ensure        = 'Absent'
                }

                $compareTargetResourceResult = Compare-TargetResourceState @compareTargetResourceParametersFuture
                $testCases = @()
                # Need to remove parameters that will always be true
                $compareTargetResourceResult = $compareTargetResourceResult | Where-Object -FilterScript {
                    $_.Parameter -ne 'EffectiveTime' -and
                    $_.Parameter -ne 'DistinguishedName'
                }

                $compareTargetResourceResult | ForEach-Object {
                    $testCases += @{
                        Parameter = $_.Parameter
                        Expected  = $_.Expected
                        Actual    = $_.Actual
                        Pass      = $_.Pass
                    }
                }

                It "Should return false for <Parameter>" -TestCases $testCases {
                    param
                    (
                        [Parameter()]
                        $Parameter,

                        [Parameter()]
                        $Expected,

                        [Parameter()]
                        $Actual,

                        [Parameter()]
                        $Pass
                    )

                    $Expected | Should -Not -Be $Actual
                    $Pass | Should -BeFalse
                }

            }
        }
        #endregion Function Compare-TargetResourceState

        #region Function Test-TargetResource
        Describe -Name 'MSFT_ADKDSKey\Test-TargetResource' -Tag 'Test' {
            Context -Name "When the system is in the desired state and 'Ensure' is 'Present'" {
                It "Should pass when the Parameters are properly set" {
                    Mock -CommandName Compare-TargetResourceState -MockWith {
                        return $mockKDSRootKeyFutureCompare
                    }

                    $testTargetResourceParametersFuture = @{
                        EffectiveTime = ($mockKDSRootKeyFuture.EffectiveTime).ToString()
                    }

                    Test-TargetResource @testTargetResourceParametersFuture | Should -BeTrue

                    Assert-MockCalled -CommandName Compare-TargetResourceState -ParameterFilter {
                        $mockKDSRootKeyFuture.EffectiveTime -eq $EffectiveTime
                    } -Scope It -Exactly -Times 1
                }
            }

            Context -Name "When the system is in the desired state and 'Ensure' is 'Absent'" {
                It "Should pass when 'Ensure' is set to 'Absent" {
                    $mockKDSRootKeyFutureCompareEnsureAbsent = Copy-ArrayObjects $mockKDSRootKeyFutureCompare
                    $objectEnsure = $mockKDSRootKeyFutureCompareEnsureAbsent | Where-Object -FilterScript {$_.Parameter -eq 'Ensure'}
                    $objectEnsure.Actual = 'Absent'
                    $objectEnsure.Pass = $true

                    Mock -CommandName Compare-TargetResourceState -MockWith {
                        return $mockKDSRootKeyFutureCompareEnsureAbsent
                    }

                    $testTargetResourceParametersFuture = @{
                        EffectiveTime = ($mockKDSRootKeyFuture.EffectiveTime).ToString()
                        Ensure        = 'Absent'
                    }

                    Test-TargetResource @testTargetResourceParametersFuture | Should -BeTrue

                    Assert-MockCalled -CommandName Compare-TargetResourceState -ParameterFilter {
                        $mockKDSRootKeyFuture.EffectiveTime -eq $EffectiveTime
                    } -Scope It -Exactly -Times 1
                }
            }

            Context -Name "When the system is NOT in the desired state and 'Ensure' is 'Absent'" {
                $mockKDSRootKeyFutureCompareNotCompliant = Copy-ArrayObjects $mockKDSRootKeyFutureCompare

                $testIncorrectParameters = @{
                    Ensure = 'Absent'
                }

                $testCases = @()
                foreach($incorrectParameter in $testIncorrectParameters.GetEnumerator())
                {
                    $objectParameter = $mockKDSRootKeyFutureCompareNotCompliant | Where-Object -FilterScript { $_.Parameter -eq $incorrectParameter.Name }
                    $objectParameter.Expected = $incorrectParameter.Value
                    $objectParameter.Pass = $false

                    $testCases += @{
                        Parameter = $incorrectParameter.Name
                        Value = $incorrectParameter.Value
                    }
                }

                Mock -CommandName Compare-TargetResourceState -MockWith {
                    return $mockKDSRootKeyFutureCompareNotCompliant
                }

                It "Should return $false when <Parameter> is incorrect" -TestCases $testCases {
                    param
                    (
                        [Parameter()]
                        $Parameter,

                        [Parameter()]
                        $Value
                    )

                    $testTargetResourceParametersFuture = @{
                        EffectiveTime = ($mockKDSRootKeyFuture.EffectiveTime).ToString()
                        Ensure        = 'Present'
                    }

                    $testTargetResourceParametersFuture[$Parameter] = $value
                    Test-TargetResource @testTargetResourceParametersFuture | Should -BeFalse

                    Assert-MockCalled -CommandName Compare-TargetResourceState -ParameterFilter {
                        $mockKDSRootKeyFuture.EffectiveTime -eq $EffectiveTime
                    } -Scope It -Exactly -Times 1

                }
            }
        }
        #endregion Function Test-TargetResource

        #region Function Set-TargetResource
        Describe -Name 'MSFT_ADKDSKey\Set-TargetResource' -Tag 'Set' {
            BeforeAll {
                Mock -CommandName Add-KDSRootKey
                Mock -CommandName Remove-ADObject
                Mock -CommandName Write-Warning
            }

            Context -Name 'When the system is in the desired state and KDS Root Key is Present' {
                Mock -CommandName Compare-TargetResourceState -MockWith {
                    return $mockKDSRootKeyFutureCompare
                }

                $setTargetResourceParametersFuture = @{
                    EffectiveTime = ($mockKDSRootKeyFuture.EffectiveTime).ToString()
                }

                It 'Should NOT take any action when all parameters are correct' {
                    Set-TargetResource @setTargetResourceParametersFuture

                    Assert-MockCalled -CommandName Add-KDSRootKey -Scope It -Times 0
                    Assert-MockCalled -CommandName Remove-ADObject -Scope It -Times 0
                    Assert-MockCalled -CommandName Write-Warning -Scope It -Exactly -Times 0
                    Assert-MockCalled -CommandName Compare-TargetResourceState -ParameterFilter {
                        $mockKDSRootKeyFuture.EffectiveTime -eq $EffectiveTime
                    } -Scope It -Exactly -Times 1
                }
            }

            Context -Name 'When the system is in the desired state and KDS Root Key is Absent' {
                $mockKDSRootKeyFutureCompareEnsureAbsent = Copy-ArrayObjects $mockKDSRootKeyFutureCompare
                $objectEnsure = $mockKDSRootKeyFutureCompareEnsureAbsent | Where-Object -FilterScript {$_.Parameter -eq 'Ensure'}
                $objectEnsure.Expected = 'Absent'
                $objectEnsure.Pass = $false

                Mock -CommandName Compare-TargetResourceState -MockWith {
                    return $mockKDSRootKeyFutureCompareEnsureAbsent
                }

                $setTargetResourceParametersFuture = @{
                    EffectiveTime = ($mockKDSRootKeyFuture.EffectiveTime).ToString()
                    Ensure = 'Present'
                }

                It 'Should NOT take any action when all parameters are correct' {
                    Set-TargetResource @setTargetResourceParametersFuture

                    Assert-MockCalled -CommandName Add-KDSRootKey -Scope It -Times 1
                    Assert-MockCalled -CommandName Remove-ADObject -Scope It -Times 0
                    Assert-MockCalled -CommandName Write-Warning -Scope It -Exactly -Times 0
                    Assert-MockCalled -CommandName Compare-TargetResourceState -ParameterFilter {
                        $mockKDSRootKeyFuture.EffectiveTime -eq $EffectiveTime
                    } -Scope It -Exactly -Times 1
                }
            }

            Context -Name 'When the system is NOT in the desired state and need to remove KDS Root Key' {
                BeforeEach {
                    $mockKDSRootKeyFutureCompareEnsureAbsent = Copy-ArrayObjects $mockKDSRootKeyFutureCompare
                    $objectEnsure = $mockKDSRootKeyFutureCompareEnsureAbsent | Where-Object -FilterScript {$_.Parameter -eq 'Ensure'}
                    $objectEnsure.Actual = 'Present'
                    $objectEnsure.Pass = $false

                    Mock -CommandName Compare-TargetResourceState -MockWith {
                        return $mockKDSRootKeyFutureCompareEnsureAbsent
                    }

                    $setTargetResourceParametersFuture = @{
                        EffectiveTime = ($mockKDSRootKeyFuture.EffectiveTime).ToString()
                        Ensure = 'Absent'
                    }
                }

                Context -Name 'When more than one KDS root key exists' {
                    Mock -CommandName Get-KdsRootKey -MockWith {
                        return @($mockKDSRootKeyFuture, $mockKDSRootKeyPast)
                    }

                    It "Should call 'Remove-ADObject' when 'Ensure' is set to 'Present'" {
                        Set-TargetResource @setTargetResourceParametersFuture

                        Assert-MockCalled -CommandName Add-KDSRootKey -Scope It -Times 0
                        Assert-MockCalled -CommandName Remove-ADObject -Scope It -Times 1
                        Assert-MockCalled -CommandName Write-Warning -Scope It -Exactly -Times 0
                        Assert-MockCalled -CommandName Get-KdsRootKey -Scope It -Exactly -Times 1
                        Assert-MockCalled -CommandName Compare-TargetResourceState -ParameterFilter {
                            $mockKDSRootKeyFuture.EffectiveTime -eq $EffectiveTime
                        } -Scope It -Exactly -Times 1
                    }
                }

                Context -Name 'When only one KDS root key exists' {
                    Mock -CommandName Get-KdsRootKey -MockWith {
                        return ,@($mockKDSRootKeyFuture)
                    }

                    It "Should call NOT 'Remove-ADObject' when 'Ensure' is set to 'Present' and 'ForceRemove' is 'False'" {
                        { Set-TargetResource @setTargetResourceParametersFuture -ErrorAction 'SilentlyContinue' } |
                            Should -Throw ($script:localizedData.NotEnoughKDSRootKeysPresentNoForce -f
                                                $setTargetResourceParametersFuture.EffectiveTime)

                        Assert-MockCalled -CommandName Add-KDSRootKey -Scope It -Times 0
                        Assert-MockCalled -CommandName Remove-ADObject -Scope It -Times 0
                        Assert-MockCalled -CommandName Write-Warning -Scope It -Exactly -Times 0
                        Assert-MockCalled -CommandName Get-KdsRootKey -Scope It -Exactly -Times 1
                        Assert-MockCalled -CommandName Compare-TargetResourceState -ParameterFilter {
                            $mockKDSRootKeyFuture.EffectiveTime -eq $EffectiveTime
                        } -Scope It -Exactly -Times 1
                    }

                    $setTargetResourceParametersFutureForce = @{
                        EffectiveTime = ($mockKDSRootKeyFuture.EffectiveTime).ToString()
                        Ensure        = 'Absent'
                        ForceRemove   = $true
                    }

                    It "Should call 'Remove-ADObject' when 'Ensure' is set to 'Present' and 'ForceRemove' is 'True'" {
                        Set-TargetResource @setTargetResourceParametersFutureForce

                        Assert-MockCalled -CommandName Add-KDSRootKey -Scope It -Times 0
                        Assert-MockCalled -CommandName Remove-ADObject -Scope It -Times 1
                        Assert-MockCalled -CommandName Write-Warning -Scope It -Exactly -Times 1
                        Assert-MockCalled -CommandName Get-KdsRootKey -Scope It -Exactly -Times 1
                        Assert-MockCalled -CommandName Compare-TargetResourceState -ParameterFilter {
                            $mockKDSRootKeyFuture.EffectiveTime -eq $EffectiveTime
                        } -Scope It -Exactly -Times 1
                    }
                }

                Context -Name 'When calling Remove-ADObject fails' {
                    Mock -CommandName Get-KdsRootKey -MockWith {
                        return @($mockKDSRootKeyFuture, $mockKDSRootKeyPast)
                    }

                    Mock -CommandName Remove-ADObject -MockWith {
                        throw 'Microsoft.ActiveDirectory.Management.ADServerDownException'
                    }

                    It "Should call 'Remove-ADObject' and throw an error when catching any errors" {
                        { Set-TargetResource  @setTargetResourceParametersFuture -ErrorAction 'SilentlyContinue' } |
                            Should -Throw ($script:localizedData.KDSRootKeyRemoveError -f
                                                $setTargetResourceParametersFuture.EffectiveTime)

                        Assert-MockCalled -CommandName Remove-ADObject -Scope It -Exactly -Times 1
                    }
                }
            }

            Context -Name 'When the system is NOT in the desired state and need to add KDS Root Key' {
                BeforeEach {
                    $mockKDSRootKeyCompareEnsureAbsent = Copy-ArrayObjects $mockKDSRootKeyFutureCompare
                    $objectEnsure = $mockKDSRootKeyCompareEnsureAbsent | Where-Object -FilterScript {$_.Parameter -eq 'Ensure'}
                    $objectEnsure.Actual = 'Absent'
                    $objectEnsure.Pass = $false

                    Mock -CommandName Compare-TargetResourceState -MockWith {
                        return $mockKDSRootKeyCompareEnsureAbsent
                    }
                }

                It "Should call 'Add-KDSRootKey' when 'Ensure' is set to 'Present'" {
                    $setTargetResourceParametersFuture = @{
                        EffectiveTime = ($mockKDSRootKeyFuture.EffectiveTime).ToString()
                        Ensure = 'Present'
                    }

                    Set-TargetResource @setTargetResourceParametersFuture

                    Assert-MockCalled -CommandName Add-KDSRootKey -Scope It -Times 1
                    Assert-MockCalled -CommandName Remove-ADObject -Scope It -Times 0
                    Assert-MockCalled -CommandName Write-Warning -Scope It -Exactly -Times 0
                    Assert-MockCalled -CommandName Compare-TargetResourceState -ParameterFilter {
                        $mockKDSRootKeyFuture.EffectiveTime -eq $EffectiveTime
                    } -Scope It -Exactly -Times 1
                }

                It "Should NOT call 'Add-KDSRootKey' when 'EffectiveTime' is past date and 'AllowUnsafeEffectiveTime' is 'False'" {
                    $setTargetResourceParametersPast = @{
                        EffectiveTime = ($mockKDSRootKeyPast.EffectiveTime).ToString()
                        Ensure        = 'Present'
                    }

                    { Set-TargetResource @setTargetResourceParametersPast -ErrorAction 'SilentlyContinue' } |
                        Should -Throw ($script:localizedData.AddingKDSRootKeyError -f
                                            $setTargetResourceParametersPast.EffectiveTime)

                    Assert-MockCalled -CommandName Add-KDSRootKey -Scope It -Times 0
                    Assert-MockCalled -CommandName Remove-ADObject -Scope It -Times 0
                    Assert-MockCalled -CommandName Write-Warning -Scope It -Exactly -Times 0
                    Assert-MockCalled -CommandName Compare-TargetResourceState -ParameterFilter {
                        $mockKDSRootKeyPast.EffectiveTime
                    } -Scope It -Exactly -Times 1
                }

                It "Should call 'Add-KDSRootKey' when 'EffectiveTime' is past date and 'AllowUnsafeEffectiveTime' is 'True'" {
                    $setTargetResourceParametersPast = @{
                        EffectiveTime            = ($mockKDSRootKeyPast.EffectiveTime).ToString()
                        Ensure                   = 'Present'
                        AllowUnsafeEffectiveTime = $true
                    }

                    Set-TargetResource @setTargetResourceParametersPast

                    Assert-MockCalled -CommandName Add-KDSRootKey -Scope It -Times 1
                    Assert-MockCalled -CommandName Remove-ADObject -Scope It -Times 0
                    Assert-MockCalled -CommandName Write-Warning -Scope It -Exactly -Times 1
                    Assert-MockCalled -CommandName Compare-TargetResourceState -ParameterFilter {
                        $mockKDSRootKeyPast.EffectiveTime
                    } -Scope It -Exactly -Times 1
                }

                It 'Should call throw an error if EffectiveTime cannot be parsed' {
                    $setTargetResourceParametersFuture = @{
                        EffectiveTime = 'Useless Time'
                    }

                    { Set-TargetResource  @setTargetResourceParametersFuture -ErrorAction 'SilentlyContinue' } |
                        Should -Throw ($script:localizedData.EffectiveTimeInvalid -f
                                            $setTargetResourceParametersFuture.EffectiveTime)

                    Assert-MockCalled -CommandName Compare-TargetResourceState -ParameterFilter {
                        $mockKDSRootKeyFuture.EffectiveTime
                    } -Scope It -Exactly -Times 1
                }

                Context -Name 'When calling Add-KDSRootKey fails' {
                    Mock -CommandName Add-KDSRootKey -MockWith {
                        throw 'Microsoft.ActiveDirectory.Management.ADServerDownException'
                    }

                    It "Should call 'Add-KdsRootKey' and throw an error when catching any errors" {
                        $setTargetResourceParametersFuture = @{
                            EffectiveTime = ($mockKDSRootKeyFuture.EffectiveTime).ToString()
                            Ensure = 'Present'
                        }

                        { Set-TargetResource  @setTargetResourceParametersFuture -ErrorAction 'SilentlyContinue' } |
                            Should -Throw ($script:localizedData.KDSRootKeyAddError -f
                                                $setTargetResourceParametersFuture.EffectiveTime)

                        Assert-MockCalled -CommandName Add-KdsRootKey -Scope It -Exactly -Times 1
                    }
                }
            }
        }
        #endregion Function Set-TargetResource
    }
}
finally
{
    Invoke-TestCleanup
}
