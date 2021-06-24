#!/bin/bash

#Azure CLI Commands to create an Azure Key Vault and deployment for Ready Monitoring Workshop
#Tip: Show the Integrated Terminal from View\Integrated Terminal or Ctrl+`
#Tip: highlight a line, press Ctrl+Shift+P and then "Terminal: Run Selected Text in Active Terminal" to run the line of code!

#Step 1: Use a name no longer then five charactors all LOWERCASE.  Your initials would work well if working in the same sub as others.
declare monitoringWorkShopName="yourinitialshere"
declare location="eastus" #Note: This location has been selected because Azure Monitor Preview is enabled here.

#Step 2: Create ResourceGroup after updating the location to one of your choice. Use get-AzureRmLocation to see a list
#Create a new Resource Group with YOUR name!
az group create --name $monitoringWorkShopName -l $location

#Step 3: Create Key Vault and set flag to enable for template deployment with ARM
declare monitoringWorkShopVaultName=$(echo $monitoringWorkShopName"MonWorkshopVault")
az keyvault create --name $monitoringWorkShopVaultName -g $monitoringWorkShopName -l $location --enabled-for-template-deployment true

#Step 4: Add password as a secret.  Use a password that meets the azure pwd police like P@ssw0rd123!!
read -s -p "Password for your VMs: " PASSWORD
az keyvault secret set --vault-name $monitoringWorkShopVaultName --name 'VMPassword' --value $PASSWORD

#Step 5:create Azure AD service principal for AKS, this will return your password for the Service Principal account
declare scope=$(az group show -n $monitoringWorkShopName --query id -o tsv)
az ad sp create-for-rbac -n "ready-$monitoringWorkShopName-aks-preday" --role owner --scopes=$(echo $scope) --query password --output tsv

#Add your password for the Service Principal to the vault
az keyvault secret set --vault-name $monitoringWorkShopVaultName --name 'SPPassword' --value '<paste password here>'

#Step 6: Update azuredeploy.parameters.json file with your envPrefixName and Key Vault resourceID Example --> /subscriptions/{guid}/resourceGroups/{group-name}/providers/Microsoft.KeyVault/vaults/{vault-name}
# Hint: Run the following line of code to retrieve the resourceID so you can cut and paste from the terminal into your parameters file!
az keyvault show --name $monitoringWorkShopVaultName -o json 

#Step 7: Run deployment below after updating and SAVING the parameter file with your key vault info.  Make sure to update the paths to the json files or run the command from the same directory
#Note: This will deploy VMs using DS3_v2 series VMs.  By default a subscription is limited to 10 cores of DS Series per region.  You may have to request more cores or
# choice another region if you run into quota errors on your deployment.  Also feel free to modify the ARM template to use a different VM Series.
az deployment group create --name monitoringWorkShopDeployment -g $monitoringWorkShopName --template-file VMSSazuredeploy.json --parameters @azuredeploy.parameters.json

#Step 8: Once the initial deployment is complete we now need to deploy the AKS Cluster.  
#Note: As its more then likely you had to open a new cloud shell rerun step 1 to set the variables 
az group create --name $monitoringWorkShopName"-AKS" -l $location

#Find your Service Principal Object ID
az ad sp show --id 'enter AppId here' --query objectId

#Update the aksdeploy.parameters.json parameters file with the envPrefixName, existingServicePrincipalObjectId, existingServicePrincipalClientId, and existingServicePrincipalClientSecret
#Run deployment below after updating and SAVING the parameter file
#Note: If deploying using Cloud Shell copy the two json files to the cloud shell
az deployment group create --name aksmonitoringWorkShopDeployment -g $monitoringWorkShopName"-AKS" --template-file aksdeploy.json --parameters aksdeploy.parameters.json

#Once the AKS cluster is deployed and because we enabled Kubernetes 
#RBAC authorization, you will need to apply cluster role binding to use Live Logs

#Connect to your cluster
az aks get-credentials --resource-group $monitoringWorkShopName"-AKS" --name $monitoringWorkShopName"aksdemo"
#use this to test your connection
kubectl get nodes
#deploy the cluster role bindings
kubectl create -f LogReaderRBAC.yaml
