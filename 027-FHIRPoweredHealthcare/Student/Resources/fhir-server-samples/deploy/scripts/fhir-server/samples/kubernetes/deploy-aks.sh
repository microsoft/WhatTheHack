#!/bin/bash

set -eE -o functrace

failure() {
  local lineno=$1
  local msg=$2
  echo -e "\033[31mScript failed at $lineno: ${msg}\e[0m"
}

trap 'failure ${LINENO} "$BASH_COMMAND"' ERR

usage() {
    echo "deploy-aks.sh  --name <name>"
    echo "              [--resource-group-name <group name>]"
    echo "              [--location <location>]"
    echo "              [--max-nodes <default 5> ]"
    echo "              [--vm-size <default Standard_DS2_v2>]"
    echo "              [--help]"
}

# Checking if we have the tools we need to run this script
command -v jq >/dev/null 2>&1 || { echo >&2 "'jq' is required but not installed. Aborting."; exit 1; }
command -v helm >/dev/null 2>&1 || { echo >&2 "'helm' (version 3) is required but not installed. Aborting."; exit 1; }
command -v az >/dev/null 2>&1 || { echo >&2 "'az' (Azure CLI) is required but not installed. Aborting."; exit 1; }
command -v kubectl >/dev/null 2>&1 || { echo >&2 "'kubectl' is required but not installed. Aborting."; exit 1; }

# Settings
location="westus2"
maxNodes=5
vmSize="Standard_DS2_v2"
clusterName=""
resourceGroupName=""

# Parse command line arguments
while [ "$1" != "" ]; do
    case $1 in
        -n | --name )                               shift
                                                    clusterName=$1
                                                    ;;
        -g | --resource-group-name )                shift
                                                    resourceGroupName=$1
                                                    ;;
        -l | --location )                           shift
                                                    location=$1
                                                    ;;
        -m | --max-nodes )                          shift
                                                    maxNodes=$1
                                                    ;;
        -v | --vm-size )                            shift
                                                    vmSize=$1
                                                    ;;
        -h | --help )                               usage
                                                    exit
                                                    ;;
        * )                                         usage
                                                    exit 1
    esac
    shift
done

if [ -z "$clusterName" ]; then
    echo "Please provide a cluster name"
    usage
    exit 1
fi

if [ -z "$resourceGroupName" ]; then
    resourceGroupName="$clusterName"
fi

keyvaultName="${clusterName}"

# First create a resource group
az group create --name $resourceGroupName --location $location

# Create a keyvault
az keyvault create -n $keyvaultName -g $resourceGroupName --enable-soft-delete true

sshKeyFile=~/.ssh/${name}_rsa
setKeyVaultSshSecrets=false
sshPrivateKey=`az keyvault secret show --vault-name $keyvaultName --name ssh-private-key 2> /dev/null || true`

if [ -n "$sshPrivateKey" ]; then
    echo $sshPrivateKey | jq -r .value > $sshKeyFile
else
    setKeyVaultSshSecrets=true
fi

sshPublicKey=`az keyvault secret show --vault-name $keyvaultName --name ssh-public-key 2> /dev/null || true`
if [ -n "$sshPublicKey" ]; then
    echo $sshPublicKey | jq -r .value > ${sshKeyFile}.pub
else
    setKeyVaultSshSecrets=true
fi

if [ ! -f $sshKeyFile ]; then
    ssh-keygen -f $sshKeyFile -t rsa -N ''
    setKeyVaultSshSecrets=true
fi

if [ "$setKeyVaultSshSecrets" = true ]; then
    az keyvault secret set --name "ssh-private-key" --vault-name $keyvaultName --file $sshKeyFile > /dev/null
    az keyvault secret set --name "ssh-public-key" --vault-name $keyvaultName --file ${sshKeyFile}.pub > /dev/null
fi

#We need to know if the cluster is already there:
clusterFound=`az aks list --query "[?(name=='${clusterName}'&&resourceGroup=='${resourceGroupName}')]" | jq '. | length'`

