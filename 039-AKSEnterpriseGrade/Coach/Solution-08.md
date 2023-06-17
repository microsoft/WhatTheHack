# Challenge 08 - Arc-Enabled Kubernetes and Arc-Enabled Data Services - Coach's Guide 

[< Previous Solution](./Solution-07.md) - **[Home](./README.md)**

## Notes and Guidance

- Participants can choose multiple options to deploy their own non-AKS cluster, the one documented here is using aks-engine.
- Using gitops, consider not exposing secrets in the repo as something optional. Alternatives to fix this are Sealed Secrets or Azure Key Vault integration
- You can choose whether focusing more on deploying different Arc extensions on the cluster (APIM, App Services, etc), or move on to the Arc-enabled Data Services part 
- For Arc-enabled Data Services, participants need to decide whether implementing direct or indirect connectivity mode. Depending on the mode, tooling will be different. For example, direct connectivity mode supports only portal deployment at the time of this writing. 

## Solution Guide

This guide includes a couple of different options participants may choose for this challenge. If you have experienced participants that know one of the ways, you can steer them in the other directions to increase their learning curve:

- To create the cluster you can use either kubeadm or aks-engine. aks-engine will soon be deprecated in favor of CAPI, the latter is not documented in this guide
- To deploy Arc-enabled data services, there are essentially the options for **direct** and **indirect** connectivity, plus support for different tooling (portal, VScode, CLI, etc). This guide focuses on indirect mode, since at the time of this writing it is the only method providing end-to-end support for CLI. However, some direct code is documented too in the relevant sections.

### Create non-managed Kubernetes cluster with kubeadm

The overall flow is creating a VM in Azure, and install kubeadm tooling to configure it as single-node cluster. Additional worker nodes can be added, but that is not contemplated in this guide. This method is probably good enough for Arc-enabled k8s, but you will need to beef the VM up substantially (or add worker nodes) to support the heavier Arc-enabled data workloads.

```bash
# Variables
rg=aksengine
location=westeurope
vnet_name=k8snet
vnet_prefix=172.10.0.0/16
subnet_name=k8s
subnet_prefix=172.10.1.0/24
master_vm_name=kubemaster
master_vm_size=Standard_DS3_v2
master_disk_size=10
pod_cidr=192.168.0.0/16

# Create a resource group, VNet and VM
az group create -n $rg -l $location
az network vnet create --name $vnet_name --resource-group $rg --location $location \
  --address-prefixes $vnet_prefix --subnet-name $subnet_name --subnet-prefixes $subnet_prefix
subnet_id=$(az network vnet subnet show -n $subnet_name --vnet-name $vnet_name -g $rg --query id -o tsv) && echo $subnet_id
az vm create -n $master_vm_name -g $rg -l $location \
  --image UbuntuLTS --generate-ssh-keys \
  --size $master_vm_size --data-disk-sizes-gb $master_disk_size \
  --public-ip-address "${master_vm_name}-pip" --subnet $subnet_id

# Create script to stand up cluster
prepare_cluster_file=/tmp/prepare-cluster-node.sh
cat <<REALEND > $prepare_cluster_file
#!/bin/bash
echo "Installing Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io

echo "Configuring Docker..."

sudo cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo systemctl daemon-reload
sudo systemctl restart docker

echo "Installing Kubernetes components..."

sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add 
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update && sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
REALEND

# Run script
master_pip=$(az network public-ip show -n "${master_vm_name}-pip" -g $rg --query ipAddress -o tsv) && echo $master_pip 
user=$(ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $master_pip "whoami") && echo $user
scp $prepare_cluster_file "${master_pip}:/home/${user}/prepare_cluster.sh"
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $master_pip "bash ./prepare_cluster.sh"

# Initiate the kubernetes cluster. Update the placeholders for fqdns and public IP
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $master_pip "sudo kubeadm init --pod-network-cidr=$pod_cidr --apiserver-cert-extra-sans $master_pip"

# Copy/paste the token and CA cert hash and store it in variables for later (if you want to add nodes)
token=<copy/paste token here from previous output>
ca_cert_hash=<copy/paste CA cert hash here from previous output>

# Copy the kubeconfig file to .kube folder for kubectl access on the VM
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $master_pip "mkdir -p $HOME/.kube"
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $master_pip "sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config"
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $master_pip "sudo chown $(id -u):$(id -g) $HOME/.kube/config"

# Install the network plugin
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $master_pip "kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml"

# Remove the master taint as we are currently using a single node cluster
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $master_pip "kubectl taint nodes --all node-role.kubernetes.io/master-"
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $master_pip "cat $HOME/.kube/config"

# Use cluster
ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no $master_pip "kubectl get node"
```

