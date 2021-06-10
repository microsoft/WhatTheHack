# Challenge 8: Plan and Implement BCDR

[< Previous Challenge](./07-Install-Configure-Apps.md) - **[Home](./README.md)** - [Next Challenge >](./09-Automate-AVD-Tasks.md)

## Notes & Guidance

Students will only be setting up Disaster Recovery for Japan West.

- For this challenge students need to set up Azure Site Recovery for their Japan West HostPool to East Us Spoke Vnet.
    - They will use East Us because it is already available and don't want them to have more overhead to create another secondary location.
    - Students don't need to do a test failover, just confirm the data is being replicated to the secondary site to show DR is available.
    - They will use the same Subnet that the EastUS Session Host VMs are using.

**NOTE:** Students will NOT need to create a second hostpool in East US for the Japan West. When the VM failsover to East US the computer name and agent are still registered to the Japan West Hostpool. Even though the machines will be running in East US the Session Hosts will be available in the Japan West Hostpool. Microsoft manages the HostPool availability and redundancy, so students wont need to create another hostpool.

- They will use Azure Backup for the Session Host VMs and profiles.
    - Because the Personal desktops store data, backing up Personal VMs in case of data loss is our best practice. Users could restore from Backup if there was ever VM corruption.
    - They can set up the backup policy to backup every 24hours.
    - They can also use Azure Back up for backing up their profiles in the storage account.

-  Fslogix CLoud Cache should be set up already in earlier challenges so all they need to do is use Recovery Vault to backup the storage account. Its fine if they just want to back up one storage account.
