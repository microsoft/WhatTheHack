# Challenge 3: Offline migration

[< Previous Challenge](./02-size-analysis.md) - **[Home](../README.md)** - [Next Challenge >](./04-offline-cutover-validation.md)

## Proctor Tips

1. The attendees will not be able to connect to Azure DB for PostgreSQL/MySQL from within the container. In order to connect, they will need to add the public IP address to the DB firewall. This is the ip address the container is using for egress to connect to Azure DB. One way to find it is to do this:
```shell

apt update
apt install curl
curl ifconfig.me

```

1. Another way is to login to the database container, and then try to launch a connection to the Azure DB for MySQL or Postgres. It will fail wuth a firewall error that will reveal the address. In the example below, pgtarget is the Postgres server name, serveradmin is the admin user created on Azure.

```shell

kubectl -n postgresql exec deploy/postgres -it -- bash
root@postgres-64786b846-khk28:/#  psql -h pgtarget.postgres.database.azure.com -p 5432 -U serveradmin@pgtarget -d postgres

```
