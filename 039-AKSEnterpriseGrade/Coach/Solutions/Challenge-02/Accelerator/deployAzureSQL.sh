#!/bin/bash

# Collect input parameters from the user

echo -n "Please enter a resource group name: "
read rgname
echo -n "Please enter an Azure region (i.e. \"eastus\", \"westus\"):"
read location
echo -n "Please enter a password for the SQL Server admin account:"
read -s sql_password

# Create Azure Resource Group

rg=$rgname
echo -n "Creating resource group $rgname in $location..."
az group create -n $rg -l $location

# Create SQL DB

sql_server_name=sqlserver$RANDOM
sql_db_name=mydb
sql_username=azure

echo -n "Creating Azure SQL Database server $sql_server_name in $location..."

az sql server create -n "$sql_server_name" -g "$rg" -l "$location" --admin-user "$sql_username" --admin-password "$sql_password"
sql_server_fqdn=$(az sql server show -n "$sql_server_name" -g "$rg" -o tsv --query fullyQualifiedDomainName)

echo -n "Creating SQL Database $sql_db_name on $sql_server_name..."
az sql db create -n "$sql_db_name" -s "$sql_server_name" -g "$rg" -e Basic -c 5 --no-wait