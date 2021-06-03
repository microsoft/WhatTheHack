# Challenge 1: Head in the cloud, feet on the ground

[< Previous Challenge](./solution-00.md) - **[Home](./README.md)** - [Next Challenge >](./solution-02.md)

## Notes & Guidance

- There's a number of different methods to deploy a MySQL database, you can use the included [mysql.bicep](./Solutions/mysql.bicep) file for that. The only required parameter is the `clientIp`, which you can retrieve and provide as shown below, a more or less random (but deterministic) password is created if none is passed (and captured as an env variable)

    ```shell
    CLIENT_IP=`curl -s https://ifconfig.me`
    MYSQL=`az deployment group create -g $RG -f Solutions/mysql.bicep -p clientIp=$CLIENT_IP --query properties.outputs`
    MYSQL_URL=`echo "$MYSQL" | jq -r .jdbcUrl.value`
    MYSQL_USER=`echo "$MYSQL" | jq -r .userName.value`
    MYSQL_PASS=`echo "$MYSQL" | jq -r .password.value`
    ```

- On the Azure Marketplace there are multiple MySQL offerings, make sure that Azure Database for MySQL is chosen when the portal is used. Any configuration is fine but a single server on the basic tier with a single vCore and 50GB storage should be sufficient.
- Important thing to keep in mind is that the firewall needs to be opened for the client IP address, and also the local machine needs to be able to connect to the outside world through port `3306` (for some organizations this might require connecting to the guest wi-fi :/)
- Once the database is up and running, you can connect to it by providing the configuration parameters MYSQL_URL, MYSQL_USER and MYSQL_PASS. Easiest method is to define those in the current shell as environment variables, but alternatively you could pass them to the `mvn` command as well. And don't forget to turn on the `mysql` profile.

    ```shell
    mvnw spring-boot:run -Dspring-boot.run.jvmArguments="-Dspring.profiles.active=mysql -DMYSQL_URL=$MYSQL_URL -DMYSQL_USER=$MYSQL_USER -DMYSQL_PASS=$MYSQL_PASS"
    ```

- Note that the MYSQL_URL is the full jdbc url, and the MYSQL_USER must include the database server name as a suffix. In addition the MYSQL_URL needs to contain the `serverTime=UTC` option too. If you've used the included bicep file, the generated output already contains this information.
- Verifying that the database has been updated can be done through the cloud shell as it contains the `mysql` client. We're using default setting for the MySQL database when using the bicep file, which turns on SSL, hence the `--ssl` option.

    ```shell
    $ mysql --ssl -h MYSQL_SERVER_FQDN -D petclinic -u MYSQL_USER -p
    Enter password:
    Reading table information for completion of table and column names
    You can turn off this feature to get a quicker startup with -A

    Welcome to the MariaDB monitor.  Commands end with ; or \g.
    Your MySQL connection id is 64629
    Server version: 5.6.47.0 MySQL Community Server (GPL)

    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

    MySQL [petclinic]> show tables;
    +---------------------+
    | Tables_in_petclinic |
    +---------------------+
    | owners              |
    | pets                |
    | specialties         |
    | types               |
    | vet_specialties     |
    | vets                |
    | visits              |
    +---------------------+
    7 rows in set (0.025 sec)
    ```
