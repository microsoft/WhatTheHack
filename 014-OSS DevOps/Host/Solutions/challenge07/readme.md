#Create a Jenkins Container in ACI

##Create the Resource Group
```shell
az group create --name myJenKinsRG --location westus2
```

## Create the Container Instance
```shell
az container create --resource-group myJenKinsRG --name myjenkins --image registry.hub.docker.com/jenkins/jenkins --dns-name-label jenkins-aci-demo --ports 8080 50000 --verbose
```

## Get the public FQDN
```
az container show --resource-group myJenKinsRG --name myjenkins --query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" --out table
```

## Get the Logs of the Container
```
az container logs --resource-group myJenKinsRG --name myjenkins
```

## Execute a command inside of the container
```
az container exec -g myJenKinsRG --name myjenkins --exec-command "/bin/bash wget https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip"
```
