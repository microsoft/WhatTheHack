#!/bin/bash

#Azure CLI Commands to create an Azure Key Vault and deploy a secret to it
#Tip: Show the Integrated Terminal from View\Integrated Terminal or Ctrl+`
#Tip: highlight a line, press Ctrl+Shift+P and then "Terminal: Run Selected Text in Active Terminal" to run the line of code!

#Step 1: Use a name with all characters LOWERCASE.  Your initials would work well if working in the same sub as others. 
# Pick a location that is the same region where you are deploying your template!
declare iacHackName="wth-iac"
declare location="eastus"

#Step 2: Create ResourceGroup after updating the location to one of your choice.
#Create a new Resource Group with YOUR name!
az group create --name $iacHackName -l $location

#Step 3: Create Key Vault and set flag to enable for template deployment with ARM
declare vaultSuffix="-KeyVault"
declare iacHackVaultName="$iacHackName$vaultSuffix" 
az keyvault create --name $iacHackVaultName -g $iacHackName -l $location --enabled-for-template-deployment true

#Step 4: Add password as a secret.  Use a password that meets the azure pwd police like P@ssw0rd123!!
read -s -p "Password for your VMs: " PASSWORD
az keyvault secret set --vault-name $iacHackVaultName --name 'adminPassword' --value $PASSWORD

#Step 5: Update azuredeploy.parameters.json file with your envPrefixName and Key Vault resourceID Example --> /subscriptions/{guid}/resourceGroups/{group-name}/providers/Microsoft.KeyVault/vaults/{vault-name}
# Hint: Run the following line of code to retrieve the resourceID so you can cut and paste from the terminal into your parameters file!
az keyvault show --name $iacHackVaultName -o json 
