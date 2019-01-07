#!/bin/bash

#Azure CLI Commands to create an Azure Key Vault and deployment for Monitoring Hackathon
#Tip: Show the Integrated Terminal from View\Integrated Terminal or Ctrl+`
#Tip: highlight a line, press Ctrl+Shift+P and then "Terminal: Run Selected Text in Active Terminal" to run the line of code!

#Step 1: Use a name no longer then five charactors all LOWERCASE.  Your initials would work well if working in the same sub as others.
declare monitoringHackName="yourinitialshere"
declare location="eastus"

#Step 2: Create ResourceGroup after updating the location to one of your choice. Use get-AzureRmLocation to see a list
#Create a new Resource Group with YOUR name!
az group create --name $monitoringHackName -l $location

#Step 3: Create Key Vault and set flag to enable for template deployment with ARM
declare vaultSuffix="MonitoringHackVault"
declare monitoringHackVaultName="$monitoringHackName$vaultSuffix" 
az keyvault create --name $monitoringHackVaultName -g $monitoringHackName -l $location --enabled-for-template-deployment true

#Step 4: Add password as a secret.  Use a password that meets the azure pwd police like P@ssw0rd123!!
read -s -p "Password for your VMs: " PASSWORD
az keyvault secret set --vault-name $monitoringHackVaultName --name 'VMPassword' --value $PASSWORD

#Step 5: Update azuredeploy.parameters.json file with your envPrefixName and Key Vault resourceID Example --> /subscriptions/{guid}/resourceGroups/{group-name}/providers/Microsoft.KeyVault/vaults/{vault-name}
# Hint: Run the following line of code to retrieve the resourceID so you can cut and paste from the terminal into your parameters file!
az keyvault show --name $monitoringHackVaultName -o json 

#Step 6: Run deployment below after updating and SAVING the parameter file with your key vault info.  Make sure to update the paths to the json files or run the command from the same directory
#Note: This will deploy VMs using DS3_v2 series VMs.  By default a subscription is limited to 10 cores of DS Series per region.  You may have to request more cores or
# choice another region if you run into quota errors on your deployment.  Also feel free to modify the ARM template to use a different VM Series.
az group deployment create --name monitoringHackDeployment -g $monitoringHackName --template-file VMSSazuredeploy.json --parameters @azuredeploy.parameters.json
