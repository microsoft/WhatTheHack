# culture="en-US"
ConvertFrom-StringData @'
    QueryingDomainPasswordPolicy   = Querying Active Directory domain '{0}' default password policy. (ADDDPP0001)
    UpdatingDomainPasswordPolicy   = Updating Active Directory domain '{0}' default password policy. (ADDDPP0002)
    SettingPasswordPolicyValue     = Setting password policy '{0}' property to '{1}'. (ADDDPP0003)
    ResourcePropertyValueIncorrect = Property '{0}' value is incorrect; expected '{1}', actual '{2}'. (ADDDPP0004)
    ResourceInDesiredState         = Resource '{0}' is in the desired state. (ADDDPP0005)
    ResourceNotInDesiredState      = Resource '{0}' is NOT in the desired state. (ADDDPP0006)
'@
