# culture="en-US"
ConvertFrom-StringData @'
    RetrievingGroupMembers         = Retrieving group membership based on '{0}' property. (ADG0001)
    GroupMembershipNotDesiredState = Group membership is NOT in the desired state. (ADG0002)
    AddingGroupMembers             = Adding '{0}' member(s) to AD group '{1}'. (ADG0003)
    RemovingGroupMembers           = Removing '{0}' member(s) from AD group '{1}'. (ADG0004)
    AddingGroup                    = Creating AD Group '{0}'. (ADG0005)
    UpdatingGroup                  = Updating AD Group '{0}'. (ADG0006)
    RemovingGroup                  = Removing AD Group '{0}'. (ADG0007)
    MovingGroup                    = Moving AD Group '{0}' to '{1}'. (ADG0008)
    RestoringGroup                 = Attempting to restore the group {0} from recycle bin. (ADG0009)
    GroupNotFound                  = AD Group '{0}' was not found. (ADG00010)
    NotDesiredPropertyState        = AD Group '{0}' is not correct. Expected '{1}', actual '{2}'. (ADG0011)
    UpdatingGroupProperty          = Updating AD Group property '{0}' to '{1}'. (ADG0012)
    GroupMembershipMultipleDomains = Group membership objects are in '{0}' different AD Domains. (ADG0013)
'@
