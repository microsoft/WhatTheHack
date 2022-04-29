# Challenge 1: Discovery and Assessment 

[< Previous Challenge](./00-prereqs.md) - **[Home](./README.md)** - [Next Challenge >](./02-offline-migration.md)

## Coach Tips

* The attendees should check the links given in Reference section about limitations to figure out if the source database can be moved to Azure. Note: we only need to check the wth database that hosts the application data




* To connect to PostgreSQL, run this from Azure Cloud Shell or from your computer to connect using the psql command line tool. Alternatively, you can use a tool like Azure Data Studio, pgAdmin or DBeaver




    ```bash
    kubectl -n postgresql exec deploy/postgres -it -- /usr/bin/psql -U postgres wth
    ```
    
    
    
* The SQL below lists the PostgreSQL version, database size and the loaded extensions


 
   
   ```sql
   select version() ;
   
   select pg_size_pretty(pg_database_size('wth'));
  
   SELECT name, default_version, installed_version, left(comment,80) As comment FROM pg_available_extensions WHERE installed_version IS NOT NULL ORDER BY name;
   ```
   
   Alternate commands to check the database size and installed extensions are:
   
   ```sql
   
   \l+ wth 
   
   \dx
   
   ```
   
   
   * To connect to MySQL, run this from Azure Cloud Shell or from your computer to connect using the mysql command line. Alternatively, you can use a tool like MySQL Workbench or DBeaver



    ```bash
    kubectl -n mysql exec deploy/mysql -it -- /usr/bin/mysql -u root -p
    ```



    * In MySQL check the db version, what engine tables we have and the total database size (tables only, excluding index)


    
    ```sql
      select version () ;
      
      select table_schema, engine, count(1) from information_schema.tables where table_schema = 'wth' group by table_schema, engine  ;
            
      SELECT table_schema "DB Name",         ROUND(SUM(data_length + index_length) / 1024 / 1024, 1) "DB Size in MB"
       FROM information_schema.tables GROUP BY table_schema; 
    ```
    Here is a link with helpful MySQL configuration recommendations for data loading during a migration
    https://docs.microsoft.com/en-us/azure/dms/tutorial-mysql-azure-mysql-offline-portal#sizing-the-target-azure-database-for-mysql-instance

* Here is a link to Azure CLI commands to manage Azure Database for PostgreSQL. This may be useful to verify the Azure Database for PostgreSQL deployment. https://docs.microsoft.com/en-us/cli/azure/postgres?view=azure-cli-latest 

* Here is a link to the Azure CLI commands to manage Azure Database for MySQL. This may be useful to verify the Azure Database for MySQL deployment. https://docs.microsoft.com/en-us/cli/azure/mysql?view=azure-cli-latest


