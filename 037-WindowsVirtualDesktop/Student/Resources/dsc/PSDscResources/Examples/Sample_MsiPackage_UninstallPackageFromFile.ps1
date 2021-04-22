<#
    .SYNOPSIS
        Uninstalls the MSI file with the product ID: '{DEADBEEF-80C6-41E6-A1B9-8BDB8A05027F}'
        at the path: 'file://Examples/example.msi'.

        Note that the MSI file with the given product ID must already exist at the specified path.
        The product ID and path value in this file are provided for example purposes only and will
        need to be replaced with valid values.

        You can run the following command to get a list of all available MSIs on
        your system with the correct Path (LocalPackage) and product ID (IdentifyingNumber):

        Get-WmiObject Win32_Product | Format-Table IdentifyingNumber, Name, LocalPackage
#>
Configuration Sample_MsiPackage_UninstallPackageFromFile
{
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost
    {
        MsiPackage MsiPackage1
        {
            ProductId = '{DEADBEEF-80C6-41E6-A1B9-8BDB8A05027F}'
            Path = 'file://Examples/example.msi'
            Ensure = 'Absent'
        }
    }
}
