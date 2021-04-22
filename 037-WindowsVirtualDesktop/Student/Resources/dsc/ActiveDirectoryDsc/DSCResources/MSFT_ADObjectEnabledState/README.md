# Description

This resource enforces the property `Enabled` on the object class *Computer*.

>This resource could support other object classes like *msDS-ManagedServiceAccount*,
>*msDS-GroupManagedServiceAccount*, and *User*. But these object classes
>are not yet supported due to that other resources already enforces the
>`Enabled` property. If this resource should support another object class,
>then it should be made so that only one resource enforces the enabled
>property. This is to prevent a potential "ping-pong" behavior if both
>resource would be used in a configuration.

## Requirements

* Target machine must be running Windows Server 2008 R2 or later.
