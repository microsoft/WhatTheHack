# Challenge 3: Prepare to Migrate to Azure - Coach's Guide

[< Previous Challenge](./02-discovery.md) - **[Home](./README.md)** - [Next Challenge >](./04-migrate.md)

## Notes and Guidance


## Solution Guide

-  Create storage account(s?) for use when enabling replication
    - Point out a (current, August 21) limitation of hyper-v that we can't migrate direct to a managed disk
    - type of storage account (standard vs premium) determines type of disk ultimately created
    - Q: is hyper-v migration directly to managed disks coming any time soon?
-  Register Hyper-V host with Azure Migrate: Server Migration
    - this often / previously took a while or was tricky somehow? Check when testing
-  Enable replication
    - <- save this time for Q&A / parking lot when replication is happening?
-  Test failover
    - Perhaps do one, rather than multiple?
    - Discuss limitations including connectivity, domain controllers, etc
