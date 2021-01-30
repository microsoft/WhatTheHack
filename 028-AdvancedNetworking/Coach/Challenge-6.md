# Challenge 6: Coach's Guide

[< Previous Challenge](./Challenge-5.md) - [Home](./README.md) - [Next Challenge >](./Challenge-7.md)

## Notes and Guidance


- NSGs do not have rdp and ssh ports open to the internet. It should point to the vnet Bastion range.

- MAnagement connections should go through Azure Bastion. Verify the connection status once a session is opened.

- Check for Bastion diagnostics logs logged to the storage account.
