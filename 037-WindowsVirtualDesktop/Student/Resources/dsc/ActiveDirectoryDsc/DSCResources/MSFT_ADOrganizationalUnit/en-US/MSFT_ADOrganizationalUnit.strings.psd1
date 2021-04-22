# culture="en-US"
ConvertFrom-StringData @'
    RetrievingOU               = Retrieving OU '{0}' from path '{1}'. (ADOU0001)
    UpdatingOU                 = Updating OU '{0}'. (ADOU0002)
    DeletingOU                 = Deleting OU '{0}'. (ADOU0003)
    CreatingOU                 = Creating OU '{0}'. (ADOU0004)
    RestoringOU                = Attempting to restore the organizational unit object {0} from the recycle bin. (ADOU0005)
    OUInDesiredState           = OU '{0}' exists and is in the desired state. (ADOU0006)
    OUNotInDesiredState        = OU '{0}' exists but is not in the desired state. (ADOU0007)
    OUExistsButShouldNot       = OU '{0}' exists when it should not exist. (ADOU0008)
    OUDoesNotExistButShould    = OU '{0}' does not exist when it should exist. (ADOU0009)
    OUDoesNotExistAndShouldNot = OU '{0}' does not exist and is in the desired state. (ADOU0010)
    PathNotFoundError          = The Path '{0}' was not found. (ADOU0011)
'@
