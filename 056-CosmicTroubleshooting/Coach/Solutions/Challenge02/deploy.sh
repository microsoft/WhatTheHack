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
  --name "Challenge02-sh" \
  --location $location \
  --template-file "WTHAzureCosmosDB.IaC/main.bicep" \
  --parameters @$parametersfilename \
  --parameters resourceGroupName=$RG_NAME)


originDir=$PWD

echo "Building and publishing solution"
# Build and publish the solution
dotnet publish "WTHAzureCosmosDB.sln" -c "Release" -clp:ErrorsOnly
cd "./WTHAzureCosmosDB.Web/bin/Release/net6.0/publish/"
zip -r deploy.zip *

# Publish the web app to azure and clean up
webAppName=`echo $output | jq -r '.properties.outputs.webAppName.value'`
slotName=`echo $output | jq -r '.properties.parameters.slotName.value'`
suppressOutput=$(az webapp deployment source config-zip -g $RG_NAME -n $webAppName --src "./deploy.zip" --slot $slotName)
rm "./deploy.zip"
cd $originDir

echo "Building and publishing proxy func app solution"
# Build and publish the solution
cd "./WTHAzureCosmosDB.ProxyFuncApp"
dotnet publish "WTHAzureCosmosDB.ProxyFuncApp.csproj" -c "Release" -clp:ErrorsOnly
cd "./bin/Release/net6.0/publish/"
zip -r deploy.zip *

# Publish the web app to azure and clean up
funcProxyAppName=`echo $output | jq -r '.properties.outputs.proxyFuncAppName.value'`
suppressOutput=$(az functionapp deployment source config-zip -g $RG_NAME -n $funcProxyAppName --src "./deploy.zip")
rm "./deploy.zip"
cd $originDir

echo ""
echo ""
echo ""
echosuccess "The deployment has been completed."
echo ""

webUrl=`echo $bicepDeploymentOutputs | jq -r '.webAppHostname.value'`
echo "Website is available on https://$webUrl"