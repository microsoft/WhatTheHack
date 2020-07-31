# Install Docker and Docker-Compose

First, go to the [Azure Cloud Shell](https://shell.azure.com), sign in and follow the setup steps for "Bash (Linux)"

## Select the proper Azure Subscription you would like to work with:
```
az account list -o table
az account set --subscription <subscription-id>
```

## Create the Docker Host Azure VM

Run the script below to set up your Docker Host in VM. 

Important Notes:

* The value assigned to `RG` should be in lowercase without special characters, just [a-z] and/or [0-9].
* The `az vm create` command has this parameter `--custom-data` which requires a file called `docker.yaml` - you can find this file here: [docker.yaml](../../../Resources/Code/docker.yaml). 
     * You will need to run the `az vm create` command in the directory where `docker.yaml` exists **or** update the path to the `docker.yaml` file.
     * `--custom-data` uses Cloud-init which is a widely used approach for customizing Linux VMs as they boot for the first time. Learn more about [Azure and Cloud-init](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/using-cloud-init).
* This script creates a Resoure Group for you, a Network Security Group, a VNet, a Public IP Address, the VM and it supporting resources (hard disk, nic).
* Remember, you are running this inside Azure Cloud Shell!
* Don't change the `--admin-username` value. 

```
RG=<your resource group>
NSG=dockerhostnsg
VM=dockerhostvm
az group create -n $RG -l eastus
az network nsg create -g $RG -n $NSG
az network nsg rule create -g $RG --nsg-name $NSG -n http --priority 1000 --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' --destination-port-ranges 80 --access Allow --protocol Tcp --description "http"
az network nsg rule create -g $RG --nsg-name $NSG -n docker --priority 1010 --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' --destination-port-ranges 2375-2376 --access Allow --protocol Tcp --description "docker"
az network nsg rule create -g $RG --nsg-name $NSG -n ssh --priority 1020 --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' --destination-port-ranges 22 --access Allow --protocol Tcp --description "ssh"
az vm create -n $VM -g $RG --image Canonical:UbuntuServer:18.04-LTS:latest --nsg $NSG --admin-username dockeradmin --admin-password d0cker@dminzz --authentication-type password --custom-data docker.yaml 
```

Once this is done successfully, run the following inside Azure Cloud Shell. This will wire up the Docker Client in Azure Cloud Shell to talk to the VM in Azure. **Note** that you will need to update the script below with the actual IP Address for your server (you should see that in the output of the `az vm create` command you just ran).

```
export DOCKER_HOST=tcp://<vm-ip>:2375/
export DOCKER_TLS_VERIFY=
export DOCKER_CERT_PATH=
```

Validate your docker host VM is properly provisioned and ready to use.
```
docker images
docker ps
```
Notice that you are using the local docker client inside the Azure Cloud Shel and it is connecting and running commands on your VM in Azure! 

**IMPORTANT NOTE**

*We are exposing our Docker Host with Port 2375 and without any secrets or certificates. This is very unsafe and should ONLY be used for a lab challenge like this. Anyone that has access to your IP address can control Docker on your VM (essentially giving them root access). In real dev/test and production scenarios, you will connect with certificates over port 2376.*


## Install docker-compose in your Azure Cloud Shell
```
mkdir tools
curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o $HOME/tools/docker-compose
chmod +x $HOME/tools/docker-compose
echo "export PATH=$PATH:$HOME/tools" >> ~/.bashrc
source ~/.bashrc
docker-compose --version
```
