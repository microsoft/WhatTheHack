#!/bin/bash

if [ $# -lt 3 ]; then
   echo "Usage:  ./deployHack.sh <AzureDataCenter> <SubscriptionId> <BaseName>"
   exit
fi

loc=$1
sub=$2
baseName=$3
rg="rg-$baseName"
cosmoAccountName="$baseName-cosmosdb"

#create resource group
az group create --name $rg --location $loc --subscription $sub

#create App insights and get key
az group deployment create --name DeployAppInsights --template-uri https://raw.githubusercontent.com/andywahr/microservices-workshop/master/src/azuredeploy-appinsights.json --parameters name=appInsights$baseName regionId=southcentralus --resource-group $rg --subscription $sub
appInsightsKey=$(az resource show --resource-group $rg --subscription $sub --resource-type Microsoft.Insights/components --name appInsights$baseName --query "properties.InstrumentationKey" | tr -d '"')

#create cosmos db account and list keys
az cosmosdb create --subscription $sub --resource-group $rg --name $cosmoAccountName
cosmosPrimaryKey=$(az cosmosdb list-keys --resource-group $rg --subscription $sub --name $cosmoAccountName --query primaryMasterKey | tr -d '"')

#create dataloader ACI
az container create --subscription $sub --resource-group $rg --name $baseName-dataloader --image microservicesdiscovery/travel-dataloader --dns-name-label $baseName-dataloader --environment-variables DataAccountName=$cosmoAccountName DataAccountPassword=$cosmosPrimaryKey ApplicationInsights__InstrumentationKey=$appInsightsKey --restart-policy OnFailure
#az container attach --subscription $sub --resource-group $rg --name $baseName-dataloader

#create data service ACI
az container create --subscription $sub --resource-group $rg --name $baseName-data --image microservicesdiscovery/travel-data-service --dns-name-label $baseName-dataservice --environment-variables DataAccountName=$cosmoAccountName DataAccountPassword=$cosmosPrimaryKey ApplicationInsights__InstrumentationKey=$appInsightsKey --restart-policy OnFailure
dataServiceUri=$(az container show -g $rg -n $baseName-data --query "ipAddress.fqdn" | tr -d '"')

#create itinerary service ACI
az container create --subscription $sub --resource-group $rg --name $baseName-itinerary --image microservicesdiscovery/travel-itinerary-service --dns-name-label $baseName-itineraryservice --environment-variables DataAccountName=$cosmoAccountName DataAccountPassword=$cosmosPrimaryKey ApplicationInsights__InstrumentationKey=$appInsightsKey --restart-policy OnFailure
itineraryServiceUri=$(az container show -g $rg -n $baseName-itinerary --query "ipAddress.fqdn" | tr -d '"')
	
#create and deploy app service container 
az appservice plan create --name asp-discovery --resource-group $rg --is-linux --location $loc --sku S1 --number-of-workers 1 --subscription $sub
az webapp create --subscription $sub --resource-group $rg --name $baseName-web --plan asp-discovery -i microservicesdiscovery/travel-web 
az webapp config appsettings set  --resource-group $rg --subscription $sub --name $baseName-web --settings DataAccountName=$cosmoAccountName DataAccountPassword=$cosmosPrimaryKey ApplicationInsights__InstrumentationKey=$appInsightsKey DataServiceUrl="http://$dataServiceUri/" ItineraryServiceUrl="http://$itineraryServiceUri/"


