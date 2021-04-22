ConvertFrom-StringData @'
FoundZone = Found a {0} zone named {1}.
CouldNotFindZone = Unable to find a zone named {0}.
RecreateZone = The {0} zone {1} was removed pending recreation. The existing zone type or replication scope cannot be converted.
UpdatingMasterServers = The list of servers for the conditional forwarder, {0}, was updated to {1}.
MoveADZone = The conditional forwarder, {0}, was moved to {1} replication scope.
NewZone = The conditional forwarder, {0}, was created.
RemoveZone = The conditional forwarder, {0}, was removed.
ZoneDoesNotExist = The zone, {0}, does not exist.
IncorrectZoneType = The zone {0} is {1}. Expected forwarder.
ZoneIsDsIntegrated = The zone {0} is AD Integrated. Expected file.
ZoneIsFileBased = The zone {0} is file based. Expected AD Integrated.
ReplicationScopeDoesNotMatch = The zone {0} has replication scope {1}. Expected replication scope {2}.
DirectoryPartitionDoesNotMatch = The zone {0} is not stored in the partition {1}.
MasterServersDoNotMatch = Expected master servers for the zone {0} to be {1}. Found {2}.
ZoneExists = The zone, {0}, exists.
MasterServersIsMandatory = The MasterServers parameter is mandatory when ensuring a zone is present.
DirectoryPartitionNameIsMandatory = A DirectoryPartitionName is mandatory when the replication scope is custom.
'@