Cleanup the environment when you are ready:

```bash
# Delete RG !!!DANGER!!!
az group delete -n $rg -y --no-wait
```

### Create non-managed Kubernetes cluster with AKS engine

This method uses aks-engine to stand up a non-managed Kubernetes cluster in Azure. aks-engine will be deprecated in favor of CAPI, but it is still a fairly easy way of standing up non-AKS, multi-node clusters in Azure.

Let's start with installing aks-engine if required:

```bash
# Install AKS engine
# Go here: https://github.com/Azure/aks-engine/releases/latest
# Example with v0.61.0:
aksengine_exec=$(which aks-engine 2>/dev/null)
if [[ "$aksengine_exec" == "aks-engine not found" ]]
then
    echo "Downloading and installing aks-engine executable..."
    aksengine_tmp=/tmp/aksengine.tar.gz
    wget https://github.com/Azure/aks-engine/releases/download/v0.61.0/aks-engine-v0.61.0-linux-amd64.tar.gz -O $aksengine_tmp
    tar xfvz $aksengine_tmp -C /tmp/
    sudo cp /tmp/aks-engine-v0.61.0-linux-amd64/aks-engine /usr/local/bin
else
    echo "aks-engine executable found in ${aksengine_exec}"
fi
```

Create an AKS engine cluster:

```bash
# Variables
rg=aksengine
location=westeurope
az group create -n $rg -l $location

# Retrieve Service Principal form your Azure Key Vault, required for AKS engine or CAPI
keyvault_name=<your_akv_name>
purpose=aksengine
keyvault_appid_secret_name=$purpose-sp-appid
keyvault_password_secret_name=$purpose-sp-secret
keyvault_appid_secret_name=$purpose-sp-appid
keyvault_password_secret_name=$purpose-sp-secret
sp_app_id=$(az keyvault secret show --vault-name $keyvault_name -n $keyvault_appid_secret_name --query 'value' -o tsv 2>/dev/null)
sp_app_secret=$(az keyvault secret show --vault-name $keyvault_name -n $keyvault_password_secret_name --query 'value' -o tsv 2>/dev/null)

# If they could not be retrieved, generate new ones
if [[ -z "$sp_app_id" ]] || [[ -z "$sp_app_secret" ]]
then
    echo "No SP for AKS-engine could be found in AKV $keyvault_name, generating new ones..."
    sp_name=$purpose
    sp_output=$(az ad sp create-for-rbac --name $sp_name --skip-assignment 2>/dev/null)
    sp_app_id=$(echo $sp_output | jq -r '.appId')
    sp_app_secret=$(echo $sp_output | jq -r '.password')
    # Store the created app ID and secret in an AKV
    az keyvault secret set --vault-name $keyvault_name -n $keyvault_appid_secret_name --value $sp_app_id
    az keyvault secret set --vault-name $keyvault_name -n $keyvault_password_secret_name --value $sp_app_secret
else
    echo "Service Principal $sp_app_id and secret successfully retrieved from AKV $keyvault_name"
fi

# Grant access to the SP to the new RG
scope=$(az group show -n $rg --query id -o tsv)
assignee=$(az ad sp show --id $sp_app_id --query objectId -o tsv)
az role assignment create --scope $scope --role Contributor --assignee $assignee

# Retrieve example JSON file describing a basic cluster
# url=https://raw.githubusercontent.com/Azure/aks-engine/master/examples/kubernetes.json
# aksengine_cluster_file="./aksengine_cluster.json" 
# wget $url -O $aksengine_cluster_file
# You can modify the kubernetes.json file, for example with smaller VM sizes such as Standard_B2ms

# Optionally we can create a cluster file from scratch:
aksengine_vm_size=Standard_B2ms
worker_count=3
aksengine_cluster_file="./aksengine_cluster.json" 
cat <<EOF > $aksengine_cluster_file
{
  "apiVersion": "vlabs",
  "properties": {
    "orchestratorProfile": {
      "orchestratorType": "Kubernetes"
    },
    "masterProfile": {
      "count": 1,
      "dnsPrefix": "",
      "vmSize": "$aksengine_vm_size"
    },
    "agentPoolProfiles": [
      {
        "name": "agentpool1",
        "count": $worker_count,
        "vmSize": "$aksengine_vm_size"
      }
    ],
    "linuxProfile": {
      "adminUsername": "azureuser",
      "ssh": {
        "publicKeys": [
          {
            "keyData": ""
          }
        ]
      }
    },
    "servicePrincipalProfile": {
      "clientId": "",
      "secret": ""
    }
  }
}
EOF

# Create AKS-engine cluster
# You might need to install aks-engine from https://github.com/Azure/aks-engine/blob/master/docs/tutorials/quickstart.md
subscription=$(az account show --query id -o tsv)
domain=abc$RANDOM
rm -rf _output   # The output directory cannot exist
aks-engine deploy --subscription-id $subscription \
    --dns-prefix $domain \
    --resource-group $rg \
    --location $location \
    --api-model $aksengine_cluster_file \
    --client-id $sp_app_id \
    --client-secret $sp_app_secret \
    --set servicePrincipalProfile.clientId=$sp_app_id \
    --set servicePrincipalProfile.secret="$sp_app_secret"

# There are different ways to access the cluster
# Exporting the KUBECONFIG variable is required by the command "az k8sconfiguration create"
export KUBECONFIG="./_output/$domain/kubeconfig/kubeconfig.$location.json" 
kubectl get node
# The alias is a little dirty trick for lazy persons like me
# alias ke="kubectl --kubeconfig ./_output/$domain/kubeconfig/kubeconfig.$location.json" 
```

