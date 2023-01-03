#!/bin/bash

RG_NAME=${1:-rg-wth-azurecosmosdb}
SEED_DATABASE=1
SHOW_DEBUG_OUTPUT=false

escape_quotes(){
    echo $@ | sed s/'"'/'\\"'/g
}


curlwithcode() {
    code=0
    # Run curl in a separate command, capturing output of -w "%{http_code}" into statuscode
    # and sending the content to a file with -o >(cat >/tmp/curl_body)
    statuscode=$(curl -w "%{http_code}" \
        -o >(cat >/tmp/curl_body) \
        "$@"
    ) || code="$?"

    body="$(cat /tmp/curl_body)"
    echo "{\"statusCode\": $statuscode,"
    echo "\"exitCode\": $code,"
    echo "\"body\": \"$(escape_quotes $body)\"}"
}

echoerr() { printf "\033[0;31m%s\n\033[0m" "$*" >&2; }
echosuccess() { printf "\033[0;32m%s\n\033[0m" "$*" >&2; }


# Read the bicep parameters
parametersfilename='./WTHAzureCosmosDB.IaC/main.parameters.json'

echo "Please enter a resource group name (Hit enter to accept 'rg-wth-azurecosmosdb' as the default value):"
read rgname

if ! [ -z "$rgname" ]
then
    RG_NAME=$rgname
fi

echo "Deploying infrastructure"

location=`jq -r ".parameters.location.value" $parametersfilename`

# Deploy our infrastructure
output=$(az deployment sub create \
  --name "Challenge04-sh" \
  --location $location \
  --template-file "WTHAzureCosmosDB.IaC/main.bicep" \
  --parameters @$parametersfilename \
  --parameters resourceGroupName=$RG_NAME)