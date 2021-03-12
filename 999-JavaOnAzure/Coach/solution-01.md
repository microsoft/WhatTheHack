# Challenge 1: 

[< Previous Challenge](./solution-00.md) - **[Home](../README.md)** - [Next Challenge>](./solution-02.md)

## Notes & Guidance

- There's a number of different methods to deploy a MySQL database, you can use the included [mysql.bicep](./assets/mysql.bicep) file for that. The only required parameter is the accessIp, which you can provide or retrieve as shown below, a more or less random (but deterministic) password is created if none is passed (and shown as an output)

```shell
az deployment group create -g $RG -f mysql.bicep -p accessIp=`curl -s https://ifconfig.me` --query properties.outputs
```

- Important thing to keep in mind is that the firewall needs to be opened for the client IP address

- Once the database is up and running, you can connect to it by providing the configuration parameters MYSQL_URL, MYSQL_USER and MYSQL_PASS. Easiest method is to define those in the current shell as environment variables, but alternatively you could pass them to the `mvn` as well. And don't forget to turn on thy `mysql` profile.

```shell
mvnw spring-boot:run -Dspring-boot.run.jvmArguments="-Dspring.profiles.active=mysql -DMYSQL_URL=... -DMYSQL_USER=... -DMYSQL_PASS=..."
```

Note that the MYSQL_URL is the full jdbc url, and the MYSQL_USER must include the database server name as a suffix. In addition the MYSQL_URL should contain the `serverTime=UTC` option as well.

- Verifying that database has been updated can be done through cloud shell

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