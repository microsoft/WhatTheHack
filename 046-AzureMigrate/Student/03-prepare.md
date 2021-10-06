# Challenge 3: Prepare to Migrate to Azure

[< Previous Challenge](./02-discovery.md) - **[Home](../README.md)** - [Next Challenge >](./04-migrate.md)

## Description

Prepare the migration and do a migration test.

If you changed the IP addresses when migrating to Azure, you would need to "teach" each VM how to reach the next application tier:

- UbuntuWAF has the IP address of webserver1 hard coded in `/etc/nginx/nginx.conf`
- smarthotelweb1 has the IP address of the application server hard coded in `C:\inetpub\SmartHotel.Registration\Web.config`
- smarthotelweb2 has the database connection string in `C:\inetpub\SmartHotel.Registration.Wcf\Web.config`

Make sure to download the registration key for the Recovery Services vault from a browser inside the Azure VM, instead of downloading it to your local machine and then moving it to the Azure VM (time zone differences might make the registration process fail).

## Success Criteria

- On-premises Virtual Machines have been replicated to Azure
- A migration test has been performed: as a minimum, make sure the VMs boot up correcly, and that you can connect to them remotely

## Learning Resources

- [Migrate Hyper-V VMs to Azure](https://docs.microsoft.com/azure/migrate/tutorial-migrate-hyper-v?tabs=UI)
