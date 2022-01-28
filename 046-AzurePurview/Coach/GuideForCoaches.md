# Deployment of the environment: 

 1. Open attached script and modify subscribtionID, region and amount of environments for users (1 environment = 1 resource group with all needed service).
 2. At the begining of the script you will have to log in to the Azure.
 3. Script will create one shared resource group (rg-PurviewFastHack-SharedAssets) and multiple resource groups for each participant (rg-PurviewFastHack001, 002...)
 4. RDP to azure sql vm in shared resource group.
 6. Download WideWorldImporters-Full.bak from  https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0
 7. Restore WideWorldImporters-Full backup.
 8. 
 
 
 # Checklist before starting openHack
 1. Running SQL VM with WideWorldImporters database in shared RG.
 
