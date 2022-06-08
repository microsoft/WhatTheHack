# Challenge 3: Prepare to Migrate to Azure

[< Previous Challenge](./02-discovery.md) - **[Home](../README.md)** - [Next Challenge >](./04-migrate.md)

## Introduction

This challenge involves deploying the tools to replicate our workload to Azure.  We will also confirm our migration timeline, make any pre-migration changes that are required and test the migration will work as expected. 

## Pre-requisites

Output from previous challenges including migration plans and output of assessments. 

## Description

- Install and configure any necessary tooling
- Check whether there are any changes you need to make to the on-premises VMs prior to migrating them to Azure
- Begin the process of replicating data from on-premises to Azure
- Test if VMs will still operate correctly post-migration

## Success Criteria

- On-premises workload is replicating to Azure
- Tests have been completed to ensure migration will succeed - any issues discovered have been rectified
- Migration plans have been updated with any new information discovered

## Learning Resources

- [Migrate Hyper-V VMs to Azure](https://docs.microsoft.com/azure/migrate/tutorial-migrate-hyper-v?tabs=UI)

## Tips

If you changed the IP addresses when migrating to Azure, you would need to update each VM config to enable access to the next application tier:

- UbuntuWAF has the IP address of webserver1 hard coded in `/etc/nginx/nginx.conf`
- smarthotelweb1 has the IP address of the application server hard coded in `C:\inetpub\SmartHotel.Registration\Web.config`
- smarthotelweb2 has the database connection string in `C:\inetpub\SmartHotel.Registration.Wcf\Web.config`

Make sure you download the registration key for the Recovery Services vault from a browser inside the Azure VM, instead of downloading it to your local machine and then moving it to the Azure VM (time zone differences might make the registration process fail).
