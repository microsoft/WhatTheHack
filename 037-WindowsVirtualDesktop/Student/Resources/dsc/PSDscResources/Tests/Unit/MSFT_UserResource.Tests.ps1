# To run these tests, the currently logged on user must have rights to create a user
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
param ()

$errorActionPreference = 'Stop'
Set-StrictMode -Version 'Latest'

$script:testFolderPath = Split-Path -Path $PSScriptRoot -Parent
$script:testHelpersPath = Join-Path -Path $script:testFolderPath -ChildPath 'TestHelpers'
Import-Module -Name (Join-Path -Path $script:testHelpersPath -ChildPath 'CommonTestHelper.psm1')

$script:testEnvironment = Enter-DscResourceTestEnvironment `
    -DSCResourceModuleName 'PSDscResources' `
    -DSCResourceName 'MSFT_UserResource' `
    -TestType 'Unit'

try {

    Import-Module -Name (Join-Path -Path  $script:testHelpersPath `
                                   -ChildPath 'MSFT_UserResource.TestHelper.psm1')

    # get rid of this if-check once the fix for this is released
    if (Test-IsNanoServer)
    {
        Import-Module -Name 'Microsoft.Powershell.LocalAccounts'
    }

    # Commented out until the fix is released
    #Import-Module -Name 'Microsoft.Powershell.LocalAccounts'

    InModuleScope 'MSFT_UserResource' {

        $script:disposableObjects = @()

        try
        {
            $existingUserName = 'TestUserName12345'
            $existingUserPassword = 'StrongOne7.'
            $existingUserSecurePassword = ConvertTo-SecureString -String $existingUserPassword -AsPlainText -Force
            $existingUserTestCredential = New-Object PSCredential ($existingUserName, $existingUserSecurePassword)

            # Mock user object and properties used for most tests
            $existingUserValues = @{
                Name = $existingUserName
                Password = $existingUserTestCredential
                Description = 'Some Description'
                DisplayName = 'Test Existing User'
                FullName = 'Test Existing User'
                Enabled = $true
                PasswordNeverExpires = $false
                PasswordExpires = '01/03/2018 17:04:20'
                UserCannotChangePassword = $false
                UserMayChangePassword = $true
                PasswordChangeRequired = $false
            }

            $newUserName = 'NewTestUserName12345'
            $newUserPassword = 'NewStrongOne123.'
            $newUserSecurePassword = ConvertTo-SecureString -String $newUserPassword -AsPlainText -Force
            $newUserCredential = New-Object PSCredential ($newUserName, $newUserSecurePassword)

            # Mock user object and properties mainly used for checking updating values
            $newUserValues = @{
                Name = $newUserName
                Password = $newUserCredential
                Description = 'Some other Description'
                DisplayName = 'Test New User1'
                FullName = 'Test New User1'
                Enabled = $true
                PasswordNeverExpires = $true
                PasswordExpires = $null
                UserCannotChangePassword = $true
                UserMayChangePassword = $false
                PasswordChangeRequired = $false
            }


            $modifiableUserName = 'newUser1234'
            $modifiableUserPassword = 'ThisIsAStrongPassword543!'
            $modifiableUserSecurePassword = ConvertTo-SecureString -String $modifiableUserPassword -AsPlainText -Force
            $modifiableUserCredential = New-Object PSCredential ($modifiableUserName, $modifiableUserSecurePassword)

            # Mock user object that gets modified by the Set-TargetResourceOnNanoServer tests
            $modifiableUserValues = @{
                Name = $modifiableUserName
                Password = $modifiableUserCredential
                Description = 'Another Description'
                DisplayName = 'Test New User2'
                FullName = 'Another Description'
                Enabled = $false
                PasswordNeverExpires = $true
                PasswordExpires = $null
                UserCannotChangePassword = $true
                UserMayChangePassword = $false
                PasswordChangeRequired = $true
            }

            if (Test-IsNanoServer)
            {
                $script:UserObject = New-Object -TypeName 'System.Management.Automation.SecurityAccountsManager.LocalUser' `
                                                -ArgumentList @( $existingUserName )
                $script:disposableObjects += $script:UserObject

                # Properties that are only on Nano Server user object
                $script:UserObject.FullName = $existingUserValues.FullName
                $script:UserObject.UserMayChangePassword = $existingUserValues.UserMayChangePassword
                $script:UserObject.PasswordExpires = $existingUserValues.PasswordExpires
            }
            else
            {
                $script:testPrincipalContext = New-Object -TypeName 'System.DirectoryServices.AccountManagement.PrincipalContext' `
                                                          -ArgumentList @( [System.DirectoryServices.AccountManagement.ContextType]::Machine )
                $script:disposableObjects += $script:testPrincipalContext
                $script:UserObject = New-Object -TypeName 'System.DirectoryServices.AccountManagement.UserPrincipal' `
                                                -ArgumentList @( $testPrincipalContext )
                $script:disposableObjects += $script:UserObject

                # Properties that are only on FullSku user object
                $script:UserObject.DisplayName = $existingUserValues.DisplayName
                $script:UserObject.UserCannotChangePassword = $existingUserValues.UserCannotChangePassword
                $script:UserObject.PasswordNeverExpires = $existingUserValues.PasswordNeverExpires

            }

            # Properties that are used on both Nano and Full Sku
            $script:UserObject.Name = $existingUserValues.Name
            $script:UserObject.Description = $existingUserValues.Description
            $script:UserObject.Enabled = $existingUserValues.Enabled

            Describe 'UserResource/Get-TargetResource' {

                Context 'Tests on FullSKU' {
                    Mock -CommandName Test-IsNanoServer -MockWith { return $false }
                    Mock -CommandName Remove-UserOnFullSku -MockWith {}
                    Mock -CommandName Remove-DisposableObject -MockWith {}

                    It 'Should return the user as Present' {
                        Mock -CommandName Find-UserByNameOnFullSku -MockWith { return $existingUserValues }

                        $getTargetResourceResult = Get-TargetResource -UserName $existingUserValues.Name

                        Assert-MockCalled -CommandName Find-UserByNameOnFullSku -Exactly 1 -Scope It
                        Assert-MockCalled -CommandName Remove-DisposableObject -Exactly 1 -Scope It

                        $getTargetResourceResult['UserName']                 | Should Be $existingUserValues.Name
                        $getTargetResourceResult['Ensure']                   | Should Be 'Present'
                        $getTargetResourceResult['Description']              | Should Be $existingUserValues.Description
                        $getTargetResourceResult['FullName']                 | Should Be $existingUserValues.DisplayName
                        $getTargetResourceResult['PasswordChangeRequired']   | Should Be $null
                        $getTargetResourceResult['PasswordChangeNotAllowed'] | Should Be $existingUserValues.UserCannotChangePassword
                        $getTargetResourceResult['PasswordNeverExpires']     | Should Be $existingUserValues.PasswordNeverExpires
                        $getTargetResourceResult['Disabled']                 | Should Be (-not $existingUserValues.Enabled)
                    }

                    It 'Should return the user as Absent' {
                        Mock -CommandName Find-UserByNameOnFullSku -MockWith { return $null }

                        $getTargetResourceResult = Get-TargetResource -UserName 'NotAUserName'

                        Assert-MockCalled -CommandName Find-UserByNameOnFullSku -Exactly 1 -Scope It
                        Assert-MockCalled -CommandName Remove-DisposableObject -Exactly 1 -Scope It

                        $getTargetResourceResult['UserName']                | Should Be 'NotAUserName'
                        $getTargetResourceResult['Ensure']                  | Should Be 'Absent'
                    }

                    It 'Should throw an Invalid Operaion exception' {
                        Mock -CommandName Find-UserByNameOnFullSku -MockWith { Throw }
                        Mock -CommandName New-InvalidOperationException -MockWith {}

                        Get-TargetResource -UserName 'DuplicateUser'

                        Assert-MockCalled -CommandName Find-UserByNameOnFullSku -Exactly 1 -Scope It
                        Assert-MockCalled -CommandName New-InvalidOperationException -Exactly 1 -Scope It
                    }
                }

                Context 'Tests on Nano Server' {

                    Mock -CommandName Test-IsNanoServer -MockWith { return $true }

                    It 'Should return the user as Present on Nano Server' {
                        Mock -CommandName Find-UserByNameOnNanoServer -MockWith { return $existingUserValues }

                        $getTargetResourceResult = Get-TargetResource -UserName $existingUserValues.Name

                        Assert-MockCalled -CommandName Find-UserByNameOnNanoServer -Exactly 1 -Scope It

                        $getTargetResourceResult['UserName']                 | Should Be $existingUserValues.Name
                        $getTargetResourceResult['Ensure']                   | Should Be 'Present'
                        $getTargetResourceResult['Description']              | Should Be $existingUserValues.Description
                        $getTargetResourceResult['FullName']                 | Should Be $existingUserValues.FullName
                        $getTargetResourceResult['PasswordChangeRequired']   | Should Be $null
                        $getTargetResourceResult['PasswordChangeNotAllowed'] | Should Be (-not $existingUserValues.UserMayChangePassword)
                        $getTargetResourceResult['PasswordNeverExpires']     | Should Be (-not $existingUserValues.PasswordExpires)
                        $getTargetResourceResult['Disabled']                 | Should Be (-not $existingUserValues.Enabled)
                    }

                    It 'Should return a different user as Present on Nano Server' {
                        Mock -CommandName Find-UserByNameOnNanoServer -MockWith { return $newUserValues }

                        $getTargetResourceResult = Get-TargetResource -UserName $newUserValues.Name

                        Assert-MockCalled -CommandName Find-UserByNameOnNanoServer -Exactly 1 -Scope It

                        $getTargetResourceResult['UserName']                 | Should Be $newUserValues.Name
                        $getTargetResourceResult['Ensure']                   | Should Be 'Present'
                        $getTargetResourceResult['Description']              | Should Be $newUserValues.Description
                        $getTargetResourceResult['FullName']                 | Should Be $newUserValues.FullName
                        $getTargetResourceResult['PasswordChangeRequired']   | Should Be $null
                        $getTargetResourceResult['PasswordChangeNotAllowed'] | Should Be (-not $newUserValues.UserMayChangePassword)
                        $getTargetResourceResult['PasswordNeverExpires']     | Should Be (-not $newUserValues.PasswordExpires)
                        $getTargetResourceResult['Disabled']                 | Should Be (-not $newUserValues.Enabled)
                    }

                    It 'Should return the user as Absent' {
                        Mock -CommandName Find-UserByNameOnNanoServer `
                             -MockWith { Write-Error -Message 'Test error message' -ErrorId  'UserNotFound' }

                        $getTargetResourceResult = Get-TargetResource -UserName 'NotAUserName'

                        Assert-MockCalled -CommandName Find-UserByNameOnNanoServer -Exactly 1 -Scope It

                        $getTargetResourceResult['UserName']                | Should Be 'NotAUserName'
                        $getTargetResourceResult['Ensure']                  | Should Be 'Absent'
                    }

                    It 'Should throw an Invalid Operation exception' {
                        $exception = New-Object -TypeName 'InvalidOperationException' `
                                                -ArgumentList @($null)
                        $errorRecord = New-Object -TypeName System.Management.Automation.ErrorRecord `
                                                  -ArgumentList @($exception, 'MachineStateIncorrect', 'InvalidOperation', $null)
                        Mock -CommandName Find-UserByNameOnNanoServer -MockWith { Throw }
                        { Get-TargetResource -UserName 'DuplicateUser' } | Should -Throw -ExpectedMessage $errorRecord

                        Assert-MockCalled -CommandName Find-UserByNameOnNanoServer -Exactly 1 -Scope It

                    }
                }
            }

            Describe 'UserResource/Set-TargetResource' {
                Context 'Tests on FullSKU' {
                    Mock -CommandName Test-IsNanoServer -MockWith { return $false }
                    Mock -CommandName Add-UserOnFullSku -MockWith { return $script:UserObject }
                    Mock -CommandName Remove-UserOnFullSku -MockWith {}
                    Mock -CommandName Save-UserOnFullSku -MockWith {}
                    Mock -CommandName Set-UserPasswordOnFullSku -MockWith {}
                    Mock -CommandName Revoke-UserPassword -MockWith {}
                    Mock -CommandName Remove-DisposableObject -MockWith {}

                    It 'Should remove the user' {
                        Mock -CommandName Find-UserByNameOnFullSku -MockWith { return $script:UserObject }

                        Set-TargetResource -UserName $existingUserValues.Name `
                                           -Ensure 'Absent'

                        Assert-MockCalled -CommandName Add-UserOnFullSku -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Remove-UserOnFullSku -Exactly 1 -Scope It
                    }

                    It 'Should add a new user with a password' {
                        Mock -CommandName Find-UserByNameOnFullSku -MockWith { return $null }

                        Set-TargetResource -UserName $existingUserValues.Name `
                                           -Password $existingUserValues.Password `
                                           -Ensure 'Present'

                        Assert-MockCalled -CommandName Find-UserByNameOnFullSku -Exactly 1 -Scope It
                        Assert-MockCalled -CommandName Add-UserOnFullSku -Exactly 1 -Scope It
                        Assert-MockCalled -CommandName Remove-UserOnFullSku -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Save-UserOnFullSku -Exactly 1 -Scope It
                        Assert-MockCalled -CommandName Remove-DisposableObject -Exactly 1 -Scope It

                        $script:UserObject.Name | Should Be $existingUserValues.Name
                        $script:UserObject.DisplayName | Should Be ''
                    }

                    It 'Should update the user' {
                        Mock -CommandName Find-UserByNameOnFullSku -MockWith { return $script:UserObject }

                        $disabled = $true
                        $passwordNeverExpires = $true
                        $passwordChangeRequired = $false
                        $passwordChangeNotAllowed = $true

                        Set-TargetResource -UserName $existingUserValues.Name `
                                           -Password $existingUserValues.Password `
                                           -Ensure 'Present' `
                                           -FullName $newUserValues.DisplayName `
                                           -Description $newUserValues.Description `
                                           -Disabled $disabled `
                                           -PasswordNeverExpires $passwordNeverExpires `
                                           -PasswordChangeRequired $passwordChangeRequired `
                                           -PasswordChangeNotAllowed $passwordChangeNotAllowed

                        Assert-MockCalled -CommandName Find-UserByNameOnFullSku -Exactly 1 -Scope It
                        Assert-MockCalled -CommandName Add-UserOnFullSku -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Remove-UserOnFullSku -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Set-UserPasswordOnFullSku -Exactly 1 -Scope It
                        Assert-MockCalled -CommandName Revoke-UserPassword -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Save-UserOnFullSku -Exactly 1 -Scope It
                        Assert-MockCalled -CommandName Remove-DisposableObject -Exactly 1 -Scope It

                        $script:UserObject.Name | Should Be $existingUserValues.Name
                        $script:UserObject.DisplayName | Should Be $newUserValues.DisplayName
                        $script:UserObject.UserCannotChangePassword | Should Be $passwordChangeNotAllowed
                        $script:UserObject.PasswordNeverExpires | Should Be $passwordNeverExpires
                        $script:UserObject.Description | Should Be $newUserValues.Description
                        $script:UserObject.Enabled | Should Be (-not $disabled)
                    }

                    It 'Should update the user again with different values' {
                        Mock -CommandName Find-UserByNameOnFullSku -MockWith { return $script:UserObject }

                        $disabled = $false
                        $passwordNeverExpires = $false
                        $passwordChangeRequired = $true
                        $passwordChangeNotAllowed = $false

                        Set-TargetResource -UserName $existingUserValues.Name `
                                           -Ensure 'Present' `
                                           -FullName $modifiableUserValues.DisplayName `
                                           -Description $modifiableUserValues.Description `
                                           -Disabled $disabled `
                                           -PasswordNeverExpires $passwordNeverExpires `
                                           -PasswordChangeRequired $passwordChangeRequired `
                                           -PasswordChangeNotAllowed $passwordChangeNotAllowed

                        Assert-MockCalled -CommandName Find-UserByNameOnFullSku -Exactly 1 -Scope It
                        Assert-MockCalled -CommandName Add-UserOnFullSku -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Remove-UserOnFullSku -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Set-UserPasswordOnFullSku -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Revoke-UserPassword -Exactly 1 -Scope It
                        Assert-MockCalled -CommandName Save-UserOnFullSku -Exactly 1 -Scope It
                        Assert-MockCalled -CommandName Remove-DisposableObject -Exactly 1 -Scope It

                        $script:UserObject.Name | Should Be $existingUserValues.Name
                        $script:UserObject.DisplayName | Should Be $modifiableUserValues.DisplayName
                        $script:UserObject.UserCannotChangePassword | Should Be $passwordChangeNotAllowed
                        $script:UserObject.PasswordNeverExpires | Should Be $passwordNeverExpires
                        $script:UserObject.Description | Should Be $modifiableUserValues.Description
                        $script:UserObject.Enabled | Should Be (-not $disabled)
                    }

                    It 'Should not update the user if no new values are passed in' {
                        Mock -CommandName Find-UserByNameOnFullSku -MockWith { return $script:UserObject }

                        Set-TargetResource -UserName $existingUserValues.Name `
                                           -Ensure 'Present'

                        Assert-MockCalled -CommandName Find-UserByNameOnFullSku -Exactly 1 -Scope It
                        Assert-MockCalled -CommandName Add-UserOnFullSku -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Remove-UserOnFullSku -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Set-UserPasswordOnFullSku -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Revoke-UserPassword -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Save-UserOnFullSku -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Remove-DisposableObject -Exactly 1 -Scope It

                        $script:UserObject.Name | Should Be $existingUserValues.Name
                        $script:UserObject.DisplayName | Should Be $modifiableUserValues.DisplayName
                        $script:UserObject.Description | Should Be $modifiableUserValues.Description
                    }

                    It 'Should not update the user if existing values are passed in' {
                        Mock -CommandName Find-UserByNameOnFullSku -MockWith { return $script:UserObject }

                        Set-TargetResource -UserName $existingUserValues.Name `
                                           -Ensure 'Present' `
                                           -FullName $modifiableUserValues.DisplayName `
                                           -Description $modifiableUserValues.Description

                        Assert-MockCalled -CommandName Find-UserByNameOnFullSku -Exactly 1 -Scope It
                        Assert-MockCalled -CommandName Add-UserOnFullSku -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Remove-UserOnFullSku -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Set-UserPasswordOnFullSku -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Revoke-UserPassword -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Save-UserOnFullSku -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Remove-DisposableObject -Exactly 1 -Scope It

                        $script:UserObject.Name | Should Be $existingUserValues.Name
                        $script:UserObject.DisplayName | Should Be $modifiableUserValues.DisplayName
                        $script:UserObject.Description | Should Be $modifiableUserValues.Description
                    }

                    It 'Should throw an Invalid Operation exception' {
                        $exception = New-Object -TypeName 'InvalidOperationException' `
                                                -ArgumentList @($null)
                        $errorRecord = New-Object -TypeName System.Management.Automation.ErrorRecord `
                                                  -ArgumentList @($exception, 'MachineStateIncorrect', 'InvalidOperation', $null)
                        Mock -CommandName Find-UserByNameOnFullSku -MockWith { Throw }

                        { Set-TargetResource -UserName 'DuplicateUser' } | Should -Throw -ExpectedMessage $errorRecord

                        Assert-MockCalled -CommandName Find-UserByNameOnFullSku -Exactly 1 -Scope It
                        Assert-MockCalled -CommandName Save-UserOnFullSku -Exactly 0 -Scope It
                    }
                }

                Context 'Tests on Nano Server' {
                    Mock -CommandName Test-IsNanoServer -MockWith { return $true }
                    Mock -CommandName Test-CredentialsValidOnNanoServer -MockWith { return $true }
                    # Mock -CommandName New-LocalUser -MockWith {}
                    # Mock -CommandName Remove-LocalUser -MockWith {}
                    # Mock -CommandName Disable-LocalUser -MockWith {}
                    # Mock -CommandName Enable-LocalUser -MockWith {}

                    It 'Should add a new user' -Skip:$true {
                        Mock -CommandName Set-LocalUser -MockWith { $modifiableUserValues.FullName = [String]::Empty}

                        Mock -CommandName Find-UserByNameOnNanoServer `
                             -MockWith { Write-Error -Message 'Test error message' -ErrorId  'UserNotFound' }

                        Set-TargetResource -UserName $modifiableUserValues.Name `
                                           -Ensure 'Present'

                        # Set-LocalUser only called to set FullName
                        Assert-MockCalled -CommandName Find-UserByNameOnNanoServer -Exactly 1 -Scope It
                        Assert-MockCalled -CommandName New-LocalUser -Exactly 1 -Scope It
                        Assert-MockCalled -CommandName Set-LocalUser -Exactly 1 -Scope It

                        $modifiableUserValues.Name | Should Be $modifiableUserValues.Name
                        $modifiableUserValues.FullName | Should Be ''
                    }

                    It 'Should remove the user' -Skip:$true {
                        Mock -CommandName Find-UserByNameOnNanoServer -MockWith { return $script:UserObject }
                        Mock -CommandName Set-LocalUser -MockWith {}

                        Set-TargetResource -UserName $existingUserValues.Name `
                                           -Ensure 'Absent'

                        Assert-MockCalled -CommandName Find-UserByNameOnNanoServer -Exactly 1 -Scope It
                        Assert-MockCalled -CommandName New-LocalUser -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Remove-LocalUser -Exactly 1 -Scope It
                        Assert-MockCalled -CommandName Set-LocalUser -Exactly 0 -Scope It
                    }

                    It 'Should not remove the user if the user does not exist' -Skip:$true {
                        Mock -CommandName Find-UserByNameOnNanoServer `
                             -MockWith { Write-Error -Message 'Test error message' -ErrorId  'UserNotFound' }
                        Mock -CommandName Set-LocalUser -MockWith {}

                        Set-TargetResource -UserName 'NotAUserName' `
                                           -Ensure 'Absent'

                        Assert-MockCalled -CommandName Find-UserByNameOnNanoServer -Exactly 1 -Scope It
                        Assert-MockCalled -CommandName New-LocalUser -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Remove-LocalUser -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Set-LocalUser -Exactly 0 -Scope It
                    }

                    It 'Should update all values of the user' -Skip:$true {
                        Mock -CommandName Find-UserByNameOnNanoServer -MockWith { return $existingUserValues }
                        Mock -CommandName Set-LocalUser -MockWith {}

                        Set-TargetResource -UserName $existingUserValues.Name `
                                           -Password $newUserValues.Password `
                                           -Ensure 'Present' `
                                           -FullName $newUserValues.FullName `
                                           -Description $newUserValues.Description `
                                           -Disabled $existingUserValues.Enabled `
                                           -PasswordNeverExpires (-not $existingUserValues.PasswordNeverExpires) `
                                           -PasswordChangeRequired (-not $existingUserValues.PasswordChangeRequired) `
                                           -PasswordChangeNotAllowed $existingUserValues.UserMayChangePassword

                        <# Set-LocalUser called to:
                             Set the Password
                             Change the FullName
                             Change the Description
                             Change PasswordNeverExpires
                             Set PasswordChangeRequired (which sets the password to expire 'Now')
                             Set UserMayChangePassword
                        #>
                        Assert-MockCalled -CommandName Find-UserByNameOnNanoServer -Exactly 1 -Scope It
                        Assert-MockCalled -CommandName New-LocalUser -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Remove-LocalUser -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Set-LocalUser -Exactly 6 -Scope It
                        Assert-MockCalled -CommandName Disable-LocalUser -Exactly 1 -Scope It
                        Assert-MockCalled -CommandName Enable-LocalUser -Exactly 0 -Scope It

                    }

                    It 'Should update the user with different values' -Skip:$true {
                        Mock -CommandName Find-UserByNameOnNanoServer -MockWith { return $modifiableUserValues }
                        $modifiableUserValues.FullName = 'new full name'
                        Mock -CommandName Set-LocalUser -MockWith {}

                        Set-TargetResource -UserName $modifiableUserValues.Name `
                                           -Password $modifiableUserValues.Password `
                                           -Ensure 'Present' `
                                           -FullName $null `
                                           -Description $null `
                                           -Disabled $modifiableUserValues.Enabled `
                                           -PasswordNeverExpires (-not $modifiableUserValues.PasswordNeverExpires) `
                                           -PasswordChangeRequired (-not $modifiableUserValues.PasswordChangeRequired) `
                                           -PasswordChangeNotAllowed $modifiableUserValues.UserMayChangePassword

                        <# Set-LocalUser called to:
                             Set the Password (even though it's the same)
                             Change the FullName
                             Change the Description
                             Change PasswordNeverExpires
                             Set UserMayChangePassword
                             (Set-LocalUser will not be called to set PasswordChangeRequired if it is set to false, )
                        #>
                        Assert-MockCalled -CommandName Find-UserByNameOnNanoServer -Exactly 1 -Scope It
                        Assert-MockCalled -CommandName New-LocalUser -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Remove-LocalUser -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Set-LocalUser -Exactly 5 -Scope It
                        Assert-MockCalled -CommandName Disable-LocalUser -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Enable-LocalUser -Exactly 1 -Scope It
                    }

                    It 'Should not update the user if no new values are passed in' -Skip:$true {
                        Mock -CommandName Find-UserByNameOnNanoServer -MockWith { return $existingUserValues }
                        Mock -CommandName Set-LocalUser -MockWith {}

                        Set-TargetResource -UserName $existingUserValues.Name `
                                           -Ensure 'Present'

                        Assert-MockCalled -CommandName Find-UserByNameOnNanoServer -Exactly 1 -Scope It
                        Assert-MockCalled -CommandName New-LocalUser -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Remove-LocalUser -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Set-LocalUser -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Disable-LocalUser -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Enable-LocalUser -Exactly 0 -Scope It
                    }

                    It 'Should not update the user if existing values are passed in' -Skip:$true {
                        Mock -CommandName Find-UserByNameOnNanoServer -MockWith { return $existingUserValues }
                        Mock -CommandName Set-LocalUser -MockWith {}

                        Set-TargetResource -UserName $existingUserValues.Name `
                                           -Ensure 'Present' `
                                           -FullName $existingUserValues.FullName `
                                           -Description $existingUserValues.Description `
                                           -Disabled (-not $existingUserValues.Enabled) `
                                           -PasswordNeverExpires $existingUserValues.PasswordNeverExpires `
                                           -PasswordChangeRequired $existingUserValues.PasswordChangeRequired `
                                           -PasswordChangeNotAllowed (-not $existingUserValues.UserMayChangePassword)

                        Assert-MockCalled -CommandName Find-UserByNameOnNanoServer -Exactly 1 -Scope It
                        Assert-MockCalled -CommandName New-LocalUser -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Remove-LocalUser -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Set-LocalUser -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Disable-LocalUser -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Enable-LocalUser -Exactly 0 -Scope It
                    }

                    It 'Should throw an Invalid Operation exception' -Skip:$true {
                        $exception = New-Object -TypeName 'InvalidOperationException' `
                                                -ArgumentList @($null)
                        $errorRecord = New-Object -TypeName System.Management.Automation.ErrorRecord `
                                                  -ArgumentList @($exception, 'MachineStateIncorrect', 'InvalidOperation', $null)
                        Mock -CommandName Find-UserByNameOnNanoServer -MockWith { Throw }

                        { Set-TargetResource -UserName 'DuplicateUser' } | Should -Throw -ExpectedMessage $errorRecord

                        Assert-MockCalled -CommandName Find-UserByNameOnNanoServer -Exactly 1 -Scope It
                        Assert-MockCalled -CommandName New-LocalUser -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Remove-LocalUser -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Set-LocalUser -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Disable-LocalUser -Exactly 0 -Scope It
                        Assert-MockCalled -CommandName Enable-LocalUser -Exactly 0 -Scope It
                    }

                }
            }

            Describe 'UserResource/Test-TargetResource' {
                Context 'Tests on FullSKU' {
                    Mock -CommandName Test-IsNanoServer -MockWith { return $false }
                    Mock -CommandName Find-UserByNameOnFullSku -MockWith { return $existingUserValues } `
                                                               -ParameterFilter { $UserName -eq $existingUserName }
                    $absentUserName = 'AbsentUserUserName123456789'
                    Mock -CommandName Find-UserByNameOnFullSku -MockWith { return $null } `
                                                               -ParameterFilter { $UserName -eq $absentUserName }
                    It 'Should return true when user Present and correct values' {
                        Mock -CommandName Test-UserPasswordOnFullSku -MockWith { return $true }
                        $testTargetResourceResult = Test-TargetResource -UserName $existingUserValues.Name `
                                                                        -Description $existingUserValues.Description `
                                                                        -Password $existingUserValues.Password `
                                                                        -Disabled (-not $existingUserValues.Enabled) `
                                                                        -PasswordNeverExpires $existingUserValues.PasswordNeverExpires `
                                                                        -PasswordChangeNotAllowed $existingUserValues.UserCanNotChangePassword
                        $testTargetResourceResult | Should -BeTrue

                        Assert-MockCalled -CommandName Find-UserByNameOnFullSku -Exactly 1 -Scope It
                        Assert-MockCalled -CommandName Test-UserPasswordOnFullSku -Exactly 1 -Scope It
                    }

                    It 'Should return true when user Absent and Ensure = Absent' {
                        $testTargetResourceResult = Test-TargetResource -UserName $absentUserName `
                                                                        -Ensure 'Absent'
                        $testTargetResourceResult | Should -BeTrue
                    }

                    It 'Should return false when user Absent and Ensure = Present' {
                        $testTargetResourceResult = Test-TargetResource -UserName $absentUserName `
                                                                        -Ensure 'Present'
                        $testTargetResourceResult | Should -BeFalse
                    }

                    It 'Should return false when user Present and Ensure = Absent' {
                        $testTargetResourceResult = Test-TargetResource -UserName $existingUserName `
                                                                        -Ensure 'Absent'
                        $testTargetResourceResult | Should -BeFalse
                    }

                    It 'Should return false when Password is wrong' {
                        Mock -CommandName Test-UserPasswordOnFullSku -MockWith { return $false }

                        $testTargetResourceResult = Test-TargetResource -UserName $existingUserName `
                                                                        -Password $newUserValues.Password
                        $testTargetResourceResult | Should -BeFalse

                        Assert-MockCalled -CommandName Find-UserByNameOnFullSku -Exactly 1 -Scope It
                        Assert-MockCalled -CommandName Test-UserPasswordOnFullSku -Exactly 1 -Scope It
                    }

                    It 'Should return false when user Present and wrong Description' {
                        $testTargetResourceResult = Test-TargetResource -UserName $existingUserName `
                                                                        -Description 'Wrong description'
                        $testTargetResourceResult | Should -BeFalse
                    }

                    It 'Should return false when FullName is incorrect' {
                        $testTargetResourceResult = Test-TargetResource -UserName $existingUserName `
                                                                        -FullName 'Wrong FullName'
                        $testTargetResourceResult | Should -BeFalse
                    }

                    It 'Should return false when Disabled is incorrect' {
                        $testTargetResourceResult = Test-TargetResource -UserName $existingUserName `
                                                                        -Disabled $existingUserValues.Enabled
                        $testTargetResourceResult | Should -BeFalse
                    }

                    It 'Should return false when PasswordNeverExpires is incorrect' {
                        $testTargetResourceResult = Test-TargetResource `
                                              -UserName $existingUserName `
                                              -PasswordNeverExpires (-not $existingUserValues.PasswordNeverExpires)
                        $testTargetResourceResult | Should -BeFalse
                    }

                    It 'Should return false when PasswordChangeNotAllowed is incorrect' {
                        $testTargetResourceResult = Test-TargetResource `
                                               -UserName $existingUserName `
                                               -PasswordChangeNotAllowed $existingUserValues.UserMayChangePassword
                        $testTargetResourceResult | Should -BeFalse
                    }
                }

                Context 'Tests on Nano Server' {
                    Mock -CommandName Test-IsNanoServer -MockWith { return $true }
                    Mock -CommandName Find-UserByNameOnNanoServer -MockWith { return $existingUserValues } `
                                                                  -ParameterFilter { $UserName -eq $existingUserName }
                    $absentUserName = 'AbsentUserUserName123456789'
                    Mock -CommandName Find-UserByNameOnNanoServer `
                         -MockWith { Write-Error -Message 'Test error message' -ErrorId  'UserNotFound' } `
                         -ParameterFilter { $UserName -eq $absentUserName }
                    $duplicateUserName = 'DuplicateUserName'
                    Mock -CommandName Find-UserByNameOnNanoServer -MockWith { Throw } `
                                                                  -ParameterFilter { $UserName -eq $duplicateUserName }

                    It 'Should return true when user Present and correct values' {
                        Mock -CommandName Test-CredentialsValidOnNanoServer { return $true }

                        $testTargetResourceResult = Test-TargetResource -UserName $existingUserValues.Name `
                                                                        -Description $existingUserValues.Description `
                                                                        -Password $existingUserValues.Password `
                                                                        -Disabled (-not $existingUserValues.Enabled) `
                                                                        -PasswordNeverExpires $existingUserValues.PasswordNeverExpires `
                                                                        -PasswordChangeNotAllowed $existingUserValues.UserCanNotChangePassword
                        $testTargetResourceResult | Should -BeTrue

                        Assert-MockCalled -CommandName Find-UserByNameOnNanoServer -Exactly 1 -Scope It
                        Assert-MockCalled -CommandName Test-CredentialsValidOnNanoServer -Exactly 1 -Scope It
                    }

                    It 'Should return true when user Absent and Ensure = Absent' {
                        $testTargetResourceResult = Test-TargetResource -UserName $absentUserName `
                                                                        -Ensure 'Absent'
                        $testTargetResourceResult | Should -BeTrue
                    }

                    It 'Should return false when user Absent and Ensure = Present' {
                        $testTargetResourceResult = Test-TargetResource -UserName $absentUserName `
                                                                        -Ensure 'Present'
                        $testTargetResourceResult | Should -BeFalse
                    }

                    It 'Should return false when user Present and Ensure = Absent' {
                        $testTargetResourceResult = Test-TargetResource -UserName $existingUserName `
                                                                        -Ensure 'Absent'
                        $testTargetResourceResult | Should -BeFalse
                    }

                    It 'Should return false when Password is wrong' {
                        Mock -CommandName Test-CredentialsValidOnNanoServer { return $false }

                        $testTargetResourceResult = Test-TargetResource -UserName $existingUserName `
                                                                        -Password $newUserValues.Password
                        $testTargetResourceResult | Should -BeFalse

                        Assert-MockCalled -CommandName Find-UserByNameOnNanoServer -Exactly 1 -Scope It
                        Assert-MockCalled -CommandName Test-CredentialsValidOnNanoServer -Exactly 1 -Scope It
                    }

                    It 'Should return false when user Present and wrong Description' {
                        $testTargetResourceResult = Test-TargetResource -UserName $existingUserName `
                                                                        -Description 'Wrong description'
                        $testTargetResourceResult | Should -BeFalse
                    }

                    It 'Should return false when FullName is incorrect' {
                        $testTargetResourceResult = Test-TargetResource -UserName $existingUserName `
                                                                        -FullName 'Wrong FullName'
                        $testTargetResourceResult | Should -BeFalse
                    }

                    It 'Should return false when Disabled is incorrect' {
                        $testTargetResourceResult = Test-TargetResource -UserName $existingUserName `
                                                                        -Disabled $existingUserValues.Enabled
                        $testTargetResourceResult | Should -BeFalse
                    }

                    It 'Should return false when PasswordNeverExpires is incorrect' {
                        $testTargetResourceResult = Test-TargetResource `
                                              -UserName $existingUserName `
                                              -PasswordNeverExpires (-not $existingUserValues.PasswordNeverExpires)
                        $testTargetResourceResult | Should -BeFalse
                    }

                    It 'Should return false when PasswordChangeNotAllowed is incorrect' {
                        $testTargetResourceResult = Test-TargetResource `
                                               -UserName $existingUserName `
                                               -PasswordChangeNotAllowed $existingUserValues.UserMayChangePassword
                        $testTargetResourceResult | Should -BeFalse
                    }

                    It 'Should throw an Invalid Operation exception when there are multiple users with the given name' {
                        $exception = New-Object -TypeName 'InvalidOperationException' `
                                                -ArgumentList @($null)
                        $errorRecord = New-Object -TypeName System.Management.Automation.ErrorRecord `
                                                  -ArgumentList @($exception, 'MachineStateIncorrect', 'InvalidOperation', $null)

                        { Test-TargetResource -UserName $duplicateUserName } | Should -Throw -ExpectedMessage $errorRecord

                        Assert-MockCalled -CommandName Find-UserByNameOnNanoServer -Exactly 1 -Scope It
                    }
                }
            }

            Describe 'UserResource/Assert-UserNameValid' {
                It 'Should not throw when username contains all valid chars' {
                    { Assert-UserNameValid -UserName 'abc123456!f_t-l098s' } | Should Not Throw
                }

                It 'Should throw InvalidArgumentError when username contains only whitespace and dots' {
                    $invalidName = ' . .. .     '
                    $errorCategory = [System.Management.Automation.ErrorCategory]::InvalidArgument
                    $errorId = 'UserNameHasOnlyWhiteSpacesAndDots'
                    $errorMessage = "The name $invalidName cannot be used."
                    $exception = New-Object System.ArgumentException $errorMessage;
                    $errorRecord = New-Object System.Management.Automation.ErrorRecord $exception, $errorId, $errorCategory, $null
                    { Assert-UserNameValid -UserName $invalidName } | Should -Throw -ExpectedMessage $errorRecord
                }

                It 'Should throw InvalidArgumentError when username contains an invalid char' {
                    $invalidName = 'user|name'
                    $errorCategory = [System.Management.Automation.ErrorCategory]::InvalidArgument
                    $errorId = 'UserNameHasInvalidCharachter'
                    $errorMessage = "The name $invalidName cannot be used."
                    $exception = New-Object System.ArgumentException $errorMessage;
                    $errorRecord = New-Object System.Management.Automation.ErrorRecord $exception, $errorId, $errorCategory, $null
                    { Assert-UserNameValid -UserName $invalidName } | Should -Throw -ExpectedMessage $errorRecord
                }
            }
        }
        finally
        {
            foreach ($disposableObject in $script:disposableObjects)
            {
                $disposableObject.Dispose()
            }
        }
    }
}
finally
{
    Exit-DscResourceTestEnvironment -TestEnvironment $script:testEnvironment
}
