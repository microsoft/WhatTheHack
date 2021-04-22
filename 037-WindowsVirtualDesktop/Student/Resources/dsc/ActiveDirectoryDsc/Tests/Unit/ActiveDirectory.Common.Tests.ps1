<#
    This module is loaded as a nested module when the ActiveDirectoryDsc module is imported,
    remove the module from the session to avoid the error message:

        Multiple Script modules named 'ActiveDirectoryDsc.Common'
        are currently loaded.  Make sure to remove any extra copies
        of the module from your session before testing.
#>
Get-Module -Name 'ActiveDirectoryDsc.Common' -All | Remove-Module -Force

Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath '..\TestHelpers\ActiveDirectoryDsc.TestHelper.psm1')

if (-not (Test-RunForCITestCategory -Type 'Unit' -Category 'Tests'))
{
    return
}

# Import the ActiveDirectoryDsc.Common module to test
$script:resourceModulePath = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
$script:modulesFolderPath = Join-Path -Path $script:resourceModulePath -ChildPath 'Modules\ActiveDirectoryDsc.Common'

Import-Module -Name (Join-Path -Path $script:modulesFolderPath -ChildPath 'ActiveDirectoryDsc.Common.psm1') -Force

InModuleScope 'ActiveDirectoryDsc.Common' {
    # Load stub cmdlets and classes.
    Import-Module (Join-Path -Path $PSScriptRoot -ChildPath 'Stubs\ActiveDirectory_2019.psm1') -Force
    Import-Module (Join-Path -Path $PSScriptRoot -ChildPath 'Stubs\ADDSDeployment_2019.psm1') -Force

    Describe 'ActiveDirectoryDsc.Common\Test-DscParameterState' -Tag TestDscParameterState {
        Context 'When passing values' {
            It 'Should return true for two identical tables' {
                $mockDesiredValues = @{
                    Example = 'test'
                }

                $testParameters = @{
                    CurrentValues = $mockDesiredValues
                    DesiredValues = $mockDesiredValues
                }

                Test-DscParameterState @testParameters | Should -BeTrue
            }

            It 'Should return false when a value is different for [System.String]' {
                $mockCurrentValues = @{
                    Example = [System.String] 'something'
                }

                $mockDesiredValues = @{
                    Example = [System.String] 'test'
                }

                $testParameters = @{
                    CurrentValues = $mockCurrentValues
                    DesiredValues = $mockDesiredValues
                }

                Test-DscParameterState @testParameters | Should -BeFalse
            }

            It 'Should return false when a value is different for [System.Int32]' {
                $mockCurrentValues = @{
                    Example = [System.Int32] 1
                }

                $mockDesiredValues = @{
                    Example = [System.Int32] 2
                }

                $testParameters = @{
                    CurrentValues = $mockCurrentValues
                    DesiredValues = $mockDesiredValues
                }

                Test-DscParameterState @testParameters | Should -BeFalse
            }

            It 'Should return false when a value is different for [System.Int16]' {
                $mockCurrentValues = @{
                    Example = [System.Int16] 1
                }

                $mockDesiredValues = @{
                    Example = [System.Int16] 2
                }

                $testParameters = @{
                    CurrentValues = $mockCurrentValues
                    DesiredValues = $mockDesiredValues
                }

                Test-DscParameterState @testParameters | Should -BeFalse
            }

            It 'Should return false when a value is different for [System.UInt16]' {
                $mockCurrentValues = @{
                    Example = [System.UInt16] 1
                }

                $mockDesiredValues = @{
                    Example = [System.UInt16] 2
                }

                $testParameters = @{
                    CurrentValues = $mockCurrentValues
                    DesiredValues = $mockDesiredValues
                }

                Test-DscParameterState @testParameters | Should -BeFalse
            }

            It 'Should return false when a value is different for [System.Boolean]' {
                $mockCurrentValues = @{
                    Example = [System.Boolean] $true
                }

                $mockDesiredValues = @{
                    Example = [System.Boolean] $false
                }

                $testParameters = @{
                    CurrentValues = $mockCurrentValues
                    DesiredValues = $mockDesiredValues
                }

                Test-DscParameterState @testParameters | Should -BeFalse
            }

            It 'Should return false when a value is missing' {
                $mockCurrentValues = @{}
                $mockDesiredValues = @{
                    Example = 'test'
                }

                $testParameters = @{
                    CurrentValues = $mockCurrentValues
                    DesiredValues = $mockDesiredValues
                }

                Test-DscParameterState @testParameters | Should -BeFalse
            }

            It 'Should return true when only a specified value matches, but other non-listed values do not' {
                $mockCurrentValues = @{
                    Example = 'test'
                    SecondExample = 'true'
                }

                $mockDesiredValues = @{
                    Example = 'test'
                    SecondExample = 'false'
                }

                $testParameters = @{
                    CurrentValues = $mockCurrentValues
                    DesiredValues = $mockDesiredValues
                    ValuesToCheck = @('Example')
                }

                Test-DscParameterState @testParameters | Should -BeTrue
            }

            It 'Should return false when only specified values do not match, but other non-listed values do ' {
                $mockCurrentValues = @{
                    Example = 'test'
                    SecondExample = 'true'
                }

                $mockDesiredValues = @{
                    Example = 'test'
                    SecondExample = 'false'
                }

                $testParameters = @{
                    CurrentValues = $mockCurrentValues
                    DesiredValues = $mockDesiredValues
                    ValuesToCheck = @('SecondExample')
                }

                Test-DscParameterState @testParameters | Should -BeFalse
            }

            It 'Should return false when an empty hash table is used in the current values' {
                $mockCurrentValues = @{}
                $mockDesiredValues = @{
                    Example = 'test'
                    SecondExample = 'false'
                }

                $testParameters = @{
                    CurrentValues = $mockCurrentValues
                    DesiredValues = $mockDesiredValues
                }

                Test-DscParameterState @testParameters | Should -BeFalse
            }

            It 'Should return true when evaluating a table against a CimInstance' {
                $mockCurrentValues = @{
                    Handle = '0'
                    ProcessId = '1000'
                }

                $mockWin32ProcessProperties = @{
                    Handle    = 0
                    ProcessId = 1000
                }

                $mockNewCimInstanceParameters = @{
                    ClassName  = 'Win32_Process'
                    Property   = $mockWin32ProcessProperties
                    Key        = 'Handle'
                    ClientOnly = $true
                }

                $mockDesiredValues = New-CimInstance @mockNewCimInstanceParameters

                $testParameters = @{
                    CurrentValues = $mockCurrentValues
                    DesiredValues = $mockDesiredValues
                    ValuesToCheck = @('Handle', 'ProcessId')
                }

                Test-DscParameterState @testParameters | Should -BeTrue
            }

            It 'Should return false when evaluating a table against a CimInstance and a value is wrong' {
                $mockCurrentValues = @{
                    Handle = '1'
                    ProcessId = '1000'
                }

                $mockWin32ProcessProperties = @{
                    Handle    = 0
                    ProcessId = 1000
                }

                $mockNewCimInstanceParameters = @{
                    ClassName  = 'Win32_Process'
                    Property   = $mockWin32ProcessProperties
                    Key        = 'Handle'
                    ClientOnly = $true
                }

                $mockDesiredValues = New-CimInstance @mockNewCimInstanceParameters

                $testParameters = @{
                    CurrentValues = $mockCurrentValues
                    DesiredValues = $mockDesiredValues
                    ValuesToCheck = @('Handle', 'ProcessId')
                }

                Test-DscParameterState @testParameters | Should -BeFalse
            }

            It 'Should return true when evaluating a hash table containing an array' {
                $mockCurrentValues = @{
                    Example = 'test'
                    SecondExample = @('1', '2')
                }

                $mockDesiredValues = @{
                    Example = 'test'
                    SecondExample = @('1', '2')
                }

                $testParameters = @{
                    CurrentValues = $mockCurrentValues
                    DesiredValues = $mockDesiredValues
                }

                Test-DscParameterState @testParameters | Should -BeTrue
            }

            It 'Should return false when evaluating a hash table containing an array with wrong values' {
                $mockCurrentValues = @{
                    Example = 'test'
                    SecondExample = @('A', 'B')
                }

                $mockDesiredValues = @{
                    Example = 'test'
                    SecondExample = @('1', '2')
                }

                $testParameters = @{
                    CurrentValues = $mockCurrentValues
                    DesiredValues = $mockDesiredValues
                }

                Test-DscParameterState @testParameters | Should -BeFalse
            }

            It 'Should return false when evaluating a hash table containing an array, but the CurrentValues are missing an array' {
                $mockCurrentValues = @{
                    Example = 'test'
                }

                $mockDesiredValues = @{
                    Example = 'test'
                    SecondExample = @('1', '2')
                }

                $testParameters = @{
                    CurrentValues = $mockCurrentValues
                    DesiredValues = $mockDesiredValues
                }

                Test-DscParameterState @testParameters | Should -BeFalse
            }

            It 'Should return false when evaluating a hash table containing an array, but the property i CurrentValues is $null' {
                $mockCurrentValues = @{
                    Example = 'test'
                    SecondExample = $null
                }

                $mockDesiredValues = @{
                    Example = 'test'
                    SecondExample = @('1', '2')
                }

                $testParameters = @{
                    CurrentValues = $mockCurrentValues
                    DesiredValues = $mockDesiredValues
                }

                Test-DscParameterState @testParameters | Should -BeFalse
            }
        }

        Context 'When passing invalid types for DesiredValues' {
            It 'Should throw the correct error when DesiredValues is of wrong type' {
                $mockCurrentValues = @{
                    Example = 'something'
                }

                $mockDesiredValues = 'NotHashTable'

                $testParameters = @{
                    CurrentValues = $mockCurrentValues
                    DesiredValues = $mockDesiredValues
                }

                $mockCorrectErrorMessage = ($script:localizedData.PropertyTypeInvalidForDesiredValues -f $testParameters.DesiredValues.GetType().Name)
                { Test-DscParameterState @testParameters } | Should -Throw $mockCorrectErrorMessage
            }

            It 'Should write a warning when DesiredValues contain an unsupported type' {
                Mock -CommandName Write-Warning -Verifiable

                # This is a dummy type to test with a type that could never be a correct one.
                class MockUnknownType
                {
                    [ValidateNotNullOrEmpty()]
                    [System.String]
                    $Property1

                    [ValidateNotNullOrEmpty()]
                    [System.String]
                    $Property2

                    MockUnknownType()
                    {
                    }
                }

                $mockCurrentValues = @{
                    Example = New-Object -TypeName 'MockUnknownType'
                }

                $mockDesiredValues = @{
                    Example = New-Object -TypeName 'MockUnknownType'
                }

                $testParameters = @{
                    CurrentValues = $mockCurrentValues
                    DesiredValues = $mockDesiredValues
                }

                Test-DscParameterState @testParameters | Should -BeFalse

                Assert-MockCalled -CommandName Write-Warning -Exactly -Times 1
            }
        }

        Context 'When passing an CimInstance as DesiredValue and ValuesToCheck is $null' {
            It 'Should throw the correct error' {
                $mockCurrentValues = @{
                    Example = 'something'
                }

                $mockWin32ProcessProperties = @{
                    Handle    = 0
                    ProcessId = 1000
                }

                $mockNewCimInstanceParameters = @{
                    ClassName  = 'Win32_Process'
                    Property   = $mockWin32ProcessProperties
                    Key        = 'Handle'
                    ClientOnly = $true
                }

                $mockDesiredValues = New-CimInstance @mockNewCimInstanceParameters

                $testParameters = @{
                    CurrentValues = $mockCurrentValues
                    DesiredValues = $mockDesiredValues
                    ValuesToCheck = $null
                }

                $mockCorrectErrorMessage = $script:localizedData.PropertyTypeInvalidForValuesToCheck
                { Test-DscParameterState @testParameters } | Should -Throw $mockCorrectErrorMessage
            }
        }

        Assert-VerifiableMock
    }
    Describe 'ActiveDirectoryDsc.Common\Get-LocalizedData' {
        $mockTestPath = {
            return $mockTestPathReturnValue
        }

        $mockImportLocalizedData = {
            $BaseDirectory | Should -Be $mockExpectedLanguagePath
        }

        BeforeEach {
            Mock -CommandName Test-Path -MockWith $mockTestPath -Verifiable
            Mock -CommandName Import-LocalizedData -MockWith $mockImportLocalizedData -Verifiable
        }

        Context 'When loading localized data for Swedish' {
            $mockExpectedLanguagePath = 'sv-SE'
            $mockTestPathReturnValue = $true

            It 'Should call Import-LocalizedData with sv-SE language' {
                Mock -CommandName Join-Path -MockWith {
                    return 'sv-SE'
                } -Verifiable

                { Get-LocalizedData -ResourceName 'DummyResource' } | Should -Not -Throw

                Assert-MockCalled -CommandName Join-Path -Exactly -Times 3 -Scope It
                Assert-MockCalled -CommandName Test-Path -Exactly -Times 1 -Scope It
                Assert-MockCalled -CommandName Import-LocalizedData -Exactly -Times 1 -Scope It
            }

            $mockExpectedLanguagePath = 'en-US'
            $mockTestPathReturnValue = $false

            It 'Should call Import-LocalizedData and fallback to en-US if sv-SE language does not exist' {
                Mock -CommandName Join-Path -MockWith {
                    return $ChildPath
                } -Verifiable

                { Get-LocalizedData -ResourceName 'DummyResource' } | Should -Not -Throw

                Assert-MockCalled -CommandName Join-Path -Exactly -Times 4 -Scope It
                Assert-MockCalled -CommandName Test-Path -Exactly -Times 1 -Scope It
                Assert-MockCalled -CommandName Import-LocalizedData -Exactly -Times 1 -Scope It
            }

            Context 'When $ScriptRoot is set to a path' {
                $mockExpectedLanguagePath = 'sv-SE'
                $mockTestPathReturnValue = $true

                It 'Should call Import-LocalizedData with sv-SE language' {
                    Mock -CommandName Join-Path -MockWith {
                        return 'sv-SE'
                    } -Verifiable

                    { Get-LocalizedData -ResourceName 'DummyResource' -ScriptRoot '.' } | Should -Not -Throw

                    Assert-MockCalled -CommandName Join-Path -Exactly -Times 1 -Scope It
                    Assert-MockCalled -CommandName Test-Path -Exactly -Times 1 -Scope It
                    Assert-MockCalled -CommandName Import-LocalizedData -Exactly -Times 1 -Scope It
                }

                $mockExpectedLanguagePath = 'en-US'
                $mockTestPathReturnValue = $false

                It 'Should call Import-LocalizedData and fallback to en-US if sv-SE language does not exist' {
                    Mock -CommandName Join-Path -MockWith {
                        return $ChildPath
                    } -Verifiable

                    { Get-LocalizedData -ResourceName 'DummyResource' -ScriptRoot '.' } | Should -Not -Throw

                    Assert-MockCalled -CommandName Join-Path -Exactly -Times 2 -Scope It
                    Assert-MockCalled -CommandName Test-Path -Exactly -Times 1 -Scope It
                    Assert-MockCalled -CommandName Import-LocalizedData -Exactly -Times 1 -Scope It
                }
            }
        }

        Context 'When loading localized data for English' {
            Mock -CommandName Join-Path -MockWith {
                return 'en-US'
            } -Verifiable

            $mockExpectedLanguagePath = 'en-US'
            $mockTestPathReturnValue = $true

            It 'Should call Import-LocalizedData with en-US language' {
                { Get-LocalizedData -ResourceName 'DummyResource' } | Should -Not -Throw
            }
        }

        Assert-VerifiableMock
    }

    Describe 'ActiveDirectoryDsc.Common\New-InvalidResultException' {
        Context 'When calling with Message parameter only' {
            It 'Should throw the correct error' {
                $mockErrorMessage = 'Mocked error'

                { New-InvalidResultException -Message $mockErrorMessage } | Should -Throw $mockErrorMessage
            }
        }

        Context 'When calling with both the Message and ErrorRecord parameter' {
            It 'Should throw the correct error' {
                $mockErrorMessage = 'Mocked error'
                $mockExceptionErrorMessage = 'Mocked exception error message'

                $mockException = New-Object -TypeName 'System.Exception' -ArgumentList $mockExceptionErrorMessage
                $mockErrorRecord = New-Object -TypeName 'System.Management.Automation.ErrorRecord' -ArgumentList @($mockException, $null, 'InvalidResult', $null)

                { New-InvalidResultException -Message $mockErrorMessage -ErrorRecord $mockErrorRecord } | Should -Throw ('System.Exception: {0} ---> System.Exception: {1}' -f $mockErrorMessage, $mockExceptionErrorMessage)
            }
        }

        Assert-VerifiableMock
    }

    Describe 'ActiveDirectoryDsc.Common\New-ObjectNotFoundException' {
        Context 'When calling with Message parameter only' {
            It 'Should throw the correct error' {
                $mockErrorMessage = 'Mocked error'

                { New-ObjectNotFoundException -Message $mockErrorMessage } | Should -Throw $mockErrorMessage
            }
        }

        Context 'When calling with both the Message and ErrorRecord parameter' {
            It 'Should throw the correct error' {
                $mockErrorMessage = 'Mocked error'
                $mockExceptionErrorMessage = 'Mocked exception error message'

                $mockException = New-Object -TypeName 'System.Exception' -ArgumentList $mockExceptionErrorMessage
                $mockErrorRecord = New-Object -TypeName 'System.Management.Automation.ErrorRecord' -ArgumentList @($mockException, $null, 'InvalidResult', $null)

                { New-ObjectNotFoundException -Message $mockErrorMessage -ErrorRecord $mockErrorRecord } | Should -Throw ('System.Exception: {0} ---> System.Exception: {1}' -f $mockErrorMessage, $mockExceptionErrorMessage)
            }
        }

        Assert-VerifiableMock
    }

    Describe 'ActiveDirectoryDsc.Common\New-InvalidOperationException' {
        Context 'When calling with Message parameter only' {
            It 'Should throw the correct error' {
                $mockErrorMessage = 'Mocked error'

                { New-InvalidOperationException -Message $mockErrorMessage } | Should -Throw $mockErrorMessage
            }
        }

        Context 'When calling with both the Message and ErrorRecord parameter' {
            It 'Should throw the correct error' {
                $mockErrorMessage = 'Mocked error'
                $mockExceptionErrorMessage = 'Mocked exception error message'

                $mockException = New-Object -TypeName 'System.Exception' -ArgumentList $mockExceptionErrorMessage
                $mockErrorRecord = New-Object -TypeName 'System.Management.Automation.ErrorRecord' -ArgumentList @($mockException, $null, 'InvalidResult', $null)

                { New-InvalidOperationException -Message $mockErrorMessage -ErrorRecord $mockErrorRecord } | Should -Throw ('System.InvalidOperationException: {0} ---> System.Exception: {1}' -f $mockErrorMessage, $mockExceptionErrorMessage)
            }
        }

        Assert-VerifiableMock
    }

    Describe 'ActiveDirectoryDsc.Common\New-InvalidArgumentException' {
        Context 'When calling with both the Message and ArgumentName parameter' {
            It 'Should throw the correct error' {
                $mockErrorMessage = 'Mocked error'
                $mockArgumentName = 'MockArgument'

                { New-InvalidArgumentException -Message $mockErrorMessage -ArgumentName $mockArgumentName } | Should -Throw ('Parameter name: {0}' -f $mockArgumentName)
            }
        }

        Assert-VerifiableMock
    }

    Describe 'DscResource.Common\Start-ProcessWithTimeout' {
        Context 'When starting a process successfully' {
            It 'Should return exit code 0' {
                $startProcessWithTimeoutParameters = @{
                    FilePath = 'powershell.exe'
                    ArgumentList = '-Command &{Start-Sleep -Seconds 2}'
                    Timeout = 300
                }

                $processExitCode = Start-ProcessWithTimeout @startProcessWithTimeoutParameters
                $processExitCode | Should -BeExactly 0
            }
        }

        Context 'When starting a process and the process does not finish before the timeout period' {
            It 'Should throw an error message' {
                $startProcessWithTimeoutParameters = @{
                    FilePath = 'powershell.exe'
                    ArgumentList = '-Command &{Start-Sleep -Seconds 4}'
                    Timeout = 2
                }

                { Start-ProcessWithTimeout @startProcessWithTimeoutParameters } | Should -Throw -ErrorId 'ProcessNotTerminated,Microsoft.PowerShell.Commands.WaitProcessCommand'
            }
        }
    }

    Describe 'ActiveDirectoryDsc.Common\Resolve-DomainFQDN' {
        It 'Returns "DomainName" when "ParentDomainName" not supplied' {
            $testDomainName = 'contoso.com'
            $testParentDomainName = $null

            $result = Resolve-DomainFQDN -DomainName $testDomainName -ParentDomainName $testParentDomainName

            $result | Should -Be $testDomainName
        }

        It 'Returns compound "DomainName.ParentDomainName" when "ParentDomainName" supplied' {
            $testDomainName = 'subdomain'
            $testParentDomainName = 'contoso.com'

            $result = Resolve-DomainFQDN -DomainName $testDomainName -ParentDomainName $testParentDomainName

            $result | Should -Be ('{0}.{1}' -f $testDomainName, $testParentDomainName)
        }
    }

    Describe 'ActiveDirectoryDsc.Common\Test-DomainMember' {
        It 'Returns "True" when domain member' {
            Mock -CommandName Get-CimInstance -MockWith {
                return @{
                    Name = $env:COMPUTERNAME
                    PartOfDomain = $true
                }
            }

            Test-DomainMember | Should -BeTrue
        }

        It 'Returns "False" when workgroup member' {
            Mock -CommandName Get-CimInstance -MockWith {
                return @{
                    Name = $env:COMPUTERNAME
                }
            }

            Test-DomainMember | Should -BeFalse
        }
    }

    Describe 'ActiveDirectoryDsc.Common\Get-DomainName' {
        It 'Returns expected domain name' {
            Mock -CommandName Get-CimInstance -MockWith {
                return @{
                    Name = $env:COMPUTERNAME
                    Domain = 'contoso.com'
                }
            }

            Get-DomainName | Should -Be 'contoso.com'
        }
    }

    Describe 'ActiveDirectoryDsc.Common\Assert-Module' {
        BeforeAll {
            $testModuleName = 'TestModule'
        }

        Context 'When module is not installed' {
            BeforeAll {
                Mock -CommandName Get-Module
            }

            It 'Should throw the correct error' {
                { Assert-Module -ModuleName $testModuleName } | Should -Throw ($script:localizedData.RoleNotFoundError -f $testModuleName)
            }
        }

        Context 'When module is available' {
            BeforeAll {
                Mock -CommandName Import-Module
                Mock -CommandName Get-Module -MockWith {
                    return @{
                        Name = $testModuleName
                    }
                }
            }

            Context 'When module should not be imported' {
                It 'Should not throw an error' {
                    { Assert-Module -ModuleName $testModuleName } | Should -Not -Throw

                    Assert-MockCalled -CommandName Import-Module -Exactly -Times 0 -Scope It
                }
            }

            Context 'When module should be imported' {
                It 'Should not throw an error' {
                    { Assert-Module -ModuleName $testModuleName -ImportModule } | Should -Not -Throw

                    Assert-MockCalled -CommandName Import-Module -Exactly -Times 1 -Scope It
                }
            }
        }
    }

    Describe 'ActiveDirectoryDsc.Common\Get-ADObjectParentDN' {
        It 'Returns CN object parent path' {
            Get-ADObjectParentDN -DN 'CN=Administrator,CN=Users,DC=contoso,DC=com' | Should -Be 'CN=Users,DC=contoso,DC=com'
        }

        It 'Returns OU object parent path' {
            Get-ADObjectParentDN -DN 'CN=Administrator,OU=Custom Organizational Unit,DC=contoso,DC=com' | Should -Be 'OU=Custom Organizational Unit,DC=contoso,DC=com'
        }
    }

    Describe 'ActiveDirectoryDsc.Common\Remove-DuplicateMembers' {
        It 'Should removes one duplicate' {
            $members = Remove-DuplicateMembers -Members 'User1','User2','USER1'
            $members -is [System.String[]] | Should -BeTrue

            $members.Count | Should -Be 2
            $members -contains 'User1' | Should -BeTrue
            $members -contains 'User2' | Should -BeTrue
        }

        It 'Should removes two duplicates' {
            $members = Remove-DuplicateMembers -Members 'User1','User2','USER1','USER2'
            $members -is [System.String[]] | Should -BeTrue

            $members.Count | Should -Be 2
            $members -contains 'User1' | Should -BeTrue
            $members -contains 'User2' | Should -BeTrue
        }

        It 'Should removes double duplicates' {
            $members = Remove-DuplicateMembers -Members 'User1','User2','USER1','user1'
            $members -is [System.String[]] | Should -BeTrue

            $members.Count | Should -Be 2
            $members -contains 'User1' | Should -BeTrue
            $members -contains 'User2' | Should -BeTrue
        }

        It 'Should return a string array with one one entry' {
            $members = Remove-DuplicateMembers -Members 'User1','USER1','user1'
            $members -is [System.String[]] | Should -BeTrue

            $members.Count | Should -Be 1
            $members -contains 'User1' | Should -BeTrue
        }

        It 'Should return empty collection when passed a $null value' {
            $members = Remove-DuplicateMembers -Members $null
            $members -is [System.String[]] | Should -BeTrue

            $members.Count | Should -Be 0
        }

        It 'Should return empty collection when passed an empty collection' {
            $members = Remove-DuplicateMembers -Members @()
            $members -is [System.String[]] | Should -BeTrue

            $members.Count | Should -Be 0
        }
    }

    Describe 'ActiveDirectoryDsc.Common\Test-Members' {
        It 'Passes when nothing is passed' {
            Test-Members -ExistingMembers $null | Should -BeTrue
        }

        It 'Passes when there are existing members but members are required' {
            $testExistingMembers = @('USER1', 'USER2')

            Test-Members -ExistingMembers $testExistingMembers | Should -BeTrue
        }

        It 'Passes when existing members match required members' {
            $testExistingMembers = @('USER1', 'USER2')
            $testMembers = @('USER2', 'USER1')

            Test-Members -ExistingMembers $testExistingMembers -Members $testMembers | Should -BeTrue
        }

        It 'Fails when there are no existing members and members are required' {
            $testExistingMembers = @('USER1', 'USER2')
            $testMembers = @('USER1', 'USER3')

            Test-Members -ExistingMembers $null -Members $testMembers | Should -BeFalse
        }

        It 'Fails when there are more existing members than the members required' {
            $testExistingMembers = @('USER1', 'USER2', 'USER3')
            $testMembers = @('USER1', 'USER3')

            Test-Members -ExistingMembers $null -Members $testMembers | Should -BeFalse
        }

        It 'Fails when there are more existing members than the members required' {
            $testExistingMembers = @('USER1', 'USER2')
            $testMembers = @('USER1', 'USER3', 'USER2')

            Test-Members -ExistingMembers $null -Members $testMembers | Should -BeFalse
        }

        It 'Fails when existing members do not match required members' {
            $testExistingMembers = @('USER1', 'USER2')
            $testMembers = @('USER1', 'USER3')

            Test-Members -ExistingMembers $testExistingMembers -Members $testMembers | Should -BeFalse
        }

        It 'Passes when existing members include required member' {
            $testExistingMembers = @('USER1', 'USER2')
            $testMembersToInclude = @('USER2')

            Test-Members -ExistingMembers $testExistingMembers -MembersToInclude $testMembersToInclude | Should -BeTrue
        }

        It 'Passes when existing members include required members' {
            $testExistingMembers = @('USER1', 'USER2')
            $testMembersToInclude = @('USER2', 'USER1')

            Test-Members -ExistingMembers $testExistingMembers -MembersToInclude $testMembersToInclude | Should -BeTrue
        }

        It 'Fails when existing members is missing a required member' {
            $testExistingMembers = @('USER1')
            $testMembersToInclude = @('USER2')

            Test-Members -ExistingMembers $testExistingMembers -MembersToInclude $testMembersToInclude | Should -BeFalse
        }

        It 'Fails when existing members is missing a required member' {
            $testExistingMembers = @('USER1', 'USER3')
            $testMembersToInclude = @('USER2')

            Test-Members -ExistingMembers $testExistingMembers -MembersToInclude $testMembersToInclude | Should -BeFalse
        }

        It 'Fails when existing members is missing a required members' {
            $testExistingMembers = @('USER3')
            $testMembersToInclude = @('USER1', 'USER2')

            Test-Members -ExistingMembers $testExistingMembers -MembersToInclude $testMembersToInclude | Should -BeFalse
        }

        It 'Passes when existing member does not include excluded member' {
            $testExistingMembers = @('USER1')
            $testMembersToExclude = @('USER2')

            Test-Members -ExistingMembers $testExistingMembers -MembersToExclude $testMembersToExclude | Should -BeTrue
        }

        It 'Passes when existing member does not include excluded members' {
            $testExistingMembers = @('USER1')
            $testMembersToExclude = @('USER2', 'USER3')

            Test-Members -ExistingMembers $testExistingMembers -MembersToExclude $testMembersToExclude | Should -BeTrue
        }

        It 'Passes when existing members does not include excluded member' {
            $testExistingMembers = @('USER1', 'USER2')
            $testMembersToExclude = @('USER3')

            Test-Members -ExistingMembers $testExistingMembers -MembersToExclude $testMembersToExclude | Should -BeTrue
        }

        It 'Should fail when an existing members is include as an excluded member' {
            $testExistingMembers = @('USER1', 'USER2')
            $testMembersToExclude = @('USER2')

            Test-Members -ExistingMembers $testExistingMembers -MembersToExclude $testMembersToExclude | Should -BeFalse
        }

        It 'Should pass when MembersToExclude is set to $null' {
            $testExistingMembers = @('USER1', 'USER2')
            $testMembersToExclude = $null

            Test-Members -ExistingMembers $testExistingMembers -MembersToExclude $testMembersToExclude | Should -BeTrue
        }

        It 'Should pass when MembersToInclude is set to $null' {
            $testExistingMembers = @('USER1', 'USER2')
            $testMembersToInclude = $null

            Test-Members -ExistingMembers $testExistingMembers -MembersToInclude $testMembersToInclude | Should -BeTrue
        }

        It 'Should fail when Members is set to $null' {
            $testExistingMembers = @('USER1', 'USER2')
            $testMembers = $null

            Test-Members -ExistingMembers $testExistingMembers -Members $testMembers -Verbose | Should -BeFalse
        }

        It 'Should fail when multiple Members are the wrong members' {
            $testExistingMembers = @('USER1', 'USER2')
            $testMembers = @('USER3', 'USER4')

            Test-Members -ExistingMembers $testExistingMembers -Members $testMembers -Verbose | Should -BeFalse
        }

        It 'Should fail when multiple MembersToInclude are not present in existing members' {
            $testExistingMembers = @('USER1', 'USER2')
            $testMembersToInclude = @('USER3', 'USER4')

            Test-Members -ExistingMembers $testExistingMembers -MembersToInclude $testMembersToInclude -Verbose | Should -BeFalse
        }

        It 'Should fail when multiple MembersToExclude are present in existing members' {
            $testExistingMembers = @('USER1', 'USER2')
            $testMembersToExclude = @('USER1', 'USER2')

            Test-Members -ExistingMembers $testExistingMembers -MembersToExclude $testMembersToExclude -Verbose | Should -BeFalse
        }
    }

    Describe 'ActiveDirectoryDsc.Common\Assert-MemberParameters' {
        It 'Should throws if both parameters Members and MembersToInclude are specified' {
            {
                Assert-MemberParameters -Members @('User1') -MembersToInclude @('User2')
            } | Should -Throw ($script:localizedData.MembersAndIncludeExcludeError -f 'Members', 'MembersToInclude', 'MembersToExclude')
        }

        It 'Should throw if both parameters Members and MembersToExclude are specified' {
            {
                Assert-MemberParameters -Members @('User1') -MembersToExclude @('User2')
            } | Should -Throw ($script:localizedData.MembersAndIncludeExcludeError -f 'Members', 'MembersToInclude', 'MembersToExclude')
        }

        It 'Should throws if the both parameters MembersToInclude and MembersToExclude contain the same member' {
            {
                Assert-MemberParameters -MembersToExclude @('user1') -MembersToInclude @('USER1')
            } | Should -Throw ($errorMessage = $script:localizedData.IncludeAndExcludeConflictError -f 'user1', 'MembersToInclude', 'MembersToExclude')
        }

        It 'Should throw if both parameters MembersToInclude and MembersToExclude contains no members (are empty)' {
            {
                Assert-MemberParameters -MembersToExclude @() -MembersToInclude @()
            } | Should -Throw ($script:localizedData.IncludeAndExcludeAreEmptyError -f 'MembersToInclude', 'MembersToExclude')
        }
    }

    Describe 'ActiveDirectoryDsc.Common\ConvertTo-Timespan' {
        It "Returns 'System.TimeSpan' object type" {
            $testIntTimeSpan = 60

            $result = ConvertTo-TimeSpan -TimeSpan $testIntTimeSpan -TimeSpanType Minutes

            $result -is [System.TimeSpan] | Should -BeTrue
        }

        It 'Creates TimeSpan from seconds' {
            $testIntTimeSpan = 60

            $result = ConvertTo-TimeSpan -TimeSpan $testIntTimeSpan -TimeSpanType Seconds

            $result.TotalSeconds | Should -Be $testIntTimeSpan
        }

        It 'Creates TimeSpan from minutes' {
            $testIntTimeSpan = 60

            $result = ConvertTo-TimeSpan -TimeSpan $testIntTimeSpan -TimeSpanType Minutes

            $result.TotalMinutes | Should -Be $testIntTimeSpan
        }

        It 'Creates TimeSpan from hours' {
            $testIntTimeSpan = 60

            $result = ConvertTo-TimeSpan -TimeSpan $testIntTimeSpan -TimeSpanType Hours

            $result.TotalHours | Should -Be $testIntTimeSpan
        }

        It 'Creates TimeSpan from days' {
            $testIntTimeSpan = 60

            $result = ConvertTo-TimeSpan -TimeSpan $testIntTimeSpan -TimeSpanType Days

            $result.TotalDays | Should -Be $testIntTimeSpan
        }
    }

    Describe 'ActiveDirectoryDsc.Common\ConvertFrom-Timespan' {
        It "Returns 'System.UInt32' object type" {
            $testIntTimeSpan = 60
            $testTimeSpan = New-TimeSpan -Seconds $testIntTimeSpan

            $result = ConvertFrom-TimeSpan -TimeSpan $testTimeSpan -TimeSpanType Seconds

            $result -is [System.UInt32] | Should -BeTrue
        }

        It 'Converts TimeSpan to total seconds' {
            $testIntTimeSpan = 60
            $testTimeSpan = New-TimeSpan -Seconds $testIntTimeSpan

            $result = ConvertFrom-TimeSpan -TimeSpan $testTimeSpan -TimeSpanType Seconds

            $result | Should -Be $testTimeSpan.TotalSeconds
        }

        It 'Converts TimeSpan to total minutes' {
            $testIntTimeSpan = 60
            $testTimeSpan = New-TimeSpan -Minutes $testIntTimeSpan

            $result = ConvertFrom-TimeSpan -TimeSpan $testTimeSpan -TimeSpanType Minutes

            $result | Should -Be $testTimeSpan.TotalMinutes
        }

        It 'Converts TimeSpan to total hours' {
            $testIntTimeSpan = 60
            $testTimeSpan = New-TimeSpan -Hours $testIntTimeSpan

            $result = ConvertFrom-TimeSpan -TimeSpan $testTimeSpan -TimeSpanType Hours

            $result | Should -Be $testTimeSpan.TotalHours
        }

        It 'Converts TimeSpan to total days' {
            $testIntTimeSpan = 60
            $testTimeSpan = New-TimeSpan -Days $testIntTimeSpan

            $result = ConvertFrom-TimeSpan -TimeSpan $testTimeSpan -TimeSpanType Days

            $result | Should -Be $testTimeSpan.TotalDays
        }
    }

    Describe 'ActiveDirectoryDsc.Common\Get-ADCommonParameters' {
        It "Returns 'System.Collections.Hashtable' object type" {
            $testIdentity = 'contoso.com'

            $result = Get-ADCommonParameters -Identity $testIdentity

            $result -is [System.Collections.Hashtable] | Should -BeTrue
        }

        It "Returns 'Identity' key by default" {
            $testIdentity = 'contoso.com'

            $result = Get-ADCommonParameters -Identity $testIdentity

            $result['Identity'] | Should -Be $testIdentity
        }

        It "Returns 'Name' key when 'UseNameParameter' is specified" {
            $testIdentity = 'contoso.com'

            $result = Get-ADCommonParameters -Identity $testIdentity -UseNameParameter

            $result['Name'] | Should -Be $testIdentity
        }

        foreach ($identityParam in @('UserName','GroupName','ComputerName'))
        {
            It "Returns 'Identity' key when '$identityParam' alias is specified" {
                $testIdentity = 'contoso.com'
                $getADCommonParameters = @{
                    $identityParam = $testIdentity
                }

                $result = Get-ADCommonParameters @getADCommonParameters

                $result['Identity'] | Should -Be $testIdentity
            }
        }

        It "Returns 'Identity' key by default when 'Identity' and 'CommonName' are specified" {
            $testIdentity = 'contoso.com'
            $testCommonName = 'Test Common Name'

            $result = Get-ADCommonParameters -Identity $testIdentity -CommonName $testCommonName

            $result['Identity'] | Should -Be $testIdentity
        }

        It "Returns 'Identity' key with 'CommonName' when 'Identity', 'CommonName' and 'PreferCommonName' are specified" {
            $testIdentity = 'contoso.com'
            $testCommonName = 'Test Common Name'

            $result = Get-ADCommonParameters -Identity $testIdentity -CommonName $testCommonName -PreferCommonName

            $result['Identity'] | Should -Be $testCommonName
        }

        It "Returns 'Identity' key with 'Identity' when 'Identity' and 'PreferCommonName' are specified" {
            $testIdentity = 'contoso.com'

            $result = Get-ADCommonParameters -Identity $testIdentity -PreferCommonName

            $result['Identity'] | Should -Be $testIdentity
        }

        it "Returns 'Name' key when 'UseNameParameter' and 'PreferCommonName' are supplied" {
            $testIdentity = 'contoso.com'
            $testCommonName = 'Test Common Name'

            $result = Get-ADCommonParameters -Identity $testIdentity -UseNameParameter -CommonName $testCommonName -PreferCommonName

            $result['Name'] | Should -Be $testCommonName
        }

        It "Does not return 'Credential' key by default" {
            $testIdentity = 'contoso.com'

            $result = Get-ADCommonParameters -Identity $testIdentity

            $result.ContainsKey('Credential') | Should -BeFalse
        }

        It "Returns 'Credential' key when specified" {
            $testIdentity = 'contoso.com'
            $testCredential = [System.Management.Automation.PSCredential]::Empty

            $result = Get-ADCommonParameters -Identity $testIdentity -Credential $testCredential

            $result['Credential'] | Should -Be $testCredential
        }

        It "Does not return 'Server' key by default" {
            $testIdentity = 'contoso.com'

            $result = Get-ADCommonParameters -Identity $testIdentity

            $result.ContainsKey('Server') | Should -BeFalse
        }

        It "Returns 'Server' key when specified" {
            $testIdentity = 'contoso.com'
            $testServer = 'testserver.contoso.com'

            $result = Get-ADCommonParameters -Identity $testIdentity -Server $testServer

            $result['Server'] | Should -Be $testServer
        }

        It "Converts 'DomainController' parameter to 'Server' key" {
            $testIdentity = 'contoso.com'
            $testServer = 'testserver.contoso.com'

            $result = Get-ADCommonParameters -Identity $testIdentity -DomainController $testServer

            $result['Server'] | Should -Be $testServer
        }

        It 'Accepts remaining arguments' {
            $testIdentity = 'contoso.com'

            $result = Get-ADCommonParameters -Identity $testIdentity -UnexpectedParameter 42

            $result['Identity'] | Should -Be $testIdentity
        }
    }

    Describe 'ActiveDirectoryDsc.Common\ConvertTo-DeploymentForestMode' {
        It 'Converts an Microsoft.ActiveDirectory.Management.ForestMode to Microsoft.DirectoryServices.Deployment.Types.ForestMode' {
            ConvertTo-DeploymentForestMode -Mode Windows2012Forest | Should -BeOfType [Microsoft.DirectoryServices.Deployment.Types.ForestMode]
        }

        It 'Converts an Microsoft.ActiveDirectory.Management.ForestMode to the correct Microsoft.DirectoryServices.Deployment.Types.ForestMode' {
            ConvertTo-DeploymentForestMode -Mode Windows2012Forest | Should -Be ([Microsoft.DirectoryServices.Deployment.Types.ForestMode]::Win2012)
        }

        It 'Converts valid integer to Microsoft.DirectoryServices.Deployment.Types.ForestMode' {
            ConvertTo-DeploymentForestMode -ModeId 5 | Should -BeOfType [Microsoft.DirectoryServices.Deployment.Types.ForestMode]
        }

        It 'Converts a valid integer to the correct Microsoft.DirectoryServices.Deployment.Types.ForestMode' {
            ConvertTo-DeploymentForestMode -ModeId 5 | Should -Be ([Microsoft.DirectoryServices.Deployment.Types.ForestMode]::Win2012)
        }

        It 'Throws an exception when an invalid forest mode is selected' {
            { ConvertTo-DeploymentForestMode -Mode Nonexistant } | Should -Throw
        }

        It 'Throws no exception when a null value is passed' {
            { ConvertTo-DeploymentForestMode -Mode $null } | Should -Not -Throw
        }

        It 'Throws no exception when an invalid mode id is selected' {
            { ConvertTo-DeploymentForestMode -ModeId 666 } | Should -Not -Throw
        }

        It 'Returns $null when a null value is passed' {
            ConvertTo-DeploymentForestMode -Mode $null | Should -Be $null
        }

        It 'Returns $null when an invalid mode id is selected' {
            ConvertTo-DeploymentForestMode -ModeId 666 | Should -Be $null
        }
    }

    Describe 'ActiveDirectoryDsc.Common\ConvertTo-DeploymentDomainMode' {
        It 'Converts an Microsoft.ActiveDirectory.Management.DomainMode to Microsoft.DirectoryServices.Deployment.Types.DomainMode' {
            ConvertTo-DeploymentDomainMode -Mode Windows2012Domain | Should -BeOfType [Microsoft.DirectoryServices.Deployment.Types.DomainMode]
        }

        It 'Converts an Microsoft.ActiveDirectory.Management.DomainMode to the correct Microsoft.DirectoryServices.Deployment.Types.DomainMode' {
            ConvertTo-DeploymentDomainMode -Mode Windows2012Domain | Should -Be ([Microsoft.DirectoryServices.Deployment.Types.DomainMode]::Win2012)
        }

        It 'Converts valid integer to Microsoft.DirectoryServices.Deployment.Types.DomainMode' {
            ConvertTo-DeploymentDomainMode -ModeId 5 | Should -BeOfType [Microsoft.DirectoryServices.Deployment.Types.DomainMode]
        }

        It 'Converts a valid integer to the correct Microsoft.DirectoryServices.Deployment.Types.DomainMode' {
            ConvertTo-DeploymentDomainMode -ModeId 5 | Should -Be ([Microsoft.DirectoryServices.Deployment.Types.DomainMode]::Win2012)
        }

        It 'Throws an exception when an invalid domain mode is selected' {
            { ConvertTo-DeploymentDomainMode -Mode Nonexistant } | Should -Throw
        }

        It 'Throws no exception when a null value is passed' {
            { ConvertTo-DeploymentDomainMode -Mode $null } | Should -Not -Throw
        }

        It 'Throws no exception when an invalid mode id is selected' {
            { ConvertTo-DeploymentDomainMode -ModeId 666 } | Should -Not -Throw
        }

        It 'Returns $null when a null value is passed' {
            ConvertTo-DeploymentDomainMode -Mode $null | Should -Be $null
        }

        It 'Returns $null when an invalid mode id is selected' {
            ConvertTo-DeploymentDomainMode -ModeId 666 | Should -Be $null
        }
    }

    Describe 'ActiveDirectoryDsc.Common\Restore-ADCommonObject' {
        $getAdObjectReturnValue = @(
            [PSCustomObject] @{
                Deleted           = $true
                DistinguishedName = 'CN=a375347\0ADEL:f0e3f4fe-212b-43e7-83dd-c8f3b47ebb9c,CN=Deleted Objects,DC=contoso,DC=com'
                Name              = 'a375347'
                ObjectClass       = 'user'
                ObjectGUID        = 'f0e3f4fe-212b-43e7-83dd-c8f3b47ebb9c'
                # Make this one day older.
                whenChanged       = (Get-Date).AddDays(-1)
            },
            [PSCustomObject] @{
                Deleted           = $true
                DistinguishedName = 'CN=a375347\0ADEL:d3c8b8c1-c42b-4533-af7d-3aa73ecd2216,CN=Deleted Objects,DC=contoso,DC=com'
                Name              = 'a375347'
                ObjectClass       = 'user'
                ObjectGUID        = 'd3c8b8c1-c42b-4533-af7d-3aa73ecd2216'
                whenChanged       = Get-Date
            }
        )

        $restoreAdObjectReturnValue = [PSCustomObject] @{
            DistinguishedName = 'CN=a375347,CN=Accounts,DC=contoso,DC=com'
            Name              = 'a375347'
            ObjectClass       = 'user'
            ObjectGUID        = 'd3c8b8c1-c42b-4533-af7d-3aa73ecd2216'
        }

        $getAdCommonParameterReturnValue = @{Identity = 'something'}
        $restoreIdentity = 'SomeObjectName'
        $restoreObjectClass = 'user'
        $restoreObjectWrongClass = 'wrong'

        Context 'When there are objects in the recycle bin' {
            Mock -CommandName Get-ADObject -MockWith { return $getAdObjectReturnValue } -Verifiable
            Mock -CommandName Get-ADCommonParameters -MockWith { return $getAdCommonParameterReturnValue }
            Mock -CommandName Restore-ADObject -Verifiable

            It 'Should not throw when called with the correct parameters' {
                {Restore-ADCommonObject -Identity $restoreIdentity -ObjectClass $restoreObjectClass} | Should -Not -Throw
            }

            It 'Should return the correct restored object' {
                Mock -CommandName Restore-ADObject -MockWith { return $restoreAdObjectReturnValue}
                (Restore-ADCommonObject -Identity $restoreIdentity -ObjectClass $restoreObjectClass).ObjectClass | Should -Be 'user'
            }

            It 'Should throw the correct error when invalid parameters are used' {
                {Restore-ADCommonObject -Identity $restoreIdentity -ObjectClass $restoreObjectWrongClass} | Should -Throw "Cannot validate argument on parameter 'ObjectClass'"
            }

            It 'Should call Get-ADObject as well as Restore-ADObject' {
                Assert-VerifiableMock
            }

            It 'Should throw an InvalidOperationException when object parent does not exist' {
                Mock -CommandName Restore-ADObject -MockWith {
                    throw New-Object -TypeName Microsoft.ActiveDirectory.Management.ADException
                }

                {
                    Restore-ADCommonObject -Identity $restoreIdentity -ObjectClass $restoreObjectClass
                } | Should -Throw ($script:localizedData.RecycleBinRestoreFailed -f $restoreIdentity, $restoreObjectClass)
            }
        }

        Context 'When there are no objects in the recycle bin' {
            Mock -CommandName Get-ADObject
            Mock -CommandName Get-ADCommonParameters -MockWith { return $getAdCommonParameterReturnValue}
            Mock -CommandName Restore-ADObject

            It 'Should return $null' {
                Restore-ADCommonObject -Identity $restoreIdentity -ObjectClass $restoreObjectClass | Should -Be $null
            }

            It 'Should not call Restore-ADObject' {
                Restore-ADCommonObject -Identity $restoreIdentity -ObjectClass $restoreObjectClass
                Assert-MockCalled -CommandName Restore-ADObject -Exactly -Times 0 -Scope It
            }
        }
    }

    Describe 'ActiveDirectoryDsc.Common\Get-ADDomainNameFromDistinguishedName' {
        $validDistinguishedNames = @(
            @{
                DN     = 'CN=group1,OU=Group,OU=Wacken,DC=contoso,DC=com'
                Domain = 'contoso.com'
            }
            @{
                DN     = 'CN=group1,OU=Group,OU=Wacken,DC=sub,DC=contoso,DC=com'
                Domain = 'sub.contoso.com'
            }
            @{
                DN     = 'CN=group1,OU=Group,OU=Wacken,DC=child,DC=sub,DC=contoso,DC=com'
                Domain = 'child.sub.contoso.com'
            }
        )

        $invalidDistinguishedNames = @(
            'Group1'
            'contoso\group1'
            'user1@contoso.com'
        )

        Context 'The distinguished name is valid' {
            foreach ($name in $validDistinguishedNames)
            {
                It "Should match domain $($name.Domain)" {
                    Get-ADDomainNameFromDistinguishedName -DistinguishedName $name.Dn | Should -Be $name.Domain
                }
            }
        }

        Context 'The distinguished name is invalid' {
            foreach ($name in $invalidDistinguishedNames)
            {
                It "Should return `$null for $name" {
                    Get-ADDomainNameFromDistinguishedName -DistinguishedName $name | Should -Be $null
                }
            }
        }
    }

    Describe 'ActiveDirectoryDsc.Common\Add-ADCommonGroupMember' {
        Mock -CommandName Assert-Module -ParameterFilter { $ModuleName -eq 'ActiveDirectory' }

        $memberData = @(
            [PSCustomObject] @{
                Name = 'CN=Account1,DC=contoso,DC=com'
                Domain = 'contoso.com'
            }
            [PSCustomObject] @{
                Name = 'CN=Group1,DC=contoso,DC=com'
                Domain = 'contoso.com'
            }
            [PSCustomObject] @{
                Name = 'CN=Computer1,DC=contoso,DC=com'
                Domain = 'contoso.com'
            }
            [PSCustomObject] @{
                Name = 'CN=Account1,DC=a,DC=contoso,DC=com'
                Domain = 'a.contoso.com'
            }
            [PSCustomObject] @{
                Name = 'CN=Group1,DC=a,DC=contoso,DC=com'
                Domain = 'a.contoso.com'
            }
            [PSCustomObject] @{
                Name = 'CN=Computer1,DC=a,DC=contoso,DC=com'
                Domain = 'a.contoso.com'
            }
            [PSCustomObject] @{
                Name = 'CN=Account1,DC=b,DC=contoso,DC=com'
                Domain = 'b.contoso.com'
            }
            [PSCustomObject] @{
                Name = 'CN=Group1,DC=b,DC=contoso,DC=com'
                Domain = 'b.contoso.com'
            }
            [PSCustomObject] @{
                Name = 'CN=Computer1,DC=b,DC=contoso,DC=com'
                Domain = 'b.contoso.com'
            }
        )

        $invalidMemberData = @(
            'contoso.com\group1'
            'user1@contoso.com'
            'computer1.contoso.com'
        )

        $fakeParameters = @{
            Identity = 'SomeGroup'
        }

        Context 'When all members are in the same domain' {
            Mock -CommandName Add-ADGroupMember
            $groupCount = 0
            foreach ($domainGroup in ($memberData | Group-Object -Property Domain))
            {
                $groupCount ++
                It 'Should not throw an error when calling Add-ADCommonGroupMember' {
                    Add-ADCommonGroupMember -Members $domainGroup.Group.Name -Parameters $fakeParameters
                }
            }

            It "Should have called Add-ADGroupMember $groupCount times" {
                Assert-MockCalled -CommandName Add-ADGroupMember -Exactly -Times $groupCount
            }
        }

        Context 'When members are in different domains' {
            Mock -CommandName Add-ADGroupMember
            Mock -CommandName Get-ADObject -MockWith {
                param
                (
                    [Parameter()]
                    [System.String]
                    $Identity,

                    [Parameter()]
                    [System.String]
                    $Server,

                    [Parameter()]
                    [System.String[]]
                    $Properties
                )

                $objectClass = switch ($Identity)
                {
                    {$Identity -match 'Group'} { 'group' }
                    {$Identity -match 'Account'} { 'user' }
                    {$Identity -match 'Computer'} { 'computer' }
                }

                return (
                    [PSCustomObject] @{
                        objectClass = $objectClass
                    }
                )
            }
            # Mocks should return something that is used with Add-ADGroupMember
            Mock -CommandName Get-ADComputer -MockWith { return 'placeholder' }
            Mock -CommandName Get-ADGroup -MockWith { return 'placeholder' }
            Mock -CommandName Get-ADUser -MockWith { return 'placeholder' }

            It 'Should not throw an error' {
                {Add-ADCommonGroupMember -Members $memberData.Name -Parameters $fakeParameters -MembersInMultipleDomains} | Should -Not -Throw
            }

            It 'Should have called all mocked cmdlets' {
                Assert-MockCalled -CommandName Get-ADComputer -Exactly -Times $memberData.Where( {$_.Name -like '*Computer*'}).Count
                Assert-MockCalled -CommandName Get-ADUser -Exactly -Times $memberData.Where( {$_.Name -like '*Account*'}).Count
                Assert-MockCalled -CommandName Get-ADGroup -Exactly -Times $memberData.Where( {$_.Name -like '*Group*'}).Count
                Assert-MockCalled -CommandName Add-ADGroupMember -Exactly -Times $memberData.Count
            }
        }

        Context 'When the domain name cannot be determined' {
            It 'Should throw the correct error' {
                {
                    Add-ADCommonGroupMember -Members $invalidMemberData -Parameters $fakeParameters -MembersInMultipleDomains
                } | Should -Throw ($script:localizedData.EmptyDomainError -f $invalidMemberData[0], $fakeParameters.Identity)
            }
        }
    }

    Describe 'ActiveDirectoryDsc.Common\Get-DomainControllerObject' {
        Context 'When domain name cannot be reached' {
            BeforeAll {
                Mock -CommandName Get-ADDomainController -MockWith {
                    throw New-Object -TypeName 'Microsoft.ActiveDirectory.Management.ADServerDownException'
                }
            }

            It 'Should throw the correct error' {
                { Get-DomainControllerObject -DomainName 'contoso.com' -Verbose } | Should -Throw $localizedString.FailedEvaluatingDomainController

                Assert-MockCalled -CommandName Get-ADDomainController -Exactly -Times 1 -Scope It
            }
        }

        Context 'When current node is not a domain controller' {
            BeforeAll {
                Mock -CommandName Get-ADDomainController
                Mock -CommandName Test-IsDomainController -MockWith {
                    return $false
                }
            }

            It 'Should return $null' {
                $getDomainControllerObjectResult = Get-DomainControllerObject -DomainName 'contoso.com' -Verbose
                $getDomainControllerObjectResult | Should -BeNullOrEmpty

                Assert-MockCalled -CommandName Get-ADDomainController -Exactly -Times 1 -Scope It
            }
        }

        Context 'When current node is not a domain controller, but operating system information says it should be' {
            BeforeAll {
                Mock -CommandName Get-ADDomainController
                Mock -CommandName Test-IsDomainController -MockWith {
                    return $true
                }
            }

            It 'Should throw the correct error' {
                { Get-DomainControllerObject -DomainName 'contoso.com' -Verbose } | Should -Throw $script:localizedData.WasExpectingDomainController

                Assert-MockCalled -CommandName Get-ADDomainController -Exactly -Times 1 -Scope It
            }
        }

        Context 'When current node is a domain controller' {
            BeforeAll {
                Mock -CommandName Get-ADDomainController -MockWith {
                    return @{
                        Site            = 'MySite'
                        Domain          = 'contoso.com'
                        IsGlobalCatalog = $true
                    }
                }
            }

            It 'Should return the correct values for each property' {
                $getDomainControllerObjectResult = Get-DomainControllerObject -DomainName 'contoso.com' -Verbose

                $getDomainControllerObjectResult.Site | Should -Be 'MySite'
                $getDomainControllerObjectResult.Domain | Should -Be 'contoso.com'
                $getDomainControllerObjectResult.IsGlobalCatalog | Should -BeTrue

                Assert-MockCalled -CommandName Get-ADDomainController -Exactly -Times 1 -Scope It
            }
        }

        Context 'When current node is a domain controller, and using specific credential' {
            BeforeAll {
                Mock -CommandName Get-ADDomainController -MockWith {
                    return @{
                        Site            = 'MySite'
                        Domain          = 'contoso.com'
                        IsGlobalCatalog = $true
                    }
                }

                $mockAdministratorUser = 'admin@contoso.com'
                $mockAdministratorPassword = 'P@ssw0rd-12P@ssw0rd-12' | ConvertTo-SecureString -AsPlainText -Force
                $mockAdministratorCredential = New-Object -TypeName 'System.Management.Automation.PSCredential' -ArgumentList @($mockAdministratorUser, $mockAdministratorPassword)
            }

            It 'Should return the correct values for each property' {
                $getDomainControllerObjectResult = Get-DomainControllerObject -DomainName 'contoso.com' -Credential $mockAdministratorCredential -Verbose

                $getDomainControllerObjectResult.Site | Should -Be 'MySite'
                $getDomainControllerObjectResult.Domain | Should -Be 'contoso.com'
                $getDomainControllerObjectResult.IsGlobalCatalog | Should -BeTrue

                Assert-MockCalled -CommandName Get-ADDomainController -ParameterFilter {
                    $PSBoundParameters.ContainsKey('Credential') -eq $true
                } -Exactly -Times 1 -Scope It
            }
        }
    }

    Describe 'ActiveDirectoryDsc.Common\Test-IsDomainController' {
        Context 'When operating system information says the node is a domain controller' {
            BeforeAll {
                Mock -CommandName Get-CimInstance -MockWith {
                    return @{
                        ProductType = 2
                    }
                }
            }

            It 'Should return $true' {
                $testIsDomainControllerResult = Test-IsDomainController
                $testIsDomainControllerResult | Should -BeTrue

                Assert-MockCalled -CommandName Get-CimInstance -Exactly -Times 1 -Scope It
            }
        }

        Context 'When operating system information says the node is not a domain controller' {
            BeforeAll {
                Mock -CommandName Get-CimInstance -MockWith {
                    return @{
                        ProductType = 3
                    }
                }
            }

            It 'Should return $false' {
                $testIsDomainControllerResult = Test-IsDomainController
                $testIsDomainControllerResult | Should -BeFalse

                Assert-MockCalled -CommandName Get-CimInstance -Exactly -Times 1 -Scope It
            }
        }
    }

    Describe 'ActiveDirectoryDsc.Common\Convert-PropertyMapToObjectProperties' {
        Context 'When a property map should be converted to object properties' {
            BeforeAll {
                $propertyMapValue = @(
                    @{
                        ParameterName = 'ComputerName'
                        PropertyName = 'cn'
                    },
                    @{
                        ParameterName = 'Location'
                    }
                )
            }

            It 'Should return the correct values' {
                $convertPropertyMapToObjectPropertiesResult = Convert-PropertyMapToObjectProperties $propertyMapValue
                $convertPropertyMapToObjectPropertiesResult | Should -HaveCount 2
                $convertPropertyMapToObjectPropertiesResult[0] | Should -Be 'cn'
                $convertPropertyMapToObjectPropertiesResult[1] | Should -Be 'Location'
            }
        }

        Context 'When a property map contains a wrong type' {
            BeforeAll {
                $propertyMapValue = @(
                    @{
                        ParameterName = 'ComputerName'
                        PropertyName = 'cn'
                    },
                    'Location'
                )
            }

            It 'Should throw the correct error' {
                {
                    Convert-PropertyMapToObjectProperties $propertyMapValue
                } | Should -Throw $localizedString.PropertyMapArrayIsWrongType
            }
        }
    }

    Describe 'DscResource.Common\Test-DscPropertyState' -Tag 'TestDscPropertyState' {
        Context 'When comparing tables' {
            It 'Should return true for two identical tables' {
                $mockValues = @{
                    CurrentValue = 'Test'
                    DesiredValue = 'Test'
                }

                Test-DscPropertyState -Values $mockValues | Should -BeTrue
            }
        }

        Context 'When comparing strings' {
            It 'Should return false when a value is different for [System.String]' {
                $mockValues = @{
                    CurrentValue = [System.String] 'something'
                    DesiredValue = [System.String] 'test'
                }

                Test-DscPropertyState -Values $mockValues | Should -BeFalse
            }

            It 'Should return false when a String value is missing' {
                $mockValues = @{
                    CurrentValue = $null
                    DesiredValue = [System.String] 'Something'
                }

                Test-DscPropertyState -Values $mockValues | Should -BeFalse
            }

            It 'Should return true when two strings are equal' {
                $mockValues = @{
                    CurrentValue = [System.String] 'Something'
                    DesiredValue = [System.String] 'Something'
                }

                Test-DscPropertyState -Values $mockValues | Should -Be $true
            }
        }

        Context 'When comparing integers' {
            It 'Should return false when a value is different for [System.Int32]' {
                $mockValues = @{
                    CurrentValue = [System.Int32] 1
                    DesiredValue = [System.Int32] 2
                }

                Test-DscPropertyState -Values $mockValues | Should -BeFalse
            }

            It 'Should return true when the values are the same for [System.Int32]' {
                $mockValues = @{
                    CurrentValue = [System.Int32] 2
                    DesiredValue = [System.Int32] 2
                }

                Test-DscPropertyState -Values $mockValues | Should -Be $true
            }

            It 'Should return false when a value is different for [System.UInt32]' {
                $mockValues = @{
                    CurrentValue = [System.UInt32] 1
                    DesiredValue = [System.UInt32] 2
                }

                Test-DscPropertyState -Values $mockValues | Should -Be $false
            }

            It 'Should return true when the values are the same for [System.UInt32]' {
                $mockValues = @{
                    CurrentValue = [System.UInt32] 2
                    DesiredValue = [System.UInt32] 2
                }

                Test-DscPropertyState -Values $mockValues | Should -Be $true
            }

            It 'Should return false when a value is different for [System.Int16]' {
                $mockValues = @{
                    CurrentValue = [System.Int16] 1
                    DesiredValue = [System.Int16] 2
                }

                Test-DscPropertyState -Values $mockValues | Should -BeFalse
            }

            It 'Should return true when the values are the same for [System.Int16]' {
                $mockValues = @{
                    CurrentValue = [System.Int16] 2
                    DesiredValue = [System.Int16] 2
                }

                Test-DscPropertyState -Values $mockValues | Should -Be $true
            }

            It 'Should return false when a value is different for [System.UInt16]' {
                $mockValues = @{
                    CurrentValue = [System.UInt16] 1
                    DesiredValue = [System.UInt16] 2
                }

                Test-DscPropertyState -Values $mockValues | Should -BeFalse
            }

            It 'Should return true when the values are the same for [System.UInt16]' {
                $mockValues = @{
                    CurrentValue = [System.UInt16] 2
                    DesiredValue = [System.UInt16] 2
                }

                Test-DscPropertyState -Values $mockValues | Should -Be $true
            }

            It 'Should return false when a Integer value is missing' {
                $mockValues = @{
                    CurrentValue = $null
                    DesiredValue = [System.Int32] 1
                }

                Test-DscPropertyState -Values $mockValues | Should -BeFalse
            }
        }

        Context 'When comparing booleans' {
            It 'Should return false when a value is different for [System.Boolean]' {
                $mockValues = @{
                    CurrentValue = [System.Boolean] $true
                    DesiredValue = [System.Boolean] $false
                }

                Test-DscPropertyState -Values $mockValues | Should -BeFalse
            }

            It 'Should return false when a Boolean value is missing' {
                $mockValues = @{
                    CurrentValue = $null
                    DesiredValue = [System.Boolean] $true
                }

                Test-DscPropertyState -Values $mockValues | Should -BeFalse
            }
        }

        Context 'When comparing arrays' {
            It 'Should return true when evaluating an array' {
                $mockValues = @{
                    CurrentValue = @('1','2')
                    DesiredValue = @('1','2')
                }

                Test-DscPropertyState -Values $mockValues | Should -BeTrue
            }

            It 'Should return false when evaluating an array with wrong values' {
                $mockValues = @{
                    CurrentValue = @('CurrentValueA','CurrentValueB')
                    DesiredValue = @('DesiredValue1','DesiredValue2')
                }

                Test-DscPropertyState -Values $mockValues | Should -BeFalse
            }

            It 'Should return false when evaluating an array, but the current value is $null' {
                $mockValues = @{
                    CurrentValue = $null
                    DesiredValue = @('1','2')
                }

                Test-DscPropertyState -Values $mockValues | Should -BeFalse
            }

            It 'Should return false when evaluating an array, but the desired value is $null' {
                $mockValues = @{
                    CurrentValue = @('1','2')
                    DesiredValue = $null
                }

                Test-DscPropertyState -Values $mockValues | Should -BeFalse
            }

            It 'Should return false when evaluating an array, but the current value is an empty array' {
                $mockValues = @{
                    CurrentValue = @()
                    DesiredValue = @('1','2')
                }

                Test-DscPropertyState -Values $mockValues | Should -BeFalse
            }

            It 'Should return false when evaluating an array, but the desired value is an empty array' {
                $mockValues = @{
                    CurrentValue = @('1','2')
                    DesiredValue = @()
                }

                Test-DscPropertyState -Values $mockValues | Should -BeFalse
            }

            It 'Should return true when evaluating an array, when both values are $null' {
                $mockValues = @{
                    CurrentValue = $null
                    DesiredValue = $null
                }

                Test-DscPropertyState -Values $mockValues -Verbose | Should -BeTrue
            }

            It 'Should return true when evaluating an array, when both values are an empty array' {
                $mockValues = @{
                    CurrentValue = @()
                    DesiredValue = @()
                }

                Test-DscPropertyState -Values $mockValues -Verbose | Should -BeTrue
            }
        }

        Context -Name 'When passing invalid types for DesiredValue' {
            It 'Should write a warning when DesiredValue contain an unsupported type' {
                Mock -CommandName Write-Warning -Verifiable

                # This is a dummy type to test with a type that could never be a correct one.
                class MockUnknownType
                {
                    [ValidateNotNullOrEmpty()]
                    [System.String]
                    $Property1

                    [ValidateNotNullOrEmpty()]
                    [System.String]
                    $Property2

                    MockUnknownType()
                    {
                    }
                }

                $mockValues = @{
                    CurrentValue = New-Object -TypeName 'MockUnknownType'
                    DesiredValue = New-Object -TypeName 'MockUnknownType'
                }

                Test-DscPropertyState -Values $mockValues | Should -BeFalse

                Assert-MockCalled -CommandName Write-Warning -Exactly -Times 1 -Scope It
            }
        }

        Assert-VerifiableMock
    }

    Describe 'ActiveDirectoryDsc.Common\Compare-ResourcePropertyState' {
        Context 'When one property is in desired state' {
            BeforeAll {
                $mockCurrentValues = @{
                    ComputerName = 'DC01'
                }

                $mockDesiredValues = @{
                    ComputerName = 'DC01'
                }
            }

            It 'Should return the correct values' {
                $compareTargetResourceStateParameters = @{
                    CurrentValues = $mockCurrentValues
                    DesiredValues = $mockDesiredValues
                }

                $compareTargetResourceStateResult = Compare-ResourcePropertyState @compareTargetResourceStateParameters
                $compareTargetResourceStateResult | Should -HaveCount 1
                $compareTargetResourceStateResult.ParameterName | Should -Be 'ComputerName'
                $compareTargetResourceStateResult.Expected | Should -Be 'DC01'
                $compareTargetResourceStateResult.Actual | Should -Be 'DC01'
                $compareTargetResourceStateResult.InDesiredState | Should -BeTrue
            }
        }

        Context 'When two properties are in desired state' {
            BeforeAll {
                $mockCurrentValues = @{
                    ComputerName = 'DC01'
                    Location = 'Sweden'
                }

                $mockDesiredValues = @{
                    ComputerName = 'DC01'
                    Location = 'Sweden'
                }
            }

            It 'Should return the correct values' {
                $compareTargetResourceStateParameters = @{
                    CurrentValues = $mockCurrentValues
                    DesiredValues = $mockDesiredValues
                }

                $compareTargetResourceStateResult = Compare-ResourcePropertyState @compareTargetResourceStateParameters
                $compareTargetResourceStateResult | Should -HaveCount 2
                $compareTargetResourceStateResult[0].ParameterName | Should -Be 'ComputerName'
                $compareTargetResourceStateResult[0].Expected | Should -Be 'DC01'
                $compareTargetResourceStateResult[0].Actual | Should -Be 'DC01'
                $compareTargetResourceStateResult[0].InDesiredState | Should -BeTrue
                $compareTargetResourceStateResult[1].ParameterName | Should -Be 'Location'
                $compareTargetResourceStateResult[1].Expected | Should -Be 'Sweden'
                $compareTargetResourceStateResult[1].Actual | Should -Be 'Sweden'
                $compareTargetResourceStateResult[1].InDesiredState | Should -BeTrue
            }
        }

        Context 'When passing just one property and that property is not in desired state' {
            BeforeAll {
                $mockCurrentValues = @{
                    ComputerName = 'DC01'
                }

                $mockDesiredValues = @{
                    ComputerName = 'APP01'
                }
            }

            It 'Should return the correct values' {
                $compareTargetResourceStateParameters = @{
                    CurrentValues = $mockCurrentValues
                    DesiredValues = $mockDesiredValues
                }

                $compareTargetResourceStateResult = Compare-ResourcePropertyState @compareTargetResourceStateParameters
                $compareTargetResourceStateResult | Should -HaveCount 1
                $compareTargetResourceStateResult.ParameterName | Should -Be 'ComputerName'
                $compareTargetResourceStateResult.Expected | Should -Be 'APP01'
                $compareTargetResourceStateResult.Actual | Should -Be 'DC01'
                $compareTargetResourceStateResult.InDesiredState | Should -BeFalse
            }
        }

        Context 'When passing two properties and one property is not in desired state' {
            BeforeAll {
                $mockCurrentValues = @{
                    ComputerName = 'DC01'
                    Location = 'Sweden'
                }

                $mockDesiredValues = @{
                    ComputerName = 'DC01'
                    Location = 'Europe'
                }
            }

            It 'Should return the correct values' {
                $compareTargetResourceStateParameters = @{
                    CurrentValues = $mockCurrentValues
                    DesiredValues = $mockDesiredValues
                }

                $compareTargetResourceStateResult = Compare-ResourcePropertyState @compareTargetResourceStateParameters
                $compareTargetResourceStateResult | Should -HaveCount 2
                $compareTargetResourceStateResult[0].ParameterName | Should -Be 'ComputerName'
                $compareTargetResourceStateResult[0].Expected | Should -Be 'DC01'
                $compareTargetResourceStateResult[0].Actual | Should -Be 'DC01'
                $compareTargetResourceStateResult[0].InDesiredState | Should -BeTrue
                $compareTargetResourceStateResult[1].ParameterName | Should -Be 'Location'
                $compareTargetResourceStateResult[1].Expected | Should -Be 'Europe'
                $compareTargetResourceStateResult[1].Actual | Should -Be 'Sweden'
                $compareTargetResourceStateResult[1].InDesiredState | Should -BeFalse
            }
        }

        Context 'When passing a common parameter set to desired value' {
            BeforeAll {
                $mockCurrentValues = @{
                    ComputerName = 'DC01'
                }

                $mockDesiredValues = @{
                    ComputerName = 'DC01'
                    Verbose = $true
                }
            }

            It 'Should return the correct values' {
                $compareTargetResourceStateParameters = @{
                    CurrentValues = $mockCurrentValues
                    DesiredValues = $mockDesiredValues
                }

                $compareTargetResourceStateResult = Compare-ResourcePropertyState @compareTargetResourceStateParameters
                $compareTargetResourceStateResult | Should -HaveCount 1
                $compareTargetResourceStateResult.ParameterName | Should -Be 'ComputerName'
                $compareTargetResourceStateResult.Expected | Should -Be 'DC01'
                $compareTargetResourceStateResult.Actual | Should -Be 'DC01'
                $compareTargetResourceStateResult.InDesiredState | Should -BeTrue
            }
        }

        Context 'When using parameter Properties to compare desired values' {
            BeforeAll {
                $mockCurrentValues = @{
                    ComputerName = 'DC01'
                    Location = 'Sweden'
                }

                $mockDesiredValues = @{
                    ComputerName = 'DC01'
                    Location = 'Europe'
                }
            }

            It 'Should return the correct values' {
                $compareTargetResourceStateParameters = @{
                    CurrentValues = $mockCurrentValues
                    DesiredValues = $mockDesiredValues
                    Properties = @(
                        'ComputerName'
                    )
                }

                $compareTargetResourceStateResult = Compare-ResourcePropertyState @compareTargetResourceStateParameters
                $compareTargetResourceStateResult | Should -HaveCount 1
                $compareTargetResourceStateResult.ParameterName | Should -Be 'ComputerName'
                $compareTargetResourceStateResult.Expected | Should -Be 'DC01'
                $compareTargetResourceStateResult.Actual | Should -Be 'DC01'
                $compareTargetResourceStateResult.InDesiredState | Should -BeTrue
            }
        }

        Context 'When using parameter Properties and IgnoreProperties to compare desired values' {
            BeforeAll {
                $mockCurrentValues = @{
                    ComputerName = 'DC01'
                    Location = 'Sweden'
                    Ensure = 'Present'
                }

                $mockDesiredValues = @{
                    ComputerName = 'DC01'
                    Location = 'Europe'
                    Ensure = 'Absent'
                }
            }

            It 'Should return the correct values' {
                $compareTargetResourceStateParameters = @{
                    CurrentValues = $mockCurrentValues
                    DesiredValues = $mockDesiredValues
                    IgnoreProperties = @(
                        'Ensure'
                    )
                }

                $compareTargetResourceStateResult = Compare-ResourcePropertyState @compareTargetResourceStateParameters
                $compareTargetResourceStateResult | Should -HaveCount 2
                $compareTargetResourceStateResult[0].ParameterName | Should -Be 'ComputerName'
                $compareTargetResourceStateResult[0].Expected | Should -Be 'DC01'
                $compareTargetResourceStateResult[0].Actual | Should -Be 'DC01'
                $compareTargetResourceStateResult[0].InDesiredState | Should -BeTrue
                $compareTargetResourceStateResult[1].ParameterName | Should -Be 'Location'
                $compareTargetResourceStateResult[1].Expected | Should -Be 'Europe'
                $compareTargetResourceStateResult[1].Actual | Should -Be 'Sweden'
                $compareTargetResourceStateResult[1].InDesiredState | Should -BeFalse
            }
        }

        Context 'When using parameter Properties and IgnoreProperties to compare desired values' {
            BeforeAll {
                $mockCurrentValues = @{
                    ComputerName = 'DC01'
                    Location = 'Sweden'
                    Ensure = 'Present'
                }

                $mockDesiredValues = @{
                    ComputerName = 'DC01'
                    Location = 'Europe'
                    Ensure = 'Absent'
                }
            }

            It 'Should return and empty array' {
                $compareTargetResourceStateParameters = @{
                    CurrentValues = $mockCurrentValues
                    DesiredValues = $mockDesiredValues
                    Properties = @(
                        'ComputerName'
                    )
                    IgnoreProperties = @(
                        'ComputerName'
                    )
                }

                $compareTargetResourceStateResult = Compare-ResourcePropertyState @compareTargetResourceStateParameters
                $compareTargetResourceStateResult | Should -BeNullOrEmpty
            }
        }
    }

    Describe 'ActiveDirectoryDsc.Common\Assert-ADPSDrive' {
        Mock -CommandName Assert-Module

        Context 'When the AD PS Drive does not exist and the New-PSDrive function is successful' {
            Mock -CommandName Get-PSDrive -MockWith { $null }
            Mock -CommandName New-PSDrive

            It 'Should not throw' {
                { Assert-ADPSDrive } | Should -Not -Throw
            }

            It 'Should have called Assert-Module' {
                Assert-MockCalled -CommandName Assert-Module -Exactly -Times 1 -Scope Context
            }

            It 'Should have called Get-PSDrive only once' {
                Assert-MockCalled -CommandName Get-PSDrive -Exactly -Times 1 -Scope Context
            }

            It 'Should have called New-PSDrive only once' {
                Assert-MockCalled -CommandName New-PSDrive -Exactly -Times 1 -Scope Context
            }
        }

        Context 'When the AD PS Drive does not exist and the New-PSDrive function is not successful' {
            Mock -CommandName Get-PSDrive -MockWith { $null }
            Mock -CommandName New-PSDrive -MockWith { throw }

            It 'Should throw the correct error' {
                { Assert-ADPSDrive } | Should -Throw $script:localizedString.CreatingNewADPSDriveError
            }

            It 'Should call Assert-Module' {
                Assert-MockCalled -CommandName Assert-Module -Exactly -Times 1 -Scope Context
            }

            It 'Should call Get-PSDrive once' {
                Assert-MockCalled -CommandName Get-PSDrive -Exactly -Times 1 -Scope Context
            }

            It 'Should call New-PSDrive once' {
                Assert-MockCalled -CommandName New-PSDrive -Exactly -Times 1 -Scope Context
            }
        }

        Context 'When the AD PS Drive already exists' {
            Mock -CommandName Get-PSDrive -MockWith { New-MockObject -Type System.Management.Automation.PSDriveInfo }
            Mock -CommandName New-PSDrive

            It 'Should not throw' {
              { Assert-ADPSDrive } | Should -Not -Throw
            }

            It 'Should call Assert-Module only once' {
                Assert-MockCalled -CommandName Assert-Module -Exactly -Times 1 -Scope Context
            }

            It 'Should call Get-PSDrive only once' {
                Assert-MockCalled -CommandName Get-PSDrive -Exactly -Times 1 -Scope Context
            }

            It 'Should not call New-PSDrive' {
                Assert-MockCalled -CommandName New-PSDrive -Exactly -Times 0 -Scope Context
            }
        }
    }

    Describe 'ActiveDirectoryDsc.Common\Test-ADReplicationSite' {
        BeforeAll {
            $mockAdministratorUser = 'admin@contoso.com'
            $mockAdministratorPassword = 'P@ssw0rd-12P@ssw0rd-12'
            $mockAdministratorCredential = New-Object -TypeName 'System.Management.Automation.PSCredential' -ArgumentList @(
                $mockAdministratorUser,
                ($mockAdministratorPassword | ConvertTo-SecureString -AsPlainText -Force)
            )

            Mock -CommandName Get-ADDomainController -MockWith {
                return @{
                    HostName = $env:COMPUTERNAME
                }
            }
        }

        Context 'When a replication site does not exist' {
            BeforeAll {
                Mock -CommandName Get-ADReplicationSite -MockWith {
                    throw New-Object -TypeName 'Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException'
                }
            }

            It 'Should return $false' {
                $testADReplicationSiteResult = Test-ADReplicationSite -SiteName 'TestSite' -DomainName 'contoso.com' -Credential $mockAdministratorCredential
                $testADReplicationSiteResult | Should -BeFalse

                Assert-MockCalled -CommandName Get-ADDomainController -Exactly -Times 1 -Scope It
                Assert-MockCalled -CommandName Get-ADReplicationSite -Exactly -Times 1 -Scope It
            }
        }

        Context 'When a replication site exist' {
            BeforeAll {
                Mock -CommandName Get-ADReplicationSite -MockWith {
                    return 'site object'
                }
            }

            It 'Should return $true' {
                $testADReplicationSiteResult = Test-ADReplicationSite -SiteName 'TestSite' -DomainName 'contoso.com' -Credential $mockAdministratorCredential
                $testADReplicationSiteResult | Should -BeTrue

                Assert-MockCalled -CommandName Get-ADDomainController -Exactly -Times 1 -Scope It
                Assert-MockCalled -CommandName Get-ADReplicationSite -Exactly -Times 1 -Scope It
            }
        }
    }

    Describe 'ActiveDirectoryDsc.Common\New-CimCredentialInstance' {
        Context 'When creating a new MSFT_Credential CIM instance credential object' {
            BeforeAll {
                $mockAdministratorUser = 'admin@contoso.com'
                $mockAdministratorPassword = 'P@ssw0rd-12P@ssw0rd-12'
                $mockAdministratorCredential = New-Object -TypeName 'System.Management.Automation.PSCredential' -ArgumentList @(
                    $mockAdministratorUser,
                    ($mockAdministratorPassword | ConvertTo-SecureString -AsPlainText -Force)
                )
            }

            It 'Should return the correct values' {
                $newCimCredentialInstanceResult = New-CimCredentialInstance -Credential $mockAdministratorCredential
                $newCimCredentialInstanceResult | Should -BeOfType 'Microsoft.Management.Infrastructure.CimInstance'
                $newCimCredentialInstanceResult.CimClass.CimClassName | Should -Be 'MSFT_Credential'
                $newCimCredentialInstanceResult.UserName | Should -Be $mockAdministratorUser
                $newCimCredentialInstanceResult.Password | Should -BeNullOrEmpty
            }
        }
    }

    Describe 'ActiveDirectoryDsc.Common\Add-TypeAssembly' {
        Context 'When assembly fails to load' {
            BeforeAll {
                Mock -CommandName Add-Type -MockWith {
                    throw
                }

                $mockAssembly = 'MyAssembly'
            }

            It 'Should throw the correct error' {
                { Add-TypeAssembly -AssemblyName $mockAssembly } | Should -Throw ($script:localizedData.CouldNotLoadAssembly -f $mockAssembly)
            }
        }

        Context 'When loading an assembly into the session' {
            BeforeAll {
                Mock -CommandName Add-Type

                $mockAssembly = 'MyAssembly'
            }

            It 'Should not throw and call the correct mocks' {
                { Add-TypeAssembly -AssemblyName $mockAssembly } | Should -Not -Throw

                Assert-MockCalled -CommandName Add-Type -ParameterFilter {
                    $AssemblyName -eq $mockAssembly
                } -Exactly -Times 1 -Scope It
            }

            Context 'When the type is already loaded into the session' {
                It 'Should not throw and not call any mocks' {
                    { Add-TypeAssembly -AssemblyName $mockAssembly -TypeName 'System.String' } | Should -Not -Throw

                    Assert-MockCalled -CommandName Add-Type -Exactly -Times 0 -Scope It
                }
            }

            Context 'When the type is missing from the session' {
                It 'Should not throw and call the correct mocks' {
                    { Add-TypeAssembly -AssemblyName $mockAssembly -TypeName 'My.Type' } | Should -Not -Throw

                    Assert-MockCalled -CommandName Add-Type -ParameterFilter {
                        $AssemblyName -eq $mockAssembly
                    } -Exactly -Times 1 -Scope It
                }
            }
        }
    }

    Describe 'ActiveDirectoryDsc.Common\New-ADDirectoryContext' {
        Context 'When creating a new Active Directory context' {
            BeforeAll {
                # This credential object must be created before we mock New-Object.
                $mockAdministratorUser = 'admin@contoso.com'
                $mockAdministratorPassword = 'P@ssw0rd-12P@ssw0rd-12'
                $mockAdministratorCredential = New-Object -TypeName 'System.Management.Automation.PSCredential' -ArgumentList @(
                    $mockAdministratorUser,
                    ($mockAdministratorPassword | ConvertTo-SecureString -AsPlainText -Force)
                )

                Mock -CommandName Add-TypeAssembly -Verifiable
                Mock -CommandName New-Object
            }

            Context 'When the calling with only parameter DirectoryContextType' {
                It 'Should not throw and call the correct mocks' {
                    { Get-ADDirectoryContext -DirectoryContextType 'Domain' } | Should -Not -Throw

                    Assert-MockCalled -CommandName New-Object -ParameterFilter {
                        $ArgumentList.Count -eq 1 `
                        -and $ArgumentList[0] -eq 'Domain'
                    } -Exactly -Times 1 -Scope It
                }
            }

            Context 'When the calling with parameters DirectoryContextType and Name' {
                It 'Should not throw and call the correct mocks' {
                    {
                        Get-ADDirectoryContext -DirectoryContextType 'Domain' -Name 'my.domain'
                    } | Should -Not -Throw

                    Assert-MockCalled -CommandName New-Object -ParameterFilter {
                        $ArgumentList.Count -eq 2 `
                        -and $ArgumentList[0] -eq 'Domain' `
                        -and $ArgumentList[1] -eq 'my.domain'
                    } -Exactly -Times 1 -Scope It
                }
            }

            Context 'When the calling with parameters DirectoryContextType, Name and Credential' {
                It 'Should not throw and call the correct mocks' {
                    {
                        Get-ADDirectoryContext -DirectoryContextType 'Domain' -Name 'my.domain' -Credential $mockAdministratorCredential
                    } | Should -Not -Throw

                    Assert-MockCalled -CommandName New-Object -ParameterFilter {
                        $ArgumentList.Count -eq 4 `
                        -and $ArgumentList[0] -eq 'Domain' `
                        -and $ArgumentList[1] -eq 'my.domain' `
                        -and $ArgumentList[2] -eq $mockAdministratorUser `
                        -and $ArgumentList[3] -eq $mockAdministratorPassword
                    } -Exactly -Times 1 -Scope It
                }
            }

            Assert-VerifiableMock
        }
    }

    Describe 'ActiveDirectoryDsc.Common\Find-DomainController' -Tag 'FindDomainController'  {
        Context 'When a domain controller is found in a domain' {
            BeforeAll {
                $mockAdministratorUser = 'admin@contoso.com'
                $mockAdministratorPassword = 'P@ssw0rd-12P@ssw0rd-12'
                $mockAdministratorCredential = New-Object -TypeName 'System.Management.Automation.PSCredential' -ArgumentList @(
                    $mockAdministratorUser,
                    ($mockAdministratorPassword | ConvertTo-SecureString -AsPlainText -Force)
                )

                $mockDomainName = 'contoso.com'

                Mock -CommandName Find-DomainControllerFindOneInSiteWrapper
                Mock -CommandName Find-DomainControllerFindOneWrapper
                Mock -CommandName Get-ADDirectoryContext -MockWith {
                    return New-Object `
                        -TypeName 'System.DirectoryServices.ActiveDirectory.DirectoryContext' `
                        -ArgumentList @('Domain', $mockDomainName)
                }
            }

            Context 'When the calling with only the parameter DomainName' {
                It 'Should not throw and call the correct mocks' {
                    { Find-DomainController -DomainName $mockDomainName -Verbose } | Should -Not -Throw

                    Assert-MockCalled -CommandName Get-ADDirectoryContext -ParameterFilter {
                        $Name -eq $mockDomainName `
                        -and -not $PSBoundParameters.ContainsKey('Credential')
                    } -Exactly -Times 1 -Scope It

                    Assert-MockCalled -Command Find-DomainControllerFindOneWrapper -Exactly -Times 1 -Scope It
                    Assert-MockCalled -Command Find-DomainControllerFindOneInSiteWrapper -Exactly -Times 0 -Scope It
                }
            }

            Context 'When the calling with the parameter SiteName' {
                It 'Should not throw and call the correct mocks' {
                    { Find-DomainController -DomainName $mockDomainName -SiteName 'Europe' -Verbose } | Should -Not -Throw

                    Assert-MockCalled -CommandName Get-ADDirectoryContext -ParameterFilter {
                        $Name -eq $mockDomainName `
                        -and -not $PSBoundParameters.ContainsKey('Credential')
                    } -Exactly -Times 1 -Scope It

                    Assert-MockCalled -Command Find-DomainControllerFindOneWrapper -Exactly -Times 0 -Scope It
                    Assert-MockCalled -Command Find-DomainControllerFindOneInSiteWrapper -Exactly -Times 1 -Scope It
                }
            }

            Context 'When the calling with the parameter Credential' {
                It 'Should not throw and call the correct mocks' {
                    { Find-DomainController -DomainName $mockDomainName -Credential $mockAdministratorCredential -Verbose } | Should -Not -Throw

                    Assert-MockCalled -CommandName Get-ADDirectoryContext -ParameterFilter {
                        $Name -eq $mockDomainName `
                        -and $PSBoundParameters.ContainsKey('Credential')
                    } -Exactly -Times 1 -Scope It

                    Assert-MockCalled -Command Find-DomainControllerFindOneWrapper -Exactly -Times 1 -Scope It
                    Assert-MockCalled -Command Find-DomainControllerFindOneInSiteWrapper -Exactly -Times 0 -Scope It
                }
            }

            Assert-VerifiableMock
        }

        Context 'When no domain controller is found' {
            BeforeAll {
                Mock -CommandName Get-ADDirectoryContext -MockWith {
                    return New-Object `
                        -TypeName 'System.DirectoryServices.ActiveDirectory.DirectoryContext' `
                        -ArgumentList @('Domain', $mockDomainName)
                }

                Mock -CommandName Find-DomainControllerFindOneWrapper -MockWith {
                    throw New-object -TypeName 'System.DirectoryServices.ActiveDirectory.ActiveDirectoryObjectNotFoundException'
                }

                Mock -CommandName Write-Verbose -ParameterFilter {
                    $Message -eq ($script:localizedData.FailedToFindDomainController -f $mockDomainName)
                } -MockWith {
                    Write-Verbose -Message ('VERBOSE OUTPUT FROM MOCK: {0}' -f $Message) -Verbose
                }
            }

            It 'Should not throw and call the correct mocks' {
                { Find-DomainController -DomainName $mockDomainName -Verbose } | Should -Not -Throw

                Assert-MockCalled -Command Find-DomainControllerFindOneWrapper -Exactly -Times 1 -Scope It
                Assert-MockCalled -Command Write-Verbose -Exactly -Times 1 -Scope It
            }

            Assert-VerifiableMock
        }

        Context 'When the lookup for a domain controller fails' {
            BeforeAll {
                Mock -CommandName Get-ADDirectoryContext -MockWith {
                    return New-Object `
                        -TypeName 'System.DirectoryServices.ActiveDirectory.DirectoryContext' `
                        -ArgumentList @('Domain', $mockDomainName)
                }

                $mockErrorMessage = 'Mocked error'

                Mock -CommandName Find-DomainControllerFindOneWrapper -MockWith {
                    throw $mockErrorMessage
                }
            }

            It 'Should throw the correct error' {
                { Find-DomainController -DomainName $mockDomainName -Verbose } | Should -Throw $mockErrorMessage

                Assert-MockCalled -Command Find-DomainControllerFindOneWrapper -Exactly -Times 1 -Scope It
            }

            Assert-VerifiableMock
        }

        Context 'When the Find-DomainController throws an authentication exception' {
            BeforeAll {
                $mockErrorMessage = 'The user name or password is incorrect.'

                Mock -CommandName Find-DomainControllerFindOneWrapper -MockWith {
                    $exceptionWithInnerException = New-Object -TypeName 'System.Management.Automation.MethodInvocationException' `
                    -ArgumentList @(
                        $mockErrorMessage,
                        (New-Object -TypeName 'System.Security.Authentication.AuthenticationException')
                    )

                    $newObjectParameters = @{
                        TypeName     = 'System.Management.Automation.ErrorRecord'
                        ArgumentList = @(
                            $exceptionWithInnerException,
                            'AuthenticationException',
                            'InvalidOperation',
                            $null
                        )
                    }

                    throw New-Object @newObjectParameters
                }
            }

            Context 'When the parameter WaitForValidCredentials is not specified' {
                It 'Should throw the correct error' {
                    { Find-DomainController -DomainName $mockDomainName -Verbose } | Should -Throw $mockErrorMessage

                    Assert-MockCalled -Command Find-DomainControllerFindOneWrapper -Exactly -Times 1 -Scope It
                }
            }

            Context 'When the parameter WaitForValidCredentials is set to $false' {
                It 'Should throw the correct error' {
                    { Find-DomainController -DomainName $mockDomainName -WaitForValidCredentials:$false -Verbose } | Should -Throw $mockErrorMessage

                    Assert-MockCalled -Command Find-DomainControllerFindOneWrapper -Exactly -Times 1 -Scope It
                }
            }

            Context 'When the parameter WaitForValidCredentials is set to $true' {
                BeforeAll {
                    Mock -CommandName Write-Warning
                }

                It 'Should not throw an exception' {
                    { Find-DomainController -DomainName $mockDomainName -WaitForValidCredentials -Verbose } | Should -Not -Throw

                    Assert-MockCalled -Command Find-DomainControllerFindOneWrapper -Exactly -Times 1 -Scope It
                    Assert-MockCalled -CommandName Write-Warning -Exactly -Times 1 -Scope It
                }
            }
        }
    }
}
