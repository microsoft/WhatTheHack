# culture='en-US'
ConvertFrom-StringData @'
    ForestNotFound             = Cannot contact forest '{0}'. Check the spelling of the Forest FQDN and make sure that a domain controller is available on the network. (ADOF0001)
    CredentialError            = Credential error. Check the username and password used. (ADOF0002)
    GetUnhandledException      = Unhandled exception getting Optional Feature status for forest '{0}'. (ADOF0003)
    SetUnhandledException      = Unhandled exception setting Optional Feature status for forest '{0}'. (ADOF0004)
    ForestFunctionalLevelError = Forest functional level '{0}' does not meet minimum requirement of Windows2008R2Forest or greater. (ADOF0005)
    DomainFunctionalLevelError = Domain functional level '{0}' does not meet minimum requirement of Windows2008R2Forest or greater. (ADOF0006)
    OptionalFeatureEnabled          = Active Directory {0} is enabled. (ADOF0007)
    OptionalFeatureNotEnabled       = Active Directory {0} is not enabled. (ADOF0008)
    EnablingOptionalFeature         = Enabling Active Directory {1} in the forest '{0}'. (ADOF0009)
'@
