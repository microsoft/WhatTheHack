@secure()
param adminPassword string

// This Bicep file is mostly a noop.  It's just used to demonstrate reading from a Key Vault

// This is only to show you accessed the Key Vault.  THIS IS AN ANTI-PATTERN AND NOT RECOMMENDED IN NORMAL USE
output kvinfo string = adminPassword
