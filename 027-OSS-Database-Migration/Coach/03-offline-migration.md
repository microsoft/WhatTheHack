# Challenge 3: Offline migration

[< Previous Challenge](./02-size-analysis.md) - **[Home](../README.md)** - [Next Challenge >](./04-offline-cutover-validation.md)

## Proctor Tips

The attendees will not be able to connect to Azure DB for PostgreSQL/MySQL from within the container. In order to connect, they will need to add the public IP address to the DB firewall. This is the ip address the container is using for egress to connect to Azure DB. One way to find it is to do this:
```shell

apt update
apt install curl
curl ifconfig.me

```

Another way is to login to the database container, and then try to launch a connection to the Azure DB for MySQL or Postgres. It will fail wuth a firewall error that will reveal the address. In the example below, pgtarget is the Postgres server name, pgtarget2 is the mysql servername and both has serveradmin as the admin user created on Azure.

```shell

kubectl -n postgresql exec deploy/postgres -it -- bash
root@postgres-64786b846-khk28:/#  psql -h pgtarget.postgres.database.azure.com -p 5432 -U serveradmin@pgtarget -d postgres

```

Before migrating the data, they need to create an empty database and create the application user. Connect to the database container first and from there connect to Azure DB.
Alternately connect to Azure DB using  Azure Data studio or Pgadmin tool

```shell

kubectl -n postgresql exec deploy/postgres -it -- bash
psql -h pgtarget.postgres.database.azure.com -p 5432 -U serveradmin@pgtarget -d postgres

```

```shell

kubectl -n mysql exec deploy/mysql -it -- bash
mysql -h mytarget2.mysql.database.azure.com -P 3306 -u serveradmin@mytarget2 -p

```

Create the pizzeria application database user and the database wth

```sql

CREATE ROLE CONTOSOAPP WITH LOGIN NOSUPERUSER INHERIT CREATEDB CREATEROLE NOREPLICATION PASSWORD 'OCPHack8';
create database wth ;

```
