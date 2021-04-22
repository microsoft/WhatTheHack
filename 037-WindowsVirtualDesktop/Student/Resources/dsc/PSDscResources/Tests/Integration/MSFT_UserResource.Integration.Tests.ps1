<#
    To run these tests, the currently logged on user must have rights to create a user.
    These integration tests cover creating a brand new user, updating values
    of a user that already exists, and deleting a user that exists.
#>

# Suppressing this rule since we need to create a plaintext password to test this resource
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
param ()

if ($PSVersionTable.PSVersion -lt [Version] '5.1')
{
    Write-Warning -Message 'Cannot run PSDscResources integration tests on PowerShell versions lower than 5.1'
    return
}

$errorActionPreference = 'Stop'
Set-StrictMode -Version 'Latest'

$script:testFolderPath = Split-Path -Path $PSScriptRoot -Parent
$script:testHelpersPath = Join-Path -Path $script:testFolderPath -ChildPath 'TestHelpers'
Import-Module -Name (Join-Path -Path $script:testHelpersPath -ChildPath 'CommonTestHelper.psm1')

$script:testEnvironment = Enter-DscResourceTestEnvironment `
    -DscResourceModuleName 'PSDscResources' `
    -DscResourceName 'MSFT_UserResource' `
    -TestType 'Integration'

try
{

    $configFile = Join-Path -Path $PSScriptRoot -ChildPath 'MSFT_UserResource.config.ps1'

    Describe 'UserResource Integration Tests' {
        $script:configData = @{
            AllNodes = @(
                @{
                    NodeName = '*'
                    PSDscAllowPlainTextPassword = $true
                }
                @{
                    NodeName = 'localhost'
                }
            )
        }

        $script:logPath = Join-Path -Path $TestDrive -ChildPath 'NewUser.log'

        $script:testUserName = 'TestUserName12345'
        $script:testPassword = 'StrongOne7.'
        $script:testDescription = 'Test Description'
        $script:newTestDescription = 'New Test Description'
        $script:secureTestPassword = ConvertTo-SecureString $script:testPassword -AsPlainText -Force
        $script:testCredential = New-Object PSCredential ($script:testUserName, $script:secureTestPassword)

        Context 'Should create a new user' {
            $configurationName = 'MSFT_User_NewUser'
            $configurationPath = Join-Path -Path $TestDrive -ChildPath $configurationName

            try
            {
                It 'Should compile without throwing' {
                    {
                        . $configFile -ConfigurationName $configurationName
                        & $configurationName -UserName $script:testUserName `
                                             -Password $script:testCredential `
                                             -Description $script:testDescription `
                                             -OutputPath $configurationPath `
                                             -ConfigurationData $script:configData `
                                             -ErrorAction Stop
                        Start-DscConfiguration -Path $configurationPath -Wait -Force
                    } | Should -Not -Throw
                }

                It 'Should be able to call Get-DscConfiguration without throwing' {
                    { Get-DscConfiguration -ErrorAction Stop } | Should -Not -Throw
                }

                It 'Should return the correct configuration' {
                    $currentConfig = Get-DscConfiguration -ErrorAction Stop
                    $currentConfig.UserName | Should Be $script:testUserName
                    $currentConfig.Ensure | Should -Be 'Present'
                    $currentConfig.Description | Should Be $script:testDescription
                    $currentConfig.PasswordNeverExpires | Should -BeFalse
                    $currentConfig.Disabled | Should -BeFalse
                    $currentConfig.PasswordChangeRequired | Should -Be $null
                }
            }
            finally
            {
                if (Test-Path -Path $script:logPath) {
                    Remove-Item -Path $script:logPath -Recurse -Force
                }

                if (Test-Path -Path $configurationPath)
                {
                    Remove-Item -Path $configurationPath -Recurse -Force
                }
            }
        }

        Context 'Should update Description of an existing user' {
            $configurationName = 'MSFT_User_UpdateUserDescription'
            $configurationPath = Join-Path -Path $TestDrive -ChildPath $configurationName
            $newTestDescription = 'New Test Description'

            try
            {
                It 'Should compile without throwing' {
                    {
                        . $configFile -ConfigurationName $configurationName
                        & $configurationName -UserName $script:testUserName `
                                             -Password $script:testCredential `
                                             -Description $newTestDescription `
                                             -OutputPath $configurationPath `
                                             -ConfigurationData $script:configData `
                                             -ErrorAction 'Stop'
                        Start-DscConfiguration -Path $configurationPath -Wait -Force
                    } | Should Not Throw
                }

                It 'Should be able to call Get-DscConfiguration without throwing' {
                    { Get-DscConfiguration -ErrorAction 'Stop' } | Should Not Throw
                }

                It 'Should return the correct configuration' {
                    $currentConfig = Get-DscConfiguration -ErrorAction 'Stop'
                    $currentConfig.UserName | Should Be $script:testUserName
                    $currentConfig.Ensure | Should Be 'Present'
                    $currentConfig.Description | Should Be $newTestDescription
                    $currentConfig.PasswordNeverExpires | Should -BeFalse
                    $currentConfig.Disabled | Should -BeFalse
                    $currentConfig.PasswordChangeRequired | Should Be $null
                }
            }
            finally
            {
                if (Test-Path -Path $script:logPath) {
                    Remove-Item -Path $script:logPath -Recurse -Force
                }

                if (Test-Path -Path $configurationPath)
                {
                    Remove-Item -Path $configurationPath -Recurse -Force
                }
            }
        }

        Context 'Should update Description, FullName, and PasswordNeverExpires of an existing user' {
            $configurationName = 'MSFT_User_UpdateUserPassword'
            $configurationPath = Join-Path -Path $TestDrive -ChildPath $configurationName
            $newFullName = 'New Full Name'

            try
            {
                It 'Should compile without throwing' {
                    {
                        . $configFile -ConfigurationName $configurationName
                        & $configurationName -UserName $script:testUserName `
                                             -Password $script:testCredential `
                                             -Description $script:testDescription `
                                             -FullName $newFullName `
                                             -PasswordNeverExpires $true `
                                             -OutputPath $configurationPath `
                                             -ConfigurationData $script:configData `
                                             -ErrorAction Stop
                        Start-DscConfiguration -Path $configurationPath -Wait -Force
                    } | Should -Not -Throw
                }

                It 'Should be able to call Get-DscConfiguration without throwing' {
                    { Get-DscConfiguration -ErrorAction Stop } | Should -Not -Throw
                }

                It 'Should return the correct configuration' {
                    $currentConfig = Get-DscConfiguration -ErrorAction Stop
                    $currentConfig.UserName | Should Be $script:testUserName
                    $currentConfig.Ensure | Should -Be 'Present'
                    $currentConfig.Description | Should Be $script:testDescription
                    $currentConfig.FullName | Should Be $newFullName
                    $currentConfig.PasswordNeverExpires | Should -BeTrue
                    $currentConfig.Disabled | Should -BeFalse
                    $currentConfig.PasswordChangeRequired | Should -Be $null
                }
            }
            finally
            {
                if (Test-Path -Path $script:logPath) {
                    Remove-Item -Path $script:logPath -Recurse -Force
                }

                if (Test-Path -Path $configurationPath)
                {
                    Remove-Item -Path $configurationPath -Recurse -Force
                }
            }
        }

        Context 'Should delete an existing user' {
            $configurationName = 'MSFT_User_DeleteUser'
            $configurationPath = Join-Path -Path $TestDrive -ChildPath $configurationName

            try
            {
                It 'Should compile without throwing' {
                    {
                        . $configFile -ConfigurationName $configurationName
                        & $configurationName -UserName $script:testUserName `
                                             -Password $script:testCredential `
                                             -OutputPath $configurationPath `
                                             -ConfigurationData $script:configData `
                                             -Ensure 'Absent' `
                                             -ErrorAction Stop
                        Start-DscConfiguration -Path $configurationPath -Wait -Force
                    } | Should -Not -Throw
                }

                It 'Should be able to call Get-DscConfiguration without throwing' {
                    { Get-DscConfiguration -ErrorAction Stop } | Should -Not -Throw
                }

                It 'Should return the correct configuration' {
                    $currentConfig = Get-DscConfiguration -ErrorAction Stop
                    $currentConfig.UserName | Should Be $script:testUserName
                    $currentConfig.Ensure | Should -Be 'Absent'
                }
            }
            finally
            {
                if (Test-Path -Path $script:logPath) {
                    Remove-Item -Path $script:logPath -Recurse -Force
                }

                if (Test-Path -Path $configurationPath)
                {
                    Remove-Item -Path $configurationPath -Recurse -Force
                }
            }
        }
    }
}
finally
{
    Exit-DscResourceTestEnvironment -TestEnvironment $script:testEnvironment
}


