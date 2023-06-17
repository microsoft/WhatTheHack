# Challenge 06 - Persistent Storage in AKS - Coach's Guide 

[< Previous Solution](./Solution-05.md) - **[Home](./README.md)** - [Next Solution >](./Solution-07.md)

## Notes and Guidance

* Challenges might arise when using disks and Availability Zones
* Make sure participants understand storage limitations of the VMs (disk size, VM size)
* Note that the SQL Server YAML is taken from the docs, without integration with Azure Key Vault. Integrating it with Azure Key Vault left as optional. Participants are allowed to use secrets for this challenge for simplicity reasons.
* Explain the dependencies between Availability Zones, disks and nodes, and how this can lead to problems
* Following guide in: [Quickstart: Deploy a SQL Server container cluster on Azure](https://docs.microsoft.com/sql/linux/tutorial-sql-server-containers-kubernetes?view=sql-server-ver15)

## Solution Guide

Deploy SQL Server on AKS

```bash
# SQL pwd in secret. Azure Key Vault integration not required for this challenge
sql_password='Microsoft123!Microsoft123!'
remote "kubectl create namespace sql"
remote "kubectl -n sql create secret generic mssql --from-literal=SA_PASSWORD=\"$sql_password\""
```

```bash
# disk-backed Storage class and PVC
remote "cat <<EOF | kubectl -n sql apply -f -
kind: StorageClass
apiVersion: storage.k8s.io/v1beta1
metadata:
     name: azure-disk-retain
provisioner: kubernetes.io/azure-disk
reclaimPolicy: Retain
parameters:
  storageaccounttype: Standard_LRS
  kind: Managed
remote "kubectl get sc"
```

We will deploy a StatefulSet with `replicas=1`. Configuring HA with AlwaysOn Availability Groups or any other SQL technology is not a goal of this challenge:

```bash
# SQL Server as StatefulSet
remote "cat <<EOF | kubectl -n sql apply -f -
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mssql-statefulset
spec:
  selector:
    matchLabels:
      app: mssql
  serviceName: \"sqlservice\"
  replicas: 1
  template:
    metadata:
      labels:
        app: mssql
    spec:
      terminationGracePeriodSeconds: 10
      containers:
        - name: sqlinux
          image: mcr.microsoft.com/mssql/server:2017-latest
          env:
          - name: MSSQL_PID
            value: \"Developer\"
          - name: SA_PASSWORD
            valueFrom:
              secretKeyRef:
                name: mssql
                key: SA_PASSWORD 
          - name: ACCEPT_EULA
            value: \"Y\"
          ports:
            - containerPort: 1433
          volumeMounts:
          - name: mssqldb
            mountPath: /var/opt/mssql
  volumeClaimTemplates:
  - metadata:
      name: mssqldb
    spec:
      accessModes: [ \"ReadWriteOnce\" ]
      storageClassName: \"azure-disk-retain\"
      resources:
        requests:
          storage: 8Gi
---
apiVersion: v1
kind: Service
metadata:
  name: mssql
spec:
  selector:
    app: mssql
  ports:
    - protocol: TCP
      port: 1433
      targetPort: 1433
  type: ClusterIP
EOF"
```

```bash
# Redirect SQL API to the SQL Server service in AKS
akv_name=$rg
akv_secret_name=sqlpassword
az keyvault secret set --vault-name $akv_name -n $akv_secret_name --value $sql_password # In case the password is different
namespace=test
remote "cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: sqlconfig
  namespace: $namespace
data:
  sql_fqdn: \"mssql.sql.svc.cluster.local\"
  sql_user: \"SA\"
EOF"
remote "kubectl rollout restart deploy/api -n $namespace"
remote "kubectl -n $namespace get pod"
```

If everything goes as it should, you should see the version of the Linux-based SQL Server, instead of the Azure SQL.

![](images/aks_sqlpod.png)

```bash
curl "https://test.${azfw_ip}.nip.io/api/healthcheck"
```

We can run performance tests in the SQL container to measure the performance of the disk:

```bash
# Performance test example
pod_name=mssql-statefulset-0
remote "kubectl -n sql exec -it $pod_name -- ls /var/opt/mssql"
remote "kubectl -n sql exec -it $pod_name -- dd if=/dev/zero of=/var/opt/mssql/testfile bs=1G count=1 oflag=direct"
#remote "kubectl -n sql exec -it $pod_name -- ls /var/opt/mssql"
remote "kubectl -n sql exec -it $pod_name -- rm /var/opt/mssql/testfile"
```

This is a example output of the `dd` command:

```
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 50.4886 s, 21.3 MB/s 
```

Note the bandwidth, 21.3 MB/s, roughly matching the maximum performance of a P2 disk (check [Azure Managed Disks Pricing](https://azure.microsoft.com/pricing/details/managed-disks/)).

You can check the disks created and how they match the PVCs in Kubernetes:

```bash
remote "kubectl get pvc -A"
az disk list -g $node_rg -o table
```

In case you want to redirect the app back to the Azure SQL server so that you can delete the SQL Server pods:

```bash
# Redirect SQL API to the SQL Server service in AKS
akv_name=$rg
akv_secret_name=sqlpassword
sql_password=Microsoft123!
sql_username=azure
sql_server_name=$(az sql server list -g $rg --query '[0].name' -o tsv)
sql_server_fqdn=$(az sql server show -n $sql_server_name -g $rg -o tsv --query fullyQualifiedDomainName)
az keyvault secret set --vault-name $akv_name -n $akv_secret_name --value $sql_password # In case the password is different
namespace=test
remote "cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: sqlconfig
  namespace: $namespace
data:
  sql_fqdn: \"$sql_server_fqdn\"
  sql_user: \"$sql_username\"
EOF"
remote "kubectl rollout restart deploy/api -n $namespace"
remote "kubectl -n $namespace get pod"
```

### Optional: Persistent Volume with Large File Shares

You can create a storage account with an Azure Files Share, and then a container that mounts that share.

```bash
# Create Storage Account with Large File Shares
storage_account_name=$rg
share_name=${rg}share
# At this time the --enable-large-file-share does not work with the storage-preview extension
az extension remove -n storage-preview
az storage account create -n $storage_account_name -g $rg \
  --sku Standard_LRS --kind StorageV2 --enable-large-file-share
storage_account_key=$(az storage account keys list --account-name $storage_account_name -g $rg --query '[0].value' -o tsv)
az storage share create --account-name $storage_account_name \
  --account-key $storage_account_key --name $share_name
remote "kubectl -n sql create secret generic azure-storage \
  --from-literal=azurestorageaccountname=$storage_account_name \
  --from-literal=azurestorageaccountkey=$storage_account_key"
```

We can now create a SQL Server deployment mounting that share. We will not use Stateful Sets, because SS dynamically create the required PVCs, but we want to use the existing share we have just created:

```bash
remote "cat <<EOF | kubectl -n sql apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mssqlnfs
spec:
  replicas: 1
  selector:
     matchLabels:
       app: mssqlnfs
  template:
    metadata:
      labels:
        app: mssqlnfs
    spec:
      terminationGracePeriodSeconds: 10
      containers:
      - name: mssql
        image: mcr.microsoft.com/mssql/server:2017-latest
        ports:
        - containerPort: 1433
        env:
        - name: MSSQL_PID
          value: \"Developer\"
        - name: ACCEPT_EULA
          value: \"Y\"
        - name: SA_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mssql
              key: SA_PASSWORD 
        volumeMounts:
        - name: mssqldb
          mountPath: /var/opt/mssql
      volumes:
      - name: mssqldb
        azureFile:
          secretName: azure-storage
          shareName: $share_name
          readOnly: false
---
apiVersion: v1
kind: Service
metadata:
  name: mssqlnfs
spec:
  selector:
    app: mssqlnfs
  ports:
    - protocol: TCP
      port: 1433
      targetPort: 1433
  type: ClusterIP
EOF"
```

After verifying that the pod has ben created successfully, we can now run the same performance test in the new pod:

```bash
# Verify pod is up
sql_pod_name=$(remote "kubectl -n sql get pods -l app=mssqlnfs -o custom-columns=:metadata.name" | awk NF)
remote "kubectl -n sql describe pod $sql_pod_name"
```

```bash
# Performance test
remote "kubectl -n sql exec -it $sql_pod_name -- ls /var/opt/mssql"
remote "kubectl -n sql exec -it $sql_pod_name -- dd if=/dev/zero of=/var/opt/mssql/testfile bs=1G count=1 oflag=direct"
remote "kubectl -n sql exec -it $sql_pod_name -- rm /var/opt/mssql/testfile"
```

You should get a result like this:

```
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 10.2392 s, 105 MB/s
```

You can verify the Azure Files utilization in the metrics:

![](images/azfiles_ingress.png)

You can comment the results and compare them to the disk performance. Make the participants describe the different limits that might be at play here, and how to work around them:

* [Azure File limits](https://docs.microsoft.com/azure/storage/files/storage-files-scale-targets#file-share-and-file-scale-targets): 300 MB/s for Large Shares
* [Network limits for B-series VMs](https://docs.microsoft.com/azure/virtual-machines/sizes-b-series-burstable?toc=/azure/virtual-machines/linux/toc.json): not documented

