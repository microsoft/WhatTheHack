#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# -e: immediately exit if any command has a non-zero exit status
# -o: prevents errors in a pipeline from being masked
# IFS new value is less likely to cause confusing bugs when looping arrays or arguments (e.g. $@)
#
#HL72FHIR Workf Setup --- Author Steve Ordahl Principal Architect Health Data Platform
#

usage() { echo "Usage: $0 -i <subscriptionId> -g <resourceGroupName> -l <resourceGroupLocation> -p <prefix>" 1>&2; exit 1; }

function fail {
  echo $1 >&2
  exit 1
}

function retry {
  local n=1
  local max=5
  local delay=15
  while true; do
    "$@" && break || {
      if [[ $n -lt $max ]]; then
        ((n++))
        echo "Command failed. Retry Attempt $n/$max in $delay seconds:" >&2
        sleep $delay;
      else
        fail "The command has failed after $n attempts."
      fi
    }
  done
}
declare defsubscriptionId=""
declare subscriptionId=""
declare resourceGroupName=""
declare resourceGroupLocation=""
declare storageAccountNameSuffix="store"$RANDOM
declare storageConnectionString=""
declare evhubnamespaceName="fehub"$RANDOM
declare evhub="fhirevents"
declare evconnectionString=""
declare serviceplanSuffix="asp"
declare faname=fhirevt$RANDOM
declare faresourceid=""
declare fakey=""
declare deployzip="../FHIR/FHIREventProcessor/distribution/publish.zip"
declare deployprefix=""
declare defdeployprefix=""
declare fsurl=""
declare fsclientid=""
declare fssecret=""
declare fstenant=""
declare fsaud=""
declare fsdefaud="https://azurehealthcareapis.com"
declare hl7storename=""
declare hl7rgname=""
declare hl7sbnamespace=""
declare hl7sbqueuename=""
declare hl7storekey=""
declare hl7sbconnection=""
declare hl7convertername="hl7conv"
declare hl7converterrg=""
declare uid=$(uuidgen)
declare hl7convertkey=${uid//-}
declare hl7converterinstance=""
declare stepresult=""
declare fahost=""
# Initialize parameters specified from command line
while getopts ":i:g:n:l:p" arg; do
	case "${arg}" in
		p)
			deployprefix=${OPTARG:0:14}
			deployprefix=${deployprefix,,}
			deployprefix=${deployprefix//[^[:alnum:]]/}
			;;
		i)
			subscriptionId=${OPTARG}
			;;
		g)
			resourceGroupName=${OPTARG}
			;;
		l)
			resourceGroupLocation=${OPTARG}
			;;
		esac
done
shift $((OPTIND-1))
echo "Executing "$0"..."
echo "Checking Azure Authentication..."
#login to azure using your credentials
az account show 1> /dev/null

if [ $? != 0 ];
then
	az login
fi

defsubscriptionId=$(az account show --query "id" --out json | sed 's/"//g') 

#Prompt for parameters is some required parameters are missing
if [[ -z "$subscriptionId" ]]; then
	echo "Enter your subscription ID ["$defsubscriptionId"]:"
	read subscriptionId
	if [ -z "$subscriptionId" ] ; then
		subscriptionId=$defsubscriptionId
	fi
	[[ "${subscriptionId:?}" ]]
fi

if [[ -z "$resourceGroupName" ]]; then
	echo "This script will look for an existing resource group, otherwise a new one will be created "
	echo "You can create new resource groups with the CLI using: az group create "
	echo "Enter a resource group name"
	read resourceGroupName
	[[ "${resourceGroupName:?}" ]]
fi

