First of all, go to the [Azure Cloud Shell](https://shell.azure.com), sign in and follow the setup steps for "Bash (Linux)"

## Select the proper Azure Subscription you would like to work with:
```
az account list -o table
az account set --subscription <subscription-id>
```

## Create a docker-machine

The following variables will be used within the scope of the commands illustrated below:
```
RG=<your-resource-group-name-in-lowercase>
VM=<your-docker-machine-name-in-lowercase>
LOC=eastus
SUB_ID=<your-subscription-id>
```

*Important note: `RG` and `VM` should be in lowercase without special characters, just [a-z] and/or [0-9].*

Create a resource group where you will provision your docker-machine:
```
az group create --name $RG --location $LOC
```

Create the Azure Docker machine:
```
docker-machine create \
    --driver azure \
    --azure-subscription-id $SUB_ID \
    --azure-image  "Canonical:UbuntuServer:16.04-LTS:latest" \
    --azure-size "Standard_DS2_v2" \
    --azure-resource-group $RG \
    --azure-open-port 80 \
    --azure-location $LOC \
    $VM
```

Make available your docker-machine from within your Azure Cloud Shell session:
```
echo "eval $(docker-machine env $VM --shell bash)" >> ~/.bashrc
source ~/.bashrc
```

Validate your docker-machine is properly provisioned and ready to use:
```
docker-machine ls
docker images
docker ps
```

## Install docker-compose in your Azure Cloud Shell
```
mkdir tools
curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o $HOME/tools/docker-compose
chmod +x $HOME/tools/docker-compose
echo "export PATH=$PATH:$HOME/tools" >> ~/.bashrc
source ~/.bashrc
docker-compose --version
```