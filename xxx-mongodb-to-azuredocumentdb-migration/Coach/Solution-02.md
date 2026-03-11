# Challenge 02 - Compare source and target databases and update the application configuration - Coach's Guide 

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** 

## Notes & Guidance

* Students will need to restart the application with `Ctrl+C` and then `npm start` after changing the connection string.
* If the web site doesn't work because of a port conflict, they can use `ps -ef` and `kill <process-id>` to kill and restart the web application.
* After the web site comes up, make sure they click around again to make sure the site is working
* DMS has 2 versions, Only DMS v1 is currently visible in the portal for MongoDB (migrates to Cosmo Mongo RU only). The DMS created from VS Code is DMS v2 (migrates to Azure DocumentDB only). Hence, you can't find DMS created from VS Code in the Azure Portal or the CLI. There should be a portal experience for DocumentDB (DMS v2) later in 2026. Once that is completed both DMS v1 and v2 will be manageable from the Azure portal. 
* Since the migration job runs on DMS using cloud resources, DMS can't access the local server and hence the job will fail. In the case of an on-premises source cluster, they would need to connect the on-premises server to Azure using a VPN or ExpressRoute. 

