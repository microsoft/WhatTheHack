# culture="en-US"
ConvertFrom-StringData @'
CheckingTrustMessage      = Determining if the trust between domains '{0}' and '{1}' with the context type '{2}' exists. (ADDT0001)
RemovedTrust              = Trust between between domains '{0}' and '{1}' with the context type '{2}' has been removed. (ADDT0002)
AddedTrust                = Created the trust between domains '{0}' and '{1}' with the context type '{2}' and direction '{3}'. (ADDT0003)
SetTrustDirection         = The trust direction has been changed to '{0}'. (ADDT0004)
TrustPresentMessage       = The trust between domains '{0}' and '{1}' with the context type '{2}' exist. (ADDT0005)
TrustAbsentMessage        = There is no trust between domains '{0}' and '{1}' with the context type '{2}'. (ADDT0006)
TestConfiguration         = Determining the current state of the Active Directory trust with source domain '{0}', target domain '{1}' and context type '{2}'. (ADDT0007)
InDesiredState            = The Active Directory trust is in the desired state. (ADDT0008)
NotInDesiredState         = The Active Directory trust is not in the desired state. (ADDT0009)
NeedToRecreateTrust       = The trust type is not in desired state, removing the trust between the domains '{0}' and '{1}' with the context type '{2}' to be able to recreate the trust with the correct context type '{3}'. (ADDT0010)
RecreatedTrustType        = Recreated the trust between domains '{0}' and '{1}' with the context type '{2}' and direction '{3}'. (ADDT0011)
NotOptInToRecreateTrust   = Not opt-in to recreate trust. To opt-in set the parameter AllowTrustRecreation to $true.
'@