### Connect non-managed Kubernetes cluster to Arc

Now we have a kubernetes cluster and access to it, we can connect it to Arc. First, let's install some Azure CLI extensions:

```bash
# Refreshing the connectedk8s extension
echo "Checking if you have up-to-date Azure Arc AZ CLI 'connectedk8s' extension..."
az extension show --name "connectedk8s" &> extension_output
if cat extension_output | grep -q "not installed"; then
  az extension add --name "connectedk8s"
  rm extension_output
else
  az extension update --name "connectedk8s"
  rm extension_output
fi
echo ""
# Refreshing the k8s-configuration extension
echo "Checking if you have up-to-date Azure Arc AZ CLI 'k8s-configuration' extension..."
az extension show --name "k8s-configuration" &> extension_output
if cat extension_output | grep -q "not installed"; then
  az extension add --name "k8s-configuration"
  rm extension_output
else
  az extension update --name "k8s-configuration"
  rm extension_output
fi
echo ""
```

Now we can connect the cluster:

```shell
# Now we can create the ARC resource
arc_rg=k8sarc
az group create -n $arc_rg -l $location
arcname=myaksengine
az connectedk8s connect --name $arcname -g $arc_rg

# Diagnostics
az connectedk8s list -g $arc_rg -o table
kubectl -n azure-arc get deployments,pods
```

