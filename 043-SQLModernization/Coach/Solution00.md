# Challenge 0: Setup - Coach's Guide

**[Home](README.md)** - [Next Challenge>](./Solution01.md)

## Notes & Guidance

The primary objective of this challenge is to download and install all of the required tools and databases. There should not be any major challenges encountered unless teams do not have any members with any database experience.

The most difficult decision will be deciding on an on-premises location for the databases as virtually every option has pros and cons. Databases configured in Azure allow all team members to access and may be easier to migrate. While teams can (and are encouraged to) set up the databases locally, this may present connectivity challenges opening the SQL port, depending on the environment.

### Docker

For teams deciding to go the Docker route, here are some helpful scripts/tips. The team can install SQL Server for Docker using either Linux or Windows containers.

* Docker on Windows
    * [Install Docker](https://docs.docker.com/install/)
    * [Install PowerShell (likely already installed)](https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-windows-powershell?view=powershell-6)
    * [Optional: can use bash.  See this guide for more information](https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker?view=sql-server-linux-2017)

The following script is for example purposes only and will likely need some tweaking: 
* Configure a different port, if desired (1433:1433 maps the host port 1433 to container 1433 -- the default port).
* Edit the local location of the backup file(s) to copy to the container.
* Edit the files in the RESTORE command; if unsure, use RESTORE FILELISTONLY to make sure data/log files have a location like in the script.
* The storage is not durable in this configuration. While it will survive reboots/etc., this type of configuration is designed to testing and development purposes.

```powershell
# Download latest image, run a new container, verify running
docker pull mcr.microsoft.com/mssql/server:2019-latest

# Start a new container, verify running
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=p@ssw0rd" `
   -p 1433:1433 --name sql1 `
   -d mcr.microsoft.com/mssql/server:2019-latest
   
docker ps -a

# Create a new folder to copy backups to
docker exec -it sql1 mkdir /var/opt/mssql/backup

# Copy file from local machine to container
docker cp C:\backups\AdventureWorksLT2017.bak sql1:/var/opt/mssql/backup

# Restore the container; use restore with FILELISTONLY if you need to inspect the files in backup
# Ex: RESTORE FILELISTONLY FROM DISK = 'C:\backups\AdventureWorksLT2017.bak' WITH FILE = 1
docker exec -it sql1 /opt/mssql-tools/bin/sqlcmd `
   -S localhost -U SA -P "[YourPassword]" `
   -Q "RESTORE DATABASE AdventureWorksLT FROM DISK = '/var/opt/mssql/backup/AdventureWorksLT2017.bak' WITH MOVE 'AdventureWorksLT2012_Data' TO '/var/opt/mssql/data/AdventureWorksLT2012_Data.mdf', MOVE 'AdventureWorksLT2012_Log' TO '/var/opt/mssql/data/AdventureWorksLT2012_Log.ldf'"

# Stop all containers:
docker stop $(docker ps -aq)

# Remove all containers:
docker rm $(docker ps -aq)
```