if [ $clusterFound -eq 0 ]
then
    # There is a problem with the automatic SP creation in az aks create, so we will make the SP first
    # https://github.com/Azure/azure-cli/issues/9585

    # First let's see if we have it service principal already
    spId=""
    spPass=""

    clientIdKeyvaultSecret=`az keyvault secret show --vault-name $keyvaultName --name service-principal-client-id 2> /dev/null || true`
    clientSecretKeyvaultSecret=`az keyvault secret show --vault-name $keyvaultName --name service-principal-client-secret 2> /dev/null || true`

    if [ -n "$clientIdKeyvaultSecret" ] && [ -n "$clientSecretKeyvaultSecret" ]; then
        spId=`echo $clientIdKeyvaultSecret | jq -r .value`
        spPass=`echo $clientSecretKeyvaultSecret | jq -r .value`
    else
        subscription=$(az account show | jq -r .id)
        sp=$(az ad sp create-for-rbac --scope /subscriptions/${subscription}/resourceGroups/${resourceGroupName} --role Contributor --output json)
        spId=$(echo $sp | jq -r '.appId')
        spPass=$(echo $sp | jq -r '.password')

        az keyvault secret set --name "service-principal-client-id" --vault-name $keyvaultName --value $spId
        az keyvault secret set --name "service-principal-client-secret" --vault-name $keyvaultName --value $spPass

        sleep 30 # This is necessary make sure the service principal is available for the AKS deployment.
    fi

    az aks create \
        --resource-group $resourceGroupName \
        --name $clusterName \
        --node-count 1 \
        --node-vm-size $vmSize \
        --vm-set-type VirtualMachineScaleSets \
        --load-balancer-sku standard \
        --enable-cluster-autoscaler \
        --min-count 1 \
        --max-count $maxNodes \
        --service-principal $spId \
        --client-secret $spPass \
        --ssh-key-value ${sshKeyFile}.pub \
        --kubernetes-version 1.18.2
else
    az aks update \
        --resource-group $resourceGroupName \
        --name $clusterName \
        --update-cluster-autoscaler \
        --min-count 1 \
        --max-count $maxNodes
fi

# Get credentials for kubectl
az aks get-credentials --name $clusterName --resource-group $resourceGroupName

# Add the official stable repository
helm repo add stable https://kubernetes-charts.storage.googleapis.com/

# Install nginx
foundIngressControllerNamespace=`kubectl get namespace -o json | jq '.items[] | select(.metadata.name == "ingress-controller")'`
if [ -z "$foundIngressControllerNamespace" ]; then
    kubectl create namespace ingress-controller
fi

# The specification of linux nodes here is not really necessary since that is all we have
# but if we add Windows nodes in the future, we will want to make sure nginx is on Linux
helm upgrade --install nginx-ingress stable/nginx-ingress \
    --namespace ingress-controller \
    --set controller.replicaCount=2 \
    --set controller.nodeSelector."kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."kubernetes\.io/os"=linux

# Set up cert-manager
foundCertManagerNamespace=`kubectl get namespace -o json | jq '.items[] | select(.metadata.name == "cert-manager")'`

if [ -z "$foundCertManagerNamespace" ]; then
    kubectl create namespace cert-manager
    kubectl label namespace cert-manager cert-manager.io/disable-validation=true
    kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.12.0/cert-manager.yaml

    # wait for deployments to complete
    for i in $(kubectl get deployment --namespace cert-manager -o json | jq -r .items[].metadata.name); do
        kubectl rollout status deployment $i --namespace cert-manager
    done
fi


# Set up Azure Service Operators
accountDetails=$(az account show)

# We need to get these details back out of the KV incase this is a re-deployment
clientIdKeyvaultSecret=`az keyvault secret show --vault-name $keyvaultName --name service-principal-client-id 2> /dev/null || true`
clientSecretKeyvaultSecret=`az keyvault secret show --vault-name $keyvaultName --name service-principal-client-secret 2> /dev/null || true`
spId=`echo $clientIdKeyvaultSecret | jq -r .value`
spPass=`echo $clientSecretKeyvaultSecret | jq -r .value`

# Create location to manage helm chart for ASO
rm -rf install-aso
mkdir -p install-aso

export HELM_EXPERIMENTAL_OCI=1
helm chart pull mcr.microsoft.com/k8s/asohelmchart:latest
helm chart export mcr.microsoft.com/k8s/asohelmchart:latest --destination install-aso/

helm upgrade --install aso ./install-aso/azure-service-operator -n azureoperator-system --create-namespace  \
    --set azureSubscriptionID=$(echo $accountDetails | jq -r .id) \
    --set azureTenantID=$(echo $accountDetails | jq -r .tenantId) \
    --set azureClientID=$spId \
    --set azureClientSecret=$spPass \
    --set createNamespace=true \
    --set image.repository="mcr.microsoft.com/k8s/azureserviceoperator:latest"


# Install Pod Identities (needed for export)
# see https://github.com/Azure/aad-pod-identity for details
helm repo add aad-pod-identity https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts
helm install aad-pod-identity aad-pod-identity/aad-pod-identity

