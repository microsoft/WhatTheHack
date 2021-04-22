configuration ActiveDirectoryForest 
{ 
   param 
   ( 
        [Parameter(Mandatory=$true)]
        [String]$Domain

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]$DomainCreds
    ) 
    
    Import-DscResource -ModuleName ActiveDirectoryDsc -ModuleVersion '4.2.0.0'
    Import-DscResource -ModuleName PSDscResources -ModuleVersion '2.12.0.0'
    Import-DscResource -ModuleName xDnsServer -ModuleVersion '1.16.0.0'

    $Users = @(
        @{
            "FirstName" = "Cereal";
            "LastName" = "Killer";
        },
        @{
            "FirstName" = "Lord";
            "LastName" = "Nikon";
        },
        @{
            "FirstName" = "Crash";
            "LastName" = "Override";
        },
        @{
            "FirstName" = "Phantom";
            "LastName" = "Phreak";
        },
        @{
            "FirstName" = "Acid";
            "LastName" = "Burn";
        },
        @{
            "FirstName" = "Zero";
            "LastName" = "Cool";
        },
        @{
            "FirstName" = "The";
            "LastName" = "Plague";
        }
    )

    Node localhost
    {
        WindowsFeature ADDSInstall 
        { 
            Ensure = "Present" 
            Name = "AD-Domain-Services" 
        } 

        WindowsFeature ADDSTools
        {
            Ensure = "Present"
            Name = "RSAT-ADDS-Tools"
            DependsOn = "[WindowsFeature]ADDSInstall"
        }

        WindowsFeature ADAdminCenter
        {
            Ensure = "Present"
            Name = "RSAT-AD-AdminCenter"
            DependsOn = "[WindowsFeature]ADDSInstall"
        }

        WindowsFeature DnsTools
	    {
	        Ensure = "Present"
            Name = "RSAT-DNS-Server"
            DependsOn = "[WindowsFeature]ADDSInstall"
	    }
         
        ADDomain FirstDomainController 
        {
            DomainName = $Domain
            Credential = $DomainCreds
            SafemodeAdministratorPassword = $DomainCreds
            ForestMode = 'WinThreshold'
	  	    DependsOn = "[WindowsFeature]ADDSInstall"
        }

        xDnsServerForwarder Azure
        {
            IsSingleInstance = 'Yes'
            IPAddresses = '168.63.129.16'
            UseRootHint = $true
            DependsOn = "[ADDomain]FirstDomainController"
        }

        foreach($User in $Users)
        {
            ADUser $($User.FirstName + $User.LastName)
            {
                Ensure = 'Present'
                Password = $DomainCreds
                PasswordNeverResets = $false
                DomainName = $Domain
                CannotChangePassword = $true
                ChangePasswordAtLogon = $false 
                DisplayName = $User.FirstName + ' ' + $User.LastName
                Enabled = $true
                GivenName = $User.FirstName
                PasswordNeverExpires = $true
                Surname = $User.LastName
                UserName = ($User.FirstName + $User.LastName).ToLower()
                UserPrincipalName = ($User.FirstName + $User.LastName + '@' + $Domain).ToLower()
                DependsOn = "[ADDomain]FirstDomainController"
            }
        }
    }
}
