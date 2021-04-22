# Description

The ADOptionalFeature DSC resource will enable the Active Directory Optional Feature of choice for the target forest.
This resource first verifies that the forest and domain modes match or exceed the requirements.  If the forest or domain mode
is insufficient, then the resource will exit with an error message.  The change is executed against the
Domain Naming Master FSMO of the forest.

## Requirements

* Target machine must be running Windows Server 2008 R2 or later, depending on the feature.