And create a GitOps configuration (see [Tutorial: Deploying configurations using GitOps](https://docs.microsoft.com/azure/azure-arc/kubernetes/tutorial-use-gitops-connected-cluster) for more details):

```bash
# Create a cluster-level operator
# cluster-type can be either "connectedClusters" (for ARC clusters) or "managedClusters" (for AKS)
repo_url="https://github.com/erjosito/arc-k8s-test/" # Use your own repo here
cfg_name=testgitops
namespace=$cfg_name
az k8s-configuration create \
    --name $cfg_name \
    --cluster-name $arcname --resource-group $arc_rg \
    --operator-instance-name $cfg_name \
    --operator-namespace $namespace \
    --repository-url $repo_url \
    --scope cluster \
    --cluster-type connectedClusters

# Diagnostics
az k8s-configuration list -c $arcname -g $arc_rg --cluster-type connectedClusters -o table
az k8s-configuration show -n $cfg_name -c $arcname -g $arc_rg --cluster-type connectedClusters
kubectl -n $namespace get deploy -o wide

# Optional: update operator to enable helm or change the repo URL
# az k8s-configuration update -n $cfg_name -c $arcname -g $arc_rg --cluster-type connectedClusters --enable-helm-operator
# az k8s-configuration update -n $cfg_name -c $arcname -g $arc_rg --cluster-type connectedClusters -u $repo_url

# Optional: delete configuration
# az k8s-configuration delete -n $cfg_name -c $arcname -g $arc_rg --cluster-type connectedClusters
```

You will find sample apps in [this repo](https://github.com/erjosito/arc-k8s-test/), including a deployment with the web and api containers we have used in previous exercises ([this](https://github.com/erjosito/arc-k8s-test/blob/master/sqlapi/fullapp.yaml)). Note that in that repo there is a secret stored, and that is **very bad** practice. There are ways of using gitops with secrets, but those have been left out of scope for this challenge for simplicity reasons. If you would like including this aspect, you can look at two options:

- Using integration with a secret store such as Azure Key Vault: configure Azure Key Vault integration in your cluster and store the secret there instead of in the git repo
- Using [Sealed Secrets](https://www.weave.works/blog/storing-secure-sealed-secrets-using-gitops)

If you are using a PaaS database to test, do not forget to add the IP address of your cluster.

### Deploy arc-enabled Data Controller Direct mode

In the second part of this challenge, we will deploy a database into our cluster using Azure Arc for Data. The first thing participants should do is installing the `arcdata` Azure CLI extension:

```bash
# Install azdata (legacy)
apt-get update
# curl -SL https://private-repo.microsoft.com/python/azure-arc-data/private-preview-aug-2020-new/ubuntu-focal/azdata-cli_20.1.1-1~focal_all.deb -o azdata-cli_20.1.1-1~focal_all.deb
# dpkg -i azdata-cli_20.1.1-1~focal_all.deb
# apt-get -f install
sudo apt-get install gnupg ca-certificates curl wget software-properties-common apt-transport-https lsb-release -y
curl -sL https://packages.microsoft.com/keys/microsoft.asc |
gpg --dearmor |
sudo tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null
sudo add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/20.04/prod.list)"
sudo apt-get update
sudo apt-get install -y azdata-cli
azdata --version

# Install arcdata and customlocation extensions
echo "Checking if you have up-to-date Azure Arc AZ CLI 'arcdata' extension..."
az extension show --name "arcdata" &> extension_output
if cat extension_output | grep -q "not installed"; then
  az extension add --name "arcdata"
  rm extension_output
else
  az extension update --name "arcdata"
  rm extension_output
fi
echo "Checking if you have up-to-date Azure Arc AZ CLI 'customlocation' extension..."
az extension show --name "customlocation" &> extension_output
if cat extension_output | grep -q "not installed"; then
  az extension add --name "customlocation"
  rm extension_output
else
  az extension update --name "customlocation"
  rm extension_output
fi
```

The Data Controller can be installed through Arc extensions and the portal (see [Create Data Controller in Direct mode with Azure CLI](https://docs.microsoft.com/en-us/azure/azure-arc/data/create-data-controller-direct-cli)):

```bash
# Deploy Arc extension for Data Controller
ext_name=arcdatacontroller
az k8s-extension create \
    --name $ext_name \
    --cluster-name $arcname --resource-group $arc_rg \
    --extension-type microsoft.arcdataservices \
    --release-namespace arcdc \
    --auto-upgrade false --scope cluster \
    --cluster-type connectedClusters \
    --config Microsoft.CustomLocation.ServiceAccount=sa-bootstrapper
# Create custom location
location_name=mylocation
arc_id=$(az connectedk8s show -g $arc_rg -n $arcname --query id -o tsv) && echo $arc_id
extension_id=$(az k8s-extension show -g $arc_rg -c $arcname --cluster-type connectedClusters --name $ext_name --query id -o tsv) && echo $extension_id
az customlocation create -g $arc_rg -n $location_name --namespace arcdatalocation \
  --host-resource-id $arc_id --cluster-extension-ids $extension_id --location $location
# Deploy DC in the portal, using "azure-arc-aks-default-storage" template, and the previous SP
# Diagnostics
az k8s-extension show -g $arc_rg -c $arcname --name $ext_name --cluster-type connectedclusters
az customlocation list -g $arc_rg -o table
kubectl get datacontrollers -A
```

### Deploy arc-enabled Data Controller - Indirect mode

Indirect mode does not offer full Azure management capabilities for data services, so this section is included here for completeness:

```shell
# Create ARC data controller in the cluster
password=Microsoft123! # Using the same password as in other challenges
export AZDATA_USERNAME=$(whoami)
export AZDATA_PASSWORD=$password
export ACCEPT_EULA=yes
export REGISTRY_USERNAME="22cda7bb-2eb1-419e-a742-8710c313fe79"  # Fixed MCR username
export REGISTRY_PASSWORD="cb892016-5c33-4135-acbf-7b15bc8cb0f7"  # Fixed MCR password
subscription_id=$(az account show --query id -o tsv)
az arcdata dc create --profile-name azure-arc-aks-premium-storage \
                     --namespace arcdc --name arcdc \
                     --azure-subscription $subscription_id \
                     --resource-group $arc_rg --location $location \
                     --connectivity-mode indirect --use-k8s
# azdata dc create --profile-name azure-arc-aks-premium-storage \
                    #  --namespace arcdc --name arcdc \
                    #  --subscription $subscription_id \
                    #  --resource-group $arc_rg --location $location \
                    #  --connectivity-mode indirect
# Login
azdata login --namespace arcdc
```

There are some things you can look at now:

```shell
# Verifying DC deployment
azdata arc dc status show
azdata arc dc endpoint list -o table  # Notice the Grafana and Kibana endpoints
kubectl -n arcdc get statefulset
kubectl -n arcdc get svc
kubectl -n arcdc get ds
# Verify the available storage classes (we will use managed-premium for the DB)
kubectl get sc
# Verify the created CRDs
kubectl get crd
```

Now we can create a database. You can either use the Azure Data CLI (`azdata`), or yaml posted to your gitops repo. Here is the `azdata` way:

```shell
# Deploy Azure Database for Postgres (will take around 30-40 minutes)
arc_db_name=mypgdb
azdata arc postgres server create -n $arc_db_name --workers 1 --storage-class-data managed-premium --storage-class-logs managed-premium
# Option with Azure Files instead of Managed Disks:
# azdata arc postgres server create -n $arc_db_name --workers 1 --storage-class-data azurefile --storage-class-logs azurefile
# Option with an Azure SQL MI instead of Postgres
# azdata arc sql mi create -n $arc_db_name --storage-class-data managed-premium --storage-class-logs managed-premium
# Verify
azdata arc postgres server list
azdata arc postgres server show -n $arc_db_name
azdata arc postgres server endpoint list -n $arc_db_name
kubectl -n arcdc get postgresql-12s.arcdata.microsoft.com
kubectl -n arcdc get postgresql-12s.arcdata.microsoft.com/$arc_db_name -o yaml
kubectl -n arcdc get svc
# Danger zone
# azdata arc postgres server delete -n $arc_db_name
```

Some gotchas:

* If you are getting connection timeout errors when creating the database, you might want to login again (`azdata login --namespace arcdc`).
* If your deployment takes longer than 15 minutes, you might want to stop it, delete, and increase the size of your cluster before retrying

You might want to change `SQL_SERVER_FQDN` variable in the API container to the Kubernetes service where the database is listening (`mypgdb-svc.arcdc` in the previous example), and the `SQL_ENGINE` variable to `postgres`. You can use the `sql` endpoint of the SQL API to test if the database is reachable:


```shell
# Get public IP of SQL API service
api_svc_ip=$(kubectl get svc/api -n sqlapi -o json | jq -rc '.status.loadBalancer.ingress[0].ip' 2>/dev/null)
# Check environment variables of SQL API container (focus on SQL_xxxx variables)
curl -s "http://$api_svc_ip:8080/api/printenv"
# Check correct resolution for the database FQDN (using the service name)
curl -s "http://$api_svc_ip:8080/api/dns?fqdn=$arc_db_name-svc.arcdc"
# Check access to the database, overriding the required environment variables for the SQL API
# For example, for a SQL MI database overriding all parameters but the password
curl http://$api_svc_ip:8080/api/sql\?SQL_SERVER_FQDN\=$arc_db_name-svc.arcdc\&SQL_ENGINE\=sqlserver\&SQL_SERVER_USERNAME\=sa
```

If the environment variables are properly set in the API and Web containers, you should be able to access all the way through the database (notice the database version is SQL Server on Linux):

![](images/arcdata.png)
