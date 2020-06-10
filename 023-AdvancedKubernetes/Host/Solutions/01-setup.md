## Create AKS cluster

```
RG=
LOCATION=
az group create $RG -l $LOCATION
az aks create -n $RG -g $RG --enable-cluster-autoscaler --enable-managed-identity —node-count 1
az aks nodepool add --cluster-name $RG -g $RG -n userpool -c 1
```
