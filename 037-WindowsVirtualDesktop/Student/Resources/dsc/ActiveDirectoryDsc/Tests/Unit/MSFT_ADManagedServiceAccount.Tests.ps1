Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath '..\TestHelpers\ActiveDirectoryDsc.TestHelper.psm1')

if (-not (Test-RunForCITestCategory -Type 'Unit' -Category 'Tests'))
{
    return
}

$script:dscModuleName = 'ActiveDirectoryDsc'
$script:dscResourceName = 'MSFT_ADManagedServiceAccount'

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
            $memStream.Position=0
            $formatter.Deserialize($memStream)
        }

        $mockPath               = 'OU=Fake,DC=contoso,DC=com'
        $mockDomainController   = 'MockDC'

        $mockCredentials        = New-Object -TypeName 'System.Management.Automation.PSCredential' -ArgumentList @(
            'DummyUser',
            (ConvertTo-SecureString -String 'DummyPassword' -AsPlainText -Force)
        )

        $mockADUSer = @{
            SamAccountName    = 'User1'
            DistinguishedName = 'CN=User1,OU=Fake,DC=contoso,DC=com'
            Enabled           = $true
            SID               = 'S-1-5-21-1409167834-891301383-2860967316-1142'
            ObjectGUID        = '91bffe90-4c84-4026-b1fc-d03671ff56ab'
            GivenName         = ''
            Name              = 'User1'
        }

        $mockADComputer = @{
            SamAccountName    = 'Node1$'
            DistinguishedName = 'CN=Node1,OU=Fake,DC=contoso,DC=com'
            Enabled           = $true
            SID               = 'S-1-5-21-1409167834-891301383-2860967316-1143'
            ObjectClass       = 'computer'
            ObjectGUID        = '91bffe90-4c84-4026-b1fc-d03671ff56ac'
            DnsHostName       = 'Node1.fake.contoso.com'
        }

        $mockSingleServiceAccount = @{
            Name              = 'TestSMSA'
            DistinguishedName = "CN={0},{1}" -f ('TestSMSA', $mockPath)
            Description       = 'Dummy single service account for unit testing'
            DisplayName       = ''
            ObjectClass       = 'msDS-ManagedServiceAccount'
            Enabled           = $true
            SamAccountName    = 'TestSMSA'
            SID               = 'S-1-5-21-1409167834-891301383-2860967316-1144'
            ObjectGUID        = '91bffe90-4c84-4026-b1fc-d03671ff56ad'
        }

        $mockGroupServiceAccount = @{
            Name              = 'TestGMSA'
            DistinguishedName = "CN={0},{1}" -f ('TestGMSA', $mockPath)
            Description       = 'Dummy group service account for unit testing'
            DisplayName       = ''
            ObjectClass       = 'msDS-GroupManagedServiceAccount'
            Enabled           = $true
            SID               = 'S-1-5-21-1409167834-891301383-2860967316-1145'
            ObjectGUID        = '91bffe90-4c84-4026-b1fc-d03671ff56ae'
            PrincipalsAllowedToRetrieveManagedPassword = @($mockADUSer.SamAccountName, $mockADComputer.SamAccountName)
        }

        $mockGetSingleServiceAccount = @{
            ServiceAccountName  = $mockSingleServiceAccount.Name
            DistinguishedName   = $mockSingleServiceAccount.DistinguishedName
            Path                = $mockPath
            Description         = $mockSingleServiceAccount.Description
            DisplayName         = $mockSingleServiceAccount.DisplayName
            AccountType         = 'Single'
            AccountTypeForce    = $false
            Ensure              = 'Present'
            Enabled             = $true
            Members             = @()
            MembershipAttribute = 'sAMAccountName'
            Credential          = $mockCredentials
            DomainController    = $mockDomainController
        }

        $mockGetGroupServiceAccount = @{
            ServiceAccountName  = $mockGroupServiceAccount.Name
            DistinguishedName   = $mockGroupServiceAccount.DistinguishedName
            Path                = $mockPath
            Description         = $mockGroupServiceAccount.Description
            DisplayName         = $mockGroupServiceAccount.DisplayName
            AccountType         = 'Group'
            AccountTypeForce    = $false
            Ensure              = 'Present'
            Enabled             = $true
            Members             = $mockGroupServiceAccount.PrincipalsAllowedToRetrieveManagedPassword
            MembershipAttribute = 'sAMAccountName'
            Credential          = $mockCredentials
            DomainController    = $mockDomainController
        }

        $mockCompareSingleServiceAccount = @(
            [pscustomobject] @{
                Parameter = 'ServiceAccountName'
                Expected  = $mockGetSingleServiceAccount.ServiceAccountName
                Actual    = $mockGetSingleServiceAccount.ServiceAccountName
                Pass      = $true
            }
            [pscustomobject] @{
                Parameter = 'AccountType'
                Expected  = $mockGetSingleServiceAccount.AccountType
                Actual    = $mockGetSingleServiceAccount.AccountType
                Pass      = $true
            }
            [pscustomobject] @{
                Parameter = 'AccountTypeForce'
                Expected  = $mockGetSingleServiceAccount.AccountTypeForce
                Actual    = $mockGetSingleServiceAccount.AccountTypeForce
                Pass      = $true
            }
            [pscustomobject] @{
                Parameter = 'Path'
                Expected  = $mockGetSingleServiceAccount.Path
                Actual    = $mockGetSingleServiceAccount.Path
                Pass      = $true
            }
            [pscustomobject] @{
                Parameter = 'Ensure'
                Expected  = $mockGetSingleServiceAccount.Ensure
                Actual    = $mockGetSingleServiceAccount.Ensure
                Pass      = $true
            }
            [pscustomobject] @{
                Parameter = 'Enabled'
                Expected  = $mockGetSingleServiceAccount.Enabled
                Actual    = $mockGetSingleServiceAccount.Enabled
                Pass      = $true
            }
            [pscustomobject] @{
                Parameter = 'Description'
                Expected  = $mockGetSingleServiceAccount.Description
                Actual    = $mockGetSingleServiceAccount.Description
                Pass      = $true
            }
            [pscustomobject] @{
                Parameter = 'DisplayName'
                Expected  = $mockGetSingleServiceAccount.DisplayName
                Actual    = $mockGetSingleServiceAccount.DisplayName
                Pass      = $true
            }
            [pscustomobject] @{
                Parameter = 'DistinguishedName'
                Expected  = $mockGetSingleServiceAccount.DistinguishedName
                Actual    = $mockGetSingleServiceAccount.DistinguishedName
                Pass      = $true
            }
            [pscustomobject] @{
                Parameter = 'MembershipAttribute'
                Expected  = $mockGetSingleServiceAccount.MembershipAttribute
                Actual    = $mockGetSingleServiceAccount.MembershipAttribute
                Pass      = $true
            }
            [pscustomobject] @{
                Parameter = 'Credential'
                Expected  = $mockGetSingleServiceAccount.Credential
                Actual    = $mockGetSingleServiceAccount.Credential
                Pass      = $true
            }
            [pscustomobject] @{
                Parameter = 'DomainController'
                Expected  = $mockGetSingleServiceAccount.DomainController
                Actual    = $mockGetSingleServiceAccount.DomainController
                Pass      = $true
            }
        )

        $mockCompareGroupServiceAccount = @(
            [pscustomobject] @{
                Parameter = 'ServiceAccountName'
                Expected  = $mockGetGroupServiceAccount.ServiceAccountName
                Actual    = $mockGetGroupServiceAccount.ServiceAccountName
                Pass      = $true
            }
            [pscustomobject] @{
                Parameter = 'AccountType'
                Expected  = $mockGetGroupServiceAccount.AccountType
                Actual    = $mockGetGroupServiceAccount.AccountType
                Pass      = $true
            }
            [pscustomobject] @{
                Parameter = 'AccountTypeForce'
                Expected  = $mockGetGroupServiceAccount.AccountTypeForce
                Actual    = $mockGetGroupServiceAccount.AccountTypeForce
                Pass      = $true
            }
            [pscustomobject] @{
                Parameter = 'Path'
                Expected  = $mockGetGroupServiceAccount.Path
                Actual    = $mockGetGroupServiceAccount.Path
                Pass      = $true
            }
            [pscustomobject] @{
                Parameter = 'Ensure'
                Expected  = $mockGetGroupServiceAccount.Ensure
                Actual    = $mockGetGroupServiceAccount.Ensure
                Pass      = $true
            }
            [pscustomobject] @{
                Parameter = 'Enabled'
                Expected  = $mockGetGroupServiceAccount.Enabled
                Actual    = $mockGetGroupServiceAccount.Enabled
                Pass      = $true
            }
            [pscustomobject] @{
                Parameter = 'Description'
                Expected  = $mockGetGroupServiceAccount.Description
                Actual    = $mockGetGroupServiceAccount.Description
                Pass      = $true
            }
            [pscustomobject] @{
                Parameter = 'DisplayName'
                Expected  = $mockGetGroupServiceAccount.DisplayName
                Actual    = $mockGetGroupServiceAccount.DisplayName
                Pass      = $true
            }
            [pscustomobject] @{
                Parameter = 'Members'
                Expected  = $mockGetGroupServiceAccount.Members
                Actual    = $mockGetGroupServiceAccount.Members
                Pass      = $true
            }
            [pscustomobject] @{
                Parameter = 'Credential'
                Expected  = $mockGetGroupServiceAccount.MembershipAttribute
                Actual    = $mockGetGroupServiceAccount.MembershipAttribute
                Pass      = $true
            }
            [pscustomobject] @{
                Parameter = 'DistinguishedName'
                Expected  = $mockGetGroupServiceAccount.DistinguishedName
                Actual    = $mockGetGroupServiceAccount.DistinguishedName
                Pass      = $true
            }
            [pscustomobject] @{
                Parameter = 'Credential'
                Expected  = $mockGetGroupServiceAccount.Credential
                Actual    = $mockGetGroupServiceAccount.Credential
                Pass      = $true
            }
            [pscustomobject] @{
                Parameter = 'DomainController'
                Expected  = $mockGetGroupServiceAccount.DomainController
                Actual    = $mockGetGroupServiceAccount.DomainController
                Pass      = $true
            }
        )

        #region Function Get-TargetResource
        Describe -Name 'MSFT_ADManagedServiceAccount\Get-TargetResource' -Tag 'Get' {
            BeforeAll {
                Mock -CommandName Assert-Module -ParameterFilter {
                    $ModuleName -eq 'ActiveDirectory'
                }

                Mock -CommandName Get-ADObjectParentDN -MockWith {
                    return $mockPath
                }
            }

            Context 'When the system uses specific parameters' {
                Mock -CommandName Get-ADServiceAccount -MockWith {
                    return $mockSingleServiceAccount
                }

                It 'Should call "Assert-Module" to check AD module is installed' {
                    $testResourceParametersSingle = @{
                        ServiceAccountName = $mockSingleServiceAccount.Name
                    }

                    { Get-TargetResource @testResourceParametersSingle } | Should -Not -Throw

                    Assert-MockCalled -CommandName Assert-Module -ParameterFilter {
                        $ModuleName -eq 'ActiveDirectory'
                    } -Scope It -Exactly -Times 1
                }

                It 'Should call "Get-ADServiceAccount" with "Server" parameter when "DomainController" specified' {
                    $testResourceParametersWithServer = @{
                        ServiceAccountName = $mockSingleServiceAccount.Name
                        DomainController   = $mockDomainController
                    }

                    { Get-TargetResource @testResourceParametersWithServer } | Should -Not -Throw

                    Assert-MockCalled -CommandName Get-ADServiceAccount -ParameterFilter {
                        $Server -eq $mockDomainController
                    } -Scope It -Exactly -Times 1
                }

                It 'Should call "Get-ADServiceAccount" with "Credential" parameter when specified' {
                    $testResourceParametersWithCredentials = @{
                        ServiceAccountName = $mockSingleServiceAccount.Name
                        Credential         = $mockCredentials
                    }

                    { Get-TargetResource @testResourceParametersWithCredentials } | Should -Not -Throw

                    Assert-MockCalled -CommandName Get-ADServiceAccount -ParameterFilter {
                        $Credential -eq $mockCredentials
                    } -Scope It -Exactly -Times 1
                }
            }

            Context 'When system cannot connect to domain or other errors' {
                Mock -CommandName Get-ADServiceAccount -MockWith {
                    throw 'Microsoft.ActiveDirectory.Management.ADServerDownException'
                }

                It 'Should call "Get-ADServiceAccount" and throw an error when catching any other errors besides "Account Not Found"'{
                    $getTargetResourceParameters = @{
                        ServiceAccountName = $mockSingleServiceAccount.Name
                    }

                    { Get-TargetResource  @getTargetResourceParameters -ErrorAction 'SilentlyContinue' } |
                        Should -Throw ($script:localizedData.RetrievingServiceAccountError -f $getTargetResourceParameters.ServiceAccountName)
                }
            }

            Context 'When the system is in desired state (sMSA)' {
                Mock -CommandName Get-ADServiceAccount -ParameterFilter {
                    $mockSingleServiceAccount.Name -eq $Identity
                } -MockWith {
                    Write-Verbose "Call Get-ADServiceAccount with $($mockSingleServiceAccount.Name)"
                    return $mockSingleServiceAccount
                }

                It 'Should mock call to Get-ADServiceAccount return identical information' {
                    $testResourceParametersSingle = @{
                        ServiceAccountName = $mockSingleServiceAccount.Name
                    }

                    $getTargetResourceResult = Get-TargetResource @testResourceParametersSingle

                    $getTargetResourceResult.ServiceAccountName | Should -Be $mockSingleServiceAccount.Name
                    $getTargetResourceResult.Ensure | Should -Be 'Present'
                    $getTargetResourceResult.AccountType | Should -Be 'Single'
                    $getTargetResourceResult.Description | Should -Be $mockSingleServiceAccount.Description
                    $getTargetResourceResult.DisplayName | Should -Be $mockSingleServiceAccount.DisplayName
                    $getTargetResourceResult.Members | Should -Be @()
                    $getTargetResourceResult.Path | Should -Be $mockPath
                }
            }

            Context 'When the system is in desired state (gMSA)' {
                Mock -CommandName Get-ADServiceAccount -ParameterFilter {
                    $mockGroupServiceAccount.Name -eq $Identity
                } -MockWith {
                    Write-Verbose "Call Get-ADServiceAccount with $($mockGroupServiceAccount.Name)"
                    return $mockGroupServiceAccount
                }

                Mock -CommandName Get-ADObject -ParameterFilter {
                    $mockADComputer.SamAccountName -eq $Identity
                } -MockWith {
                    Write-Verbose "Call Get-ADObject with $($mockADComputer.SamAccountName)"
                    return $mockADComputer
                }

                Mock -CommandName Get-ADObject -ParameterFilter {
                    $mockADUSer.SamAccountName -eq $Identity
                } -MockWith {
                    Write-Verbose "Call Get-ADObject with $($mockADUser.SamAccountName)"
                    return $mockADUser
                }

                It 'Should mock call to Get-ADServiceAccount return identical information' {
                    $testResourceParametersGroup = @{
                        ServiceAccountName  = $mockGroupServiceAccount.Name
                        MembershipAttribute = 'SamAccountName'
                    }

                    $getTargetResourceResult = Get-TargetResource @testResourceParametersGroup

                    $getTargetResourceResult.ServiceAccountName | Should -Be $mockGroupServiceAccount.Name
                    $getTargetResourceResult.Ensure | Should -Be 'Present'
                    $getTargetResourceResult.AccountType | Should -Be 'Group'
                    $getTargetResourceResult.Description | Should -Be $mockGroupServiceAccount.Description
                    $getTargetResourceResult.DisplayName | Should -Be $mockGroupServiceAccount.DisplayName
                    $getTargetResourceResult.Members | Should -Be `
                        @($mockADUSer.($testResourceParametersGroup.MembershipAttribute), `
                          $mockADComputer.($testResourceParametersGroup.MembershipAttribute))
                    $getTargetResourceResult.Path | Should -Be $mockPath
                }
            }

            Context -Name 'When the system is NOT in the desired state (Both)' {
                Mock -CommandName Get-ADServiceAccount -MockWith {
                    throw New-Object Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException
                }

                $testResourceParametersSingle = @{
                    ServiceAccountName = $mockSingleServiceAccount.Name
                }

                $getTargetResourceResult = Get-TargetResource @testResourceParametersSingle

                It "Should return 'Ensure' is 'Absent'" {
                    $getTargetResourceResult.Ensure | Should -Be 'Absent'
                }

                It "Should return 'ServiceAccountName' when 'Absent'" {
                    $getTargetResourceResult.ServiceAccountName | Should -Not -BeNullOrEmpty
                    $getTargetResourceResult.ServiceAccountName | Should -BeExactly $testResourceParametersSingle.ServiceAccountName
                }
            }
        }
        #endregion Function Get-TargetResource

        #region Function Compare-TargetResourceState
        Describe -Name 'MSFT_ADManagedServiceAccount\Compare-TargetResourceState' -Tag 'Compare' {
            Context -Name 'When the system is in the desired state (sMSA)' {
                Mock -CommandName Get-TargetResource -ParameterFilter {
                    $mockSingleServiceAccount.Name -eq $ServiceAccountName
                } -MockWith {
                    Write-Verbose "Calling Get-TargetResource with $($mockSingleServiceAccount.Name)"
                    return $mockGetSingleServiceAccount
                }

                $testResourceParametersSingle = @{
                    ServiceAccountName = $mockSingleServiceAccount.Name
                    AccountType        = 'Single'
                    Path               = $mockPath
                    Description        = $mockSingleServiceAccount.Description
                    Ensure             = 'Present'
                    DisplayName        = $mockSingleServiceAccount.DisplayName
                }

                $getTargetResourceResult = Compare-TargetResourceState @testResourceParametersSingle
                $testCases = @()
                $getTargetResourceResult | ForEach-Object {
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

            Context -Name 'When the system is in the desired state (gMSA)' {
                Mock -CommandName Get-TargetResource -ParameterFilter {
                    $mockGroupServiceAccount.Name -eq $ServiceAccountName -and $MembershipAttribute -eq 'SamAccountName'
                } -MockWith {
                    Write-Verbose 'Group MSA using sAMAccountName'
                    return $mockGetGroupServiceAccount
                }

                $mockGetGroupServiceAccountDN = $mockGetGroupServiceAccount.Clone()
                $mockGetGroupServiceAccountDN['MembershipAttribute'] = 'DistinguishedName'
                $mockGetGroupServiceAccountDN['Members'] = @($mockADUSer.DistinguishedName, $mockADComputer.DistinguishedName)
                Mock -CommandName Get-TargetResource -ParameterFilter {
                    $mockGroupServiceAccount.Name -eq $ServiceAccountName -and $MembershipAttribute -eq 'DistinguishedName'
                } -MockWith {
                    Write-Verbose 'Group MSA using DistinguishedName'
                    return $mockGetGroupServiceAccountDN
                }

                $mockGetGroupServiceAccountSID = $mockGetGroupServiceAccount.Clone()
                $mockGetGroupServiceAccountSID['MembershipAttribute'] = 'SID'
                $mockGetGroupServiceAccountSID['Members'] = @($mockADUSer.SID, $mockADComputer.SID)
                Mock -CommandName Get-TargetResource -ParameterFilter {
                    $mockGroupServiceAccount.Name -eq $ServiceAccountName -and $MembershipAttribute -eq 'SID'
                } -MockWith {
                    Write-Verbose 'Group MSA using SID'
                    return $mockGetGroupServiceAccountSID
                }

                $mockGetGroupServiceAccountOID = $mockGetGroupServiceAccount.Clone()
                $mockGetGroupServiceAccountOID['MembershipAttribute'] = 'ObjectGUID'
                $mockGetGroupServiceAccountOID['Members'] = @($mockADUSer.ObjectGUID, $mockADComputer.ObjectGUID)
                Mock -CommandName Get-TargetResource -ParameterFilter {
                    $mockGroupServiceAccount.Name -eq $ServiceAccountName -and $MembershipAttribute -eq 'ObjectGUID'
                } -MockWith {
                    Write-Verbose 'Group MSA using ObjectGUID'
                    return $mockGetGroupServiceAccountOID
                }

                $testResourceParametersGroup = @{
                    ServiceAccountName  = $mockGroupServiceAccount.Name
                    MembershipAttribute = 'SamAccountName'
                    AccountType         = 'Group'
                    Path                = $mockPath
                    Description         = $mockGroupServiceAccount.Description
                    Ensure              = 'Present'
                    Members             = 'Node1$', 'User1'
                    DisplayName         = $mockGroupServiceAccount.DisplayName
                }

                $getTargetResourceResult = Compare-TargetResourceState @testResourceParametersGroup
                $testCases = @()
                $getTargetResourceResult | ForEach-Object {
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

                It "Should return identical information for 'Members' when using 'SamAccountName'" {
                    $testResourceParametersGroupSAM = @{
                        ServiceAccountName  = $mockGroupServiceAccount.Name
                        MembershipAttribute = 'SamAccountName'
                        Members             = 'Node1$', 'User1'
                        AccountType         = 'Group'
                    }

                    $getTargetResourceResultSAM  = Compare-TargetResourceState @testResourceParametersGroupSAM

                    $getTargetResourceResultSAM.Expected | Should -BeExactly $getTargetResourceResultSAM.Actual
                    $getTargetResourceResultSAM.Pass | Should -BeTrue
                }

                It "Should return identical information for 'Members' when using 'DistinguishedName'" {
                    $testResourceParametersGroupDN = @{
                        ServiceAccountName  = $mockGroupServiceAccount.Name
                        MembershipAttribute = 'DistinguishedName'
                        Members             = 'CN=Node1,OU=Fake,DC=contoso,DC=com', 'CN=User1,OU=Fake,DC=contoso,DC=com'
                        AccountType         = 'Group'
                    }

                    $getTargetResourceResultDN  = Compare-TargetResourceState @testResourceParametersGroupDN

                    $getTargetResourceResultDN.Expected | Should -BeExactly $getTargetResourceResultDN.Actual
                    $getTargetResourceResultDN.Pass | Should -BeTrue
                }

                It "Should return identical information for 'Members' when using 'SID'" {
                    $testResourceParametersGroupSID = @{
                        ServiceAccountName  = $mockGroupServiceAccount.Name
                        MembershipAttribute = 'SID'
                        Members             = 'S-1-5-21-1409167834-891301383-2860967316-1143', 'S-1-5-21-1409167834-891301383-2860967316-1142'
                        AccountType         = 'Group'
                    }

                    $getTargetResourceResultSID  = Compare-TargetResourceState @testResourceParametersGroupSID

                    $getTargetResourceResultSID.Expected | Should -BeExactly $getTargetResourceResultSID.Actual
                    $getTargetResourceResultSID.Pass | Should -BeTrue
                }

                It "Should return identical information for 'Members' when using 'ObjectGUID'" {
                    $testResourceParametersGroupGUID = @{
                        ServiceAccountName  = $mockGroupServiceAccount.Name
                        MembershipAttribute = 'ObjectGUID'
                        Members             = '91bffe90-4c84-4026-b1fc-d03671ff56ac', '91bffe90-4c84-4026-b1fc-d03671ff56ab'
                        AccountType         = 'Group'
                    }

                    $getTargetResourceResultGUID  = Compare-TargetResourceState @testResourceParametersGroupGUID

                    $getTargetResourceResultGUID.Expected | Should -BeExactly $getTargetResourceResultGUID.Actual
                    $getTargetResourceResultGUID.Pass | Should -BeTrue
                }
            }

            Context -Name 'When the system is NOT in the desired state (sMSA)' {
                Mock -CommandName Get-TargetResource -ParameterFilter {
                    $mockSingleServiceAccount.Name -eq $ServiceAccountName
                } -MockWith {
                    return $mockGetSingleServiceAccount
                }

                $testResourceParametersSingleNotCompliant = @{
                    ServiceAccountName = $mockSingleServiceAccount.Name
                    AccountType        = 'Group'
                    Path               = 'OU=FakeWrong,DC=contoso,DC=com'
                    Description        = 'Test MSA description Wrong'
                    Ensure             = 'Absent'
                    DisplayName        = 'WrongDisplayName'
                }

                $getTargetResourceResult = Compare-TargetResourceState @testResourceParametersSingleNotCompliant
                $testCases = @()
                # Need to remove parameters that will always be true
                $getTargetResourceResult = $getTargetResourceResult | Where-Object -FilterScript {
                    $_.Parameter -ne 'ServiceAccountName' -and
                    $_.Parameter -ne 'DistinguishedName' -and
                    $_.Parameter -ne 'MembershipAttribute'
                }

                $getTargetResourceResult | ForEach-Object {
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

            Context -Name 'When the system is NOT in the desired state (gMSA)' {
                Mock -CommandName Get-TargetResource -ParameterFilter {
                    $mockGroupServiceAccount.Name -eq $ServiceAccountName -and $MembershipAttribute -eq 'SamAccountName'
                } -MockWith {
                    Write-Verbose 'Group MSA using sAMAccountName'
                    return $mockGetGroupServiceAccount
                }

                $mockGetGroupServiceAccountDN = $mockGetGroupServiceAccount.Clone()
                $mockGetGroupServiceAccountDN['MembershipAttribute'] = 'DistinguishedName'
                $mockGetGroupServiceAccountDN['Members'] = @($mockADUSer.DistinguishedName, $mockADComputer.DistinguishedName)
                Mock -CommandName Get-TargetResource -ParameterFilter {
                    $mockGroupServiceAccount.Name -eq $ServiceAccountName -and $MembershipAttribute -eq 'DistinguishedName'
                } -MockWith {
                    Write-Verbose 'Group MSA using DistinguishedName'
                    return $mockGetGroupServiceAccountDN
                }

                $mockGetGroupServiceAccountSID = $mockGetGroupServiceAccount.Clone()
                $mockGetGroupServiceAccountSID['MembershipAttribute'] = 'SID'
                $mockGetGroupServiceAccountSID['Members'] = @($mockADUSer.SID, $mockADComputer.SID)
                Mock -CommandName Get-TargetResource -ParameterFilter {
                    $mockGroupServiceAccount.Name -eq $ServiceAccountName -and $MembershipAttribute -eq 'SID'
                } -MockWith {
                    Write-Verbose 'Group MSA using SID'
                    return $mockGetGroupServiceAccountSID
                }

                $mockGetGroupServiceAccountOID = $mockGetGroupServiceAccount.Clone()
                $mockGetGroupServiceAccountOID['MembershipAttribute'] = 'ObjectGUID'
                $mockGetGroupServiceAccountOID['Members'] = @($mockADUSer.ObjectGUID, $mockADComputer.ObjectGUID)
                Mock -CommandName Get-TargetResource -ParameterFilter {
                    $mockGroupServiceAccount.Name -eq $ServiceAccountName -and $MembershipAttribute -eq 'ObjectGUID'
                } -MockWith {
                    Write-Verbose 'Group MSA using ObjectGUID'
                    return $mockGetGroupServiceAccountOID
                }

                $testResourceParametersGroup = @{
                    ServiceAccountName   = $mockGroupServiceAccount.Name
                    AccountType          = 'Single'
                    Path                 = 'OU=FakeWrong,DC=contoso,DC=com'
                    Description          = 'Test MSA description Wrong'
                    Ensure               = 'Absent'
                    DisplayName          = 'WrongDisplayName'
                    MembershipAttribute = 'SamAccountName'
                }

                $getTargetResourceResult = Compare-TargetResourceState @testResourceParametersGroup
                $testCases = @()
                # Need to remove parameters that will always be true
                $getTargetResourceResult = $getTargetResourceResult | Where-Object -FilterScript {
                    $_.Parameter -ne 'ServiceAccountName' -and
                    $_.Parameter -ne 'DistinguishedName' -and
                    $_.Parameter -ne 'MembershipAttribute'
                }
                $getTargetResourceResult | ForEach-Object {
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

                It "Should return false for 'Members' when using 'SamAccountName'" {
                    $testResourceParametersGroupSAM = @{
                        ServiceAccountName  = $mockGroupServiceAccount.Name
                        MembershipAttribute = 'SamAccountName'
                        Members             = 'Node1$'
                        AccountType         = 'Group'
                    }

                    $getTargetResourceResultSAM  = Compare-TargetResourceState @testResourceParametersGroupSAM

                    $membersState = $getTargetResourceResultSAM | Where-Object -FilterScript {$_.Parameter -eq 'Members'}
                    $membersState.Expected | Should -Not -BeExactly $membersState.Actual
                    $membersState.Pass | Should -BeFalse
                }

                It "Should return false for 'Members' when using 'DistinguishedName'" {
                    $testResourceParametersGroupDN = @{
                        ServiceAccountName  = $mockGroupServiceAccount.Name
                        MembershipAttribute = 'DistinguishedName'
                        Members             = 'CN=Node1,OU=Fake,DC=contoso,DC=com'
                        AccountType         = 'Group'
                    }

                    $getTargetResourceResultDN  = Compare-TargetResourceState @testResourceParametersGroupDN

                    $membersState = $getTargetResourceResultDN | Where-Object -FilterScript {$_.Parameter -eq 'Members'}
                    $membersState.Expected | Should -Not -BeExactly $membersState.Actual
                    $membersState.Pass | Should -BeFalse
                }

                It "Should return false for 'Members' when using 'SID'" {
                    $testResourceParametersGroupSID = @{
                        ServiceAccountName  = $mockGroupServiceAccount.Name
                        MembershipAttribute = 'SID'
                        Members             = 'S-1-5-21-1409167834-891301383-2860967316-1143'
                        AccountType         = 'Group'
                    }

                    $getTargetResourceResultSID  = Compare-TargetResourceState @testResourceParametersGroupSID

                    $membersState = $getTargetResourceResultSID | Where-Object -FilterScript {$_.Parameter -eq 'Members'}
                    $membersState.Expected | Should -Not -BeExactly $membersState.Actual
                    $membersState.Pass | Should -BeFalse
                }

                It "Should return false for 'Members' when using 'ObjectGUID'" {
                    $testResourceParametersGroupGUID = @{
                        ServiceAccountName  = $mockGroupServiceAccount.Name
                        MembershipAttribute = 'ObjectGUID'
                        Members             = '91bffe90-4c84-4026-b1fc-d03671ff56ac'
                        AccountType         = 'Group'
                    }

                    $getTargetResourceResultGUID  = Compare-TargetResourceState @testResourceParametersGroupGUID

                    $membersState = $getTargetResourceResultGUID | Where-Object -FilterScript {$_.Parameter -eq 'Members'}
                    $membersState.Expected | Should -Not -BeExactly $membersState.Actual
                    $membersState.Pass | Should -BeFalse
                }
            }
        }
        #endregion Function Compare-TargetResourceState

        #region Function Test-TargetResource
        Describe -Name 'MSFT_ADManagedServiceAccount\Test-TargetResource' -Tag 'Test' {
            Context -Name "When the system is in the desired state and 'Ensure' is 'Present' (sMSA)" {
                It "Should pass when the Parameters are properly set" {
                    Mock -CommandName Compare-TargetResourceState -ParameterFilter {
                        $mockSingleServiceAccount.Name -eq $ServiceAccountName
                    } -MockWith {
                        Write-Verbose "Calling Compare-TargetResourceState with $($mockSingleServiceAccount.Name)"
                        return $mockCompareSingleServiceAccount
                    }

                    $testResourceParametersSingle = @{
                        ServiceAccountName = $mockSingleServiceAccount.Name
                        AccountType        = 'Single'
                        Path               = $mockPath
                        Description        = $mockSingleServiceAccount.Description
                        Ensure             = 'Present'
                        DisplayName        = ''
                    }

                    Test-TargetResource @testResourceParametersSingle | Should -BeTrue
                }
            }

            Context -Name "When the system is in the desired state and 'Ensure' is 'Present' (gMSA)" {
                It "Should pass when the Parameters are properly set" {
                    Mock -CommandName Compare-TargetResourceState -ParameterFilter {
                        $mockGroupServiceAccount.Name -eq $ServiceAccountName
                    } -MockWith {
                        Write-Verbose "Calling Compare-TargetResourceState with $($mockGroupServiceAccount.Name)"
                        return $mockCompareGroupServiceAccount
                    }

                    $testResourceParametersGroup = @{
                        ServiceAccountName  = $mockGroupServiceAccount.Name
                        MembershipAttribute = 'SamAccountName'
                        AccountType         = 'Group'
                        Path                = $mockPath
                        Description         = $mockGroupServiceAccount.Description
                        Ensure              = 'Present'
                        Members             = 'Node1$', 'User1'
                        DisplayName         = ''
                    }

                    Test-TargetResource @testResourceParametersGroup | Should -BeTrue
                }
            }

            Context -Name "When the system is in the desired state and 'Ensure' is 'Absent' (Both)" {
                It "Should pass when 'Ensure' is set to 'Absent" {
                    $mockCompareSingleServiceAccountEnsureAbsent = $mockCompareSingleServiceAccount.Clone()
                    $objectEnsure = $mockCompareSingleServiceAccountEnsureAbsent | Where-Object -FilterScript {$_.Parameter -eq 'Ensure'}
                    $objectEnsure.Actual = 'Absent'
                    $objectEnsure.Pass = $true

                    Mock -CommandName Compare-TargetResourceState -ParameterFilter {
                        $mockSingleServiceAccount.Name -eq $ServiceAccountName
                    } -MockWith {
                        Write-Verbose "Calling Compare-TargetResourceState with $($mockSingleServiceAccount.Name)"
                        return $mockCompareSingleServiceAccountEnsureAbsent
                    }

                    $testResourceParametersSingle = @{
                        ServiceAccountName = $mockSingleServiceAccount.Name
                        Ensure             = 'Absent'
                    }

                    Test-TargetResource @testResourceParametersSingle | Should -BeTrue
                }
            }

            Context -Name "When the system is NOT in the desired state and 'Ensure' is 'Present' (sMSA)" {
                $mockCompareSingleServiceAccountNotCompliant = Copy-ArrayObjects $mockCompareSingleServiceAccount

                $testIncorrectParameters = @{
                    AccountType = 'Group'
                    Path        = 'WrongPath'
                    Description = 'WrongDescription'
                    Ensure      = 'Absent'
                    DisplayName = 'DisplayNameWrong'
                }

                $testCases = @()
                foreach($incorrectParameter in $testIncorrectParameters.GetEnumerator())
                {
                    $objectParameter = $mockCompareSingleServiceAccountNotCompliant | Where-Object -FilterScript { $_.Parameter -eq $incorrectParameter.Name }
                    $objectParameter.Expected = $incorrectParameter.Value
                    $objectParameter.Pass = $false

                    $testCases += @{
                        Parameter = $incorrectParameter.Name
                        Value = $incorrectParameter.Value
                    }
                }

                Mock -CommandName Compare-TargetResourceState -ParameterFilter {
                    $mockSingleServiceAccount.Name -eq $ServiceAccountName
                } -MockWith {
                    Write-Verbose "Calling Compare-TargetResourceState with $($mockSingleServiceAccount.Name)"
                    return $mockCompareSingleServiceAccountNotCompliant
                }

                It "Should return $false when <Parameter> is incorrect" -TestCases $testCases {
                    param
                    (
                        [Parameter()]
                        $Parameter,

                        [Parameter()]
                        $Value
                    )

                    $testResourceParametersSingle = @{
                        ServiceAccountName = $mockSingleServiceAccount.Name
                        AccountType        = 'Single'
                        Path               = $mockPath
                        Description        = $mockSingleServiceAccount.Description
                        Ensure             = 'Present'
                        DisplayName        = ''
                    }

                    $testResourceParametersSingle[$Parameter] = $value
                    Test-TargetResource @testResourceParametersSingle | Should -BeFalse
                }
            }

            Context -Name "When the system is NOT in the desired state and 'Ensure' is 'Present' (gMSA)" {
                $mockCompareGroupServiceAccountNotCompliant = Copy-ArrayObjects $mockCompareGroupServiceAccount

                $testIncorrectParameters = @{
                    AccountType = 'Single'
                    Path        = 'WrongPath'
                    Description = 'WrongDescription'
                    Ensure      = 'Absent'
                    Members     = ''
                    DisplayName = 'DisplayNameWrong'
                }

                $testCases = @()
                foreach($incorrectParameter in $testIncorrectParameters.GetEnumerator())
                {
                    $objectParameter = $mockCompareGroupServiceAccountNotCompliant | Where-Object -FilterScript { $_.Parameter -eq $incorrectParameter.Name }
                    $objectParameter.Expected = $incorrectParameter.Value
                    $objectParameter.Pass = $false

                    $testCases += @{
                        Parameter = $incorrectParameter.Name
                        Value = $incorrectParameter.Value
                    }
                }

                Mock -CommandName Compare-TargetResourceState -ParameterFilter {
                    $mockGroupServiceAccount.Name -eq $ServiceAccountName
                } -MockWith {
                    Write-Verbose "Calling Compare-TargetResourceState with $($mockGroupServiceAccount.Name)"
                    return $mockCompareGroupServiceAccountNotCompliant
                }

                It "Should return $false when <Parameter> is incorrect" -TestCases $testCases {
                    param
                    (
                        [Parameter()]
                        $Parameter,

                        [Parameter()]
                        $Value
                    )

                    $testResourceParametersGroup = @{
                        ServiceAccountName  = $mockGroupServiceAccount.Name
                        MembershipAttribute = 'SamAccountName'
                        AccountType         = 'Group'
                        Path                = $mockPath
                        Description         = $mockGroupServiceAccount.Description
                        Ensure              = 'Present'
                        Members             = 'Node1$', 'User1'
                        DisplayName         = ''
                    }

                    $testResourceParametersGroup[$Parameter] = $value
                    Test-TargetResource @testResourceParametersGroup | Should -BeFalse
                }
            }
        }
        #endregion Function Test-TargetResource

        Describe -Name 'MSFT_ADManagedServiceAccount\New-ADServiceAccountHelper' {
            BeforeAll {
                Mock -CommandName New-ADServiceAccount
            }

            Context -Name "When the system is NOT in the desired state and 'Ensure' is 'Present' (sMSA)" {
                $testResourceParametersSingle = @{
                    ServiceAccountName = $mockSingleServiceAccount.Name
                    AccountType        = 'Single'
                    Path               = $mockPath
                    Description        = $mockSingleServiceAccount.Description
                    Ensure             = 'Present'
                    DisplayName        = 'NewDisplayName'
                }

                It 'Should call New-ADServiceAccount' {
                    New-ADServiceAccountHelper @testResourceParametersSingle
                    Assert-MockCalled -CommandName New-ADServiceAccount -Scope It -Exactly -Times 1
                }
            }

            Context -Name "When the system is NOT in the desired state and 'Ensure' is 'Present' (gMSA)" {
                $testResourceParametersGroup = @{
                    ServiceAccountName  = $mockGroupServiceAccount.Name
                    MembershipAttribute = 'SamAccountName'
                    AccountType         = 'Group'
                    Path                = $mockPath
                    Description         = $mockGroupServiceAccount.Description
                    Ensure              = 'Present'
                    Members             = 'Node1$', 'User1'
                    DisplayName         = ''
                }

                It 'Should call New-ADServiceAccount' {
                    New-ADServiceAccountHelper @testResourceParametersGroup
                    Assert-MockCalled -CommandName New-ADServiceAccount -Scope It -Exactly -Times 1
                }
            }
        }

        #region Function Set-TargetResource
        Describe -Name 'MSFT_ADManagedServiceAccount\Set-TargetResource' -Tag 'Set' {
            BeforeAll {
                Mock -CommandName New-ADServiceAccountHelper
                Mock -CommandName Remove-ADServiceAccount
                Mock -CommandName Move-ADObject
                Mock -CommandName Set-ADServiceAccount
            }

            Context -Name "When the system is in the desired state and 'Ensure' is 'Present' (sMSA)" {
                Mock -CommandName Compare-TargetResourceState -ParameterFilter {
                    $mockSingleServiceAccount.Name -eq $ServiceAccountName
                } -MockWith {
                    Write-Verbose "Calling Compare-TargetResourceState with $($mockSingleServiceAccount.Name)"
                    return $mockCompareSingleServiceAccount
                }

                $testResourceParametersSingle = @{
                    ServiceAccountName = $mockSingleServiceAccount.Name
                    AccountType        = 'Single'
                    Path               = $mockPath
                    Description        = $mockSingleServiceAccount.Description
                    Ensure             = 'Present'
                    DisplayName        = ''
                }

                It 'Should NOT take any action when all parameters are correct' {
                    Set-TargetResource @testResourceParametersSingle

                    Assert-MockCalled -CommandName Compare-TargetResourceState -Scope It -Times 1
                    Assert-MockCalled -CommandName New-ADServiceAccountHelper -Scope It -Times 0
                    Assert-MockCalled -CommandName Remove-ADServiceAccount -Scope It -Exactly -Times 0
                    Assert-MockCalled -CommandName Move-ADObject -Scope It -Exactly -Times 0
                    Assert-MockCalled -CommandName Set-ADServiceAccount -Scope It -Exactly -Times 0
                }
            }

            Context -Name "When the system is in the desired state and 'Ensure' is 'Present' (gMSA)" {
                Mock -CommandName Compare-TargetResourceState -ParameterFilter {
                    $mockGroupServiceAccount.Name -eq $ServiceAccountName
                } -MockWith {
                    Write-Verbose "Calling Compare-TargetResourceState with $($mockGroupServiceAccount.Name)"
                    return $mockCompareGroupServiceAccount
                }

                $testResourceParametersGroup = @{
                    ServiceAccountName  = $mockGroupServiceAccount.Name
                    MembershipAttribute = 'SamAccountName'
                    AccountType         = 'Group'
                    Path                = $mockPath
                    Description         = $mockGroupServiceAccount.Description
                    Ensure              = 'Present'
                    Members             = 'Node1$', 'User1'
                    DisplayName         = ''
                }

                It 'Should NOT take any action when all parameters are correct' {
                    Set-TargetResource @testResourceParametersGroup

                    Assert-MockCalled -CommandName Compare-TargetResourceState -Scope It -Times 1
                    Assert-MockCalled -CommandName New-ADServiceAccountHelper -Scope It -Times 0
                    Assert-MockCalled -CommandName Remove-ADServiceAccount -Scope It -Exactly -Times 0
                    Assert-MockCalled -CommandName Move-ADObject -Scope It -Exactly -Times 0
                    Assert-MockCalled -CommandName Set-ADServiceAccount -Scope It -Exactly -Times 0
                }
            }

            Context -Name "When the system is in the desired state and 'Ensure' is 'Absent' (Both)" {
                $mockCompareSingleServiceAccountEnsureAbsent = $mockCompareSingleServiceAccount.Clone()
                $objectEnsure = $mockCompareSingleServiceAccountEnsureAbsent | Where-Object -FilterScript {$_.Parameter -eq 'Ensure'}
                $objectEnsure.Actual = 'Absent'
                $objectEnsure.Pass = $true

                Mock -CommandName Compare-TargetResourceState -ParameterFilter {
                    $mockSingleServiceAccount.Name -eq $ServiceAccountName
                } -MockWith {
                    Write-Verbose "Calling Compare-TargetResourceState with $($mockSingleServiceAccount.Name)"
                    return $mockCompareSingleServiceAccountEnsureAbsent
                }

                $testResourceParametersSingle = @{
                    ServiceAccountName = $mockSingleServiceAccount.Name
                    Ensure             = 'Absent'
                }

                It "Should pass when 'Ensure' is set to 'Absent" {
                    Set-TargetResource @testResourceParametersSingle

                    Assert-MockCalled -CommandName Compare-TargetResourceState -Scope It -Times 1
                    Assert-MockCalled -CommandName New-ADServiceAccountHelper -Scope It -Times 0
                    Assert-MockCalled -CommandName Remove-ADServiceAccount -Scope It -Exactly -Times 0
                    Assert-MockCalled -CommandName Move-ADObject -Scope It -Exactly -Times 0
                    Assert-MockCalled -CommandName Set-ADServiceAccount -Scope It -Exactly -Times 0
                }
            }

            Context -Name "When the system is NOT in the desired state and 'Ensure' is 'Present' (sMSA)" {
                $mockCompareSingleServiceAccountNotCompliantPath = Copy-ArrayObjects $mockCompareSingleServiceAccount
                $mockCompareSingleServiceAccountNotCompliantOtherParameters = Copy-ArrayObjects $mockCompareSingleServiceAccount
                $mockCompareSingleServiceAccountNotCompliantAccountType = Copy-ArrayObjects $mockCompareSingleServiceAccount
                $mockCompareSingleServiceAccountNotCompliantEnsure = Copy-ArrayObjects $mockCompareSingleServiceAccount

                #region Incorrect Path setup
                $objectPath = $mockCompareSingleServiceAccountNotCompliantPath | Where-Object -FilterScript {$_.Parameter -eq 'Path'}
                $objectPath.Expected = 'WrongPath'
                $objectPath.Pass = $false

                Mock -CommandName Compare-TargetResourceState -ParameterFilter {
                    $mockSingleServiceAccount.Name -eq $ServiceAccountName -and $Path -eq $objectPath.Expected
                } -MockWith {
                    Write-Verbose "Calling Compare-TargetResourceState with $($mockSingleServiceAccount.Name) and Path '$($objectPath.Expected)'"
                    return $mockCompareSingleServiceAccountNotCompliantPath
                }
                #endregion Incorrect Path setup

                It "Should call 'Move-ADObject' when 'Path' is incorrect" {
                    $testResourceParametersSingle = @{
                        ServiceAccountName = $mockSingleServiceAccount.Name
                        Path               = $objectPath.Expected
                    }

                    Set-TargetResource @testResourceParametersSingle
                    Assert-MockCalled -CommandName Compare-TargetResourceState -Scope It -Times 1
                    Assert-MockCalled -CommandName New-ADServiceAccountHelper -Scope It -Times 0
                    Assert-MockCalled -CommandName Remove-ADServiceAccount -Scope It -Exactly -Times 0
                    Assert-MockCalled -CommandName Move-ADObject -Scope It -Exactly -Times 1
                    Assert-MockCalled -CommandName Set-ADServiceAccount -Scope It -Exactly -Times 0
                }

                #region Incorrect parameter test setup
                $testIncorrectParameters = @{
                    Description = 'WrongDescription'
                    DisplayName = 'WrongDisplayName'
                }

                $testCases = @()
                foreach($incorrectParameter in $testIncorrectParameters.GetEnumerator())
                {
                    $objectParameter = $mockCompareSingleServiceAccountNotCompliantOtherParameters |
                                            Where-Object -FilterScript { $_.Parameter -eq $incorrectParameter.Name }
                    $objectParameter.Expected = $incorrectParameter.Value
                    $objectParameter.Pass = $false

                    $testCases += @{
                        Parameter = $incorrectParameter.Name
                        Value = $incorrectParameter.Value
                    }
                }

                Mock -CommandName Compare-TargetResourceState -ParameterFilter {
                    $mockSingleServiceAccount.Name -eq $ServiceAccountName -and (
                        $Description -eq $testIncorrectParameters.Description -or
                        $DisplayName -eq $testIncorrectParameters.DisplayName
                    )
                } -MockWith {
                    Write-Verbose "Calling Compare-TargetResourceState with $($mockSingleServiceAccount.Name) and incorrect parameters"
                    return $mockCompareSingleServiceAccountNotCompliantOtherParameters
                }
                #endregion Incorrect parameter test setup

                It "Should call 'Set-ADServiceAccount' when '<Parameter>' is incorrect" -TestCases $testCases {
                    param
                    (
                        [Parameter()]
                        $Parameter,

                        [Parameter()]
                        $Value
                    )

                    $testResourceParametersSingle = @{
                        ServiceAccountName = $mockSingleServiceAccount.Name
                    }
                    $testResourceParametersSingle[$Parameter] = $Value

                    Set-TargetResource @testResourceParametersSingle

                    Assert-MockCalled -CommandName Compare-TargetResourceState -Scope It -Times 1
                    Assert-MockCalled -CommandName New-ADServiceAccountHelper -Scope It -Times 0
                    Assert-MockCalled -CommandName Remove-ADServiceAccount -Scope It -Exactly -Times 0
                    Assert-MockCalled -CommandName Move-ADObject -Scope It -Exactly -Times 0
                    Assert-MockCalled -CommandName Set-ADServiceAccount -Scope It -Exactly -Times 1
                }

                #region Incorrect Account type setup
                $objectAccountType = $mockCompareSingleServiceAccountNotCompliantAccountType | Where-Object -FilterScript {$_.Parameter -eq 'AccountType'}
                $objectAccountType.Expected = 'Group'
                $objectAccountType.Pass = $false

                Mock -CommandName Compare-TargetResourceState -ParameterFilter {
                    $mockSingleServiceAccount.Name -eq $ServiceAccountName -and $AccountType -eq $objectAccountType.Expected
                } -MockWith {
                    Write-Verbose "Calling Compare-TargetResourceState with $($mockSingleServiceAccount.Name) and AccountType '$($objectAccountType.Expected)'"
                    return $mockCompareSingleServiceAccountNotCompliantAccountType
                }
                #endregion Incorrect Account type setup

                It "Should NOT call 'Remove-ADServiceAccount, New-ADServiceAccountHelper' when 'AccountType' is incorrect and 'AccountTypeForce' is false" {
                    $testResourceParametersSingle = @{
                        ServiceAccountName = $mockSingleServiceAccount.Name
                        AccountType        = $objectAccountType.Expected
                        AccountTypeForce   = $false
                    }

                    # Check if Warning is returned
                    Set-TargetResource @testResourceParametersSingle 3>&1 | Should -Not -Be $null

                    Assert-MockCalled -CommandName Compare-TargetResourceState -Scope It -Times 1
                    Assert-MockCalled -CommandName New-ADServiceAccountHelper -Scope It -Times 0
                    Assert-MockCalled -CommandName Remove-ADServiceAccount -Scope It -Exactly -Times 0
                    Assert-MockCalled -CommandName Move-ADObject -Scope It -Exactly -Times 0
                    Assert-MockCalled -CommandName Set-ADServiceAccount -Scope It -Exactly -Times 0
                }

                It "Should call 'Remove-ADServiceAccount, New-ADServiceAccountHelper' when 'AccountType' is incorrect and 'AccountTypeForce' is true" {
                    $testResourceParametersSingle = @{
                        ServiceAccountName = $mockSingleServiceAccount.Name
                        AccountType        = 'Group'
                        AccountTypeForce   = $true
                    }

                    Set-TargetResource @testResourceParametersSingle

                    Assert-MockCalled -CommandName Compare-TargetResourceState -Scope It -Times 1
                    Assert-MockCalled -CommandName New-ADServiceAccountHelper -Scope It -Times 1
                    Assert-MockCalled -CommandName Remove-ADServiceAccount -Scope It -Exactly -Times 1
                    Assert-MockCalled -CommandName Move-ADObject -Scope It -Exactly -Times 0
                    Assert-MockCalled -CommandName Set-ADServiceAccount -Scope It -Exactly -Times 0
                }

                #region Incorrect Ensure setup
                $objectEnsure = $mockCompareSingleServiceAccountNotCompliantEnsure | Where-Object -FilterScript {$_.Parameter -eq 'Ensure'}
                $objectEnsure.Expected = 'Absent'
                $objectEnsure.Pass = $false

                Mock -CommandName Compare-TargetResourceState -ParameterFilter {
                    $mockSingleServiceAccount.Name -eq $ServiceAccountName -and $Ensure -eq $objectEnsure.Expected
                } -MockWith {
                    Write-Verbose "Calling Compare-TargetResourceState with $($mockSingleServiceAccount.Name) and Ensure '$($objectEnsure.Expected)'"
                    return $mockCompareSingleServiceAccountNotCompliantEnsure
                }
                #endregion Incorrect Ensure type setup

                It "Should call 'Remove-ADServiceAccount' when 'Ensure' is set to 'Absent'" {
                    $testResourceParametersSingle = @{
                        ServiceAccountName = $mockSingleServiceAccount.Name
                        Ensure             = $objectEnsure.Expected
                    }

                    Set-TargetResource @testResourceParametersSingle

                    Assert-MockCalled -CommandName Compare-TargetResourceState -Scope It -Times 1
                    Assert-MockCalled -CommandName New-ADServiceAccountHelper -Scope It -Times 0
                    Assert-MockCalled -CommandName Remove-ADServiceAccount -Scope It -Exactly -Times 1
                    Assert-MockCalled -CommandName Move-ADObject -Scope It -Exactly -Times 0
                    Assert-MockCalled -CommandName Set-ADServiceAccount -Scope It -Exactly -Times 0
                }

            }

            Context -Name "When the system is NOT in the desired state and 'Ensure' is 'Present' (gMSA)" {
                $mockCompareGroupServiceAccountNotCompliantPath = Copy-ArrayObjects $mockCompareGroupServiceAccount
                $mockCompareGroupServiceAccountNotCompliantOtherParameters = Copy-ArrayObjects $mockCompareGroupServiceAccount
                $mockCompareGroupServiceAccountNotCompliantAccountType = Copy-ArrayObjects $mockCompareGroupServiceAccount
                $mockCompareGroupServiceAccountNotCompliantEnsure = Copy-ArrayObjects $mockCompareGroupServiceAccount

                #region Incorrect Path setup
                $objectPath = $mockCompareGroupServiceAccountNotCompliantPath | Where-Object -FilterScript {$_.Parameter -eq 'Path'}
                $objectPath.Expected = 'WrongPath'
                $objectPath.Pass = $false

                Mock -CommandName Compare-TargetResourceState -ParameterFilter {
                    $mockGroupServiceAccount.Name -eq $ServiceAccountName -and $Path -eq $objectPath.Expected
                } -MockWith {
                    Write-Verbose "Calling Compare-TargetResourceState with $($mockGroupServiceAccount.Name) and Path '$($objectPath.Expected)'"
                    return $mockCompareGroupServiceAccountNotCompliantPath
                }
                #endregion Incorrect Path setup

                It "Should call 'Move-ADObject' when 'Path' is incorrect" {
                    $testResourceParametersGroup = @{
                        ServiceAccountName = $mockGroupServiceAccount.Name
                        AccountType        = 'Group'
                        Path               = $objectPath.Expected
                    }

                    Set-TargetResource @testResourceParametersGroup
                    Assert-MockCalled -CommandName Compare-TargetResourceState -Scope It -Times 1
                    Assert-MockCalled -CommandName New-ADServiceAccountHelper -Scope It -Times 0
                    Assert-MockCalled -CommandName Remove-ADServiceAccount -Scope It -Exactly -Times 0
                    Assert-MockCalled -CommandName Move-ADObject -Scope It -Exactly -Times 1
                    Assert-MockCalled -CommandName Set-ADServiceAccount -Scope It -Exactly -Times 0
                }

                #region Incorrect parameter test setup
                $testIncorrectParameters = @{
                    Description = 'WrongDescription'
                    DisplayName = 'WrongDisplayName'
                    Members     = 'WrongUser'
                }

                $testCases = @()
                foreach($incorrectParameter in $testIncorrectParameters.GetEnumerator())
                {
                    $objectParameter = $mockCompareGroupServiceAccountNotCompliantOtherParameters |
                                            Where-Object -FilterScript { $_.Parameter -eq $incorrectParameter.Name }
                    $objectParameter.Expected = $incorrectParameter.Value
                    $objectParameter.Pass = $false

                    $testCases += @{
                        Parameter = $incorrectParameter.Name
                        Value = $incorrectParameter.Value
                    }
                }

                Mock -CommandName Compare-TargetResourceState -ParameterFilter {
                    $mockGroupServiceAccount.Name -eq $ServiceAccountName -and (
                        $Description -eq $testIncorrectParameters.Description -or
                        $DisplayName -eq $testIncorrectParameters.DisplayName -or
                        $Members -eq $testIncorrectParameters.Members
                    )
                } -MockWith {
                    Write-Verbose "Calling Compare-TargetResourceState with $($mockGroupServiceAccount.Name) and incorrect parameters"
                    return $mockCompareGroupServiceAccountNotCompliantOtherParameters
                }
                #endregion Incorrect parameter test setup

                It "Should call 'Set-ADServiceAccount' when '<Parameter>' is incorrect" -TestCases $testCases {
                    param
                    (
                        [Parameter()]
                        $Parameter,

                        [Parameter()]
                        $Value
                    )

                    $testResourceParametersGroup = @{
                        ServiceAccountName = $mockGroupServiceAccount.Name
                        AccountType        = 'Group'
                    }
                    $testResourceParametersGroup[$Parameter] = $Value

                    Set-TargetResource @testResourceParametersGroup
                    Assert-MockCalled -CommandName Compare-TargetResourceState -Scope It -Times 1
                    Assert-MockCalled -CommandName New-ADServiceAccountHelper -Scope It -Times 0
                    Assert-MockCalled -CommandName Remove-ADServiceAccount -Scope It -Exactly -Times 0
                    Assert-MockCalled -CommandName Move-ADObject -Scope It -Exactly -Times 0
                    Assert-MockCalled -CommandName Set-ADServiceAccount -Scope It -Exactly -Times 1
                }

                #region Incorrect Account type setup
                $objectAccountType = $mockCompareGroupServiceAccountNotCompliantAccountType | Where-Object -FilterScript {$_.Parameter -eq 'AccountType'}
                $objectAccountType.Expected = 'Single'
                $objectAccountType.Pass = $false

                Mock -CommandName Compare-TargetResourceState -ParameterFilter {
                    $mockGroupServiceAccount.Name -eq $ServiceAccountName -and $AccountType -eq $objectAccountType.Expected
                } -MockWith {
                    Write-Verbose "Calling Compare-TargetResourceState with $($mockGroupServiceAccount.Name) and AccountType '$($objectAccountType.Expected)'"
                    return $mockCompareGroupServiceAccountNotCompliantAccountType
                }
                #endregion Incorrect Account type setup

                It "Should NOT call 'Remove-ADServiceAccount, New-ADServiceAccountHelper' when 'AccountType' is incorrect and 'AccountTypeForce' is false" {
                    $testResourceParametersGroup = @{
                        ServiceAccountName = $mockGroupServiceAccount.Name
                        AccountType        = $objectAccountType.Expected
                        AccountTypeForce   = $false
                    }

                    # Check if Warning is returned
                    Set-TargetResource @testResourceParametersGroup 3>&1 | Should -Not -Be $null

                    Assert-MockCalled -CommandName Compare-TargetResourceState -Scope It -Times 1
                    Assert-MockCalled -CommandName New-ADServiceAccountHelper -Scope It -Times 0
                    Assert-MockCalled -CommandName Remove-ADServiceAccount -Scope It -Exactly -Times 0
                    Assert-MockCalled -CommandName Move-ADObject -Scope It -Exactly -Times 0
                    Assert-MockCalled -CommandName Set-ADServiceAccount -Scope It -Exactly -Times 0
                }

                It "Should call 'Remove-ADServiceAccount, New-ADServiceAccountHelper' when 'AccountType' is incorrect and 'AccountTypeForce' is true" {
                    $testResourceParametersGroup = @{
                        ServiceAccountName = $mockGroupServiceAccount.Name
                        AccountType        = 'Single'
                        AccountTypeForce   = $true
                    }

                    Set-TargetResource @testResourceParametersGroup
                    Assert-MockCalled -CommandName Compare-TargetResourceState -Scope It -Times 1
                    Assert-MockCalled -CommandName New-ADServiceAccountHelper -Scope It -Times 1
                    Assert-MockCalled -CommandName Remove-ADServiceAccount -Scope It -Exactly -Times 1
                    Assert-MockCalled -CommandName Move-ADObject -Scope It -Exactly -Times 0
                    Assert-MockCalled -CommandName Set-ADServiceAccount -Scope It -Exactly -Times 0
                }

                #region Incorrect Ensure setup
                $objectEnsure = $mockCompareGroupServiceAccountNotCompliantEnsure | Where-Object -FilterScript {$_.Parameter -eq 'Ensure'}
                $objectEnsure.Expected = 'Absent'
                $objectEnsure.Pass = $false

                Mock -CommandName Compare-TargetResourceState -ParameterFilter {
                    $mockGroupServiceAccount.Name -eq $ServiceAccountName -and $Ensure -eq $objectEnsure.Expected
                } -MockWith {
                    Write-Verbose "Calling Compare-TargetResourceState with $($mockGroupServiceAccount.Name) and Ensure '$($objectEnsure.Expected)'"
                    return $mockCompareGroupServiceAccountNotCompliantEnsure
                }
                #endregion Incorrect Ensure type setup

                It "Should call 'Remove-ADServiceAccount' when 'Ensure' is set to 'Absent'" {
                    $testResourceParametersGroup = @{
                        ServiceAccountName = $mockGroupServiceAccount.Name
                        AccountType        = 'Group'
                        Ensure             = $objectEnsure.Expected
                    }

                    Set-TargetResource @testResourceParametersGroup

                    Assert-MockCalled -CommandName Compare-TargetResourceState -Scope It -Times 1
                    Assert-MockCalled -CommandName New-ADServiceAccountHelper -Scope It -Times 0
                    Assert-MockCalled -CommandName Remove-ADServiceAccount -Scope It -Exactly -Times 1
                    Assert-MockCalled -CommandName Move-ADObject -Scope It -Exactly -Times 0
                    Assert-MockCalled -CommandName Set-ADServiceAccount -Scope It -Exactly -Times 0
                }
            }

            Context -Name "When the system is NOT in the desired state and 'Ensure' is 'Present' (Both)" {
                $mockCompareSingleServiceAccountNotEnsure = Copy-ArrayObjects $mockCompareSingleServiceAccount

                #region Incorrect Ensure setup
                $objectEnsure = $mockCompareSingleServiceAccountNotEnsure | Where-Object -FilterScript {$_.Parameter -eq 'Ensure'}
                $objectEnsure.Expected = 'Present'
                $objectEnsure.Actual = 'Absent'
                $objectEnsure.Pass = $false

                Mock -CommandName Compare-TargetResourceState -ParameterFilter {
                    $mockSingleServiceAccount.Name -eq $ServiceAccountName
                } -MockWith {
                    Write-Verbose "Calling Compare-TargetResourceState with $($mockSingleServiceAccount.Name)"
                    return $mockCompareSingleServiceAccountNotEnsure
                }
                #endregion Incorrect Ensure setup

                It "Should call 'New-AdServiceAccount' when 'Ensure' is set to 'Present" {
                    $testResourceParametersSingle = @{
                        ServiceAccountName = $mockSingleServiceAccount.Name
                        Ensure             = $objectEnsure.Expected
                    }

                    Set-TargetResource @testResourceParametersSingle

                    Assert-MockCalled -CommandName Compare-TargetResourceState -Scope It -Times 1
                    Assert-MockCalled -CommandName New-ADServiceAccountHelper -Scope It -Times 1
                    Assert-MockCalled -CommandName Remove-ADServiceAccount -Scope It -Exactly -Times 0
                    Assert-MockCalled -CommandName Move-ADObject -Scope It -Exactly -Times 0
                    Assert-MockCalled -CommandName Set-ADServiceAccount -Scope It -Exactly -Times 0
                }
            }

            Context 'When system cannot connect to domain or other errors' {
                Mock -CommandName Move-ADObject -MockWith {
                    Write-Verbose "Calling 'Move-ADObject' and throwing an error"
                    throw 'Microsoft.ActiveDirectory.Management.ADServerDownException'
                }

                $mockCompareSingleServiceAccountNotCompliantPath = Copy-ArrayObjects $mockCompareSingleServiceAccount

                #region Incorrect Path setup
                $objectPath = $mockCompareSingleServiceAccountNotCompliantPath | Where-Object -FilterScript {$_.Parameter -eq 'Path'}
                $objectPath.Expected = 'WrongPath'
                $objectPath.Pass = $false

                Mock -CommandName Compare-TargetResourceState -ParameterFilter {
                    $mockSingleServiceAccount.Name -eq $ServiceAccountName -and $Path -eq $objectPath.Expected
                } -MockWith {
                    Write-Verbose "Calling Compare-TargetResourceState with $($mockSingleServiceAccount.Name) and Path '$($objectPath.Expected)'"
                    return $mockCompareSingleServiceAccountNotCompliantPath
                }
                #endregion Incorrect Path setup

                It 'Should call "Move-ADObject" and throw an error when catching any other errors besides "Account Not Found"'{
                    $testResourceParametersSingle = @{
                        ServiceAccountName = $mockSingleServiceAccount.Name
                        Path               = $objectPath.Expected
                    }
                    { Set-TargetResource  @testResourceParametersSingle -ErrorAction 'SilentlyContinue' } |
                        Should -Throw ($script:localizedData.AddingManagedServiceAccountError -f $testResourceParametersSingle.ServiceAccountName)
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
