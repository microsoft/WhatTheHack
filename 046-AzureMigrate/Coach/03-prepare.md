# Challenge 3: Prepare to Migrate to Azure - Coach's Guide

[< Previous Challenge](./02-discovery.md) - **[Home](./README.md)** - [Next Challenge >](./04-migrate.md)

## Notes and Guidance

-  Create storage account(s?) for use when enabling replication
    - Point out a (current, August 21) limitation of hyper-v that we can't migrate direct to a managed disk
    - type of storage account (standard vs premium) determines type of disk ultimately created
    - Q: is hyper-v migration directly to managed disks coming any time soon?
-  Register Hyper-V host with Azure Migrate: Server Migration
    - this often / previously took a while or was tricky somehow? Check when testing
-  Enable replication
    - <- save this time for Q&A / parking lot when replication is happening?
-  Test failover
    - Perhaps do one, rather than multiple?
    - Discuss limitations including connectivity, domain controllers, etc

## Solution Guide

You can use this script to create the required resources for replication

```bash
# Create resources required for migration
rg_onprem=migratefasthack-onprem
rg_azure_prod=migratefasthack-azure-prod
rg_azure_test=migratefasthack-azure-test
location=westeurope
# Storage account
az storage account create -n fasthack$RANDOM -g $rg_azure_prod --sku Premium_LRS --kind StorageV2 -l $location
# Prod VNet 
vnet_name=vnet-prod
az network vnet create -g $rg_azure_prod -n $vnet_name --address-prefix 172.16.0.0/16
az network vnet subnet create -g $rg_azure_prod --vnet-name $vnet_name --name WAF --address-prefix 172.16.1.0/24
az network vnet subnet create -g $rg_azure_prod --vnet-name $vnet_name --name web --address-prefix 172.16.2.0/24
az network vnet subnet create -g $rg_azure_prod --vnet-name $vnet_name --name db --address-prefix 172.16.3.0/24
# Test VNet
vnet_name=vnet-test
az network vnet create -g $rg_azure_test -n $vnet_name --address-prefix 172.16.0.0/16
az network vnet subnet create -g $rg_azure_test --vnet-name $vnet_name --name WAF --address-prefix 172.16.1.0/24
az network vnet subnet create -g $rg_azure_test --vnet-name $vnet_name --name web --address-prefix 172.16.2.0/24
az network vnet subnet create -g $rg_azure_test --vnet-name $vnet_name --name db --address-prefix 172.16.3.0/24
```
