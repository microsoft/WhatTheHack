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

### Deploy the yaml file and verify the application has deployed successfully

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

### Scaling

What happens if you try to scale the application? One of two things:

1. Multiple pods are scheduled on the same node. Due to the way the infrastructure works, since the data disk is attached to the node, the pods can share the same volume. Thus both pods will persist to the same location and the stream will look like this:

```
2021-03-24:22:55:17 - static-disk-app-5dbd479c7f-74kfj
2021-03-24:23:17:21 - static-disk-app-5dbd479c7f-74kfj
2021-03-24:23:17:22 - static-disk-app-5dbd479c7f-jzg5n
2021-03-24:23:17:22 - static-disk-app-5dbd479c7f-74kfj
2021-03-24:23:17:23 - static-disk-app-5dbd479c7f-jzg5n
2021-03-24:23:17:23 - static-disk-app-5dbd479c7f-74kfj
2021-03-24:23:17:24 - static-disk-app-5dbd479c7f-jzg5n
2021-03-24:23:17:24 - static-disk-app-5dbd479c7f-74kfj
2021-03-24:23:17:25 - static-disk-app-5dbd479c7f-jzg5n
2021-03-24:23:17:25 - static-disk-app-5dbd479c7f-74kfj
2021-03-24:23:17:26 - static-disk-app-5dbd479c7f-jzg5n
```

2. Pods are scheduled on different nodes. Due to the way the infrastructure works, a disk can usually only be attached to a single node. The second pod will try to attach the disk to the node it runs on and fail.

## Sub-challenge 2: Dynamic provisioning with Azure Disks

### Use PVCs in the deployment yaml

See [dynamic-disk-deployment.yaml](../Resources/07-data-volumes/dynamic-disk-deployment.yaml).

### Deploy the yaml file and verify the application has deployed successfully

```bash
$ kubectl get deploy
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
disk-app   1/1     1            1           2m37s

$ kubectl get pod
NAME                      READY   STATUS    RESTARTS   AGE
disk-app-78d66989-dmr55   2/2     Running   0          2m39s

$ kubectl get svc
NAME         TYPE           CLUSTER-IP    EXTERNAL-IP     PORT(S)        AGE
disk-app     LoadBalancer   10.0.32.228   52.191.218.25   80:30684/TCP   2m47s

$ kubectl get pvc
NAME                 STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
managed-disk-claim   Bound    pvc-b43420ee-b94b-4621-b60b-2ce3a03c45bc   5Gi        RWO            default        34s

$ kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                        STORAGECLASS   REASON   AGE
pvc-b43420ee-b94b-4621-b60b-2ce3a03c45bc   5Gi        RWO            Delete           Bound    default/managed-disk-claim   default                 35s
```

### Stream content of persisted file 

```
2021-03-24:23:45:44 - disk-app-78d66989-dmr55
2021-03-24:23:45:45 - disk-app-78d66989-dmr55
2021-03-24:23:45:46 - disk-app-78d66989-dmr55
2021-03-24:23:45:47 - disk-app-78d66989-dmr55
2021-03-24:23:45:48 - disk-app-78d66989-dmr55
2021-03-24:23:45:49 - disk-app-78d66989-dmr55
2021-03-24:23:45:50 - disk-app-78d66989-dmr55
2021-03-24:23:45:51 - disk-app-78d66989-dmr55
2021-03-24:23:45:52 - disk-app-78d66989-dmr55
2021-03-24:23:45:53 - disk-app-78d66989-dmr55
```









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
