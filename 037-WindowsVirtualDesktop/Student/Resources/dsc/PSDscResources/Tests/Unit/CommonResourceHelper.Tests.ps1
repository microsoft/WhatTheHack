$errorActionPreference = 'Stop'
Set-StrictMode -Version 'Latest'

Describe 'CommonResourceHelper Unit Tests' {
    BeforeAll {
        # Import the CommonResourceHelper module to test
        $testsFolderFilePath = Split-Path -Path $PSScriptRoot -Parent
        $moduleRootFilePath = Split-Path -Path $testsFolderFilePath -Parent
        $dscResourcesFolderFilePath = Join-Path -Path $moduleRootFilePath -ChildPath 'DscResources'
        $commonResourceHelperFilePath = Join-Path -Path $dscResourcesFolderFilePath -ChildPath 'CommonResourceHelper.psm1'
        Import-Module -Name $commonResourceHelperFilePath
    }

    InModuleScope 'CommonResourceHelper' {
        Describe 'Test-IsNanoServer' {
            $testComputerInfoNanoServer = @{
                NanoServer = 1
            }

            $testComputerInfoServerNotNano = @{
            }

            Context 'Computer OS type is Server and OS server level is NanoServer' {
                Mock -CommandName 'Test-Path' -MockWith { return $true }
                Mock -CommandName 'Get-ItemProperty' -MockWith { return $testComputerInfoNanoServer }
                It 'Should not throw' {
                    { $null = Test-IsNanoServer } | Should -Not -Throw
                }

                It 'Should check the ServerLevels registry path' {
                    Assert-MockCalled -CommandName 'Get-ItemProperty' -Exactly 1 -Scope 'Context'
                }

                It 'Should return true' {
                    Test-IsNanoServer | Should -BeTrue
                }
            }

            Context 'Computer OS type is Server and OS server level is not NanoServer' {
                Mock -CommandName 'Test-Path' -MockWith { return $true }
                Mock -CommandName 'Get-ItemProperty' -MockWith { return $testComputerInfoServerNotNano }

                It 'Should not throw' {
                    { $null = Test-IsNanoServer } | Should -Not -Throw
                }

                It 'Should check the ServerLevels registry path' {
                    Assert-MockCalled -CommandName 'Get-ItemProperty' -Exactly 1 -Scope 'Context'
                }

                It 'Should return false' {
                    Test-IsNanoServer | Should -BeFalse
                }
            }

            Context 'Computer OS type is not Server' {
                Mock -CommandName 'Test-Path' -MockWith { return $false }

                It 'Should not throw' {
                    { $null = Test-IsNanoServer } | Should -Not -Throw
                }

                It 'Should check the ServerLevels registry path' {
                    Assert-MockCalled -CommandName 'Test-Path' -Exactly 1 -Scope 'Context'
                }

                It 'Should return false' {
                    Test-IsNanoServer | Should -BeFalse
                }
            }
        }

        Describe 'Test-CommandExists' {
            $testCommandName = 'TestCommandName'

            Mock -CommandName 'Get-Command' -MockWith { return $Name }

            Context 'Get-Command returns the command' {
                It 'Should not throw' {
                    { $null = Test-CommandExists -Name $testCommandName } | Should -Not -Throw
                }

                It 'Should retrieve the command with the specified name' {
                    $getCommandParameterFilter = {
                        return $Name -eq $testCommandName
                    }

                    Assert-MockCalled -CommandName 'Get-Command' -ParameterFilter $getCommandParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should return true' {
                    Test-CommandExists -Name $testCommandName | Should -BeTrue
                }
            }

            Context 'Get-Command returns null' {
                Mock -CommandName 'Get-Command' -MockWith { return $null }

                It 'Should not throw' {
                    { $null = Test-CommandExists -Name $testCommandName } | Should -Not -Throw
                }

                It 'Should retrieve the command with the specified name' {
                    $getCommandParameterFilter = {
                        return $Name -eq $testCommandName
                    }

                    Assert-MockCalled -CommandName 'Get-Command' -ParameterFilter $getCommandParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should return false' {
                    Test-CommandExists -Name $testCommandName | Should -BeFalse
                }
            }
        }
    }
}
