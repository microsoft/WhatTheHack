#!/bin/bash

FHIRSERVICENAME=""
AUDIENCE=""
WEBAPPSUFFIX="azurewebsites.net"

usage ()
{
  echo "Usage: "
  echo "  $0 -s <name service name> | -a <fhir server audience>"
  echo "     [-w <web app suffix>]"
  exit
}

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -s|--service-name)
    FHIRSERVICENAME="$2"
    shift # past argument
    shift # past value
    ;;
    -a|--audience)
    AUDIENCE="$2"
    shift # past argument
    shift # past value
    ;;
    -w|--web-app-suffix)
    WEBAPPSUFFIX="$2"
    shift # past argument
    shift # past value
    ;;
    -h|--help)
    usage
    ;;
    *)    # unknown option
    echo "Unknown argument $1"
    usage
    ;;
esac
done

command -v jq >/dev/null 2>&1 || { echo >&2 "This script requires 'jq' to be installed."; exit 1; }

[ -z $FHIRSERVICENAME ] && [ -z $AUDIENCE ] && echo "Please provide FHIR Service name or Audience" && usage

if [[ -z $AUDIENCE ]]; then
    AUDIENCE="https://${FHIRSERVICENAME}.${WEBAPPSUFFIX}"
fi

context=$(az account show)
if [[ $? -ne 0 ]]; then
    echo "Please log in with 'az login' and set an account with 'az account set'"
    exit 1
fi

#Create the app registration for the FHIR API:
apiAppReg=$(az ad app create --display-name ${AUDIENCE} --identifier-uris ${AUDIENCE})
apiAppId=$(echo $apiAppReg | jq -r .appId)
sp=$(az ad sp create --id ${apiAppId})
aadTenantId=$(echo $context | jq -r .tenantId)
environmentName=$(echo $context | jq -r .environmentName)
aadEndpoint=$(az cloud show --name $environmentName | jq -r .endpoints.activeDirectory)

#Return summary information
cat << EOF
{ 
    "AppId": "$apiAppId", 
    "TenantId": "$aadTenantId",
    "Authority": "${aadEndpoint}/${aadTenantId}",
    "Audience": "${AUDIENCE}"
}
EOF
