#!/bin/sh

ts=$(date +"%Y%m%dT%H%M%S")
echo $ts

for value in westus2 centralus southindia australiaeast westeurope eastus2
do
    for index in 1 2
    do
       echo Start Run in $value-$index
       az container delete -g rg-contosoMasks --name contosomasks-loadtest-$value-$index --yes > /dev/null
       az container create -g rg-contosoMasks --image andywahr/contosomasks-loadtest:latest --cpu 2 --memory 4 --assign-identity /subscriptions/84bcbb63-5ce7-47d6-9481-0ddd39d8d250/resourceGroups/rg-contosoMasks/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uami-contosomasks --restart-policy OnFailure --no-wait --name contosomasks-loadtest-$value-$index --location $value -e  AZURE_STORAGE_ACCOUNT=storageaccountrgcon89f8 REGION=$value-$ts-$index WebSiteURL=$1 CDN=$2
    done
done
