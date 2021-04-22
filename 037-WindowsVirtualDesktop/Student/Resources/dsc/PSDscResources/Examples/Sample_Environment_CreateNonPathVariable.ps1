<#
    .SYNOPSIS
        Creates the environment variable 'TestEnvironmentVariable' and sets the value to 'TestValue'
        both on the machine and within the process.
#>
Configuration Sample_Environment_CreateNonPathVariable 
{
    param ()

    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost
    {
        Environment CreateEnvironmentVariable
        {
            Name = 'TestEnvironmentVariable'
            Value = 'TestValue'
            Ensure = 'Present'
            Path = $false
            Target = @('Process', 'Machine')
        }
    }
}

Sample_Environment_CreateNonPathVariable
