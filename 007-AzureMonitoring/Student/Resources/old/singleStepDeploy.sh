#!/bin/bash

#Azure CLI Commands to create an Azure Key Vault and deployment for Ready Monitoring Workshop
#Tip: Show the Integrated Terminal from View\Integrated Terminal or Ctrl+`
#Tip: highlight a line, press Ctrl+Shift+P and then "Terminal: Run Selected Text in Active Terminal" to run the line of code!

#Step 1: Use a name no longer then five charactors all LOWERCASE.  Your initials would work well if working in the same sub as others.
declare monitoringWorkShopName="yourinitialshere"
declare location="eastus" #Note: This location has been selected because Azure Monitor Preview is enabled here.
declare sshkeypath="<path>" #Note: Make sure this path exists in the Azure Cloud Shell. this is the path where your ssh keys will be generated and stored.
declare prefix=$monitoringWorkShopName
declare subscriptionid=$(az account show --query id -o tsv)

#Step 2: Create ResourceGroup after updating the location to one of your choice. Use get-AzureRmLocation to see a list
#Create a new Resource Group with YOUR name!
az group create --name $monitoringWorkShopName -l $location

#Step 3: Create Key Vault and set flag to enable for template deployment with ARM
declare monitoringWorkShopVaultName=$(echo $monitoringWorkShopName"MonWorkshopVault")
az keyvault create --name $monitoringWorkShopVaultName -g $monitoringWorkShopName -l $location --enabled-for-template-deployment true

#Step 4a: Add password as a secret.  Use a password that meets the azure pwd police like P@ssw0rd123!!
read -s -p "Password for your VMs: " PASSWORD
az keyvault secret set --vault-name $monitoringWorkShopVaultName --name 'VMPassword' --value $PASSWORD

#Step 4b:generate an ssh key and store it in keyvault. Replace the path (after -f) to a path of your choice.
ssh-keygen -t rsa -b 4096 -o -C "your_email@example.com" -f $sshkeypath/id_rsa
#copy this key into key vault, please change the path if needed.
az keyvault secret set --vault-name $monitoringWorkShopVaultName --name 'sshkey-pub' --file $sshkeypath/id_rsa.pub

#Step 5:create Azure AD service principal for AKS
declare scope=$(az group show -n $monitoringWorkShopName --query id -o tsv)
az ad sp create-for-rbac -n "ready-$monitoringWorkShopName-aks-preday" --role owner --password $PASSWORD --scopes=$(echo $scope)

#Step 6: Update azuredeploy.parameters.json file with your envPrefixName and Key Vault resourceID Example --> /subscriptions/{guid}/resourceGroups/{group-name}/providers/Microsoft.KeyVault/vaults/{vault-name}
# Hint: Run the following line of code to retrieve the resourceID so you can cut and paste from the terminal into your parameters file!
declare aks_arm_client_id=$(az ad sp show --id "http://ready-$monitoringWorkShopName-aks-preday" --query appId --output tsv)
declare keyvault_uri=$(az keyvault show --name $monitoringWorkShopVaultName --query "properties.vaultUri" -o tsv)
declare keyvault_id=$(az keyvault show --name $monitoringWorkShopVaultName --query "id" -o tsv)

# Step 7: find and replace SPN ID and Keyvault URi and resource id in azuredeploy.parameters.json and terraform.tfvars
sed -i 's@enter a 5 character value here all lowercase@'"$prefix"'@g' ./azuredeploy.parameters.json
sed -i 's@<paste your vault resourceId here>@'"$keyvault_id"'@g' ./azuredeploy.parameters.json

sed -i 's@<Enter the SPN Application Id here>@'"$aks_arm_client_id"'@g' ./terraform/terraform.tfvars
sed -i 's@https://<Keyvault Name here>.vault.azure.net/@'"$keyvault_uri"'@g' ./terraform/terraform.tfvars
sed -i 's@<Enter Log Analytics existing Workspace name here>@'"$prefix""hacklogworkspace"'@g' ./terraform/terraform.tfvars
sed -i 's@<Enter Resourcegroup Name Here>@'"$prefix"'@g' ./terraform/terraform.tfvars
sed -i 's@<Enter Resourcegroup Name here>@'"$prefix"'@g' ./terraform/terraform.tfvars
sed -i 's@<Enter Subscription ID here>@'"$subscriptionid"'@g' ./terraform/terraform.tfvars

#az keyvault show --name $monitoringWorkShopVaultName -o json

#Step 7: Run deployment below after updating and SAVING the parameter file with your key vault info.  Make sure to update the paths to the json files or run the command from the same directory
#Note: This will deploy VMs using DS3_v2 series VMs.  By default a subscription is limited to 10 cores of DS Series per region.  You may have to request more cores or
# choice another region if you run into quota errors on your deployment.  Also feel free to modify the ARM template to use a different VM Series.
az group deployment create --name monitoringWorkShopDeployment -g $monitoringWorkShopName --template-file VMSSazuredeploy.json --parameters @azuredeploy.parameters.json
