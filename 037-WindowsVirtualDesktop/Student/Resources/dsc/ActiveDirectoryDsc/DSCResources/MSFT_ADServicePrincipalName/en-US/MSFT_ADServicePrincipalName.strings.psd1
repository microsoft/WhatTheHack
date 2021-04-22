# culture='en-US'
ConvertFrom-StringData @'
    GetServicePrincipalName               = Getting service principal name '{0}'. (ADSPN0001)
    ServicePrincipalNameAbsent            = Service principal name '{0}' is absent. (ADSPN0002)
    ServicePrincipalNamePresent           = Service principal name '{0}' is present on account(s) '{1}'. (ADSPN0003)
    AccountNotFound                       = Active Directory object with SamAccountName '{0}' not found. (ADSPN0004)
    RemoveServicePrincipalName            = Removing service principal name '{0}' from account '{1}'. (ADSPN0005)
    AddServicePrincipalName               = Adding service principal name '{0}' to account '{1}. (ADSPN0006)
    ServicePrincipalNameInDesiredState    = Service principal name '{0}' is in the desired state. (ADSPN0007)
    ServicePrincipalNameNotInDesiredState = Service principal name '{0}' is not in the desired state. (ADSPN0008)
'@
