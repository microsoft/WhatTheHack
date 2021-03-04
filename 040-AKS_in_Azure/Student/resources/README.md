# Containers for hackathon

This repository contains two sample containers to test microservices applications in Docker and Kubernetes:

- api
- web

Note that the images are pretty large, since they are based on standard ubuntu and centos distros. The goal is having a fully functional OS in case any in-container troubleshooting or investigation is required.

## API

sql-api (available in dockerhub [here](https://hub.docker.com/repository/docker/erjosito/sqlapi)), it offers the following endpoints:

- `/api/healthcheck`: returns a basic JSON code
- `/api/sqlversion`: returns the results of a SQL query (`SELECT @@VERSION`) against a SQL database. You can override the value of the `SQL_SERVER_FQDN` via a query parameter 
- `/api/sqlsrcip`: returns the results of a SQL query (`SELECT CONNECTIONPROPERTY("client_net_address")`) against a SQL database. You can override the value of the environment variables such as `SQL_SERVER_FQDN` via a query parameter
- `/api/ip`: returns information about the IP configuration of the container, such as private IP address, egress public IP address, default gateway, DNS servers, etc
- `/api/dns`: returns the IP address resolved from the FQDN supplied in the parameter `fqdn`
- `/api/printenv`: returns the environment variables for the container
- `/api/curl`: returns the output of a curl request, you can specify the argument with the parameter `url`
- `/api/pi`: calculates the decimals of the number pi, you can specify how many decimals with the parameter `digits`. 1,000 digits should be quick, but as you keep increasing the number of digits, more CPU will be required. You can use this endpoint to force the container to consume more CPU
- `/api/sqlsrcipinit`: the previous endpoints do not modify the database. If you want to modify the database, you need first to create a table with this endpoint
- `/api/sqlsrciplog`: this endpoint will create a new record in the table created with the previous endpoint (`sqlsrcipinit`) with a timestamp and the source IP address as seen by the database.

Environment variables can be also injected via files in the `/secrets` directory. Here the environments supported:

- `SQL_SERVER_FQDN`: FQDN of the SQL server
- `SQL_SERVER_USERNAME`: username for the SQL server
- `SQL_SERVER_PASSWORD`: password for the SQL server
- `SQL_SERVER_DB` (optional): database name
- `SQL_ENGINE` (optional): `sqlserver` (default), `mysql` or `postgres`
- `USE_SSL` (optional): if using the `mysql` engine, whether SSL is used or not. If SSL is used, the CA certificate for Azure (`BaltimoreCyberTrustRoot.crt.pem`) is taken for CA validation. The default value is `yes`
- `PORT` (optional): TCP port where the web server will be listening (8080 per default)

Source files [here](api).

## Web

Simple PHP web page that can access the previous API and shows whether the user is authenticated.

Environment variables:

- `API_URL`: URL where the SQL API can be found, for example `http://1.2.3.4:8080`

Following you have a list of labs. The commands are thought to be issued in a **Linux console**, but if you are running on a Powershell console they should work with some minor modifications (like adding a `$` in front of the variable names).

Source files [here](web).
