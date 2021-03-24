## Sub-challenge 1: Static provisioning with Azure Disks

### Provision an Azure Disk

If availability zones are enabled, the disk will need to live in the same zone as the node that the pod is running on to attach.

```bash
# if availability zones are NOT enabled
az disk create -g MC_<resource group>_<cluster name>_<region> -n managed-disk-1 --size-gb 5

# if availability zones are enabled
az disk create -g MC_<resource group>_<cluster name>_<region> -n managed-disk-1 --size-gb 5 --zone 1
```

### Use the disk in the deployment yaml

Make sure that diskName and diskURI match and point to the same disk. See [static-disk-deployment.yaml](../Resources/07-data-volumes/static-disk-deployment.yaml) for an example.

### Deploy the yaml file and verify the application has deployed successfully.

```bash
$ kubectl get deploy
NAME              READY   UP-TO-DATE   AVAILABLE   AGE
static-disk-app   1/1     1            1           20m

$ kubectl get pods
NAME                               READY   STATUS    RESTARTS   AGE
static-disk-app-5dbd479c7f-74kfj   2/2     Running   0          20m

$ kubectl get svc
NAME               TYPE           CLUSTER-IP    EXTERNAL-IP     PORT(S)        AGE
static-disk-app    LoadBalancer   10.0.6.84     40.88.193.218   80:31591/TCP   20m
```

### Stream contents of persisted file

You should see something like the below:

```
2021-03-24:22:55:17 - static-disk-app-5dbd479c7f-74kfj
2021-03-24:23:06:12 - static-disk-app-5dbd479c7f-74kfj
2021-03-24:23:06:13 - static-disk-app-5dbd479c7f-74kfj
2021-03-24:23:06:14 - static-disk-app-5dbd479c7f-74kfj
2021-03-24:23:06:15 - static-disk-app-5dbd479c7f-74kfj
2021-03-24:23:06:16 - static-disk-app-5dbd479c7f-74kfj
2021-03-24:23:06:17 - static-disk-app-5dbd479c7f-74kfj
2021-03-24:23:06:18 - static-disk-app-5dbd479c7f-74kfj
2021-03-24:23:06:19 - static-disk-app-5dbd479c7f-74kfj
2021-03-24:23:06:20 - static-disk-app-5dbd479c7f-74kfj
2021-03-24:23:06:21 - static-disk-app-5dbd479c7f-74kfj
```

### Check persistence

Verify that the timestamps are continued. If it is unclear from the stream, run `curl <PUBLIC IP>` to check.

















```yaml
kubectl apply -f ../Resources/07-data-volumes/azure-disk-pvc-example.yaml
kubectl get pvc
kubectl get pv

export MANAGED_DISK_IP=`kubectl get svc/managed-disk-svc -o json  | jq '.status.loadBalancer.ingress[0].ip' -r`
echo $MANAGED_DISK_IP

# Validate service is up
curl $MANAGED_DISK_IP

watch -n 1 'curl -s $MANAGED_DISK_IP | tail | head -20'
```

## Sub-challenge 2
```yaml
kubectl apply -f ../Resources/07-data-volumes/azure-files-nfs-pvc-example.yaml
kubectl get pvc
kubectl get pv

export FILES_NFS_IP=`kubectl get svc/azure-files-nfs-svc -o json  | jq '.status.loadBalancer.ingress[0].ip' -r`
echo $FILES_NFS_IP

# Validate service is up
curl $FILES_NFS_IP

watch -n 1 'curl -s $FILES_NFS_IP | tail | head -20'
```
