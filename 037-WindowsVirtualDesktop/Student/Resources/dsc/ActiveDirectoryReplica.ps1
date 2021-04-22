Configuration ActiveDirectoryReplica
{ 
   param 
    ( 
        [Parameter(Mandatory=$true)]
        [String]$Domain,

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]$DomainCreds,

        [Parameter(Mandatory=$false)]
        [Int]$RetryCount=20,
        
        [Parameter(Mandatory=$false)]
        [Int]$RetryIntervalSec=30
    )

    Import-DscResource -ModuleName ActiveDirectoryDsc -ModuleVersion '4.2.0.0'
    Import-DscResource -ModuleName PSDscResources -ModuleVersion '2.12.0.0'
    Import-DscResource -ModuleName xDnsServer -ModuleVersion '1.16.0.0'

    $DomainName = $Domain.Split('.')[0]
    [System.Management.Automation.PSCredential]$DomainCreds2 = New-Object System.Management.Automation.PSCredential ("${DomainName}\$($DomainCreds.UserName)", $DomainCreds.Password)

    Node localhost
    {
       LocalConfigurationManager            
       {            
          ActionAfterReboot = 'ContinueConfiguration'            
          ConfigurationMode = 'ApplyOnly'            
          RebootNodeIfNeeded = $true            
       }

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
         
        WaitForADDomain WaitForestAvailability
        {
            DomainName = $Domain
            Credential = $DomainCreds2
            WaitTimeout = 300
            DependsOn  = "[WindowsFeature]ADDSTools"
        }

        ADDomainController SecondDomainController
        {
            DomainName = $Domain
            Credential = $DomainCreds2
            SafeModeAdministratorPassword = $DomainCreds2
            DependsOn = "[WaitForADDomain]WaitForestAvailability"
        }

        xDnsServerForwarder Azure
        {
            IsSingleInstance = 'Yes'
            IPAddresses = '168.63.129.16'
            UseRootHint = $true
            DependsOn = "[ADDomainController]SecondDomainController"
        }
   }
}