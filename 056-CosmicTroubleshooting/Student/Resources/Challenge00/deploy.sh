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
  --name "Challenge00-sh" \
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
suppressOutput=$(az webapp deployment source config-zip -g $RG_NAME -n $webAppName --src "./deploy.zip")
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



cd  "./WTHAzureCosmosDB.Console"

# Seed the database
if [ $SEED_DATABASE == 1 ]; then
        echo "Seeding the Azure Cosmos DB database with data"
        dotnet run /seedProducts /connString `echo $output | jq -r '.properties.outputs.cosmosDbConnectionString.value'` -clp:ErrorsOnly
    fi

bicepDeploymentOutputs=`echo $output | jq -r '.properties.outputs'`

cd ..


# Set up load testing service

echo "Setting up a load testing service..."

loadtestingId=`echo $output | jq -r '.properties.outputs.loadtestingId.value'`
loadTestFilename=`echo $output | jq -r '.properties.outputs.loadTestingNewTestFileId.value'`
loadTestNewTestId=`echo $output | jq -r '.properties.outputs.loadTestingNewTestId.value'`
loadTestDataPlaneUrl=`echo $output | jq -r '.properties.outputs.loadTestingDataPlaneUri.value'`
loadTestingTestEndpoint="https://$loadTestDataPlaneUrl/loadtests/$loadTestNewTestId"


tokenResourceUrl="https://loadtest.azure-dev.com"

azToken=`az account get-access-token --resource $tokenResourceUrl`

# As first we create a test

authContent="`echo $azToken | jq -r '.tokenType'` `echo $azToken | jq -r '.accessToken'`";

payload="{
    'description': 'A test to simulate load to eshop',
    'displayName': 'Eshop users load',
    'environmentVariables': {},
    'resourceId': '$loadtestingId',
    'secrets': {},
    'subnet': null,
    'keyvaultReferenceIdentityId': null,
    'keyvaultReferenceIdentityType': 'SystemAssigned',
    'loadTestConfig': {
        'engineInstances': 4,
        'splitAllCSVs': false
    },
    'passFailCriteria': {
        'passFailMetrics': {}
    },
    'testId': '$loadTestNewTestId'
}";

output=`curlwithcode -X 'PATCH' \
    -H 'Content-Type: application/merge-patch+json' \
    -H 'Accept: application/json' \
    -H "Authorization: $authContent" \
    -d "$payload" \
    ''$loadTestingTestEndpoint'?api-version=2022-06-01-preview' 2>/dev/null`

statusCode=`echo $output | jq -r '.statusCode'`

if [ $statusCode -ne 200 ] && [ $statusCode -ne 201 ]; then
    echoerr "Azure Load Testing dataplane returned different status code (${statusCode}, was expecting 200 or 201) for test creation.\n${output}";
    exit 1;
fi



# next is uploading a file
loadTestingTestFilesEndpoint=$loadTestingTestEndpoint"/files/"$loadTestFilename"?fileType=0&api-version=2022-06-01-preview"
if [ $SHOW_DEBUG_OUTPUT == 1 ]; then
    echo "Load testing files endpoing: "
    echo $loadTestingTestFilesEndpoint
fi

output=`curlwithcode -X "PUT" \
    -H "Authorization: $authContent" \
    -F 'file=@./WTHAzureCosmosDB.IaC/simulate-load-eshop.jmx' $loadTestingTestFilesEndpoint 2>/dev/null`
    statusCode=`echo $output | jq -r '.statusCode'`

if [ $statusCode -ne 200 ] && [ $statusCode -ne 201 ]; then
    echoerr "Azure Load Testing dataplane returned different status code (${statusCode}, was expecting 200 or 201) for test plan upload.\n${output}";
    exit 1;
fi



# waiting for test validation
echo "Waiting for test plan validation by Azure..."

runtime="2 minute"
endtime=$(date -ud "$runtime" +%s)

testPlanStatus="VALIDATION_INITIATED";

while [[ $(date -u +%s) -le $endtime ]]; do
    azTokenExpiresOn=`echo $azToken | jq -r '.expiresOn'`
    
    dateExpiresOn=`date  '+%s' --date "$azTokenExpiresOn"`
    now=`date  '+%s'`

    if [ $dateExpiresOn -le $now ]; then
        echo "Refreshing access token..."
        azToken=`az account get-access-token --resource $tokenResourceUrl`
        authContent="`echo $azToken | jq -r '.tokenType'` `echo $azToken | jq -r '.accessToken'`"
    fi


    output=`curlwithcode -X 'GET' \
    -H 'Accept: application/json' \
    -H "Authorization: $authContent" \
    "${loadTestingTestEndpoint}?api-version=2022-06-01-preview" 2>/dev/null `


    statusCode=`echo $output | jq -r '.statusCode'`

    if [ $statusCode -ne 200 ] && [ $statusCode -ne 201 ]; then
        echoerr "Azure Load Testing dataplane returned different status code (${statusCode}, was expecting 200) during gathering test plan status.\n${output}";
        exit 1;
    fi

    state=`echo $output | jq -r '.body' | jq -r '.inputArtifacts.testScriptUrl.validationStatus'`
    echo "checking for updates... $state"
    
    if [ "$state" == "" ]; then
        echo "Empty validation status - skipping"
        continue;
    fi
    
    if [ "$state" == "VALIDATION_SUCCESS" ]; then
        testPlanStatus="VALIDATION_SUCCESS"
        break
    fi
  
    sleep 10

done

if [ "$testPlanStatus" != "VALIDATION_SUCCESS" ]  && [ "$testPlanStatus" == "VALIDATION_INITIATED" ]; then
    echoerr "Azure Load Testing JMX test plan validation timeout-ed!"
elif [ "$testPlanStatus" != "VALIDATION_SUCCESS" ] && [ "$testPlanStatus" != "VALIDATION_INITIATED" ]; then
    echoerr "Azure Load Testing JMX test plan validation failed!"
else
    # ok
    echosuccess "Azure Load Testing JMX test plan validation completed."
fi

echo ""
echo ""
echo ""
echosuccess "The deployment has been completed."
echo ""

webUrl=`echo $bicepDeploymentOutputs | jq -r '.webAppHostname.value'`
echo "Website is available on https://$webUrl"
