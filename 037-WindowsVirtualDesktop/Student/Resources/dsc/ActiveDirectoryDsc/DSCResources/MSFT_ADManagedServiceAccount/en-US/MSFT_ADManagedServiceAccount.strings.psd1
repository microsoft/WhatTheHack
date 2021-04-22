# culture='en-US'
ConvertFrom-StringData @'
    AddingManagedServiceAccount           = Adding AD Managed Service Account '{0}'. (MSA0001)
    RemovingManagedServiceAccount         = Removing AD Managed Service Account '{0}'. (MSA0003)
    MovingManagedServiceAccount           = Moving AD Managed Service Account '{0}' to '{1}'. (MSA0004)
    ManagedServiceAccountNotFound         = AD Managed Service Account '{0}' was not found. (MSA0005)
    RetrievingServiceAccount              = Retrieving AD Managed Service Account '{0}'. (MSA0006)
    AccountTypeForceNotTrue               = The 'AccountTypeForce' was either not specified or set to false. To convert from a '{0}' MSA to a '{1}' MSA, AccountTypeForce must be set to true. (MSA0007)
    NotDesiredPropertyState               = AD Managed Service Account '{0}' is not correct. Expected '{1}', actual '{2}'. (MSA0008)
    MSAInDesiredState                     = AD Managed Service Account '{0}' is in the desired state. (MSA0009)
    MSANotInDesiredState                  = AD Managed Service Account '{0}' is NOT in the desired state. (MSA0010)
    UpdatingManagedServiceAccountProperty = Updating AD Managed Service Account property '{0}' to '{1}'. (MSA0011)
    AddingManagedServiceAccountError      = Error adding AD Managed Service Account '{0}'. (MSA0012)
    RetrievingPrincipalMembers            = Retrieving Principals Allowed To Retrieve Managed Password based on '{0}' property. (MSA0013)
    RetrievingServiceAccountError         = There was an error when retrieving the AD Managed Service Account '{0}'. (MSA0014)
'@