defdeployprefix=${resourceGroupName:0:14}
defdeployprefix=${defdeployprefix//[^[:alnum:]]/}
defdeployprefix=${defdeployprefix,,}

if [[ -z "$resourceGroupLocation" ]]; then
	echo "If creating a *new* resource group, you need to set a location "
	echo "You can lookup locations with the CLI using: az account list-locations "
	
	echo "Enter resource group location:"
	read resourceGroupLocation
fi
#Prompt for parameters is some required parameters are missing
if [[ -z "$deployprefix" ]]; then
	echo "Enter your deployment prefix ["$defdeployprefix"]:"
	read deployprefix
	if [ -z "$deployprefix" ] ; then
		deployprefix=$defdeployprefix
	fi
	deployprefix=${deployprefix:0:14}
	deployprefix=${deployprefix//[^[:alnum:]]/}
    deployprefix=${deployprefix,,}
	[[ "${deployprefix:?}" ]]
fi
if [ -z "$subscriptionId" ] || [ -z "$resourceGroupName" ]; then
	echo "Either one of subscriptionId, resourceGroupName is empty"
	usage
fi
#Prompt for Converter Resource group to avoid function app conflicts
echo "Enter a resource group name to deploy the converter to ["$deployprefix$hl7convertername"]:"
read hl7converterrg
if [ -z "$hl7converterrg" ] ; then
 	 hl7converterrg=$deployprefix$hl7convertername
fi
if [ "$hl7converterrg" = "$resourceGroupName" ]; then
    echo "The converter resource group cannot be the same as the target resource group"
	exit 1;
fi
if [ -z "$hl7converterrg" ] ; then
 	 hl7converterrg=$deployprefix$hl7convertername
fi
#Prompt for HL7Ingest Storage and Service Bus
echo "Enter the name of the HL7 Ingest Resource Group:"
read hl7rgname
if [ -z "$hl7rgname" ] ; then
	echo "You must provide the name of the resource group that contains the HL7 ingest platform"
	exit 1;
fi
echo "Enter the name of the HL7 Ingest storage account:"
read hl7storename
if [ -z "$hl7storename" ] ; then
	echo "You must provide the name of the storage account of the HL7 ingest platform"
	exit 1;
fi
echo "Enter the name of the HL7 ServiceBus namespace:"
read hl7sbnamespace
if [ -z "$hl7sbnamespace" ] ; then
	echo "You must provide the namespace name of the service bus of the HL7 ingest platform"
	exit 1;
fi
echo "Enter the name of the HL7 ServiceBus destination queue:"
read hl7sbqueuename
if [ -z "$hl7sbqueuename" ] ; then
	echo "You must provide the name of the service bus queue of the HL7 ingest platform"
	exit 1;
fi
#Prompt for FHIR Server Parameters
echo "Enter the destination FHIR Server URL:"
read fsurl
if [ -z "$fsurl" ] ; then
	echo "You must provide a destination FHIR Server URL"
	exit 1;
fi
echo "Enter the FHIR Server Service Client Application ID:"
read fsclientid
if [ -z "$fsclientid" ] ; then
	echo "You must provide a Service Client Application ID"
	exit 1;
fi
echo "Enter the FHIR Server Service Client Secret:"
read fssecret
if [ -z "$fssecret" ] ; then
	echo "You must provide a Service Client Secret"
	exit 1;
fi
echo "Enter the FHIR Server/Service Client Audience/Resource ["$fsdefaud"]:"
	read fsaud
	if [ -z "$fsaud" ] ; then
		fsaud=$fsdefaud
	fi
	[[ "${fsaud:?}" ]]
echo "Enter the FHIR Server/Service Client Tenant ID:"
read fstenant
if [ -z "$fstenant" ] ; then
	echo "You must provide a FHIR Server/Service Client Tenant"
	exit 1;
fi

echo "Setting subscription id and checking resource groups..."
#set the default subscription id
az account set --subscription $subscriptionId

set +e

#Check for existing RG
if [ $(az group exists --name $resourceGroupName) = false ]; then
	echo "Resource group with name" $resourceGroupName "could not be found. Creating new resource group.."
	set -e
	(
		set -x
		az group create --name $resourceGroupName --location $resourceGroupLocation 1> /dev/null
	)
else
	echo "Using existing resource group..."
fi

if [ $(az group exists --name $hl7converterrg) = false ]; then
	echo "Resource group with name" $hl7converterrg "could not be found. Creating new resource group.."
	set -e
	(
		set -x
		az group create --name $hl7converterrg --location $resourceGroupLocation 1> /dev/null
	)
else
	echo "Using existing resource group for converter deployment..."
fi
#Set up variables
faresourceid="/subscriptions/"$subscriptionId"/resourceGroups/"$resourceGroupName"/providers/Microsoft.Web/sites/"$faname
#Start deployment
echo "Starting HL72FHIR Workflow Platform deployment..."
(
		#set -x
		#Create Storage Account
		echo "Creating Storage Account["$deployprefix$storageAccountNameSuffix"]..."
		stepresult=$(az storage account create --name $deployprefix$storageAccountNameSuffix --resource-group $resourceGroupName --location  $resourceGroupLocation --sku Standard_LRS --encryption-services blob --kind StorageV2)
		echo "Retrieving Storage Account Connection String..."
		storageConnectionString=$(az storage account show-connection-string -g $resourceGroupName -n $deployprefix$storageAccountNameSuffix --query "connectionString" --output tsv)
		#Create EventHub Bus Namespace and Hub
		echo "Creating FHIR Event Hub Namespace ["$evhubnamespaceName"]..."
		stepresult=$(az eventhubs namespace create --name $evhubnamespaceName --resource-group $resourceGroupName -l $resourceGroupLocation)
		# Create eventhub for fhirevents
		echo "Creating FHIR Event Hub ["$evhub"]..."
		stepresult=$(az eventhubs eventhub create --name $evhub --resource-group $resourceGroupName --namespace-name $evhubnamespaceName)
		echo "Retrieving Event Hub Connection String..."
		evconnectionString=$(az eventhubs namespace authorization-rule keys list --resource-group $resourceGroupName --namespace-name $evhubnamespaceName --name RootManageSharedAccessKey --query primaryConnectionString --output tsv)
		#Create FHIREventProcessor Function App
		#Create Service Plan
		echo "Creating FHIREventProcessor Function App Service Plan["$deployprefix$serviceplanSuffix"]..."
		stepresult=$(az appservice plan create -g  $resourceGroupName -n $deployprefix$serviceplanSuffix --number-of-workers 2 --sku B1)
		#Create the Function App
		echo "Creating FHIREventProcessor Function App ["$faname"]..."
		fahost=$(az functionapp create --name $faname --storage-account $deployprefix$storageAccountNameSuffix  --plan $deployprefix$serviceplanSuffix  --resource-group $resourceGroupName --runtime dotnet --os-type Windows --functions-version 2 --query defaultHostName --output tsv)
		#Add App Settings
		echo "Configuring FHIREventProcessor Function App ["$faname"]..."
		stepresult=$(az functionapp config appsettings set --name $faname  --resource-group $resourceGroupName --settings FS_URL=$fsurl FS_TENANT_NAME=$fstenant FS_CLIENT_ID=$fsclientid FS_SECRET=$fssecret FS_RESOURCE=$fsaud EventHubConnection=$evconnectionString EventHubName=$evhub)
		echo "Deploying FHIREventProcessor Function App from repo to host ["$fahost"]..."
		#deployment from git repo
		stepresult=$(retry az functionapp deployment source config-zip --name $faname --resource-group $resourceGroupName --src $deployzip)
		#Deploy HL7 FHIR Converter
		hl7converterinstance=$deployprefix$hl7convertername$RANDOM
		echo "Deploying FHIR Converter ["$hl7converterinstance"] to resource group ["$hl7converterrg"]..."
		stepresult=$(az group deployment create -g $hl7converterrg --template-uri https://raw.githubusercontent.com/microsoft/FHIR-Converter/master/deploy/default-azuredeploy.json --parameters serviceName=$hl7converterinstance --parameters apiKey=$hl7convertkey)
		echo "Deploying Custom Logic App Connector for FHIR Server..."
		stepresult=$(az group deployment create -g $resourceGroupName --template-file hl7tofhir/LogicAppCustomConnectors/fhir_server_connect_template.json  --parameters fhirserverproxyhost=$faname".azurewebsites.net")
		echo "Deploying Custom Logic App Connector for FHIR Converter..."
		stepresult=$(az group deployment create -g $resourceGroupName --template-file hl7tofhir/LogicAppCustomConnectors/fhir_converter_connect_template.json  --parameters fhirconverterhost=$hl7converterinstance".azurewebsites.net")
		echo "Loading HL7 Ingest connections/keys..."
		hl7storekey=$(az storage account keys list -g $hl7rgname -n $hl7storename --query "[?keyName=='key1'].value" --output tsv)
		hl7sbconnection=$(az servicebus namespace authorization-rule keys list --resource-group $hl7rgname --namespace-name $hl7sbnamespace --name RootManageSharedAccessKey --query primaryConnectionString --output tsv)
		echo "Loading FHIREventProcessor Function Keys..."
		fakey=$(retry az rest --method post --uri "https://management.azure.com"$faresourceid"/host/default/listKeys?api-version=2018-02-01" --query "functionKeys.default" --output tsv)
		echo "Deploying HL72FHIR Logic App..."
		stepresult=$(az group deployment create -g $resourceGroupName --template-file hl7tofhir/hl72fhir.json  --parameters HL7FHIRConverter_1_api_key=$hl7convertkey azureblob_1_accountName=$hl7storename azureblob_1_accessKey=$hl7storekey FHIRServerProxy_1_api_key=$fakey servicebus_1_connectionString=$hl7sbconnection servicebus_1_queue=$hl7sbqueuename)
		echo " "
		echo "************************************************************************************************************"
		echo "HL72FHIR Workflow Platform has successfully been deployed to group "$resourceGroupName" on "$(date)
		echo "Please note the following reference information for future use:"
		echo "Your FHIR EventHub namespace is: "$evhubnamespaceName
		echo "Your FHIR EventHub name is: "$evhub
		echo "Your HL7 FHIR Converter Host is: "$hl7converterinstance
		echo "Your HL7 FHIR Converter Key is: "$hl7convertkey
		echo "Your HL7 FHIR Converter Resource Group is: "$hl7converterrg
		echo "************************************************************************************************************"
		echo " "
)
	
if [ $?  == 0 ];
 then
	echo "HL72FHIR Workflow Platform has successfully been deployed"
fi
