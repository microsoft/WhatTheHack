# Challenge 4: Secrets and Configuration Management - Coach's Guide

[< Previous Challenge](./03-aks_monitoring.md) - **[Home](./README.md)** - [Next Challenge >](./05-aks_security.md)

## Notes and Guidance

* The fact that no static passwords can be used implies that AAD Pod Identity is a prerequisite
* Note that with the nginx ingress controller injecting certificates as files is not possible. The new CSI driver can inject secrets as files **and** variables. However, since certificates are not a must in this challenge, you can ignore this point
* Note that Flexvol is deprecated in favor of CSI. Steer participants towards the CSI implementation
* The identity space in AKS is quite dynamic, consider that there might a way of fulfilling this challenge without using pod identity
* Pod identity is now an addon for AKS, it would be recommended using that addon instead of the helm installation
* Along this lab a large number of pods will be created. Chances are that the number of pods will exceed 30, the maximum per node for Azure CNI. If the participant has deployed one single node, some pods will not start. One possible solution is enable the cluster autoscaler:

## Solution Guide

```bash
# Cluster autoscaler
az aks update -n $aks_name -g $rg \
    --enable-cluster-autoscaler --min-count 1 --max-count 3
```

See this link for more details on Pod Identity: [https://github.com/Azure/aad-pod-identity](https://github.com/Azure/aad-pod-identity).

```bash
# Pod Identity
identity_name=apiid
node_rg=$(az aks show -n $aks_name -g $rg --query nodeResourceGroup -o tsv)
az identity create -g $node_rg -n $identity_name
identity_client_id=$(az identity show -g $node_rg -n $identity_name --query clientId -o tsv)
identity_principal_id=$(az identity show -g $node_rg -n $identity_name --query principalId -o tsv)
identity_id=$(az identity show -g $node_rg -n $identity_name --query id -o tsv)
subscription_id=$(az account show --query id -o tsv)
az role assignment create --role Reader --assignee $identity_principal_id --scope $rg_id
# Install
remote "kubectl apply -f https://raw.githubusercontent.com/Azure/aad-pod-identity/master/deploy/infra/deployment-rbac.yaml"
remote "kubectl apply -f https://raw.githubusercontent.com/Azure/aad-pod-identity/master/deploy/infra/mic-exception.yaml"
remote "cat <<EOF | kubectl apply -f -
apiVersion: \"aadpodidentity.k8s.io/v1\"
kind: AzureIdentity
metadata:
  name: $identity_name
spec:
  type: 0
  resourceID: $identity_id
  clientID: $identity_client_id
EOF"
remote "cat <<EOF | kubectl apply -f -
apiVersion: \"aadpodidentity.k8s.io/v1\"
kind: AzureIdentityBinding
metadata:
  name: $identity_name-binding
spec:
  azureIdentity: $identity_name
  selector: $identity_name
EOF"
# Demo pod
remote "cat << EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: demo
  labels:
    aadpodidbinding: $identity_name
spec:
  containers:
  - name: demo
    image: mcr.microsoft.com/k8s/aad-pod-identity/demo:1.2
    args:
      - --subscriptionid=$subscription_id
      - --clientid=$identity_client_id
      - --resourcegroup=$rg
    env:
      - name: MY_POD_NAME
        valueFrom:
          fieldRef:
            fieldPath: metadata.name
      - name: MY_POD_NAMESPACE
        valueFrom:
          fieldRef:
            fieldPath: metadata.namespace
      - name: MY_POD_IP
        valueFrom:
          fieldRef:
            fieldPath: status.podIP
  nodeSelector:
    kubernetes.io/os: linux
EOF"
remote "kubectl get azureidentity"
remote "kubectl get azureidentitybinding"
az role assignment list --assignee $identity_client_id --all -o table
remote "kubectl get pod/demo --show-labels"
remote "kubectl logs demo"
```

See [https://github.com/Azure/secrets-store-csi-driver-provider-azure](https://github.com/Azure/secrets-store-csi-driver-provider-azure):

```bash
# akv secret provider
remote "helm repo add csi-secrets-store-provider-azure https://raw.githubusercontent.com/Azure/secrets-store-csi-driver-provider-azure/master/charts"
remote "helm install csi-secrets-store-provider-azure/csi-secrets-store-provider-azure --generate-name"
tmp_file=/tmp/secretproviderclass.yaml
file=secretproviderclass.yaml
cp ./Solutions/$file $tmp_file
tenant_id=$(az account show --query 'tenantId' -o tsv)
subscription_id=$(az account show --query 'id' -o tsv)
sed -i "s|__subscription_id__|${subscription_id}|g" $tmp_file
sed -i "s|__tenant_id__|${tenant_id}|g" $tmp_file
sed -i "s|__identity_client_id__|${identity_client_id}|g" $tmp_file
sed -i "s|__akv_name__|${akv_name}|g" $tmp_file
sed -i "s|__akv_rg__|${rg}|g" $tmp_file
scp $tmp_file $vm_pip_ip:$file
remote "kubectl apply -f ./$file"
```

After having our identity ready, we can create an Azure Key Vault and store the SQL password there:

```bash
# AKV
akv_name=$rg
akv_secret_name=sqlpassword
az keyvault create -n $akv_name -g $rg
az keyvault secret set --vault-name $akv_name -n $akv_secret_name --value $sql_password
# policy
az keyvault set-policy -n $akv_name --spn $identity_client_id \
    --secret-permissions get \
    --key-permissions get \
    --certificate-permissions get
```

Redeploy API pod:

```bash
# Redeploy API
tmp_file=/tmp/api_akv.yaml
file=api_akv.yaml
cp ./Solutions/$file $tmp_file
sed -i "s|__sql_username__|${sql_username}|g" $tmp_file
sed -i "s|__sql_server_name__|${db_server_name}|g" $tmp_file
sed -i "s|__acr_name__|${acr_name}|g" $tmp_file
sed -i "s|__identity_name__|${identity_name}|g" $tmp_file
sed -i "s|__akv_name__|${akv_name}|g" $tmp_file
scp $tmp_file $vm_pip_ip:$file
remote "kubectl apply -f ./$file"
# Get IP address of service
api_svc_ip=$(remote "kubectl get svc/api -n default -o json | jq -rc '.status.loadBalancer.ingress[0].ip' 2>/dev/null")
remote "curl -s http://${api_svc_ip}:8080/api/healthcheck"
```

